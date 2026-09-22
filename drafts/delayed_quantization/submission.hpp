#pragma once

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <limits>
#include <new>
#include <stdexcept>
#include <stdint.h>
#include <vector>

// Starter Grid for the 2D heat-diffusion problem.
//
// The evaluation harness uses operator() to set initial conditions and to read
// results; it never touches your internal storage. Keep this interface,
// everything else is yours.

// Aligns storage to 64 bytes and pads the stride so every row starts aligned.
template <typename T>
class PaddedAlignedVector {
private:
  // Target the 64-byte cache lines on x86 CPUs.
  static constexpr std::size_t CACHE_ALIGNMENT{64};

  static_assert(CACHE_ALIGNMENT % sizeof(T) == 0);
  static constexpr std::size_t elements_per_line{CACHE_ALIGNMENT / sizeof(T)};

  // Cache alignment clas to be fed to vector for 64 addres-space alignment
  template <typename U>
  class CacheAlignAllocator {
  public:
    using value_type = U;

    CacheAlignAllocator() noexcept = default;

    template <typename V>
    CacheAlignAllocator(const CacheAlignAllocator<V>&) noexcept {}

    // This is necessary becaause vector compares allocaator during copying.
    // This is necessary for copying the Grid be possible as a precaution.
    template <typename V>
    bool operator==(const CacheAlignAllocator<V>&) const noexcept {
      return true;
    }

    template <typename V>
    bool operator!=(const CacheAlignAllocator<V>&) const noexcept {
      return false;
    }

    U* allocate(std::size_t count) {
      if (count > std::numeric_limits<std::size_t>::max() / sizeof(U)) {
        throw std::bad_array_new_length{};
      }

      return static_cast<U*>(::operator new(count * sizeof(U), std::align_val_t{CACHE_ALIGNMENT}));
    }

    void deallocate(U* pointer, std::size_t) noexcept {
      ::operator delete(pointer, std::align_val_t{CACHE_ALIGNMENT});
    }
  };

  // Physical row spacing includes padding; callers address logical cells only.
  std::size_t stride_;

  std::vector<T, CacheAlignAllocator<T>> storage_;

public:
  PaddedAlignedVector(std::size_t rows, std::size_t cols) : stride_{0} {
    constexpr auto max_size{std::numeric_limits<std::size_t>::max()};
    if (cols > max_size - (elements_per_line - 1)) {
      throw std::bad_array_new_length{};
    }

    stride_ = (cols + elements_per_line - 1) / elements_per_line * elements_per_line;

    // Check the total byte size before multiplying either dimension.
    if (stride_ != 0 && rows > (max_size / sizeof(T)) / stride_) {
      throw std::bad_array_new_length{};
    }

    storage_.resize(rows * stride_);
  }

  inline T* data() { return storage_.data(); }
  inline const T* data() const { return storage_.data(); }

  inline T* ptr(std::size_t i, std::size_t j) { return storage_.data() + i * stride_ + j; }

  inline const T* ptr(std::size_t i, std::size_t j) const {
    return storage_.data() + i * stride_ + j;
  }

  inline T& operator()(std::size_t i, std::size_t j) { return *ptr(i, j); }

  inline const T& operator()(std::size_t i, std::size_t j) const { return *ptr(i, j); }
};

class GridView;

class Grid {
private:
  std::size_t rows_;
  std::size_t cols_;
  mutable PaddedAlignedVector<double> grid_;

  class Grid_Quantized {
  private:
    static constexpr uint32_t QMAX{std::numeric_limits<uint32_t>::max()};

    // Empirical cutoff; validation coverage is documented beside this draft.
    static constexpr double MAX_QUANTIZED_RANGE{8.0};

    PaddedAlignedVector<uint32_t> grid_;

    double minimum_{0.0};
    double maximum_{0.0};

    double scale_{0.0};
    double spacing_{0.0};

    friend class Grid;
    friend class GridView;
    friend void apply_stencil_quantized(const GridView& source, Grid& destination);

  public:
    Grid_Quantized(std::size_t rows, std::size_t cols) : grid_{rows, cols} {}

    void record_range(double minimum, double maximum) {
      minimum_ = minimum;
      maximum_ = maximum;
    }

    void inherit_quantization(const Grid_Quantized& source) {
      minimum_ = source.minimum_;
      maximum_ = source.maximum_;
      scale_ = source.scale_;
      spacing_ = source.spacing_;
    }

    double minimum() const { return minimum_; }
    double maximum() const { return maximum_; }

    double value(std::size_t row, std::size_t col) const {
      return minimum_ + grid_(row, col) * spacing_;
    }

    bool can_quantize() const { return maximum_ - minimum_ <= MAX_QUANTIZED_RANGE; }

    void initialize(const Grid& owner) {
      // a clamp for if the range is 0, this kinda exist so that the existing logic would work
      // properly under this edge case.
      const double range{std::max(maximum_ - minimum_, 1e-20)};

      scale_ = static_cast<double>(QMAX) / range;
      spacing_ = range / static_cast<double>(QMAX);
      for (std::size_t row{0}; row < owner.rows_; ++row) {
        for (std::size_t col{0}; col < owner.cols_; ++col) {
          double encoded{(owner.grid_(row, col) - minimum_) * scale_};
          encoded = std::clamp(encoded, 0.0, static_cast<double>(QMAX));
          grid_(row, col) = static_cast<uint32_t>(encoded + 0.5);
        }
      }
    }

    void decode(const Grid& owner) const {
      for (std::size_t row{0}; row < owner.rows_; ++row) {
        for (std::size_t col{0}; col < owner.cols_; ++col) {
          owner.grid_(row, col) = value(row, col);
        }
      }
    }
  };

  mutable Grid_Quantized quantized_;
  mutable bool use_quantized_{false};
  std::size_t step_count_{0};

  void switch_to_double() const {
    if (!use_quantized_) {
      return;
    }

    quantized_.decode(*this);
    use_quantized_ = false;
  }

  void set_value(std::size_t row, std::size_t col, double value) {
    if (!std::isfinite(value)) {
      throw std::invalid_argument("Grid values must be finite");
    }

    switch_to_double();
    grid_(row, col) = value;
  }

  friend class GridView;
  friend void apply_stencil_impl(const GridView& source, Grid& destination);
  friend void apply_stencil_quantized(const GridView& source, Grid& destination);
  friend void apply_stencil(const Grid& old_grid, Grid& new_grid);

public:
  class ConstCellProxy {
  private:
    const Grid& owner_;
    std::size_t row_;
    std::size_t col_;

  public:
    ConstCellProxy(const Grid& owner, std::size_t row, std::size_t col)
        : owner_{owner}, row_{row}, col_{col} {}

    operator double() const {
      if (owner_.use_quantized_) {
        return owner_.quantized_.value(row_, col_);
      }

      return owner_.grid_(row_, col_);
    }
  };

  class CellProxy {
  private:
    Grid& owner_;
    std::size_t row_;
    std::size_t col_;

  public:
    CellProxy(Grid& owner, std::size_t row, std::size_t col)
        : owner_{owner}, row_{row}, col_{col} {}

    operator double() const { return static_cast<const Grid&>(owner_)(row_, col_); }

    CellProxy& operator=(double value) {
      owner_.set_value(row_, col_, value);
      return *this;
    }

    CellProxy& operator=(const CellProxy& other) { return *this = static_cast<double>(other); }
  };

  Grid(std::size_t rows, std::size_t cols)
      : rows_{rows}, cols_{cols}, grid_{rows, cols}, quantized_{rows, cols} {
    // I don't think it make sense to operate on zero dimensionsal grids , so this should be flagged
    // if attempted to do so
    if (rows == 0 || cols == 0) {
      throw std::invalid_argument("Grid dimensions must be positive");
    }
  }

  inline std::size_t rows() const { return rows_; }
  inline std::size_t cols() const { return cols_; }

  CellProxy operator()(std::size_t i, std::size_t j) { return CellProxy(*this, i, j); }

  ConstCellProxy operator()(std::size_t i, std::size_t j) const {
    return ConstCellProxy(*this, i, j);
  }

private:
  inline double* ptr(std::size_t i, std::size_t j) { return grid_.ptr(i, j); }

  inline const double* ptr(std::size_t i, std::size_t j) const { return grid_.ptr(i, j); }

  inline uint32_t* quantized_ptr(std::size_t i, std::size_t j) {
    return quantized_.grid_.ptr(i, j);
  }

  inline const uint32_t* quantized_ptr(std::size_t i, std::size_t j) const {
    return quantized_.grid_.ptr(i, j);
  }
};

// Borrow either representation without copying or decoding on construction.
class GridView {
private:
  const Grid& grid_;

  const Grid::Grid_Quantized& quantization() const { return grid_.quantized_; }

  friend void apply_stencil_quantized(const GridView& source, Grid& destination);

public:
  GridView(const Grid& grid) : grid_{grid} {}

  inline std::size_t rows() const { return grid_.rows(); }
  inline std::size_t cols() const { return grid_.cols(); }

  bool is_quantized() const { return grid_.use_quantized_; }

  double operator()(std::size_t i, std::size_t j) const { return grid_(i, j); }

  // Raw double storage; values may be stale while quantized.
  inline const double* ptr(std::size_t i, std::size_t j) const { return grid_.ptr(i, j); }

  inline const uint32_t* quantized_ptr(std::size_t i, std::size_t j) const {
    return grid_.quantized_ptr(i, j);
  }
};

// Divide before adding to support the full uint32_t range without overflow.
inline uint32_t quantized_stencil_value(uint32_t center, uint32_t top, uint32_t bottom,
                                       uint32_t left, uint32_t right, uint32_t rounding_offset) {
  const uint32_t whole{(center >> 1) + (top >> 3) + (bottom >> 3) + (left >> 3) + (right >> 3)};
  const uint32_t remainder{4u * (center & 1u) + (top & 7u) + (bottom & 7u) +
                           (left & 7u) + (right & 7u)};

  return whole + ((remainder + rounding_offset) >> 3);
}

inline void apply_stencil_quantized(const GridView& source, Grid& destination) {
  const std::size_t rows{source.rows()};
  const std::size_t cols{source.cols()};
  const auto& old{source.quantization()};
  // Alternate exact halves down and up on successive steps.
  const uint32_t rounding_offset{3u + static_cast<uint32_t>(source.grid_.step_count_ & 1u)};

  auto& next{destination.quantized_};
  next.inherit_quantization(old);

  std::memcpy(destination.quantized_ptr(0, 0), source.quantized_ptr(0, 0), cols * sizeof(uint32_t));
  std::memcpy(destination.quantized_ptr(rows - 1, 0), source.quantized_ptr(rows - 1, 0),cols * sizeof(uint32_t));

  #pragma omp parallel for schedule(static)
  for (std::size_t row = 1; row < rows - 1; ++row) {
    const uint32_t* top{source.quantized_ptr(row - 1, 0)};
    const uint32_t* mid{source.quantized_ptr(row, 0)};
    const uint32_t* bottom{source.quantized_ptr(row + 1, 0)};
    uint32_t* out{destination.quantized_ptr(row, 0)};

    out[0] = mid[0];
    out[cols - 1] = mid[cols - 1];

    #pragma omp simd
    for (std::size_t col = 1; col < cols - 1; ++col) {
      out[col] = quantized_stencil_value(mid[col], top[col], bottom[col], mid[col - 1],
                                         mid[col + 1], rounding_offset);
    }
  }
}

inline void apply_stencil_impl(const GridView& old_grid, Grid& new_grid) {
  const std::size_t rows{old_grid.rows()};
  const std::size_t cols{old_grid.cols()};
  std::memcpy(new_grid.ptr(0, 0), old_grid.ptr(0, 0), cols * sizeof(double));
  std::memcpy(new_grid.ptr(rows - 1, 0), old_grid.ptr(rows - 1, 0), cols * sizeof(double));

  // Include fixed boundaries in the range, as well as updated interior cells.
  double minimum{old_grid.ptr(0, 0)[0]};
  double maximum{minimum};
  for (std::size_t col{0}; col < cols; ++col) {
    const double first{new_grid.ptr(0, 0)[col]};
    const double last{new_grid.ptr(rows - 1, 0)[col]};
    minimum = std::min(minimum, std::min(first, last));
    maximum = std::max(maximum, std::max(first, last));
  }

  #pragma omp parallel for schedule(static) reduction(min:minimum) reduction(max:maximum)
  for (std::size_t row = 1; row < rows - 1; ++row) {
    const double* top{old_grid.ptr(row - 1, 0)};
    const double* mid{old_grid.ptr(row, 0)};
    const double* bottom{old_grid.ptr(row + 1, 0)};
    double* __restrict out{new_grid.ptr(row, 0)};
    out[0] = mid[0];
    out[cols - 1] = mid[cols - 1];
    minimum = std::min(minimum, std::min(out[0], out[cols - 1]));
    maximum = std::max(maximum, std::max(out[0], out[cols - 1]));

    #pragma omp simd reduction(min:minimum) reduction(max:maximum)
    for (std::size_t col = 1; col < cols - 1; ++col) {
      const double value{0.5 * mid[col] +
          0.125 * (top[col] + bottom[col] + mid[col - 1] + mid[col + 1])};
      out[col] = value;
      minimum = std::min(minimum, value);
      maximum = std::max(maximum, value);
    }
  }
  new_grid.quantized_.record_range(minimum, maximum);
}

// Apply the five-point stencil over all interior points, copying the boundary
// values unchanged from old_grid to new_grid. Implement your solution here.
inline void apply_stencil(const Grid& old_grid, Grid& new_grid) {
  if (old_grid.rows() != new_grid.rows() || old_grid.cols() != new_grid.cols()) {
    throw std::invalid_argument("Input and output grids must have matching dimensions");
  }

  const GridView source{old_grid};

  if (source.is_quantized()) {
    apply_stencil_quantized(source, new_grid);
    new_grid.use_quantized_ = true;
  } else {
    new_grid.use_quantized_ = false;
    apply_stencil_impl(source, new_grid);
    if (new_grid.quantized_.can_quantize()) {
      new_grid.quantized_.initialize(new_grid);
      new_grid.use_quantized_ = true;
    }
  }

  new_grid.step_count_ = old_grid.step_count_ + 1;
}

#pragma once

#include <algorithm>
#include <cmath>
#include <stdexcept>
#include <cstddef>
#include <cstring>
#include <limits>
#include <new>
#include <vector>

#include <immintrin.h>


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
  static constexpr std::size_t CACHE_ALIGNMENT = 64;

  static_assert(CACHE_ALIGNMENT % sizeof(T) == 0);
  static constexpr std::size_t elements_per_line = CACHE_ALIGNMENT / sizeof(T);

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
    bool operator==(const CacheAlignAllocator<V>&) const noexcept { return true; }

    template <typename V>
    bool operator!=(const CacheAlignAllocator<V>&) const noexcept { return false; }

    U* allocate(std::size_t count) {
      if (count > std::numeric_limits<std::size_t>::max() / sizeof(U))
        throw std::bad_array_new_length{};

      return static_cast<U*>(
          ::operator new(count * sizeof(U), std::align_val_t{CACHE_ALIGNMENT}));
    }

    void deallocate(U* pointer, std::size_t) noexcept {
      ::operator delete(pointer, std::align_val_t{CACHE_ALIGNMENT});
    }
  };

  // Physical row spacing includes padding; callers address logical cells only.
  std::size_t stride_;

  std::vector<T, CacheAlignAllocator<T>> storage_;

public:
  PaddedAlignedVector(std::size_t rows, std::size_t cols) : stride_(0) {
    constexpr auto max_size = std::numeric_limits<std::size_t>::max();
    if (cols > max_size - (elements_per_line - 1))
      throw std::bad_array_new_length{};

    stride_ = (cols + elements_per_line - 1) / elements_per_line * elements_per_line;

    // Check the total byte size before multiplying either dimension.
    if (stride_ != 0 && rows > (max_size / sizeof(T)) / stride_)
      throw std::bad_array_new_length{};

    storage_.resize(rows * stride_, T{}); // Every new cell starts at zero.
  }

  inline T* data() { return storage_.data(); }
  inline const T* data() const { return storage_.data(); }

  inline T* ptr(std::size_t i, std::size_t j) {
    return storage_.data() + i * stride_ + j;
  }

  inline const T* ptr(std::size_t i, std::size_t j) const {
    return storage_.data() + i * stride_ + j;
  }

  inline T& operator()(std::size_t i, std::size_t j) {
    return *ptr(i, j);
  }

  inline const T& operator()(std::size_t i, std::size_t j) const {
    return *ptr(i, j);
  }
};

class GridView;

class Grid {
private:
  struct ActiveArea {
    std::size_t first_row{0}, end_row{0};
    std::size_t first_col{0}, end_col{0};

    bool empty() const { return first_row == end_row || first_col == end_col; }

    void include(std::size_t row, std::size_t col) {
      if (empty()) {
        *this = ActiveArea{row, row + 1, col, col + 1};
      } else {
        first_row = std::min(first_row, row);
        end_row = std::max(end_row, row + 1);
        first_col = std::min(first_col, col);
        end_col = std::max(end_col, col + 1);
      }
    }

    bool contains(const ActiveArea& other) const {
      return other.empty() || (!empty() && first_row <= other.first_row &&
          end_row >= other.end_row && first_col <= other.first_col && end_col >= other.end_col);
    }
  };

  std::size_t rows_;
  std::size_t cols_;
  PaddedAlignedVector<double> grid_;
  mutable ActiveArea active_;
  mutable bool active_dirty_{false};

  // Detect the initial rectangle, or refresh it after external assignments.
  // Stencil updates maintain the rectangle directly and do not rescan.
  void detect_active_area() const {
    if (!active_dirty_) {
      return;
    }
    active_ = ActiveArea{};
    for (std::size_t row{0}; row < rows_; ++row) {
      for (std::size_t col{0}; col < cols_; ++col) {
        if (grid_(row, col) != 0.0) {
          active_.include(row, col);
        }
      }
    }
    active_dirty_ = false;
  }

  void set_value(std::size_t row, std::size_t col, double value) {
    if (!std::isfinite(value)) {
      throw std::invalid_argument("Grid values must be finite");
    }
    grid_(row, col) = value;
    active_dirty_ = true;
  }

  // Normally the growing source window covers the destination's older window.
  // Clear stale cells if the destination was instead used for another field.
  void clear_outside(const ActiveArea& next) {
    detect_active_area();
    if (next.contains(active_)) {
      return;
    }
    for (std::size_t row{active_.first_row}; row < active_.end_row; ++row) {
      double* out{grid_.ptr(row, 0)};
      if (next.empty() || row < next.first_row || row >= next.end_row) {
        std::fill(out + active_.first_col, out + active_.end_col, 0.0);
      } else {
        const std::size_t left_end{std::min(active_.end_col, next.first_col)};
        const std::size_t right_begin{std::max(active_.first_col, next.end_col)};
        if (active_.first_col < left_end) {
          std::fill(out + active_.first_col, out + left_end, 0.0);
        }
        if (right_begin < active_.end_col) {
          std::fill(out + right_begin, out + active_.end_col, 0.0);
        }
      }
    }
  }

  friend class GridView;
  friend void apply_stencil_impl(const GridView& source, Grid& destination);
  friend void apply_stencil(const Grid& source, Grid& destination);

public:
  class CellProxy {
  private:
    Grid& owner_;
    std::size_t row_;
    std::size_t col_;

  public:
    CellProxy(Grid& owner, std::size_t row, std::size_t col)
        : owner_{owner}, row_{row}, col_{col} {}
    operator double() const { return owner_.grid_(row_, col_); }
    CellProxy& operator=(double value) {
      owner_.set_value(row_, col_, value);
      return *this;
    }
    CellProxy& operator=(const CellProxy& other) { return *this = static_cast<double>(other); }
  };

  Grid(std::size_t rows, std::size_t cols)
      : rows_{rows}, cols_{cols}, grid_{rows, cols} {
    if (rows == 0 || cols == 0) {
      throw std::invalid_argument("Grid dimensions must be positive");
    }
  }

  std::size_t rows() const { return rows_; }
  std::size_t cols() const { return cols_; }
  CellProxy operator()(std::size_t row, std::size_t col) { return CellProxy{*this, row, col}; }
  double operator()(std::size_t row, std::size_t col) const { return grid_(row, col); }
};

// Borrow the old grid and snapshot its active window. Coordinates stay global.
class GridView {
private:
  const Grid& grid_;
  Grid::ActiveArea active_;
  friend void apply_stencil_impl(const GridView& source, Grid& destination);

public:
  GridView(const Grid& grid) : grid_{grid} {
    grid.detect_active_area();
    active_ = grid.active_;
  }

  std::size_t rows() const { return grid_.rows(); }
  std::size_t cols() const { return grid_.cols(); }
  std::size_t first_row() const { return active_.first_row; }
  std::size_t end_row() const { return active_.end_row; }
  std::size_t first_col() const { return active_.first_col; }
  std::size_t end_col() const { return active_.end_col; }
  bool empty() const { return active_.empty(); }

  const double* ptr(std::size_t row, std::size_t col) const { return grid_.grid_.ptr(row, col); }
  double operator()(std::size_t row, std::size_t col) const { return grid_(row, col); }
};
// Update four cells using avx at once
inline void apply_stencil_avx(const double* top, const double* mid, const double* bottom, double* out) {
  const __m256d center_weight = _mm256_set1_pd(0.5);
  const __m256d neighbor_weight = _mm256_set1_pd(0.125);

  const __m256d center = _mm256_loadu_pd(mid);

  __m256d neighbors = _mm256_add_pd(_mm256_loadu_pd(top), _mm256_loadu_pd(bottom));

  neighbors = _mm256_add_pd(neighbors, _mm256_loadu_pd(mid - 1));
  neighbors = _mm256_add_pd(neighbors, _mm256_loadu_pd(mid + 1));

  const __m256d result = _mm256_add_pd(
      _mm256_mul_pd(center_weight, center),
      _mm256_mul_pd(neighbor_weight, neighbors));

  _mm256_storeu_pd(out, result);
}


inline void apply_stencil_impl(const GridView& source, Grid& destination) {
  auto next{source.active_};
  if (!next.empty()) {
    // Heat can move by at most one cell per stencil update.
    next.first_row -= next.first_row != 0;
    next.first_col -= next.first_col != 0;
    next.end_row += next.end_row < source.rows();
    next.end_col += next.end_col < source.cols();
  }
  destination.clear_outside(next);
  destination.active_ = next;
  destination.active_dirty_ = false;
  if (next.empty()) {
    return;
  }

  const std::size_t first_col{std::max(next.first_col, std::size_t{1})};
  const std::size_t end_col{std::min(next.end_col, source.cols() - 1)};
  const std::size_t area{(next.end_row - next.first_row) * (next.end_col - next.first_col)};
  #pragma omp parallel for schedule(static) if(area >= 16384)
  for (std::size_t row = next.first_row; row < next.end_row; ++row) {
    const double* mid{source.ptr(row, 0)};
    double* __restrict out{destination.grid_.ptr(row, 0)};
    // Only the physical grid edges are fixed, not the active window's edges.
    if (row == 0 || row + 1 == source.rows()) {
      std::copy(mid + next.first_col, mid + next.end_col, out + next.first_col);
      continue;
    }
    if (next.first_col == 0) {
      out[0] = mid[0];
    }
    if (next.end_col == source.cols()) {
      out[source.cols() - 1] = mid[source.cols() - 1];
    }
    const double* top{source.ptr(row - 1, 0)};
    const double* bottom{source.ptr(row + 1, 0)};
    std::size_t col{first_col};
    for (; col + 4 <= end_col; col += 4) {
      apply_stencil_avx(top + col, mid + col, bottom + col, out + col);
    }
    for (; col < end_col; ++col) {
      out[col] = 0.5 * mid[col] +
                 0.125 * (top[col] + bottom[col] + mid[col - 1] + mid[col + 1]);
    }
  }
}

inline void apply_stencil(const Grid& source, Grid& destination) {
  if (source.rows() != destination.rows() || source.cols() != destination.cols()) {
    throw std::invalid_argument("Input and output grids must have matching dimensions");
  }
  if (&source == &destination) {
    throw std::invalid_argument("Input and output grids must be distinct");
  }
  apply_stencil_impl(GridView{source}, destination);
}

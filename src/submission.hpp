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

// The active rectangle contains every cell that might be nonzero.
// Cells outside it stay exactly zero, so they need no stencil evaluation.
class Grid {
private:
  struct Window {
    std::size_t first_row{0}, end_row{0};
    std::size_t first_col{0}, end_col{0};

    bool empty() const { return first_row == end_row || first_col == end_col; }

    void include(std::size_t row, std::size_t col) {
      if (empty()) {
        *this = Window{row, row + 1, col, col + 1};
      } else {
        first_row = std::min(first_row, row);
        end_row = std::max(end_row, row + 1);
        first_col = std::min(first_col, col);
        end_col = std::max(end_col, col + 1);
      }
    }

    bool contains(const Window& other) const {
      return other.empty() || (!empty() && first_row <= other.first_row &&
          end_row >= other.end_row && first_col <= other.first_col && end_col >= other.end_col);
    }
  };

  std::size_t rows_;
  std::size_t cols_;
  PaddedAlignedVector<double> grid_;
  Window active_;

  void set_value(std::size_t row, std::size_t col, double value) {
    if (!std::isfinite(value)) {
      throw std::invalid_argument("Grid values must be finite");
    }
    grid_(row, col) = value;
    if (value != 0.0) {
      active_.include(row, col);
    }
  }

  // A reused destination may contain an unrelated older field.
  void clear_outside(const Window& next) {
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

inline void apply_stencil(const Grid& source, Grid& destination) {
  if (source.rows_ != destination.rows_ || source.cols_ != destination.cols_) {
    throw std::invalid_argument("Input and output grids must have matching dimensions");
  }
  if (&source == &destination) {
    throw std::invalid_argument("Input and output grids must be distinct");
  }

  Grid::Window next{source.active_};
  if (!next.empty()) {
    // A five-point stencil can spread a nonzero value by at most one cell.
    next.first_row -= next.first_row != 0;
    next.first_col -= next.first_col != 0;
    next.end_row += next.end_row < source.rows_;
    next.end_col += next.end_col < source.cols_;
  }
  destination.clear_outside(next);
  destination.active_ = next;
  if (next.empty()) {
    return;
  }

  const std::size_t first_col{std::max(next.first_col, std::size_t{1})};
  const std::size_t end_col{std::min(next.end_col, source.cols_ - 1)};
  const std::size_t area{(next.end_row - next.first_row) * (next.end_col - next.first_col)};
  #pragma omp parallel for schedule(static) if(area >= 16384)
  for (std::size_t row = next.first_row; row < next.end_row; ++row) {
    const double* mid{source.grid_.ptr(row, 0)};
    double* __restrict out{destination.grid_.ptr(row, 0)};
    if (row == 0 || row + 1 == source.rows_) {
      std::copy(mid + next.first_col, mid + next.end_col, out + next.first_col);
      continue;
    }
    if (next.first_col == 0) {
      out[0] = mid[0];
    }
    if (next.end_col == source.cols_) {
      out[source.cols_ - 1] = mid[source.cols_ - 1];
    }
    const double* top{source.grid_.ptr(row - 1, 0)};
    const double* bottom{source.grid_.ptr(row + 1, 0)};
    #pragma omp simd
    for (std::size_t col = first_col; col < end_col; ++col) {
      out[col] = 0.5 * mid[col] +
                 0.125 * (top[col] + bottom[col] + mid[col - 1] + mid[col + 1]);
    }
  }
}

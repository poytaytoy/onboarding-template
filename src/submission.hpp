#pragma once

#include <algorithm>
#include <cstddef>
#include <cstring>
#include <limits>
#include <new>
#include <stdexcept>
#include <vector>

#ifdef __AVX__
#include <immintrin.h>
#endif

// Starter Grid for the 2D heat-diffusion problem.
//
// The evaluation harness uses operator() to set initial conditions and to read
// results; it never touches your internal storage. Keep this interface,
// everything else is yours.

// Aligns storage to 64 bytes and pads the stride so every row starts aligned.
template <typename T> class PaddedAlignedVector {
private:
  // Target the 64-byte cache lines on x86 CPUs.
  static constexpr std::size_t CACHE_ALIGNMENT = 64;

  static_assert(CACHE_ALIGNMENT % sizeof(T) == 0);
  static constexpr std::size_t elements_per_line = CACHE_ALIGNMENT / sizeof(T);

  // Allocates vector storage at a 64-byte boundary.
  template <typename U> class CacheAlignAllocator {
  public:
    using value_type = U;

    CacheAlignAllocator() noexcept = default;

    template <typename V>
    CacheAlignAllocator(const CacheAlignAllocator<V>&) noexcept {}

    // Vector compares allocators when copying a grid.
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

    storage_.resize(rows * stride_, T{});
  }

  inline T* ptr(std::size_t i, std::size_t j) {
    return storage_.data() + i * stride_ + j;
  }

  inline const T* ptr(std::size_t i, std::size_t j) const {
    return storage_.data() + i * stride_ + j;
  }

  inline T& operator()(std::size_t i, std::size_t j) { return *ptr(i, j); }

  inline const T& operator()(std::size_t i, std::size_t j) const {
    return *ptr(i, j);
  }
};

// Rectangle containing the nonzero cells. The end row and column are excluded.
struct ActiveArea {
  std::size_t first_row{0}, end_row{0};
  std::size_t first_col{0}, end_col{0};
  bool valid{true};

  bool empty() const { return first_row == end_row || first_col == end_col; }

  // Grow by one cell on each side, stopping at the grid edges.
  void expand(std::size_t rows, std::size_t cols) {
    if (empty()) {
      return;
    }
    if (first_row > 0) --first_row;
    if (first_col > 0) --first_col;
    if (end_row < rows) ++end_row;
    if (end_col < cols) ++end_col;
  }
};

class Grid {
private:
  std::size_t rows_;
  std::size_t cols_;
  PaddedAlignedVector<double> grid_;
  mutable ActiveArea active_{};

  // Find the nonzero rectangle again after cells have been accessed for writing.
  const ActiveArea& active_area() const {
    if (active_.valid) {
      return active_;
    }

    active_ = {};
    for (std::size_t row{0}; row < rows_; ++row) {
      for (std::size_t col{0}; col < cols_; ++col) {
        if (grid_(row, col) == 0.0) {
          continue;
        }
        if (active_.empty()) {
          active_ = {row, row + 1, col, col + 1};
        } else {
          active_.first_row = std::min(active_.first_row, row);
          active_.end_row = std::max(active_.end_row, row + 1);
          active_.first_col = std::min(active_.first_col, col);
          active_.end_col = std::max(active_.end_col, col + 1);
        }
      }
    }
    return active_;
  }

  friend void apply_stencil(const Grid& source, Grid& destination);

public:
  Grid(std::size_t rows, std::size_t cols)
      : rows_{rows}, cols_{cols}, grid_{rows, cols} {}
  std::size_t rows() const { return rows_; }
  std::size_t cols() const { return cols_; }

  // This cell may be changed, so the saved rectangle must be checked again.
  // Finish reference writes before applying a stencil.
  double& operator()(std::size_t row, std::size_t col) {
    active_.valid = false;
    return grid_(row, col);
  }
  double operator()(std::size_t row, std::size_t col) const {
    return grid_(row, col);
  }
};

// Use AVX when enabled at compile time, then finish with the regular formula.
inline void update_row(const double* top, const double* mid,
                       const double* bottom, double* out,
                       std::size_t col, std::size_t end_col) {
#ifdef __AVX__
  const __m256d center_weight{_mm256_set1_pd(0.5)};
  const __m256d neighbor_weight{_mm256_set1_pd(0.125)};

  for (; col + 4 <= end_col; col += 4) {
    const __m256d center{_mm256_loadu_pd(mid + col)};
    __m256d neighbors = _mm256_add_pd(_mm256_loadu_pd(top + col),
                                     _mm256_loadu_pd(bottom + col));
    neighbors = _mm256_add_pd(neighbors, _mm256_loadu_pd(mid + col - 1));
    neighbors = _mm256_add_pd(neighbors, _mm256_loadu_pd(mid + col + 1));
    const __m256d result =
        _mm256_add_pd(_mm256_mul_pd(center_weight, center),
                      _mm256_mul_pd(neighbor_weight, neighbors));
    _mm256_storeu_pd(out + col, result);
  }
#endif

  // either calculate what remains or calculate the entire row if AVX not enabled 
  for (; col < end_col; ++col) {
    out[col] = 0.5 * mid[col] + 0.125 * (top[col] + bottom[col] + mid[col - 1] + mid[col + 1]);
  }
}

// Alternate two grids: initialize the source and leave the destination zero.
// Between steps, only the stencil should change their cells.
inline void apply_stencil(const Grid& source, Grid& destination) {
  const std::size_t rows{source.rows_}, cols{source.cols_};
  if (rows != destination.rows_ || cols != destination.cols_) {
    throw std::invalid_argument("Grid dimensions must match");
  }
  if (&source == &destination) {
    throw std::invalid_argument("Stencil needs distinct source and destination grids");
  }

  // Heat can only spread by one cell in each direction per step.
  ActiveArea next{source.active_area()};
  next.expand(rows, cols);
  destination.active_ = next;
  if (next.empty()) {
    return;
  }

  const std::size_t first_col{std::max(next.first_col, std::size_t{1})};
  const std::size_t end_col{std::min(next.end_col, cols - 1)};
  const std::size_t width{next.end_col - next.first_col};
  
  #pragma omp parallel for schedule(static) if ((next.end_row - next.first_row) * width >= 16384)
  for (std::size_t row = next.first_row; row < next.end_row; ++row) {
    const double* mid{source.grid_.ptr(row, 0)};
    double* __restrict out{destination.grid_.ptr(row, 0)};

    // The outer edges keep their original temperatures.
    if (row == 0 || row + 1 == rows) {
      std::memcpy(out + next.first_col, mid + next.first_col,width * sizeof(double));
      continue;
    }

    if (next.first_col == 0) {
      out[0] = mid[0];
    }
    if (next.end_col == cols) {
      out[cols - 1] = mid[cols - 1];
    }

    update_row(source.grid_.ptr(row - 1, 0), mid,source.grid_.ptr(row + 1, 0), out, first_col, end_col);
  }
}

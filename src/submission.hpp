#pragma once

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

    storage_.resize(rows * stride_);
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

class Grid {
private:
  std::size_t rows_;
  std::size_t cols_;
  PaddedAlignedVector<double> grid_;

  friend class GridView;

public:
  Grid(std::size_t rows, std::size_t cols)
      : rows_(rows), cols_(cols), grid_(rows, cols) {}

  inline std::size_t rows() const { return rows_; }
  inline std::size_t cols() const { return cols_; }

  double& operator()(std::size_t i, std::size_t j) {
    return grid_(i, j);
  }

  double operator()(std::size_t i, std::size_t j) const {
    return grid_(i, j);
  }

  inline double* ptr(std::size_t i, std::size_t j) {
    return grid_.ptr(i, j);
  }

  inline const double* ptr(std::size_t i, std::size_t j) const {
    return grid_.ptr(i, j);
  }
};

// Borrow storage without copying. Essentially a viewer of it. 
class GridView {
private:
  std::size_t rows_;
  std::size_t cols_;
  const PaddedAlignedVector<double>& grid_;

public:
  GridView(const Grid& grid)
      : rows_(grid.rows_), cols_(grid.cols_), grid_(grid.grid_) {}

  inline std::size_t rows() const { return rows_; }
  inline std::size_t cols() const { return cols_; }

  inline const double* ptr(std::size_t i, std::size_t j) const {
    return grid_.ptr(i, j);
  }
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


inline void apply_stencil_impl(const GridView& old_grid, Grid& new_grid) {
  const std::size_t rows{old_grid.rows()};
  const std::size_t cols{old_grid.cols()};

  if (rows == 0 || cols == 0)
    return;

  // Copy logical boundary cells 
  std::memcpy(new_grid.ptr(0, 0), old_grid.ptr(0, 0), cols * sizeof(double));

  std::memcpy(new_grid.ptr(rows - 1, 0), old_grid.ptr(rows - 1, 0),cols * sizeof(double));

  // Rows have uniform work; static scheduling assigns each output row one writer.
  #pragma omp parallel for schedule(static)
  for (std::size_t i = 1; i < rows - 1; ++i) {
    const double* top{old_grid.ptr(i - 1, 0)};
    const double* mid{old_grid.ptr(i, 0)};
    const double* bottom{old_grid.ptr(i + 1, 0)};
    
    // Specify out is the only holder of this data within this scope with restrict, permitting potential compiler optimization
    // without worrying about alias pointers
    double* __restrict out{new_grid.ptr(i, 0)};

    out[0] = mid[0];
    out[cols - 1] = mid[cols - 1];

    std::size_t j = 1;

    // This offers a increased performance from `pragma SIMD` because they use SSE2 which only process 2 double at a time per 
    // instruction. This will explicitly use AVX which does 4 at at time

    // Four interior cells per vector; shifted addresses need unaligned loads.
    for (; j + 4 < cols; j += 4) {
      apply_stencil_avx(top + j, mid + j, bottom + j, out + j);
    }

    // Remaining columns
    for (; j < cols - 1; ++j) {
      out[j] = 0.5 * mid[j] + 0.125 * (top[j] + bottom[j] + mid[j - 1] + mid[j + 1]);
    }
  }
}

// Apply the five-point stencil over all interior points, copying the boundary
// values unchanged from old_grid to new_grid. Implement your solution here.
inline void apply_stencil(const Grid& old_grid, Grid& new_grid) {
  apply_stencil_impl(old_grid, new_grid);
}

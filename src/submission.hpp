#pragma once

#include <cstddef>
#include <vector> 
#include <cstring>
#include <cstdlib>
#include <new>

// Starter Grid for the 2D heat-diffusion problem.
//
// The evaluation harness uses operator() to set initial conditions and to read
// results; it never touches your internal storage. Keep this interface,
// everything else is yours.

template<typename T>
class PaddedAlignedVector {
  static constexpr std::size_t CACHE_ALIGNMENT = 64;
  
  static_assert(CACHE_ALIGNMENT % sizeof(T) == 0);
  
  static constexpr std::size_t elements_per_line = CACHE_ALIGNMENT / sizeof(T);

  template<typename U>
  class CacheAlignAllocator {
  public:
    using value_type = U;

    U* allocate(std::size_t count) {
      return static_cast<U*>(
        ::operator new(count * sizeof(U), std::align_val_t{CACHE_ALIGNMENT})
      );
    }

    void deallocate(U* pointer, std::size_t) noexcept {
      ::operator delete(pointer, std::align_val_t{CACHE_ALIGNMENT});
    }
  };

private: 
  std::size_t stride_;
  std::vector<T, CacheAlignAllocator<T>> storage_;

public:
  PaddedAlignedVector(std::size_t rows, std::size_t cols)
      : stride_((cols + elements_per_line - 1) / elements_per_line * elements_per_line),
        storage_(rows * stride_) {}

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

  double& operator()(std::size_t i, std::size_t j){
    return grid_(i, j);
  };

  double operator()(std::size_t i, std::size_t j) const{
    return grid_(i, j);
  };

  inline double* ptr(std::size_t i, std::size_t j) {
    return grid_.ptr(i, j);
  }

  inline const double* ptr(std::size_t i, std::size_t j) const {
    return grid_.ptr(i, j);
  }
};

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

// Apply the five-point stencil over all interior points, copying the boundary
// values unchanged from old_grid to new_grid. Implement your solution here.

inline void apply_stencil_impl(const GridView& old_grid, Grid& new_grid) {

  const std::size_t rows{old_grid.rows()};
  const std::size_t cols{old_grid.cols()};

  if (rows == 0 || cols == 0)
    return;

  // Copy logical boundary cells only; padding is not part of the field.
  std::memcpy(
    new_grid.ptr(0, 0),
    old_grid.ptr(0, 0),
    cols * sizeof(double)
  );

  std::memcpy(
      new_grid.ptr(rows - 1, 0),
      old_grid.ptr(rows - 1, 0),
      cols * sizeof(double)
  );

  // loop to populate each entry with the heat spread formula  
  #pragma omp parallel for schedule(static)
  for (std::size_t i = 1; i < rows - 1; ++i) {
    const double* top{old_grid.ptr(i - 1, 0)};
    const double* mid{old_grid.ptr(i, 0)};
    const double* bottom{old_grid.ptr(i + 1, 0)};
    double* __restrict out{new_grid.ptr(i, 0)};
    
    // populate column boundary from old to new 
    out[0] = mid[0];
    out[cols - 1] = mid[cols - 1];

    #pragma omp simd
    for (std::size_t j = 1; j < cols - 1; ++j) {
      out[j] = 0.5 * mid[j] + 0.125 * (top[j] + bottom[j] + mid[j - 1] + mid[j + 1]);
    }
  }
}

inline void apply_stencil(const Grid& old_grid, Grid& new_grid) {
  apply_stencil_impl(old_grid, new_grid);
}

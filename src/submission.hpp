#pragma once

#include <cstddef>
#include <vector> 
#include <thread> 
#include <omp.h>
#include <cstring>

// Starter Grid for the 2D heat-diffusion problem.
//
// The evaluation harness uses operator() to set initial conditions and to read
// results; it never touches your internal storage. Keep this interface,
// everything else is yours.

class Grid {

private:

  std::size_t rows_;
  std::size_t cols_;
  std::vector<double> grid_; 

public:

  inline Grid(std::size_t rows, std::size_t cols)
    : rows_(rows), cols_(cols), grid_(rows * cols) {}

  std::size_t rows() const { return rows_; }  
  std::size_t cols() const { return cols_; }

  double& operator()(std::size_t i, std::size_t j){
    return grid_[i * cols_ + j]; 
  };

  double  operator()(std::size_t i, std::size_t j) const{
    return grid_[i * cols_ + j]; 
  };

  inline double* data() {return grid_.data();}

  inline const double* data() const {return grid_.data();}

};  

// Apply the five-point stencil over all interior points, copying the boundary
// values unchanged from old_grid to new_grid. Implement your solution here.

inline void apply_stencil(const Grid& old_grid, Grid& new_grid) {

  const std::size_t rows = old_grid.rows();
  const std::size_t cols = old_grid.cols();

  // generate the pointers 
  const double* __restrict old_data = old_grid.data();
  double* __restrict new_data = new_grid.data();


  // copy the first and last row of the boundary from old to the new 
  std::memcpy(
    new_data,
    old_data,
    cols * sizeof(double)
  );

  std::memcpy(
      new_data + (rows - 1) * cols,
      old_data + (rows - 1) * cols,
      cols * sizeof(double)
  );

  // loop to populate each entry with the heat spread formula  
  #pragma omp parallel for schedule(static)
  for (std::size_t i = 1; i < rows - 1; ++i) {
    const double* top = old_data + (i - 1) * cols;
    const double* mid = old_data + i * cols;
    const double* bottom = old_data + (i + 1) * cols;
    double* out = new_data + i * cols;
    
    // populate column boundary from old to new 
    out[0] = mid[0];
    out[cols - 1] = mid[cols - 1];

    #pragma omp simd
    for (std::size_t j = 1; j < cols - 1; ++j) {
      out[j] = 0.5 * mid[j] + 0.125 * (top[j] + bottom[j] + mid[j - 1] + mid[j + 1]);
    }
  }
}

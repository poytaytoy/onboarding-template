#pragma once

#include <cstddef>
#include <vector> 
#include <thread> 
#include <omp.h>

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

  Grid(std::size_t rows, std::size_t cols)
    : rows_(rows), cols_(cols), grid_(rows * cols) {}

  std::size_t rows() const { return rows_; }  
  std::size_t cols() const { return cols_; }

  double& operator()(std::size_t i, std::size_t j){
    return grid_[i * cols_ + j]; 
  };

  double  operator()(std::size_t i, std::size_t j) const{
    return grid_[i * cols_ + j]; 
  };

  double* data() {return grid_.data();}

  const double* data() const {return grid_.data();}

};  

// Apply the five-point stencil over all interior points, copying the boundary
// values unchanged from old_grid to new_grid. Implement your solution here.

void apply_stencil(const Grid& old_grid, Grid& new_grid) {

  const std::size_t rows = old_grid.rows();
  const std::size_t cols = old_grid.cols();

  // generate the pointers 
  const double* __restrict old_data = old_grid.data();
  double* __restrict new_data = new_grid.data();

  // populate the boundary grid with the old grid entries 
  for (std::size_t i = 0; i < rows; ++i) {
    new_data[i * cols] = old_data[i * cols];
    new_data[i * cols + (cols - 1)] = old_data[i * cols + (cols - 1)];
  }

  for (std::size_t j = 1; j < cols - 1; ++j) {
    new_data[j] = old_data[j];
    new_data[(rows - 1) * cols + j] = old_data[(rows - 1) * cols + j];
  }

  // loop to populate each entry with the heat spread formula  

  #pragma omp parallel for schedule(static) num_threads(8)

  for (std::size_t i = 1; i < rows - 1; ++i) {

    for (std::size_t j = 1; j < cols - 1; ++j) {

      const double top    = old_data[(i - 1) * cols + j];
      const double mid    = old_data[i * cols + j];
      const double bottom = old_data[(i + 1) * cols + j];
      const double left   = old_data[i * cols + (j - 1)];
      const double right  = old_data[i * cols + (j + 1)];

      new_data[i * cols + j] = 0.5 * mid + 0.125 * (top + bottom + left + right);

    }
  }

}

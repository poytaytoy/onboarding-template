#pragma once

#include <cstddef>
#include <cstdint>
#include <vector> 
#include <omp.h>
#include <cstring>
#include <cmath> 
#include <algorithm> 
#include <limits>

// Starter Grid for the 2D heat-diffusion problem.
//
// The evaluation harness uses operator() to set initial conditions and to read
// results; it never touches your internal storage. Keep this interface,
// everything else is yours.

//divided by 4 and subtract by 1 to not overflow in the 4 add operations
constexpr uint32_t QMAX = std::numeric_limits<uint32_t>::max() / 4 - 1;

class Grid {
  
private:

  std::size_t rows_;
  std::size_t cols_;
  mutable std::vector<double> grid_;

public:

  void switch_to_unquantized() const {
    // Preserve every computed cell before making grid_ authoritative again.
    if (is_quantized_yet_) {
      for (std::size_t idx = 0; idx < grid_.size(); ++idx) {
        grid_[idx] = static_cast<double>(grid_quant_[idx]) * dequant_ + min_value_;
      }
      is_quantized_yet_ = false;
    }
    bad_ = false;
  }

  // if not quantizable ex, max and min are the same 
  mutable bool bad_ = false; 
  mutable std::vector<uint32_t> grid_quant_; 

  mutable bool is_quantized_yet_ = false;
  mutable double min_value_ = +INFINITY;  
  mutable double quant_; 
  mutable double dequant_;

  mutable double max_error_rate_ = 0;  
  mutable double max_error_per_step_ = 0;
  mutable int num_steps_ = 0;  
  mutable bool force_double_ = false;
  static constexpr double kErrorBudget = 1e-6;

  Grid(std::size_t rows, std::size_t cols)
    : rows_(rows), cols_(cols), grid_(rows * cols), grid_quant_(rows * cols) {}

  std::size_t rows() const { return rows_; }  
  std::size_t cols() const { return cols_; }

  double& operator()(std::size_t i, std::size_t j) {
    switch_to_unquantized();
    return grid_[i * cols_ + j];
  }

  double operator()(std::size_t i, std::size_t j) const {
    const std::size_t idx = i * cols_ + j;
    if (is_quantized_yet_) {
      return static_cast<double>(grid_quant_[idx]) * dequant_ + min_value_;
    }
    return grid_[idx];
  }

  inline double* data() {return grid_.data();}

  inline const double* data() const {return grid_.data();}
  
  inline const uint32_t* data_quantized() const {return grid_quant_.data();}

  inline uint32_t* data_quantized() {return grid_quant_.data();}

  inline void initialize_quantization_grid() const {
    if (is_quantized_yet_ || bad_ || force_double_){
      return; 
    }

    min_value_ = std::numeric_limits<double>::infinity();
    double max_value = -std::numeric_limits<double>::infinity();

    for (const auto& x : grid_) {
      max_value = std::max(x, max_value); 
      min_value_ = std::min(x, min_value_); 
    }

    double range = max_value - min_value_; 

    if (std::fpclassify(range) != FP_NORMAL) {
      bad_ = true;
      return; 
    }

    quant_ = static_cast<double>(QMAX) / (max_value - min_value_);

    dequant_ = range / static_cast<double>(QMAX);

    const double initial_error = max_error_rate_ + 0.5 * dequant_;
    // this just a guest lowkey 
    const double step_error = 2.0 * dequant_;

    if (!(dequant_ > 0.0) || !std::isfinite(quant_) ||
        !std::isfinite(initial_error + step_error) ||
        initial_error + step_error > kErrorBudget) {
      force_double_ = true;
      return;
    }

    max_error_rate_ = initial_error;
    max_error_per_step_ = step_error;

    for (size_t i = 0; i < rows_ * cols_; i ++ ) {
      grid_quant_[i] = static_cast<uint32_t>(std::llround((grid_[i] - min_value_) * quant_));
    }

    is_quantized_yet_ = true; 
  }

  inline void inherit_quantization(const Grid& old_grid){
    is_quantized_yet_ = true; 
    min_value_ = old_grid.min_value_; 
    quant_ = old_grid.quant_; 
    dequant_ = old_grid.dequant_; 
    max_error_rate_ = old_grid.max_error_rate_ + old_grid.max_error_per_step_;
    max_error_per_step_ = old_grid.max_error_per_step_; 
  }
};  

// Apply the five-point stencil over all interior points, copying the boundary
// values unchanged from old_grid to new_grid. Implement your solution here.

inline void apply_stencil_quantized(const Grid& old_grid, Grid& new_grid) {
  new_grid.inherit_quantization(old_grid); 

  const std::size_t rows = old_grid.rows();
  const std::size_t cols = old_grid.cols();

  // generate the pointers 
  const uint32_t* __restrict old_data_quantized = old_grid.data_quantized();
  const double* __restrict old_data = old_grid.data();
  double* __restrict new_data = new_grid.data();
  uint32_t* __restrict new_data_quantized = new_grid.data_quantized();

  // copy the first and last row of the boundary from old to the new 

  std::memcpy(new_data_quantized,
            old_data_quantized,
            cols * sizeof(uint32_t));

  std::memcpy(new_data_quantized + (rows - 1) * cols,
            old_data_quantized + (rows - 1) * cols,
            cols * sizeof(uint32_t));

  const double dequant = old_grid.dequant_;
  const double min_value = old_grid.min_value_; 

  // loop to populate each entry with the heat spread formula  
  const bool odd = old_grid.num_steps_ % 2;
  const uint32_t inner_round = odd ? 0u : 1u;
  const uint32_t outer_round = odd ? 3u : 4u;

  #pragma omp parallel for schedule(static) num_threads(4)
  for (std::size_t i = 1; i < rows - 1; ++i) {
      const uint32_t* top = old_data_quantized + (i - 1) * cols;
      const uint32_t* mid = old_data_quantized + i * cols;
      const uint32_t* bottom = old_data_quantized + (i + 1) * cols;
      uint32_t* out_quantized = new_data_quantized + i * cols;

      out_quantized[0] = mid[0];
      out_quantized[cols - 1] = mid[cols - 1];

      #pragma omp simd
      for (std::size_t j = 1; j < cols - 1; ++j) {
          uint32_t neighbors = top[j] + bottom[j] + mid[j - 1] + mid[j + 1];
          out_quantized[j] = ((mid[j] + inner_round) >> 1) + ((neighbors + outer_round) >> 3);
      }
  }
}

inline void apply_stencil_regular(const Grid& old_grid, Grid& new_grid) {

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

inline void apply_stencil(const Grid& old_grid, Grid& new_grid) {
  old_grid.initialize_quantization_grid();

  if (old_grid.is_quantized_yet_ &&
      old_grid.max_error_rate_ + old_grid.max_error_per_step_ > Grid::kErrorBudget) {
    old_grid.switch_to_unquantized();
    old_grid.force_double_ = true;
  }

  new_grid.is_quantized_yet_ = false;
  new_grid.bad_ = false;

  // Carry the simulation's state into the destination buffer.
  new_grid.force_double_ = old_grid.force_double_;
  new_grid.max_error_rate_ = old_grid.max_error_rate_;
  new_grid.max_error_per_step_ = old_grid.max_error_per_step_;

  if (old_grid.is_quantized_yet_) {
    apply_stencil_quantized(old_grid, new_grid);
  } else {
    apply_stencil_regular(old_grid, new_grid);
  }
  new_grid.num_steps_ = old_grid.num_steps_ + 1;
}

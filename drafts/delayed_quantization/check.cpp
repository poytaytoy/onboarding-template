#include "submission.hpp"
#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <random>
#include <string>
#include <utility>

struct Result {
  double error{0};
  double range_at_200{-1};
  double final_range{0};
  double switch_range{-1};
  std::size_t first_encoded{0};
  std::size_t quantized_updates{0};
};

Result check(const std::string& name, std::size_t rows, std::size_t cols,
             std::size_t steps, const std::vector<double>& initial) {
  Grid first(rows, cols), second(rows, cols);
  auto reference{initial};
  std::vector<double> next(rows * cols);
  for (std::size_t r{0}; r < rows; ++r) {
    for (std::size_t c{0}; c < cols; ++c) { first(r, c) = reference[r * cols + c]; }
  }
  Result result;
  bool was_encoded{false};
  for (std::size_t step{1}; step <= steps; ++step) {
    next = reference;
    for (std::size_t r{1}; r + 1 < rows; ++r) {
      for (std::size_t c{1}; c + 1 < cols; ++c) {
        const auto i{r * cols + c};
        next[i] = .5 * reference[i] + .125 *
            (reference[i-cols] + reference[i+cols] + reference[i-1] + reference[i+1]);
      }
    }
    const bool quantized_update{GridView(first).is_quantized()};
    apply_stencil(first, second);
    result.quantized_updates += quantized_update;
    const GridView output(second);
    const bool encoded{output.is_quantized()};
    // The threshold-only draft must stay quantized after the transition.
#ifdef CHECK_PERMANENT_QUANTIZATION
    assert(!was_encoded || encoded);
#endif
    was_encoded = encoded;
    double minimum{std::numeric_limits<double>::infinity()};
    double maximum{-std::numeric_limits<double>::infinity()};
    for (std::size_t r{0}; r < rows; ++r) {
      for (std::size_t c{0}; c < cols; ++c) {
        const double value{output(r,c)};
        assert(std::isfinite(value));
        result.error = std::max(result.error, std::fabs(value-next[r*cols+c]));
        minimum = std::min(minimum, value);
        maximum = std::max(maximum, value);
      }
    }
    result.final_range = maximum-minimum;
    if (step == 200) { result.range_at_200 = result.final_range; }
    if (encoded && !result.first_encoded) {
      result.first_encoded = step;
      result.switch_range = result.final_range;
    }
    reference.swap(next);
    std::swap(first, second);
  }
  std::printf("%s,%zu,%zu,%zu,%.17g,%zu,%zu,%.17g,%.17g,%.17g\n",
      name.c_str(),rows,cols,steps,result.error,result.first_encoded,result.quantized_updates,
      result.switch_range,result.range_at_200,result.final_range);
  std::fflush(stdout);
  return result;
}

int main(int argc, char** argv) {
  std::puts("case,rows,cols,steps,max_error,first_encoded,quantized_updates,switch_range,range_at_200,final_range");
  const std::string suite{argc > 1 ? argv[1] : "large"};
  unsigned failures{0};
  if (suite == "calibrate") {
    const unsigned seed{argc > 2 ? static_cast<unsigned>(std::strtoul(argv[2], nullptr, 10)) : 72319u};
    const int samples{argc > 3 ? std::atoi(argv[3]) : 48};
    const std::size_t steps{argc > 4 ? std::strtoull(argv[4], nullptr, 10) : 5000};
    const double amplitude{argc > 5 ? std::atof(argv[5]) : 32.0};
    const std::size_t factor{argc > 6 ? std::strtoull(argv[6], nullptr, 10) : 1};
    std::mt19937 random(seed);
    std::uniform_real_distribution<double> unit(0,1);
    const std::size_t widths[]{5,11,31,64,97,194};
    const std::size_t heights[]{7,13,26,33,65,130};
    constexpr double qmax{4294967295.0};
    for (int sample{0}; sample < samples; ++sample) {
      const auto rows{factor*heights[random()%6]}, cols{factor*widths[random()%6]};
      const int pattern{sample%12};
      std::vector<double> values(rows*cols);
      const double offset{sample%3 == 0 ? -amplitude*.5 : 0.0};
      for (std::size_t r{0};r<rows;++r) for (std::size_t c{0};c<cols;++c) {
        const double x{static_cast<double>(r)/(rows-1)}, y{static_cast<double>(c)/(cols-1)};
        double v{0};
        switch(pattern) {
          case 0: v=unit(random); break;
          case 1: v=(r+c)%2; break;
          case 2: v=(x>=.375 && x<.625 && y>=.375 && y<.625); break;
          case 3: v=(x+y)*.5; break;
          case 4: v=.5+.25*(std::sin(6*x)+std::cos(8*y)); break;
          case 5: v=(r==rows/2 && c==cols/2); break;
          case 6: v=(c/3)%2; break;
          case 7: v=.37; break;
          case 8: v=(qmax/2+random()%8)/qmax; break;
          case 9: v=(random()%8)/qmax; break;
          case 10: v=std::min(1.0,(x+y)*.5+(random()%8)/qmax); break;
          case 11: v=(qmax-random()%8)/qmax; break;
        }
        values[r*cols+c] = offset+amplitude*v;
      }
      if (pattern>=8) { values[0]=offset; values[1]=offset+amplitude; }
      const auto result{check("pattern"+std::to_string(pattern)+"_"+std::to_string(sample),rows,cols,steps,values)};
      failures += result.error>1e-6;
      if (sample%12==11) { std::fprintf(stderr,"Checked %d/%d fields\n",sample+1,samples); }
    }
  } else {
    for (double amplitude : {1000.0,1e6,1e9,1e12}) {
      for (bool block : {false,true}) {
        constexpr std::size_t size{1024};
        std::vector<double> values(size*size);
        if (block) {
          for (std::size_t r{384};r<640;++r) for(std::size_t c{384};c<640;++c) { values[r*size+c]=amplitude; }
        } else { values[(size/2)*size+size/2]=amplitude; }
        const auto result{check(std::string(block?"block_":"spike_")+std::to_string(amplitude),size,size,200,values)};
        failures += result.error>1e-6;
      }
    }
    for (double amplitude : {1e6,1e9,1e12}) {
      constexpr std::size_t size{33};
      std::vector<double> values(size*size);
      values[(size/2)*size+size/2]=amplitude;
      const auto result{check("small_spike_"+std::to_string(amplitude),size,size,15000,values)};
      failures += result.error>1e-6;
    }
    for (const auto dims : {std::pair<std::size_t,std::size_t>{1,1},{1,17},{17,1},{2,19}}) {
      const auto result{check("boundary_only",dims.first,dims.second,30,std::vector<double>(dims.first*dims.second,1000.0))};
      failures += result.error>1e-6;
    }
  }
  std::fprintf(stderr,"Cases exceeding tolerance: %u\n",failures);
  return failures ? 1 : 0;
}

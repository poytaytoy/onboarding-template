#include "submission.hpp"
#include <cassert>
#include <cstdio>
#include <utility>

int main() {
  // A fixed boundary extreme must prevent a switch even with a cool interior.
  Grid a(9, 17), b(9, 17);
  a(4, 0) = 1000;
  for (int step{0};step<50;++step) {
    apply_stencil(a,b);
    assert(!GridView(b).is_quantized());
    assert(static_cast<double>(b(4,0))==1000);
    std::swap(a,b);
  }

  // A source already encoded can overwrite a previously double-only destination.
  Grid cool(9,17);
  cool(4,8)=1;
  apply_stencil(cool,b);
  assert(GridView(b).is_quantized());
  const double before{b(4,8)};
  apply_stencil(b,a);
  assert(GridView(a).is_quantized());
  assert(static_cast<double>(b(4,8))==before);

  // External writes decode first; a new large range waits in doubles again.
  a(4,8)=1000000;
  assert(!GridView(a).is_quantized());
  apply_stencil(a,b);
  assert(!GridView(b).is_quantized());

  // A small range at a huge absolute offset exposes floating-point differences.
  constexpr std::size_t rows{17}, cols{23};
  Grid high(rows,cols), out(rows,cols);
  std::vector<double> reference(rows*cols), next(rows*cols);
  for(std::size_t r{0};r<rows;++r) for(std::size_t c{0};c<cols;++c) {
    reference[r*cols+c]=1e12+4.0*((r*7+c*11)%37)/36.0;
    high(r,c)=reference[r*cols+c];
  }
  double error{0};
  for(int step{0};step<200;++step) {
    next=reference;
    for(std::size_t r{1};r+1<rows;++r) for(std::size_t c{1};c+1<cols;++c) {
      const auto i{r*cols+c};
      next[i]=.5*reference[i]+.125*(reference[i-cols]+reference[i+cols]+reference[i-1]+reference[i+1]);
    }
    apply_stencil(high,out);
    for(std::size_t r{0};r<rows;++r) for(std::size_t c{0};c<cols;++c) {
      error=std::max(error,std::fabs(static_cast<double>(out(r,c))-next[r*cols+c]));
    }
    reference.swap(next);std::swap(high,out);
  }
  std::printf("State and boundary checks passed. Offset-1e12 probe: max_error=%.12g, within_tolerance=%s\n",error,error<=1e-6?"yes":"no");
}

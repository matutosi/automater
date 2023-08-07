#include <Rcpp.h>
using namespace Rcpp;

//' @rdname locate_image
//' @param mt_1,mt_2  A matrix of image data.
//' @return  A logical.
//' @export
// [[Rcpp::export]]
bool is_equal_matrix(NumericMatrix mt_1, NumericMatrix mt_2){
  for(int i = 0; i < mt_1.nrow(); i++){
    for(int j = 0; j < mt_1.ncol(); j++){
      if(mt_1(i, j) != mt_2(i, j)){
        return false;
      }
    }
  }
  // Rcout << "Equal!";
  return true;
}

//' Search needle image in haystack image and locate needle position.
//'
//' @rdname locate_image
//' @param ndl_mt,hay_mt  A matrix with grayscale x-y position.
//' @return  x-y position of needle image.
//'
//' @export
// [[Rcpp::export]]
NumericVector locate_image_cpp(NumericMatrix ndl_mt, NumericMatrix hay_mt){
  int ndl_h = ndl_mt.ncol(); int ndl_w = ndl_mt.nrow();
  int hay_h = hay_mt.ncol(); int hay_w = hay_mt.nrow();
  int last_x = hay_w - ndl_w;
  int last_y = hay_h - ndl_h;
  // use double to avoid "warning: narrowing conversion of 'x' from 'int' to 'double'"
  for(double x = 0; x < last_x; x++){
    for(double y = 0; y < last_y; y++){
      NumericMatrix h_mt = hay_mt(Range(x, x + ndl_w - 1), Range(y, y + ndl_h - 1));
      if(is_equal_matrix(ndl_mt, h_mt)){
        return {x, y};
      }
    }
  }
  return {-1, -1};
}

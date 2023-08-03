/*
library(Rcpp)
library(tidyverse)
library(imager)

needle_image   <- load.image("D:/matu/work/tmp/needle_image.png")
haystack_image <- load.image("D:/matu/work/tmp/haystack_image.png")
plot(needle_image)

ndl_mt <- img2gray_matrix(needle_image  )
hay_mt <- img2gray_matrix(haystack_image)


sourceCpp("D:/matu/work/ToDo/automater/src/locate_image.cpp")
sourceCpp("D:/matu/work/ToDo/automater/src/locate_image.cpp")

cpp_locate_img(ndl_mt, dim(ndl_mt), hay_mt, dim(hay_mt))


is_equal_matrix(ndl_mt, ndl_mt)

*/
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericMatrix is_equal_matrix(NumericMatrix mt_1, NumericMatrix mt_2){
  // bool is_equal_matrix(NumericMatrix mt_1, NumericMatrix mt_2){
  //   for(int i = 0; i < mt_1.size(); i++){
  //     for(int j = 0; j < mt_1[0].size(); j++){
  //       bool not_equal = mt_1[i][j] != mt_2[i][j];
  //       if(not_equal) return false;
  //     }
  //   }
  //   return true;
  return mt_1;
}

// [[Rcpp::export]]
NumericVector cpp_locate_img(NumericMatrix ndl_mt, NumericVector ndl_dim, 
                             NumericMatrix hay_mt, NumericVector hay_dim){
  // NumericVector cpp_locate_img(NumericVector ndl_vec, NumericVector ndl_dim, 
  //                              NumericVector hay_vec, NumericVector hay_dim){
  //   ndl_vec.attr("dim") = Dimension(ndl_dim[0], ndl_dim[1]);
  //   hay_vec.attr("dim") = Dimension(hay_dim[0], hay_dim[1]);
  //   
  //   NumericMatrix ndl_mt = as<NumericMatrix>(ndl_vec);
  //   NumericMatrix hay_mt = as<NumericMatrix>(hay_vec);

  int ndl_w = ndl_mt.nrow(); int ndl_h = ndl_mt.ncol();
  int hay_w = hay_mt.nrow(); int hay_h = hay_mt.ncol();
  int last_x = hay_w - ndl_w;
  int last_y = hay_h - ndl_h;

  for(int x = 0; x < last_x; x++){                         //   xs <- 1:last_x;
    for(int y = 0; y < last_y; y++){                       //   ys <- 1:last_y;
      for(int offset = 1; offset < (ndl_h - 1); offset++){ //   offsets <- 0:(ndl_h - 1)
        bool not_matched = false;
  //         bool not_matched = !is_equal_matrix(ndl_mt, hay_mt);
        if(not_matched){
          break;
        }
      if(offset == ndl_h){
        return {x, y};
      }
      }
    }
  }
  return {-1, -1};
}

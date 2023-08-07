// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// is_equal_matrix
bool is_equal_matrix(NumericMatrix mt_1, NumericMatrix mt_2);
RcppExport SEXP _automater_is_equal_matrix(SEXP mt_1SEXP, SEXP mt_2SEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type mt_1(mt_1SEXP);
    Rcpp::traits::input_parameter< NumericMatrix >::type mt_2(mt_2SEXP);
    rcpp_result_gen = Rcpp::wrap(is_equal_matrix(mt_1, mt_2));
    return rcpp_result_gen;
END_RCPP
}
// locate_image_cpp
NumericVector locate_image_cpp(NumericMatrix ndl_mt, NumericMatrix hay_mt);
RcppExport SEXP _automater_locate_image_cpp(SEXP ndl_mtSEXP, SEXP hay_mtSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type ndl_mt(ndl_mtSEXP);
    Rcpp::traits::input_parameter< NumericMatrix >::type hay_mt(hay_mtSEXP);
    rcpp_result_gen = Rcpp::wrap(locate_image_cpp(ndl_mt, hay_mt));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_automater_is_equal_matrix", (DL_FUNC) &_automater_is_equal_matrix, 2},
    {"_automater_locate_image_cpp", (DL_FUNC) &_automater_locate_image_cpp, 2},
    {NULL, NULL, 0}
};

RcppExport void R_init_automater(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}

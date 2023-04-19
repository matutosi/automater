#' Wrapper functions for ocr using package tesseract. 
#' 
#' Package tesseract <https://cran.r-project.org/web/packages/tesseract/index.html>
#' 
#' @name ocr
#' @param img          A string of image file path.
#' @param lng          A string with language for tesseract engine
#'                     See detail in tesseract::ocr and tesseract::tesseract.
#'                     Need to download engine by tesseract_download().
#' @param binarization A string with the type of binarization to use. 
#'                     See detail in image.binarization::image_binarization.
#' @return  A string.
#' @examples
#' \donttest{
#' library(automater)
#' tmp <- tempfile()
#' curl::curl_download("https://jeroen.github.io/images/testocr.png", tmp)
#' ocr_tesseract(tmp)
#' }
#' 
#' @export
ocr_tesseract <- function(img, lng = "jpn", binarization = NULL){
  if(!is.null(binarization)){
    img <- image.binarization::image_binarization(img, type = binarization)
  }
  text <- tesseract::ocr(img, engine = tesseract::tesseract(lng))
  return(text)
}

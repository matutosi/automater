#' Wrapper functions to convert images using package magick 
#' 
#' Package magick <https://cran.r-project.org/web/packages/magick/index.html>
#' 
#' @param image                  A magick-image object.
#' @param left_top,right_bottom  A numeric vector of x- and y-position.
#' @return                       A magick-image object.
#' @examples
#' \donttest{
#' library(magick)
#' logo <- image_read("logo:")
#' magick_crop(logo, c(100,100), c(200,250))
#' }
#' 
#' @export
magick_crop <- function(image, left_top, right_bottom){
  left   <- left_top[1]
  top    <- left_top[2]
  right  <- right_bottom[1]
  bottom <- right_bottom[2]
  geometry <- paste0(right - left, "x", bottom - top, "+", left, "+", top)
  magick::image_crop(image, geometry)
}

#' Donwload screenshot image from web based on URL and 
#' add text annotation of URL on the top of the image.
#' 
#' @param url           A string of URL.
#' @param trim          A logical if trim image by magick::image_trim().
#' @param border_size   A string of border size. "x40": Set border 
#'                      on the top for annotation. Will be passed like
#'                      imagick::image_border(img, "white", geometry = border_size).
#' @param annotate_size A string of annnotation size.
#'                      Will be passed like magick::image_annotate
#'                      (img, url, size = annotate_size).
#' @param format        A string of format of image. Will be passed like 
#'                      magick::image_convert(img, format = format)
#' @param resize        A string for resize by magick::image_scale(). 
#'                      Passed like magick::image_scale(geometry = resize).
#' @return              A magick-image object.
#' @examples
#' \donttest{
#' url <- "https://www.deepl.com/translator"
#' img <- web_screenshot(url, format = "png")
#' magick::image_browse(img)
#' magick::image_write(img, "deepl.png")
#' }
#' 
#' @export
web_screenshot <- function(url, trim = TRUE, border_size = "x40", annotate_size = 20, format = "png", resize = FALSE){
  png <- fs::file_temp(ext = "png")
  webshot::webshot(url, png)
  img <- magick::image_read(png)
  fs::file_delete(png)
  if(trim){ img <- magick::image_trim(img) }
    # add top margin (and removed bottom margin by image_crop)
  img <- magick::image_border(img, "white", geometry = border_size)
  crop_size <- stringr::str_split(border_size, pattern = "x", simplify = TRUE)[2]
  h <- magick::image_info(img)$height - as.numeric(crop_size)
  img <- magick::image_crop(img, geometry = paste0("x", h))
  img <- magick::image_convert(img, format = format)
    # add annotation
  img <- magick::image_annotate(img, url, size = annotate_size)
  if(resize != FALSE){ img <- magick::image_scale(geometry = resize) }
  return(img)
}

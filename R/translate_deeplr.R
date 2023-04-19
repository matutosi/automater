  # D:/matu/work/ToDo/kwu/R/deeplr.R
  # https://gist.github.com/matutosi/bf51c04527714675e773d3052f0e930a#file-use-deepl-with-r-and-deeplr

#' Wrapper functions to use deepl translation using package deeplr 
#' 
#' Package deeplr <https://cran.r-project.org/web/packages/deeplr/index.html>
#' 
#' @name deeplr
#' @param str                       A string.
#' @param api_key                   A string of deepl api key
#' @param source_lang,target_lang   A character to select language.
#' @return    A character translated by deepl
#' @examples
#' \donttest{
#' library(dplyr)
#' library(deeplr)
#'   # Example: "I am a cat" by Soseki Natsume
#' sentences <- c("I am a cat. I don't have a name yet.", 
#'                "I have no idea where I was born.")
#' api_key <- "set_your_key"
#' tibble::tibble(en = sentences) %>%
#'   dplyr::mutate(`:=`("jp", deepl_api(en, api_key = api_key))
#' }
#' 
#' @export
deepl_api <- function(str, api_key, source_lang = "EN", target_lang = "JA"){
  deeplr::translate2(str, source_lang = source_lang, target_lang = target_lang, auth_key = api_key)
}


  # https://www.deepl.com/translator#en/ja/this%20is%20a%20pen # this is a pen
  # rvestやcurlでHTMLを取得しようとしたが，ダメだった
  #     rvest::read_html("https://www.deepl.com/translator#en/ja/this%20is%20a%20pen")
  #     curl::curl_download("https://www.deepl.com/translator#en/ja/this%20is%20a%20pen", "d:/a.txt")
  # seleniumuで取得する必要がありそう
  #   deepl_free()ではRSeleniumuを使っている

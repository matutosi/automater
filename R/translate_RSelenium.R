  # D:/matu/work/ToDo/kwu/R/deeplr.R

#' Wrapper functions to use deepl translation using package RSelenium and others
#' 
#' Package deeplr <https://cran.r-project.org/web/packages/RSelenium/index.html>
#' 
#' For polite scraping sleep >5 sec in a running of deepl_free().
#' 
#' @param str A character. Maximum length of character is 5000 in deepl_free().
#' @param rem An RSelenium object.
#' @param source_lang,target_lang A character to select language.
#'        Use capital letters in deepl_api(), and small letters in deepl_free().
#' @return A character translated by deepl
#' 
#' @examples
#' library(RSelenium)
#' library(purrr)
#' library(dplyr)
#' library(deeplr)
#' library(rvest)
#' \dontrun{
#'   # Example: from "I am a cat" by Soseki Natsume
#' sentences <- c("I am a cat. I don't have a name yet.", "I have no idea where I was born.")
#' api_key <- "your_api_key"
#' tibble::tibble(en = sentences) %>%
#'   dplyr::mutate(jp = deepl_api(en, api_key = api_key))
#' rem <- start_selenium()
#' purrr::map_chr(sentences, deepl_free, rem = rem)
#' stop_selenium(rem)
#' }
#' @name deepl_free
#' @export
deepl_free <- function(str, rem, source_lang = "en", target_lang = "ja"){
  # https://gist.github.com/matutosi/bf51c04527714675e773d3052f0e930a#file-use-deepl-with-r-and-deeplr
  message("Translating '", stringr::str_sub(str, 1, 12), "' ... ")
  deepl <- paste0("https://www.deepl.com/translator#", source_lang, "/", target_lang, "/")
  url <- utils::URLencode(paste0(deepl, str))
  rem$navigate(url)
  sleep()
  translated <- 
    rem$getPageSource() %>%
    `[[`(1) %>%
    xml2::read_html() %>%
    rvest::html_elements("#target-dummydiv") %>%
    rvest::html_text2()
  return(translated)
}

#' Helper function to start Selenium and RSelenium
#' Need instration of Java, Selenium and GoogleChrome driver as described in README.R
#' @rdname deepl_free
#' @export
start_selenium <- function(){
  shell("d: & cd d:\\pf\\selenium & start java -jar selenium-server-standalone-3.141.59.jar")
  sleep()
  rem <- RSelenium::remoteDriver(port = 4444L, browserName = "chrome")
  rem$open()
  return(rem)
}

#' Helper function to stop Selenium and RSelenium
#' @rdname deepl_free
#' @export
stop_selenium <- function(rem){
  rem$close()
  shell("taskkill /f /im java.exe")
}

  # D:/matu/work/ToDo/kwu/R/deeplr.R

#' Wrapper functions to use deepl translation using package deeplr 
#' 
#' Package deeplr <https://cran.r-project.org/web/packages/deeplr/index.html>
#' 
#' @name deeplr
#' @param 
#' @retuen  
#' @examples
#' \donttest{
#' }
#' }
#' 
#' @export


#' Use deepl by api (deepl_api()) and free (deepl_free())
#' For polite scraping sleep >5 sec in a running of deepl_free().
#' 
#' @name use_deepl
#' @param str A character. Maximum lenght of character is 5000 in deepl_free().
#' @param rem An RSelenium object.
#' @param api_key A character of deepl api key
#' @param source_lang,target_lang A character to select language.
#'        Use capital letters in deepl_api(), and small letters in deepl_free().
#' @return A character translated by deepl
#' 
#' @example
#' library(RSelenium)
#' library(tidyverse)
#' library(deeplr)
#' library(rvest)
#' 
#'   # Example: "I am a cat" by Soseki Natsume
#' sentences <- c("I am a cat. I don't have a name yet.", "I have no idea where I was born.")
#' api_key <- "ce943af7-40e7-a8bc-a44b-466e15ee1059:fx"
#' tibble::tibble(en = sentences) %>%
#'   dplyr::mutate(jp = deepl_api(en, api_key = api_key))
#' rem <- start_selenium()
#' purrr::map_chr(sentences, deepl_free, rem = rem)
#' stop_selenium(rem)
#' 
#' 
#'   # Example: Tidy modelong with R (https://www.tmwr.org/)
#' 
#' api_key <- "ce943af7-40e7-a8bc-a44b-466e15ee1059:fx"
#' tidy_modeling <- readr::read_tsv("D:/matu/work/ToDo/TMwR/jp/contens.txt")
#' str <- 
#'   tidy_modeling %>%
#'   `[[`("en")
#' str %>%
#'   purrr::map_dbl(stringr::str_length) %>%
#'   max()
#' 
#' rem <- start_selenium()
#' 
#' str <- head(str, 9)
#' n <- 500
#' n <- 5
#' len <- length(str)
#' times <- (len %/% n) + ifelse((len %% n) == 0, 0, 1)
#' jp <- list()
#' 
#' for(i in seq(times)){
#'   begin <- (i - 1) * n + 1
#'   end   <- min(i * n, len)
#'   tmp_str <- str[begin:end]
#'   jp[[i]] <- purrr::map_chr(tmp_str, deepl_free, rem = rem)
#'   print(paste0(i * n, " / ", len))
#' }
#' 
#' stop_selenium(rem)
#' jp <- unlist(jp)
#' readr::write_tsv(tibble::tibble(jp), "C:/Users/matsumura/Desktop/tmwr_jp.txt")
#' 
#' 
#' 
#' @export
deepl_api <- function(str, api_key, source_lang = "EN", target_lang = "JA"){
  deeplr::translate2(str, source_lang = source_lang, target_lang = target_lang, auth_key = api_key)
}


  # https://gist.github.com/matutosi/bf51c04527714675e773d3052f0e930a#file-use-deepl-with-r-and-deeplr


## RSelenium

#' @rdname use_deepl
#' @export
deepl_free <- function(str, rem, source_lang = "en", target_lang = "ja"){
  message("Translating '", stringr::str_sub(str, 1, 12), "' ... ")
  deepl <- paste0("https://www.deepl.com/translator#", source_lang, "/", target_lang, "/")
  url <- URLencode(paste0(deepl, str))
  rem$navigate(url)
  sleep_rnd()
  translated <- 
    rem$getPageSource() %>%
    `[[`(1) %>%
    xml2::read_html() %>%
    rvest::html_elements("#target-dummydiv") %>%
    html_text2()
  return(translated)
}

#' Helper function to start Selenium and RSelenium
#' Need instration of Java, Selenium and GoogleChrome driver as described in README.R
#' 
start_selenium <- function(){
  shell("d: & cd d:\\pf\\selenium & start java -jar selenium-server-standalone-3.141.59.jar")
  sleep_rnd()
  rem <- RSelenium::remoteDriver(port = 4444L, browserName = "chrome")
  rem$open()
  return(rem)
}

#' Helper function to stop Selenium and RSelenium
#' @param rem An RSelenium object.
stop_selenium <- function(rem){
  rem$close()
  shell("taskkill /f /im java.exe")
}

#' Wrapper function for Sys.sleep()
#' 
#' To avoid constant sleep, random second is given by runif() and rnorm().
#' @param sec A numeric (second) to sleep.
sleep_rnd <- function(sec = 5){
  rnd <- runif(1, 0, 1) + rnorm(1, 0.7, 0.2)
  Sys.sleep(sec + rnd)
}

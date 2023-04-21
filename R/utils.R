#' Check package installation and install it when not yet.
#' 
#' @param pkg    A string of package names.
#' @param repos  A string of url for repository
#' @examples
#' \donttest{
#' validate_package("automater")
#' validate_package("xlsx")
#' }
#' 
#' @export
validate_package <- function(pkg, repos = "https://cran.ism.ac.jp/"){
  if(! pkg %in% utils::installed.packages()[,1]){
    options(repos = repos)
    utils::install.packages(pkg)
  }
}

#' Split file name into body part and extention.
#' 
#' @param   file     A string of file name.
#' @return  A list including file name of body part and extention.
#' @examples
#' file <- "aaa.body.ext"
#' file_split_name(file)
#' 
#' @export
file_split_name <- function(file){
  body <- unlist(stringr::str_split(file, "\\."))
  ext <- stringr::str_split_i(file, "\\.", -1)
  body <- stringr::str_c(body[-length(body)], collapse = ".")
  file <- list(body = body, ext = ext)
  return(file)
}

#' Add numbers to file name. 
#' 
#' @param   file    A string of file name.
#' @param   n       A integer.
#' @return  String vector of nubered file name.
#' @examples
#' file <- "aaa.body.ext"
#' file_numbered(file, 30)
#' 
#' @export
file_numbered <- function(file, n , extra = 0, sep = "_"){
  file <- file_split_name(file)
  body <- file$body
  ext <- file$ext
  number <- stringr::str_pad(seq(n), width = stringr::str_length(n) + extra, side = "left", pad = "0")
  files <- return(paste0(body, sep, number, ".", ext))
  return(files)
}


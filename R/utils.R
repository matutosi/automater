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

#' Split file name into body part and extension.
#' 
#' @param   file     A string of file name.
#' @return  A list including file name of body part and extension.
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
#' @param   n,extra An integer.
#' @param   sep     A string of separator between file name and number. 
#' @return  String vector of numbered file name.
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

#' Add numbers to file name. 
#' @param  x,y    A string vector. 
#' 
#' @return  A logical.
#' @examples
#' x <- letters[1:5]
#' y <- letters[5:8]
#' z <- letters[6:8]
#' is_duplicated(x, y)
#' is_duplicated(x, z)
#' is_duplicated(y, z)
#' 
#' @export
is_duplicated <- function(x, y){
  regrep <- stringr::str_c(y, collapse = "|")
  n_dup <- sum(stringr::str_detect(x, regrep))
  return(as.logical(n_dup))
}

#' Display message to continue
#' 
#' @export
message_to_continue <- function(){
  print("Press [Enter] key to continue ...")
  scan("stdin", character(), nlines = 1)
}

#' Copy *.rsc (and *.command, and chmod on Mac)
#' @param  file,path   A string of file and path
#' 
#' @export
set_rsc <- function(file, path){
  file <- paste0(file, if(get_os() == "win"){ ".rsc" } else{ c(".rsc", ".command") })
  rsc <- system.file(file.path("rsc", file), package = "automater")
  file.copy(rsc, path, overwrite = TRUE)
  Sys.chmod(file.path(dir, file[2]), "755")
}

#' Get os name
#' 
#' @export
get_os <- function(){
  switch(Sys.info()["sysname"],
    "Windows" = "win",
     "Linux"  = "linux",
                "mac"
  )
}


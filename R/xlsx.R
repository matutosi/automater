#' Wrapper functions to manipulate excel work books and sheets using package xlsx. 
#' 
#' Package xlsx <https://cran.r-project.org/web/packages/xlsx/index.html>
#' includes useful functions as shown bellow.
#' read.xlsx(), read.xlsx2(), write.xlsx(), write.xlsx2(), 
#' addAutoFilter(), createFreezePane(), createWorkbook(), saveWorkbook(),
#' and mores.
#' 
#' @name xlsx
#' @param sh    A excel sheet.
#' @param file  A string of excel file name.
#' @param password A String of the password.
#' @examples
#' \donttest{
#' files <- list.files(pattern = "xls")
#' for(file in files){
#'   automater::set_af_fp(file)
#' }
#' }
#' 
#' @export
set_af_fp <- function(file, password = NULL){
  wb <- xlsx::loadWorkbook(file, password = password)
  for(sh in xlsx::getSheets(wb)){
    set_auto_filter(sh)
    set_freeze_panel(sh)
  }
  xlsx::saveWorkbook(wb, file, password = password)
}

#' @rdname xlsx
#' @export
set_auto_filter <- function(sh){
  xlsx::addAutoFilter(sh, "A1:Z1")
}

#' @rdname xlsx
#' @export
set_freeze_panel <- function(sh){
  xlsx::createFreezePane(sh, 2, 2, 2, 2)
}

#' Wrapper function to manipulate excel work books and sheets. 
#' 
#' Package xlsx <>
#' incudes usefull functions as shown bellow.
#' 
#' 
#' 
#' @name xlsx
#' @param sh    A excel sheet.
#' @param file  A string of excel file name.
#' @examples
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' @export
set_af_fp <- function(file){
  wb <- xlsx::loadWorkbook(file)
  for(sh in xlsx::getSheets(wb)){
    set_auto_filter(sh)
    set_freeze_panel(sh)
  }
  xlsx::saveWorkbook(wb, file)
}

#' @export
set_auto_filter <- function(sh){
  xlsx::addAutoFilter(sh, "A1:Z1")
}

#' @export
set_freeze_panel <- function(sh){
  xlsx::createFreezePane(sh, 2, 2, 2, 2)
}

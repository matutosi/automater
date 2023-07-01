#' Wrapper functions to manipulate excel work books and sheets using package xlsx. 
#' 
#' Package xlsx <https://cran.r-project.org/web/packages/openxlsx/index.html>
#' 
#' @param file  A string of excel file name.
#' @examples
#' \donttest{
#' files <- list.files(pattern = "xls")
#' for(file in files){
#'   automater::set_af_fp(file)
#' }
#' }
#' 
#' @export
set_af_fp <- function(file){
  wb <- openxlsx::loadWorkbook(file)
  for(sheet in openxlsx::sheets(wb)){
    df <- openxlsx::readWorkbook(wb, sheet)
    openxlsx::setColWidths(wb, sheet, cols = 1:ncol(df), width =  "auto")
    openxlsx::addFilter(wb, sheet, row = 1, cols = 1:ncol(df))
    openxlsx::freezePane(wb, sheet, firstCol = TRUE, firstRow = TRUE)
  }
  openxlsx::saveWorkbook(wb, file)
}

#' Wrapper function to convert docx into pdf using package RDCOMClient.
#' 
#' @param path A string of docx path to convert.
#' @examples
#' \dontrun{
#' docx2pdf()
#' }
#' 
#' @return  An invisible string of pdf path.
#' @export
docx2pdf <- function(path){
  pdf <- fs::path_ext_set(path, "pdf")
  file <- "d:/a.docx"
  wordApp <- RDCOMClient::COMCreate("Word.Application")
  wordApp[["Visible"]] <- TRUE
  wordApp[["Documents"]]$Add()
  wordApp[["Documents"]]$Open(Filename = path)
  wordApp[["ActiveDocument"]]$SaveAs(pdf, 
  FileFormat = 17) # FileFormat=17 saves as pdf
  wordApp$Quit()
  return(invisible(pdf))
}

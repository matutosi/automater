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
  wordApp <- RDCOMClient::COMCreate("Word.Application")
  wordApp[["Visible"]] <- TRUE
  wordApp[["Documents"]]$Add()
  wordApp[["Documents"]]$Open(Filename = normalizePath(path))
   # FileFormat=17 saves as pdf
  wordApp[["ActiveDocument"]]$SaveAs(pdf, FileFormat = 17)
  wordApp$Quit()
  return(invisible(pdf))
}


#' Wrapper function to convert document among pdf, xps, html, trf, and txt.
#' Needs MS Word.
#'
#' @param path   A string of documents.
#' @param format A string of file format to convert.
#'               Avairable: "docx", "pdf", "xps", "html, "rtf", "txt".
#' @examples
#' \dontrun{
#' library(RDCOMClient)
#' convert_docs("document_path", "pdf")
#' }
#' @return  An invisible string of document path.
#' @export
convert_docs <- function(path, format){
  if(fs::path_ext(path) == format){ return(invisible(path)) }
  no <- switch(format,
                "docx" = 11,
                "pdf"  = 17,
                "xps"  = 19,
                "html" = 20,
                "rtf"  = 23,
                "txt"  = 25)
   # needs normalizePath(), do NOT use fs::path_norm() <- not work
  path <- normalizePath(path)
  suppressWarnings({
    converted <-
      normalizePath(path_convert(path, pre = "converted_", ext = format))
  })
  wordApp <- RDCOMClient::COMCreate("Word.Application")
  wordApp[["Visible"]] <- TRUE
  wordApp[["DisplayAlerts"]] <- FALSE
  doc <- wordApp[["Documents"]]$Open(path, ConfirmConversions = FALSE)
  doc$SaveAs2(converted, FileFormat = no)
  doc$close()
  return(invisible(converted))
}

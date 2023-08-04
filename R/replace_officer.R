#' Wrapper functions to replace text in MS Words using package officer.
#' 
#' Package qpdf <https://cran.r-project.org/web/packages/officer/index.html>
#' 
#' @param doc        A doc object.
#' @param old_value  A string of old value.
#' @param new_value  A string of new value.
#' @param new_value  A string of new value.
#' @param body,header,footer A logical to be replaced or not.
#' @examples
#' \dontrun{
#'   #   doc <- officer::read_docx(path)
#' 
#' }
#' 
#' @return  replace_doc_officer() returns a doc object.
#' @export
replace_doc_officer <- function(doc, old_value, new_value, body = TRUE, header = TRUE, footer = TRUE){
  if(body  ){ officer::body_replace_all_text(   doc, old_value, new_value              ) }
  if(header){ officer::headers_replace_all_text(doc, old_value, new_value, warn = FALSE) }
  if(footer){ officer::footers_replace_all_text(doc, old_value, new_value, warn = FALSE) }
  return(doc)
}

#' Helper function
#' @param replacement   A daraframe including cols: "file", "old_value", and "new_value".
#' @export
replace_docs <- function(replacement){
  files <- unique(replacement$file)
  for(f in files){
    rep <- dplyr::filter(replacement, file == f)
    doc <- officer::read_docx(f)
    for(i in seq(nrow(rep))){
      ov <- rep[["old_value"]][i]
      nv <- rep[["new_value"]][i]
      replace_doc_officer(doc, ov, nv)
      print(paste0("Replaced '", ov, "' by '", nv, "' in ", f))
    }
    write_docx(doc, path_convert(f, pre = "replaced_"))
  }
}

#' Helper function for replace_doc_officer()
#' @param  replacement  A dataframe including cols with "file", "old_value", and "new_value"
#' @return A dataframe with expanded files
#' @examples
#' replacement <- 
#'   tibble::tribble(
#'     ~file   , ~old_value, ~new_value,
#'     "a.docx", "置換前", "置換後",
#'     "b.docx", "変換前", "変換後",
#'     "a.docx,b.docx", "へんかん", "変換")
#' expand_file(replacement)
#' 
#' @export
expand_file <- function(replacement){
  into <- 
    replacement[["file"]] %>%
    stringr::str_count(",") %>%
    max() %>%
    `+`(1) %>%
    seq() %>%
    letter()
  replacement %>%
    tidyr::separate(file, into = into, sep = ",", fill = "right") %>%
    tidyr::pivot_longer(dplyr::all_of(into), names_to = "name", values_to = "file", values_drop_na = TRUE) %>%
    dplyr::select(-dplyr::all_of("name"))
}

#' Shortcut to get letters
#' @param x  An integer.
#' @export
letter <- function(x){
  letters[x]
}

#' Wrapper functions to write docx using package officer.
#' @param doc      A doc object.
#' @param path     A string of path.
#' @export
write_docx <- function(doc, path){
  # getS3method("print", "rdocx")
  officer:::print.rdocx(doc, target = path)
  #   print(doc, target = path)
}

  # #' @importFrom officer print
  # #' @importFrom officer print.rdocx
  # #' @export
  # officer:::print.rdocx

#' Wrapper functions to extract text using package officer.
#' @param doc                 A doc object.
#' @param drop_na,drop_empty  A logical.
#' @export
extract_text <- function(doc, drop_na = TRUE, drop_empty = TRUE){
  text <- 
    doc %>%
    officer::docx_summary() %>%
    `[[`("text")
  if(drop_na   ){ text <- stats::na.omit(text)    }
  if(drop_empty){ text <- text[text != ""] }
  return(text)
}

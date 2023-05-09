#' Wrapper functions to overlay page numbers and others using package qpdf.
#' 
#' pdf_overlay_stamps_each() overlay PDF for each page in pdf file. 
#' validate_page() is a helper function for pdf_overlay_stamps_each() 
#' to validate page consistency of among page no. of input, stamp, start and end.
#' pdf_overlay_page_num() and pdf_overlay_session_num() are wrapper functions to 
#' overlay page no. and session no. for accademic congress or symposium etc. 
#' pdf_overlay_page_num() can overlay up to 100 pages.
#' 
#' Package qpdf <https://cran.r-project.org/web/packages/qpdf/index.html>
#' includes useful functions as shown bellow.
#' pdf_length(), pdf_split(), pdf_subset(), pdf_combine(), 
#' pdf_compress(), pdf_rotate_pages(), pdf_overlay_stamp().
#' 
#' @name pdf_overlay
#' @param input,stamp  A string of file name or path of pdf file.
#'                     input is a base pdf and stamp will be overlayed.
#'                     No. of pages in stamp PDF should be equal to or over no. of pages in input PDF.
#'                     Pages in stamp exceeding pages over input pages will be ignored.
#' @param start,end    An integer of start and end page to be stamped.
#'                     negative integer can be used for end, which means
#'                     number from the last page.
#' @param len_input,len_stamp    An integer to validate.
#' @param session      A string of session name. Can use "a", "b", or "p".
#'                     'session = "a"' uses 'pdf/00_sn_a.pdf' as stamp. 
#'                     pdf directory include '00_sn_a.pdf', '00_sn_b.pdf', and '00_sn_p.pdf' 
#'                     by default, which invlude 50 pages (eg., A01, A02, ..., A50) respectively.
#' @examples
#' \dontrun{
#' input <- system.file("pdf/00_sn_a.pdf", package = "automater")
#' pdf_overlay_page_num(input, start = 11, end = -3)
#' pdf_overlay_session_num(input, session = "b")
#' }
#' 
#' @return  A string of output pdf file.
#' @export
pdf_overlay_stamps_each <- function(input, stamp, start = 1, end = NULL){
  len_input <- qpdf::pdf_length(input)
  len_stamp <- qpdf::pdf_length(stamp)
  if(is.null(end)){ end <- len_input }
  if(end < 0     ){ end <- len_input + end}
  validate_page(len_input, len_stamp, start, end)
  pages_inputs <- seq(to = len_input)
    # +1 means out of bounds, inputs[pages_pre]: NA
  pages_pre    <- if(start != 1      ){ seq(to = start - 1)                 } else { len_input + 1 }
  pages_post   <- if(end != len_input){ seq(from = end  + 1, to = len_input)} else { len_input + 1 }
  pages_body   <- pages_inputs[-c(pages_pre, pages_post)]
  inputs <- qpdf::pdf_split(input)
  stamps <- qpdf::pdf_split(stamp)
  out <- list()
  for(i in seq_along(pages_body)){
    out[[i]] <- qpdf::pdf_overlay_stamp(inputs[pages_body[i]], stamps[i])
  }
  out <- stats::na.omit(c(inputs[pages_pre], unlist(out), inputs[pages_post]))
  outfile <- qpdf::pdf_combine(out, "out.pdf")
  file.remove(inputs)
  file.remove(stamps)
  file.remove(out[pages_body])
  return(outfile)
}

#' @rdname pdf_overlay
#' @export
validate_page <- function(len_input, len_stamp, start, end){
  if(end       < start)    { stop("end must be larger than start!") }
  if(len_input < start)    { stop("input pages must be larger than start!") }
  if(len_input < end  )    { stop("input pages must be larger than end!") }
  if(len_input > len_stamp){ stop("stamp pages must be equal to or bigger than input!") }
}

#' @rdname pdf_overlay
#' @export
pdf_overlay_page_num <- function(input, start = 1, end = NULL){
  stamp <- file.path(find.package("automater"), "pdf/00_page.pdf")
  pdf_overlay_stamps_each(input, stamp, start, end)
}

#' @rdname pdf_overlay
#' @export
pdf_overlay_session_num <- function(input, start = 1, end = NULL, session = "a"){
  stamp <- file.path(find.package("automater"), "pdf/00_sn_", session, ".pdf")
  pdf_overlay_stamps_each(input, stamp, start, end)
}

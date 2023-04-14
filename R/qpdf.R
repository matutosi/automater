#' Wrapper function to overlay page numbers and other numvers.
#' 
#' @rdname pdf_overla
#' @param input,stamp  A string of file name or path of pdf file.
#'                     input is a base pdf and stamp will be overlayed.
#' @param start,end    An integer of start and end page to be stamped.
#'                     negative integer can be used for end, which means
#'                     number from the last page.
#' @examples
#' input <- file.path(find.package("automater"), "pdf/00_sn_a.pdf")
#' pdf_overlay_page_num(input, start = 11, end = -3)
#' 
#' @return  A string of output pdf file.
#' @export
pdf_overlay_page_num <- function(input, start = 1, end = NULL){
  stamp <- file.path(find.package("automater"), "pdf/00_page.pdf")
  pdf_overlay_stamps_each(input, stamp, start, end)
}

#' 
#' 
#' @rdname 
#' @examples
#' pdf_overlay_stamps_each(input, stamp)
#' 
#' @export
pdf_overlay_stamps_each <- function(input, stamp, start = 1, end = NULL){
  len_input <- qpdf::pdf_length(input)
  len_stamp <- qpdf::pdf_length(stamp)
  if(is.null(end)){ end <- len_input }
  if(end < 0     ){ end <- len_input + end}
  validate_length(len_input, len_stamp, start, end)

  pages_inputs <- seq(to = len_input)
  pages_pre    <- if(start != 1      ){ seq(to = start - 1)                 } else { len_input + 1 } # +1 means out of bounds, inputs[pages_pre]: NA
  pages_post   <- if(end != len_input){ seq(from = end  + 1, to = len_input)} else { len_input + 1 } # 
  pages_body   <- pages_inputs[-c(pages_pre, pages_post)]
  inputs <- qpdf::pdf_split(input)
  stamps <- qpdf::pdf_split(stamp)
  out <- list()
  for(i in seq_along(pages_body)){
    out[[i]] <- qpdf::pdf_overlay_stamp(inputs[pages_body[i]], stamps[i])
  }
  out <- na.omit(c(inputs[pages_pre], unlist(out), inputs[pages_post]))
  outfile <- qpdf::pdf_combine(out, "out.pdf")
  file.remove(inputs)
  file.remove(stamps)
  file.remove(out[pages_body])
  return(outfile)
}

validate_length <- function(len_input, len_stamp, start, end){
  if(end       < start)    { stop("end must be larger than start!") }
  if(len_input < start)    { stop("input pages must be larger than start!") }
  if(len_input < end  )    { stop("input pages must be larger than end!") }
  if(len_input > len_stamp){ stop("stamp pages must be equal to or bigger than input!") }
}

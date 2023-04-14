#' 
#' 
#' 
#' @examples
#' 
#' library(qpdf)
#' setwd("D:/matu/work/ToDo/2310vs_congress/program")
#' input <- "input.pdf"
#' stamp <- "stamp.pdf"
#' 
#' pdf_overlay_stamps_each(input, stamp)
#' 
#' 
#' 
#' 
#'  find.package("automater")
page_num <- function(input, start = 1, end = NULL){
  
}

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


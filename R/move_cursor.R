#' Move Cursor to Next Section
#' 
#' @export
next_section <- function(){
  source <- rstudioapi::getSourceEditorContext()
  section_row <- stringr::str_which(source$contents, "^#")
  current_row <- source$selection[[1]]$range$start[[1]]
  end <- length(source$contents)
  next_row <- min(end, section_row[current_row < section_row])
  if(is.na(next_row)){
    return(invisible(NULL))
  }
  next_pos <- rstudioapi::document_position(row = next_row, col = 1)
  rstudioapi::setCursorPosition(next_pos, source$id)
}

#' Move Cursor to Next Section
#' 
#' @export
prev_section <- function(){
  source <- rstudioapi::getSourceEditorContext()
  section_row <- stringr::str_which(source$contents, "^#")
  current_row <- source$selection[[1]]$range$start[[1]]
  start <- 1
  prev_row <- max(start, section_row[section_row < current_row])
  if(is.na(prev_row)){
    return(invisible(NULL))
  }
  prev_pos <- rstudioapi::document_position(row = prev_row, col = 1)
  rstudioapi::setCursorPosition(prev_pos, source$id)
}

next_section()
prev_section()

#' Wrapper function for mouse.move() and mouse.click()
#' 
#' @param x,y  A numeric to move.
#' @return  Invisible NULL.
#' @examples
#' mouse_move_click(100, 100)
#' 
#' @export
mouse_move_click <- function(x, y){
  KeyboardSimulator::mouse.move(x, y)
  KeyboardSimulator::mouse.click()
  sleep(0.5)
}

#' Wrapper function for recording mouse.get_cursor() position
#' 
#' @param n,interval A numeric of record number and interval (sec).
#' @return  A list of x and y position.
#' @examples
#' mouse_record()
#' 
#' @export
mouse_record <- function(n = 5, interval = 1){
  x <- list()
  y <- list()
  for (i in seq(n)) {
    automater::sleep(interval)
      x[[i]] <- KeyboardSimulator::mouse.get_cursor()[1]
      y[[i]] <- KeyboardSimulator::mouse.get_cursor()[2]
      position <- paste0(i, ": x = ", x[[i]], ", y = ", y[[i]], "\n")
      cat(position)
  }
  return(list(x = unlist(x), y = unlist(y)))
}

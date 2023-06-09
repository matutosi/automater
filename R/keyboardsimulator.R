#' Wrapper function for mouse.move() and mouse.click()
#' 
#' @param x,y    A numeric to move.
#' @param button A string. "left", "right", or "middle".
#' @param hold   A logical. If the button should be held down.
#' @param sleep_sec  A numeric to sleep.
#' @return  Invisible NULL.
#' @examples
#' mouse_move_click(100, 100)
#' 
#' @export
mouse_move_click <- function(x, y, button = "left", hold = FALSE, sleep_sec = 0.5){
  KeyboardSimulator::mouse.move(x, y)
  KeyboardSimulator::mouse.click(button = button, hold = hold)
  sleep(sleep_sec)
}

#' Wrapper function for recording mouse.get_cursor() position
#' 
#' @param n,interval A numeric of record number and interval (sec).
#'        "interval < 0" means wait user input (any keys on R console).
#' @return  A list of x and y position.
#' @examples
#' mouse_record(interval = 0.1)
#' 
#' @export
mouse_record <- function(n = 5, interval = 1){
  x <- list()
  y <- list()
  for (i in seq(n)) {
    if(interval < 0){
      user_input("Press any keys on R console")
    }else{
      automater::sleep(interval)
    }
    x[[i]] <- KeyboardSimulator::mouse.get_cursor()[1]
    y[[i]] <- KeyboardSimulator::mouse.get_cursor()[2]
    position <- paste0(i, ": x = ", x[[i]], ", y = ", y[[i]], "\n")
    cat(position)
  }
  return(list(x = unlist(x), y = unlist(y)))
}

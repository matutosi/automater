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

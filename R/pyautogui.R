#' Wrapper function for PyAutoGUI to recognize and click image.
#' 
#' @param img  A string of path for image to recognize.
#' @param pag  A python.builtin.module built 
#'             by reticulate::import("pyautogui")
#' @param wait A logical. 
#'             TRUE: Wait untill finding a image.
#'             FALSE: When not found image, return error.
#' @param button  A string of mouse: "left" or "right".
#' @param hold A logical. 
#'             TRUE: Keep holding.
#' @param ...  More arguments to pass pag$locateOnScreen().
#' @return     A invisible list ($x, $y) of clicked position.
#' @examples
#' python_path <- find_python()
#' reticulate::use_python(python_path)
#' pag <- reticulate::import("pyautogui")
#' img <- fs::path_package("automater", "img", "up_arrow.png")
#' recog_image_click(img, pag)
#' 
#' @export
recog_image_click <- function(img, pag, wait = TRUE, 
                              button = "left", hold = FALSE, ...){
  position <- pag$locateOnScreen(img, ...)
  if(wait){
    while(is.null(position)){
      sleep(0.5)
      position <- pag$locateOnScreen(img, ...)
    }
  }
  if(is.null(position)){
    stop("img not foud: ", img)
  }
  pos <- center(position)
  mouse_move_click(pos$x, pos$y, button = button, hold = hold)
  return(invisible(pos))
}

#' Helper function for recog_image_click() to get center of position.
#' 
#' @param position  A numeric
#' @return  A numeric list ($x, $y) of position.
#' @export
center <- function(position){
  x <- position$left + (position$width / 2)
  y <- position$top +  (position$height / 2)
  return(list(x = x, y = y))
}

#' Helper function for recog_image_click().
#' 
#' @param corner  A string to specify a corner. 
#'                "top_left", "top_right", "bottom_left", or "bottom_right".
#' @param width,height  A integer.
#' @export
display_corner <- function(corner = "bottom_right", width = 600, height = 600){
  size <- display_size()
  corner <- 
    switch(corner,
      "top_left"     = c(                 0,                   0, width, height), 
      "top_right"    = c(size$width - width,                   0, width, height), 
      "bottom_left"  = c(                 0, size$height- height, width, height), 
      "bottom_right" = c(size$width - width, size$height- height, width, height)
    )
  return(as.integer(corner))
}

#' Helper function for display_corner() to get display size.
#' 
#' @return     A numeric list ($width, $height) of display size.
#' @export
display_size <- function(){
  pos <- KeyboardSimulator::mouse.get_cursor()
  KeyboardSimulator::mouse.move(999999,999999)
  size <- KeyboardSimulator::mouse.get_cursor()
  KeyboardSimulator::mouse.move(pos[1], pos[2])
  return(list(width = size[1], height = size[2]))
}

#' Get screenshot.
#' 
#' @param path A string of path to save image.
#' @param pag  A python.builtin.module built 
#'             by reticulate::import("pyautogui")
#' @param region A integer vector including four elements.
#'               c(x-axis, y-axis, width, height)
#' @return     A invisible string of image path.
#' @examples
#' python_path <- find_python()
#' reticulate::use_python(python_path)
#' pag <- reticulate::import("pyautogui")
#' screenshot_pag("ss.png", pag = pag)
#' screenshot_pag("ss.png", region = c(100, 100, 100, 100), pag = pag)
#' 
#' @export
screenshot_pag <- function(path, region = NULL, pag = NULL){
  if(is.null(pag)){
    pag <- reticulate::import("pyautogui")
  }
  if(is.null(region)){
    display <- display_size()
    region <- as.integer(c(0, 0, display$width, display$height))
  }
  ss <- pag$screenshot(region = region)
  ss$save(path)
  return(invisible(path))
}

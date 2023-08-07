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


#' Combert Cimg class into grayscale x-y matrix.
#' Use grayscale to Speed up and to simplify code.
#' 
#' @param img   A Cimg.
#' @return      A two (x-y) dimensional matrix.
#' @rdname  locate_image
#' 
#' @export
image2gray_matrix <- function(img){
  img <- img %>% imager::rm.alpha() %>% imager::grayscale()
  return(img[,,1,1])
}

#' @param needle_image,haystack_image  A image.
#' @param center                       A logical. 
#'                                     TRUE returns center position of needle_image.
#' @return  A vector (x-y) integer of location for ndl_img.
#' @examples
#' library(magrittr)
#' library(imager)
#' haystack_image <- imager::load.example("parrots")
#' pos_x <- 200; pos_y <- 200
#' size_x <- 50; size_y <- 20
#' needle_image <- 
#'   haystack_image[
#'     pos_x:(pos_x + size_x), 
#'     pos_y:(pos_y + size_y),] %>%
#'   as.cimg()
#' 
#' layout(t(1:2))
#' plot(needle_image)
#' plot(haystack_image)
#' 
#' locate_image(needle_image, haystack_image)
#' 
#' @export
locate_image <- function(needle_image, haystack_image, center = TRUE){
  ndl_h <- imager::height(needle_image)
  ndl_w <- imager::width(needle_image)
  ndl_mt <- image2gray_matrix(needle_image)
  hay_mt <- image2gray_matrix(haystack_image)
  xy_pos <- locate_image_cpp(ndl_mt, hay_mt)
  x <- xy_pos[1]
  y <- xy_pos[2]
  if(x == -1 & y == -1){
    warning("needle_image NOT found in haystack_image")
    return(xy_pos)
  }
  if(center){
    return(c(x + ceiling(ndl_w/2), y + ceiling(ndl_h/2)))
  }else{
    return(c(x + 1, y + 1))
  }
}

## WIP
  # img2matrix <- function(img){
  #   df <- as.data.frame(img)
  #   mt <- tapply(df$value, list(df$x, df$y, df$cc), c)
  #   if(4 ==dim(mt)[3]) mt <- mt[,,1:3]
  #   return(mt)
  # }
  # img2matrix <- function(img){
  #   mt <- img[,,1,]
  #   if(4 ==dim(mt)[3]) mt <- mt[,,1:3]
  #   return(mt)
  # }
is_equal_matrix_r <- function(mt_1, mt_2){
  is_equal <- 0 == sum(mt_1 != mt_2)
  return(is_equal)
}

#' Locate image position
#' 
#' @param needle_image,haystack_image  A image.
#' @param center                       A logical. 
#'                                     TRUE returns center position of needle_image.
#' @return  A vector (x-y) integer of location for ndl_img.
#' @examples
#' library(magrittr)
#' library(imager)
#' haystack_image <- imager::load.example("parrots")
#' pos_x <- 200; pos_y <- 200
#' size_x <- 50; size_y <- 20
#' needle_image <- 
#'   haystack_image[
#'     pos_x:(pos_x + size_x), 
#'     pos_y:(pos_y + size_y),] %>%
#'   as.cimg()
#' 
#' layout(t(1:2))
#' plot(needle_image)
#' plot(haystack_image)
#' 
#' locate_image(needle_image, haystack_image)
#' 
locate_image_r <- function(needle_image, haystack_image, center = TRUE){
  ndl_h <- imager::height(needle_image)
  ndl_w <- imager::width(needle_image)
  hay_h <- imager::height(haystack_image)
  hay_w <- imager::width(haystack_image)
  ndl_mt <- image2gray_matrix(needle_image)
  hay_mt <- image2gray_matrix(haystack_image)

  last_x <- hay_w - ndl_w + 1
  last_y <- hay_h - ndl_h + 1
 
  row_nos <- 0:(ndl_h - 1)
  for(x in 1:last_x){
    for(y in 1:last_y){
      for(row_no in row_nos){
        is_matched <- is_equal_matrix_r(ndl_mt[, 1 + row_no], hay_mt[x:(x + ndl_w - 1), y + row_no])
        if(!is_matched){
          break
        }else{
        }
        if(row_no == row_nos[ndl_h]){
          if(center){
            return(c(x + floor(ndl_w/2), y + floor(ndl_h/2)))
          }else{
            return(c(x-1, y-1))
          }
        }
      }
    }
  }
  warning("Not found needle_image in haystack_image")
}

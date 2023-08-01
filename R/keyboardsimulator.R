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

img2matrix <- function(img){
  df <- as.data.frame(img)
  tapply(df$value, list(df$y, df$x, df$cc), c)
}
is_equal_matrix <- function(mt_1, mt_2){
  !sum(mt_1 != mt_2)
}


library(imager)
library(tidyverse)
  # ls("package:imager") %>% str_subset("crop")
  # ls("package:imager") %>% str_subset("gray")

size <- 10
times <- 10

hey_img <- 
  load.example("parrots") %>%
  imsub( 200 < x & x < 200 + size*times) %>%  
  imsub( 200 < y & y < 200 + size*times)
pos_x <- 10
pos_y <- 8
ndl_img <- 
  hey_img %>%
  imsub( pos_x < x & x < pos_x + size) %>%  
  imsub( pos_y < y & y < pos_y + size)

  # layout(t(1:2))
  # plot(ndl_img)
  # plot(hey_img)

locate_image <- function(ndl_img, hey_img){
  ndl_h <- height(ndl_img)
  ndl_w <- width (ndl_img)
  hey_h <- height(hey_img)
  hey_w <- width (hey_img)
  ndl_mt <- img2matrix(ndl_img)
  hey_mt <- img2matrix(hey_img)

ndl_mt[,,1]
hey_mt[,,1]

  last_x <- hey_w - ndl_w + 1
  last_y <- hey_h - ndl_h + 1
  xs <- 1:last_x
  ys <- 1:last_y
  offsets <- 0:(ndl_h - 1)

  for(x in xs){
    for(y in ys){
      for(offset in offsets){
        is_matched <- is_equal_matrix(ndl_mt[1 + offset, , ], hey_mt[x + offset, y:(y + ndl_w - 1),])
  # print(str_c(x, y, offset, sep = ", "))
  # print(ndl_mt[1 + offset, ,1])
  # print(hey_mt[x + offset, y:(y + ndl_w - 1),1])
        if(!is_matched){
          break
        }else{
print(str_c(x, y, sep = ", "))
print(is_matched)
        }
      }
    }
  }
}

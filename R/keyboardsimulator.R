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

## WIP
  # img2matrix <- function(img){
  #   df <- as.data.frame(img)
  #   mt <- tapply(df$value, list(df$x, df$y, df$cc), c)
  #   if(4 ==dim(mt)[3]) mt <- mt[,,1:3]
  #   return(mt)
  # }
img2matrix <- function(img){
  mt <- img[,,1,]
  if(4 ==dim(mt)[3]) mt <- mt[,,1:3]
  return(mt)
}

is_equal_matrix <- function(mt_1, mt_2){
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
#' library(tidyverse)
#' library(imager)
#' haystack_image <- load.example("parrots")
#' pos_x <- 200; pos_y <- 200
#' size_x <- 50; size_y <- 20
#' needle_image <- 
#'   haystack_image %>%
#'   imsub( pos_x < x & x < pos_x + size_x) %>%
#'   imsub( pos_y < y & y < pos_y + size_y)
#' 
#' layout(t(1:2))
#' plot(needle_image)
#' plot(haystack_image)
#' 
#' locate_image(needle_image, haystack_image)
#' 
#' 
#' @export
locate_image <- function(needle_image, haystack_image, center = TRUE){
  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
  # 
  # TODO: 以下を参考にしてC++で書き直す
  #   D:/matu/work/ToDo/wameicheckr/src/editdist.cpp
  #   D:/matu/work/stat/R/c/matutosi.c
  #   
  # webでコンパイル
  #   https://paiza.io/projects/kS1b4f2kWLKZ0J8oKCK3kw?language=cpp
  # 
  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
  ndl_h <- height(needle_image)
  ndl_w <- width(needle_image)
  hay_h <- height(haystack_image)
  hay_w <- width(haystack_image)
  ndl_mt <- img2matrix(needle_image)
  hay_mt <- img2matrix(haystack_image)

  last_x <- hay_w - ndl_w + 1
  last_y <- hay_h - ndl_h + 1
  xs <- 1:last_x
  ys <- 1:last_y
  row_nos <- 0:(ndl_h - 1)

  for(x in xs){
    for(y in ys){
      for(row_no in row_nos){
        is_matched <- is_equal_matrix(ndl_mt[, 1 + row_no, ], hay_mt[x:(x + ndl_w - 1), y + row_no, ])
  # # for debug
  # print(str_c(x, y, row_no, sep = ", "))
  # print(ndl_mt[1 + row_no, ,1])
  # print(hay_mt[x + row_no, y:(y + ndl_w - 1),1])
        if(!is_matched){
          break
        }else{
  # # for debug
  # print(str_c(x, y, sep = ", "))
  # print(is_matched)
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



## 
if(0){
  # ls("package:imager") %>% str_subset("load")
  # ls("package:imager") %>% str_subset("rbg")
rm(list=ls(all=TRUE)); gc(); gc()
library(tidyverse)
library(imager)

needle_image   <- load.image("D:/matu/work/tmp/needle_image.png")
haystack_image <- load.image("D:/matu/work/tmp/haystack_image.png")

locate_image(needle_image, haystack_image)

system.time(pos1 <- locate_image(needle_image, haystack_image))
system.time(pos2 <- locate_image(needle_image, haystack_image, FALSE))


system.time(img2matrix(haystack_image))


img2matrix(needle_image)

KeyboardSimulator::mouse.move(970, 97)


layout(t(1:2))
plot(needle_image)
plot(haystack_image)

needle_image
str(needle_image)


tmp <- load.image("D:/matu/work/tmp/tmp.png")

dim(tmp[])
str(tmp[])
class(tmp[])


tmp[,,1,]
img2matrix(tmp)


matrix()

}

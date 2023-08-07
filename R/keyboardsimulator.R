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

#' Take a screenshot. 
#' 
#' "screenCapture.bat"  https://github.com/npocmaka/batch.scripts/blob/master/hybrids/.net/c/screenCapture.bat
#' @param file  A string for file name of screenshot.
#' @return      A file name of screenshot. When "", screenshot will be saved in a tempral directory.
#' @examples
#' library(imager)
#' sc <- screenshot()
#' imager::load.image(sc)
#' 
#' @export
screenshot <- function(file = ""){
  if(file == ""){
    file <- fs::file_temp("sc_", ext = "png")
  }
  pkg <- fs::path_package("automater")
  exe <- fs::path(pkg, "keyboardsimulator/screenCapture.exe ")
  cmd <- paste0(exe, file)
  system(cmd, intern = TRUE)
  return(file)
}

#' Comvert Cimg class into grayscale x-y matrix.
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

#' Cut off a part of image from a whole image. 
#' 
#' @param An image of Cimg.
#' @param pos_x,pos_y  A numeric to indicate the top left corner of cuting image.
#'                     When NULL, position will be randomly sampled.
#' @param w,h          A numeric for width or height of the cutting image.
#' @return An image of Cimg.
#' @rdname 
#' @examples
#' library(imager)
#' library(magrittr)
#' sc <- 
#'   screenshot() %>%
#'   imager::load.image()
#' w <- 100
#' h <- 80
#' pos_x <- 0
#' pos_y <- height(sc) - h
#' needle <- hay2needle(sc, pos_x, pos_y, w, h)
#' plot(needle)
#' 
#' @export
hay2needle <- function(haystack_image, 
                       pos_x = NULL, pos_y = NULL, 
                       w = 50, h = 20){
  if(is.null(pos_x)){
    pos_x <- sample(imager::width(haystack_image)  -  w, 1)
  }
  if(is.null(pos_y)){
    pos_y <- sample(imager::height(haystack_image) -  h, 1)
  }
  haystack_image %>%
    imager::imsub(pos_x <= x & x <= pos_x + w - 1) %>%
    imager::imsub(pos_y <= y & y <= pos_y + h - 1) %>%
    imager::rm.alpha()
}

#' Convert array index into xy location in matrix.
#' Helper function for locate_ndl_in_hay().
#' 
#' @param index,nrow  A numeric.
#' @return A pair numeric of xy postion.
#' @examples
#' nrow <- 4
#' matrix(1:12, nrow = nrow)
#' purrr::map(1:12, index2xy, nrow = nrow)
#' 
#' @export
index2xy <- function(index, nrow){
  x <- index %% nrow
  y <- index %/% nrow
  x[x == 0] <- nrow
  y[x != 0] <- y + 1
  return(c(x, y))
}

#' Compare values within tow arrays or matrices.
#' Helper function for locate_ndl_in_hay().
#' 
#' @param ndl_mt,hay_mt  A matrix.
#' @return A tibble.
#' @examples
#' val <- seq(from = 0, to = 1, by = 0.1)
#' mt_1 <- matrix(sample(val,  20, replace = TRUE))
#' mt_2 <- matrix(sample(val, 100, replace = TRUE))
#' compare_table(mt_1, mt_2)
#' 
#' @export
compare_table <- function(ndl_mt, hay_mt){
  ndl <- count_val_freq(ndl_mt, "ndl")
  hay <- count_val_freq(hay_mt, "hay")
  dplyr::left_join(ndl, hay) %>%
    dplyr::arrange(hay, ndl)
}

#' Helper function for compare_table().
#' 
#' @param mt       A numeric matrix or array.
#' @param colname  A string of name for count.
#' @return     A 
#' @examples
#' mt <- sample(1:10, 30, replace = TRUE)
#' count_val_freq(mt, "freq")
#' 
#' @export
count_val_freq <- function(mt, colname){
  tibble::tibble(val = as.numeric(mt)) %>%
    dplyr::group_by(val) %>%
    dplyr::summarise({{colname}} := dplyr::n())
}

#' Get xy position of a value in a matrix
#' Helper function for locate_ndl_in_hay()
#' 
#' @param mt   A matrix
#' @param val  A matrix
#' @return     A list of xy pairs.
#' @examples
#' mt <- matrix(1:12, nrow = nrow)
#' xy_pos(mt, 5)
#' 
#' @export
xy_pos <- function(mt, val){
  which(mt == val) %>%
    purrr::map(index2xy, nrow(mt))
}

#' Locate needle image  matrix position in a haystack_image matrix.
#' 
#' @param ndl_mt,hay_mt  A matrix
#' @return A numeric pair of xy position of needle image.
#' @examples
#' library(imager)
#' library(magrittr)
#' sc <- 
#'   screenshot() %>%
#'   imager::load.image()
#' w <- 100
#' h <- 80
#' pos_x <- 1
#' pos_y <- height(sc) - h
#' needle <- hay2needle(sc, pos_x, pos_y, w, h)
#' hay_mt <- image2gray_matrix(sc)
#' ndl_mt <- image2gray_matrix(needle)
#' (pos <- locate_ndl_in_hay(ndl_mt, hay_mt))
#' found <- hay2needle(sc, pos[1], pos[2], w, h)
#' layout(c(1:3))
#' plot(sc)
#' plot(needle)
#' plot(found)
#' 
#' @export
locate_ndl_in_hay <- function(ndl_mt, hay_mt){
  comp_table <- compare_table(ndl_mt, hay_mt)
  val <- comp_table$val
  # first position
  pos_in_ndl <- xy_pos(ndl_mt, val[1])
  pos_in_hay <- xy_pos(hay_mt, val[1])
  base_xy <- purrr::map(pos_in_hay, `-`, pos_in_ndl[[1]])
  if(length(base_xy) == 1){
    return(base_xy[[1]] + 1)
  }
  # second and latter
  for(v in val){
    pos_in_ndl <- xy_pos(ndl_mt, v)
    pos_in_hay <- xy_pos(hay_mt, v)
    for(i in seq_along(pos_in_ndl)){
      base_xy_next <- purrr::map(pos_in_hay, `-`, pos_in_ndl[[i]])
      base_xy <- intersect(base_xy, base_xy_next)
      if(length(base_xy) == 1){
        return(base_xy[[1]] + 1)
      }
    }
  }
  warning("Needle_image Not found in haystack_image")
  return(c(0, 0))
}

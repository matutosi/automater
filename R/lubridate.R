#' Wrapper functions to ... using package lubridate 
#' 
#' Package lubridate <https://cran.r-project.org/web/packages/lubridate/index.html>
#' 
#' @name format_ymd
#' @param x,yr  String(s) of date and year.
#' @return  (A list of) strings.
#' @examples
#' x <- 
#'   "21年1月1日(月)，2021年1月1日(月)，2021年10月10日(月)，
#'   2月2日(月)，12月22日(月)，2021/1/1(月)，2021/10/10(月)，
#'   2/2(月)，12/22(月)，21年1月1日，2021年1月1日，
#'   2021年10月10日，2月2日，12月22日，2021/1/1，2021/10/10，
#'   2/2，12/22"
#' format_ymd(x)
#' 
#' @export
format_ymd <- function(x, yr = ""){
  if(yr == ""){
    yr <- 
      lubridate::today() %>%
      lubridate::year()
  }
  x %>%
    extract_date() %>%
    stringr::str_split("[^\\d]") %>%
    purrr::map(remove_empty_chr) %>%
    purrr::map(add_year, yr)
}

#' @rdname format_ymd
#' @export
extract_date <- function(x){
  date_regrep <- paste0(yr_regexp(), mn_regexp(), dy_regexp(), dw_regexp())
  date <- 
    stringr::str_extract_all(x, date_regrep) %>%
    `[[`(1)
  return(date)
}

#' @rdname format_ymd
#' @export
remove_empty_chr <- function(x){
  x[! x == ""]
}

#' @rdname format_ymd
#' @export
add_year <- function(x, yr){
  if(length(x) < 2 | length(x) > 3){
    stop("date must have two or three numbers")
  }
  if(length(x) != 3){
    x <- c(yr, x)
  }
  if(stringr::str_length(x[1]) == 2){
    x[1] <- paste0("20", x[1])
  }
  return(x)
}

#' unescape_utf() year, month, day and day of the week
#' for regular expressions of date
yr_regexp <- function(){
  "((20)*[2-5]\\\\d+[\\u5e74/_-]*)" %>%
    moranajp::unescape_utf()  
}
mn_regexp <- function(){
  "*\\\\d\\\\d*[\\u6708/_-]" %>%
    moranajp::unescape_utf()
}
dy_regexp <- function(){
  "*\\\\d\\\\d*[\\u65e5]*" %>%
    moranajp::unescape_utf()
}
dw_regexp <- function(){
  "(\\\\([\\u6708\\u706b\\u6c34\\u6728\\u91d1\\u571f\\u65e5]\\\\))*" %>%
    moranajp::unescape_utf()
}

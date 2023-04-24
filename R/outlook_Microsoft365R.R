#' Wrapper function to create and send outlook emails based on the contents of excel file using package Microsoft365R.
#' 
#' Package Microsoft365R <https://cran.r-project.org/web/packages/Microsoft365R/index.html>
#' 
#' @name outlook
#' @param path      A string of path for MS excel that include columns of email: 
#'                  "send" (required), 
#'                      1: send, 0: save in drafts.
#'                  "to" (required).
#'                  "subject" (almost required), "body" (almost required).
#'                  "cc" (optional), "bcc" (optional).
#'                  "attachment" (optional).
#'                      "attachment" is path to files separated with comma (","). 
#' @param df        A dataframe including contents of emails. 
#' @param outlook   ms_outlook_object generated with get_business_outlook().
#' @param emails    A list of ms_outlook_email class.
#' @return  A list of ms_outlook_email class.
#' 
#' @examples
#' \dontrun{
#' outlook <- Microsoft365R::get_business_outlook()
#' path <- "outlook_Microsoft365R.xlsx"
#' create_email(path, outlook)
#' }
#' 
#' @export
create_email <- function(path, outlook){
  df <- readxl::read_xlsx(path)
  emails <- gen_email(outlook, df)
  if("attachment" %in% colnames(df)){
    emails <- add_attachment(emails, df)
  }
  for(i in seq(nrow(df))){
    if(df$send[i] == 1){
      emails[[i]]$send()
    }
  }
  return(emails)
}

#' @rdname outlook
#' @export
gen_email <- function(outlook, df){
  cols <- c("to", "subject", "body", "cc", "bcc")
  df %>%
    dplyr::select(dplyr::any_of(cols)) %>%
    purrr::pmap(outlook$create_email)
}

#' @rdname outlook
#' @export
send_email <- function(emails){
  for(email in emails){ email$send() }
  return(emails)
}

#' @rdname outlook
#' @export
add_attachment <- function(emails, df){
  attachment <- df[["attachment"]]
  for(i in seq_along(emails)){
    if(!is.na(attachment[i]) & attachment[i] != ""){
      files <- strsplit(attachment[i], ",")[[1]]
      files <- gsub(" ", "", files)
        for(f in files){
          emails[[i]] <- emails[[i]]$add_attachment(f)
        }
    }
  }
  return(emails)
}

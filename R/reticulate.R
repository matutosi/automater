#' Find a path of Python.
#' 
#' @param   select_menu  A logical to show select menu. 
#'          TRUE: show select menu and return one path
#'          FALSE: return all found paths.
#' @return  A string or string vector.
#' @examples
#' python_path <- find_python()
#' reticulate::use_python(python_path)
#' 
#' @export
find_python <- function(select_memu = TRUE){
  os <- get_os()
  python_path <- 
    ifelse(os == "win", "where python", "which python") %>%
    system(intern = TRUE) %>%
    fs::path()
  if(length(python_path) > 1){
    if(select_memu){
      choice <- utils::menu(python_path, title = "Select Python path. 0: exit and return all.")
      if(choice == 0){ return(python_path) }
    }else{
      return(python_path)
    }
  }else{
    choice <- 1
  }
  return(python_path[choice])
}

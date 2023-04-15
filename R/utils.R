#' Check package installation and install it when not yet.
#' 
#' 
#' 
#' @name pkg      A string of package names.
#' @param reposs  A string of url for repository

#' @examples
#' 
#' @export
validate_package <- function(pkg, repos = "https://cran.ism.ac.jp/"){
  if(! pkg %in% installed.packages()[,1]){
    options(repos = repos)
    install.packages(pkg)
  }
}

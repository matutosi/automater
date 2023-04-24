  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
  # 
  # See https://github.com/matutosi/automater/blob/main/vignettes/outlook_Microsoft365R.Rmd
  # 
  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 

  # Prepare
pkg <- "devtools"
if(! pkg %in% installed.packages()[,1]){
  install.packages(pkg, repo = "https://cran.ism.ac.jp/")
}

pkg <- "automater"
ver <- utils::packageDescription(pkg, fields = "Version")
if(utils::compareVersion(ver, "0.2.0") < 0){
  devtools::install_github("matutosi/automater", upgrade = "never", force = TRUE)
}

automater::validate_package("Microsoft365R")

  # Run
outlook <- Microsoft365R::get_business_outlook()
path <- "d:/outlook_Microsoft365R.xlsx"
create_email(path, outlook)

automater::message_to_continue()


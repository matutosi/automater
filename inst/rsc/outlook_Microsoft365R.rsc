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
if(! pkg %in% installed.packages()[,1]){
  devtools::install_github("matutosi/automater", force = TRUE)
}

automater::validate_package("Microsoft365R")

  # Run
outlook <- Microsoft365R::get_business_outlook()
path <- "d:/outlook_Microsoft365R.xlsx"
automater::create_email(path, outlook, send = TRUE)

message_to_continue()


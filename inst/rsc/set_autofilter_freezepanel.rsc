  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
  # 
  # See https://github.com/matutosi/automater/blob/main/vignettes/xlsx.md
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

automater::validate_package("xlsx")

  # Run
files <- list.files(pattern = "xls")
for(file in files){
  automater::set_af_fp(file)
}

message_to_continue()


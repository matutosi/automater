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
ver <- utils::packageDescription(pkg, fields = "Version")
if(utils::compareVersion(ver, "0.2.0") < 0){
  devtools::install_github("matutosi/automater", upgrade = "never", force = TRUE)
}

automater::validate_package("xlsx")

  # Run
files <- list.files(pattern = "xls")
for(file in files){
  automater::set_af_fp(file)
}

automater::message_to_continue()


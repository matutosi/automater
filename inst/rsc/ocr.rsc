  # Prepare
pkg <- "devtools"
if(! pkg %in% installed.packages()[,1]){
  install.packages(pkg, repo = "https://cran.ism.ac.jp/")
}

pkg <- "automater"
if(! pkg %in% installed.packages()[,1]){
  devtools::install_github("matutosi/automater", force = TRUE)
}

automater::validate_package("tesseract")

  # Run
files <- list.files(pattern = "png|jpg|jepg|gif|tif|tiff|bmp")
for(file in files){
  print(automater::ocr_tesseract(file))
}

setwd("D:/matu/work/ToDo/automater/inst/rsc")

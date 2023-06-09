  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
  # 
  # See https://github.com/matutosi/automater/blob/main/vignettes/ocr_tesseract.md
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

automater::validate_package("tesseract")
lng <- "jpn"
if(! lng %in% tesseract::tesseract_info()$available){
  tesseract::tesseract_download(lng)
}

  # Run
files <- list.files(pattern = "bmp|gif|png|tif|tiff")
for(file in files){
  text <- automater::ocr_tesseract(file)
  writeLines(text, paste0(file, ".txt"))
}

automater::message_to_continue()


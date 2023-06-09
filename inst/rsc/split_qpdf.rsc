  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
  # 
  # See https://github.com/matutosi/automater/blob/main/vignettes/split_qpdf.md
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

automater::validate_package("qpdf")
automater::validate_package("stringr")

  # Run
files <- list.files(pattern = "\\.pdf")
for(file in files){
  output <- qpdf::pdf_split(file)
  n_page <- qpdf::pdf_length(file)
  extra <- 0  # to avoid dupulicated file name, add extra degits
  numbered <- automater::file_numbered(file, n_page, extra = extra)
  while(automater::is_duplicated(files, numbered)){
    extra <- extra + 1
    numbered <- automater::file_numbered(file, n_page, extra = extra)
  }
  file.rename(output, numbered)
}

automater::message_to_continue()


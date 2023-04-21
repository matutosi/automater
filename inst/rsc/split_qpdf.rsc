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
if(! pkg %in% installed.packages()[,1]){
  devtools::install_github("matutosi/automater", force = TRUE)
}

automater::validate_package("qpdf")
automater::validate_package("stringr")

  # Run
setwd("d:/")
files <- list.files(pattern = "\\.pdf")
file <- files[1]

for(file in files){
  n_page <- qpdf::pdf_length(file)
  output <- qpdf::pdf_split(file)
  numbered <- file_numbered(file, n_page)
  regrep_numbered <- stringr::str_c(numbered, collapse = "|")
  extra <- 0
  # to avoid dupulicated file name, add extra degits
  while(0 != sum(stringr::str_detect(files, regrep_numbered))){
    extra <- extra + 1
    numbered <- file_numbered(file, n_page, extra = extra)
    regrep_numbered <- stringr::str_c(numbered, collapse = "|")
  }
  file.rename(output, numbered)
}

  # qpdf::pdf_combine(out, "out.pdf")
  # qpdf::pdf_split(input)

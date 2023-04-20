  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
  # 
  # See https://github.com/matutosi/automater/blob/main/vignettes/translate_deeplr.Rmd
  # 
  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 

  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
  #  
  # Setting (required)
  #  
  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
  #  
api_key <- "set_your_key"
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

automater::validate_package("deeplr")
automater::validate_package("dplyr")

  # Run
api_key <- "set_your_key"
files <- list.files(pattern = "\\.txt")
for(file in files){
  txt <- utils::read.table(file, sep = "\t", col.names = "en")
  txt <- dplyr::mutate(txt, `:=`("jp", deepl_api(str = en, api_key = api_key)))
  utils::write.table(txt, paste0("translated_", file), quote = FALSE, sep = "\t", row.names = FALSE)
}


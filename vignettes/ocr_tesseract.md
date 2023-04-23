---
title: "ocr with tesseract"
output: 
  html_document:
    keep_md: true
  # rmarkdown::html_vignette:
  #   keep_md: true
  # vignette: >
  #   %\VignetteIndexEntry{ocr_tesseract}
  #   %\VignetteEngine{knitr::rmarkdown}
  #   %\VignetteEncoding{UTF-8}
---




```r
library(automater)
automater::validate_package("tesseract")
```


COR (Optical Character Recognition, extract text from image files) with package tesseract. 


```r
files <- list.files(pattern = "bmp|gif|png|tif|tiff")
text <- list()
for(file in files){
  text[file] <- automater::ocr_tesseract(file)
}
text
```


To run automater::ocr_tesseract() automatically and save contents into text files, 
use orc_tesseract.rsc in rsc directory within automater package.
When image file name is "image.png", text file will be "image.png.txt" 

- Save orc_tesseract.rsc (and orc_tesseract.command, then chmod orc_tesseract.command "755" on Mac) to a directory.    
  You can set orc_tesseract.rsc (and orc_tesseract.command on Mac) by code below.    


```r
file <- "orc_tesseract"
path <- "c:/" # set your path
automater::set_rsc(file, path)
```

- On Windows Associate extension .rsc with Rscript.exe.    
  https://www.computerhope.com/issues/ch000572.htm    


- Copy image files (bmp, gif, png, tif, tiff) to the same directory with orc_tesseract.rsc.   
- Click orc_tesseract.rsc on Windows (orc_tesseract.command on Mac).   

- Then a black command windows will be opened and wait a moment.   

Contents of orc_tesseract.rsc is shown below. 


```r
rsc <- system.file("rsc/ocr_tesseract.rsc", package = "automater")
cat(readtext::readtext(rsc, verbosity = 0)$text)
#>   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
#>   # 
#>   # See https://github.com/matutosi/automater/blob/main/vignettes/ocr_tesseract.md
#>   # 
#>   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
#> 
#>   # Prepare
#> pkg <- "devtools"
#> if(! pkg %in% installed.packages()[,1]){
#>   install.packages(pkg, repo = "https://cran.ism.ac.jp/")
#> }
#> 
#> pkg <- "automater"
#> if(! pkg %in% installed.packages()[,1]){
#>   devtools::install_github("matutosi/automater", force = TRUE)
#> }
#> 
#> automater::validate_package("tesseract")
#> lng <- "jpn"
#> if(! lng %in% tesseract::tesseract_info()$available){
#>   tesseract::tesseract_download(lng)
#> }
#> 
#>   # Run
#> files <- list.files(pattern = "bmp|gif|png|tif|tiff")
#> for(file in files){
#>   text <- automater::ocr_tesseract(file)
#>   writeLines(text, paste0(file, ".txt"))
#> }
```

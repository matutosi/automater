---
title: "Split pdf with qpdf"
output: 
  html_document:
    keep_md: true
  # output: rmarkdown::html_vignette
  # vignette: >
  #   %\VignetteIndexEntry{Split pdf with qpdf}
  #   %\VignetteEngine{knitr::rmarkdown}
  #   %\VignetteEncoding{UTF-8}
---




```r
library(automater)
automater::validate_package("qpdf")
```


Split pdf with qpdf using qpdf::pdf_split() function.
This function split a single pdf file into separate files, one for each page. 


```r
qpdf::pdf_split("a.pdf")
```

To run () automatically, use split_qpdf.rsc in rsc directory within automater package.   

- Save split_qpdf.rsc (and split_qpdf.command, then chmod split_qpdf.command "755" on Mac) to a directory.    
  You can set split_qpdf.rsc (and split_qpdf.command on Mac) by code below.    


```r
file <- "split_qpdf"
path <- "c:/" # set your path
automater::set_rsc(file, path)
```

- On Windows Associate extension .rsc with Rscript.exe.    
  https://www.computerhope.com/issues/ch000572.htm    


- Copy PDF files to the same directory with split_qpdf.rsc.   
- Click split_qpdf.rsc on Windows (split_qpdf.command on Mac).   
- Then a black command windows will be opened and wait a moment.   
- At the first time to run split_qpdf.rsc, it may take few minutes to install packages.   
- The output file is like as below.    
  - input: "original.pdf" (including 15 pages)
  - output: "original_01.pdf", "original_02.pdf", ..., "original_15.pdf"

Contents of split_qpdf.rsc is shown below. 


```r
rsc <- system.file("rsc/split_qpdf.rsc", package = "automater")
cat(readtext::readtext(rsc, verbosity = 0)$text)
#>   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
#>   # 
#>   # See https://github.com/matutosi/automater/blob/main/vignettes/split_qpdf.md
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
#> automater::validate_package("qpdf")
#> automater::validate_package("stringr")
#> 
#>   # Run
#> files <- list.files(pattern = "\\.pdf")
#> for(file in files){
#>   output <- qpdf::pdf_split(file)
#>   n_page <- qpdf::pdf_length(file)
#>   extra <- 0  # to avoid dupulicated file name, add extra degits
#>   numbered <- automater::file_numbered(file, n_page, extra = extra)
#>   while(is_duplicated(files, numbered)){
#>     extra <- extra + 1
#>     numbered <- automater::file_numbered(file, n_page, extra = extra)
#>   }
#>   file.rename(output, numbered)
#> }
```

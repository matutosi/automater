---
title: "Combine pdf with qpdf"
output: 
  html_document:
    keep_md: true
  # output: rmarkdown::html_vignette
  # vignette: >
  #   %\VignetteIndexEntry{Combine pdf with qpdf}
  #   %\VignetteEngine{knitr::rmarkdown}
  #   %\VignetteEncoding{UTF-8}
---




```r
library(automater)
automater::validate_package("qpdf")
```


Combine pdf with qpdf using qpdf::pdf_combine() function.
This function combine several pdf files into one.



```r
files <- c("a.pdf", "b.pdf", "c.pdf")
qpdf::pdf_combine(files)
```

To run () automatically, use combine_qpdf.rsc in rsc directory within automater package.   

- Save combine_qpdf.rsc (and combine_qpdf.command, then chmod combine_qpdf.command "755" on Mac) to a directory.    
  You can set combine_qpdf.rsc (and combine_qpdf.command on Mac) by code below.    


```r
file <- "combine_qpdf"
path <- "c:/" # set your path
automater::set_rsc(file, path)
```

- On Windows Associate extension .rsc with Rscript.exe.    
  https://www.computerhope.com/issues/ch000572.htm    


- Copy PDF files to the same directory with combine_qpdf.rsc.   
- Click combine_qpdf.rsc on Windows (combine_qpdf.command on Mac).   
- Then a black command windows will be opened and wait a moment.   
- At the first time to run combine_qpdf.rsc, it may take few minutes to install packages.   
- The order to combined files is the same with the order of the file names.    
  You need to rename files before using combine_qpdf.rsc.    
- The output file is name will be like "combined_"2020-11-27_12_00_00.pdf".    

Contents of combine_qpdf.rsc is shown below. 


```r
rsc <- system.file("rsc/combine_qpdf.rsc", package = "automater")
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
#> files <- sort(list.files(pattern = "\\.pdf"))
#> output <- paste0("combined_", Sys.Date(), "_", format(Sys.time(), "%H_%M_%S"), ".pdf")
#> qpdf::pdf_combine(files, output)
```

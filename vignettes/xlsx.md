---
title: "xlsx"
output: 
  html_document:
    keep_md: true
  # rmarkdown::html_vignette:
  #   keep_md: true
  # vignette: >
  #   %\VignetteIndexEntry{xlsx}
  #   %\VignetteEngine{knitr::rmarkdown}
  #   %\VignetteEncoding{UTF-8}
---




```r
library(automater)
automater::validate_package("xlsx")
```


Set autofilter and freeze panel of all excel files (xls and xlsx) in a directory using set_af_fp() function.


```r
files <- list.files(pattern = "xls")
for(file in files){
  automater::set_af_fp(file)
}
```


To run () automatically, use set_autofilter_freezepanel.rsc in rsc directory within automater package.   

- Save set_autofilter_freezepanel.rsc 
(and set_autofilter_freezepanel.command, then chmod set_autofilter_freezepanel.command "755" on Mac) to a directory.    
  You can set set_autofilter_freezepanel.rsc (and set_autofilter_freezepanel.command on Mac) by code below.    


```r
file <- "set_autofilter_freezepanel"
path <- "c:/" # set your path
automater::set_rsc(file, path)
```

- On Windows Associate extension .rsc with Rscript.exe.    
  https://www.computerhope.com/issues/ch000572.htm    

<!--
  # assoc .rsc=rscript
  # ftype rscript="D:\pf\R\R-4.2.3\bin\x64\Rscript.exe" "%1"
  # file.path(R.home(), "bin", "x64", "Rscript.exe")
  # assoc .rsc
  # ftype rscript
-->

- Copy excel files to the same directory with set_autofilter_freezepanel.rsc.   
- Click set_autofilter_freezepanel.rsc.   
- Then a black command windows will be opened and wait a moment.   

Contents of set_autofilter_freezepanel.rsc is shown below. 


```r
rsc <- system.file("rsc/set_autofilter_freezepanel.rsc", package = "automater")
cat(readtext::readtext(rsc, verbosity = 0)$text)
#>   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
#>   # 
#>   # See https://github.com/matutosi/automater/blob/main/vignettes/xlsx.md
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
#> automater::validate_package("xlsx")
#> 
#>   # Run
#> files <- list.files(pattern = "xls")
#> for(file in files){
#>   automater::set_af_fp(file)
#> }
```

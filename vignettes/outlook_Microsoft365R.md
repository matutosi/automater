---
title: "Send outlook email with Microsoft365R"
output: 
  html_document:
    keep_md: true
  # rmarkdown::html_vignette:
  #   keep_md: true
  # vignette: >
  #   %\VignetteIndexEntry{Microsoft365R}
  #   %\VignetteEngine{knitr::rmarkdown}
  #   %\VignetteEncoding{UTF-8}
---




```r
library(automater)
automater::validate_package("Microsoft365R")
```


Send outlook emails based on the contents of excel file using automater::create_email() function.



To run automater::create_email() automatically, use outlook_Microsoft365.rsc in rsc directory within automater package.

- Save outlook_Microsoft365.rsc to a directory.    
  You can copy outlook_Microsoft365.rsc by code below.    


```r
rsc <- system.file("rsc/outlook_Microsoft365.rsc", package = "automater")
target_dir <- "c:/" # set your directory
file.copy(rsc, target_dir)
```

- Associate extension .rsc with Rscript.exe.    
  https://www.computerhope.com/issues/ch000572.htm    

- Copy an excel file (outlook_Microsoft365R.xlsx) to the same directory with outlook_Microsoft365.rsc.   
  The excel file including columns below. 
  - "to" (required), 
  - "subject" (almost required)
  - "body" (almost required)
  - "cc" (optional)
  - "bcc" (optional)
  - "attachment" (optional): path to files separated with comma (",")
- Click outlook_Microsoft365.rsc.   
- Then a black command windows will be opened and wait a moment.   
- At the first time to run outlook_Microsoft365.rsc, browser stars and ask for your ID and password for authorization.   
- Input ID and password, then you will be authorized.    
- After authorization, close browser.   

If you want not to send emails but only make draft, set "send = FALSE" in the script.


```r
outlook <- Microsoft365R::get_business_outlook()
path <- "outlook_Microsoft365R.xlsx"
automater::create_email(path, outlook, send = FALSE)
```

Contents of outlook_Microsoft365.rsc is shown below. 


```r
rsc <- system.file("rsc/outlook_Microsoft365R.rsc", package = "automater")
cat(readtext::readtext(rsc, verbosity = 0)$text)
#>   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
#>   # 
#>   # See https://github.com/matutosi/automater/blob/main/vignettes/outlook_Microsoft365R.Rmd
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
#> automater::validate_package("Microsoft365R")
#> 
#>   # Run
#> outlook <- Microsoft365R::get_business_outlook()
#> path <- "d:/outlook_Microsoft365R.xlsx"
#> automater::create_email(path, outlook, send = TRUE)
```
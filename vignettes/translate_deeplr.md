---
title: "translate with deeplr"
output: 
  html_document:
    keep_md: true
  # rmarkdown::html_vignette:
  #   keep_md: true
  # vignette: >
  #   %\VignetteIndexEntry{deeplr}
  #   %\VignetteEngine{knitr::rmarkdown}
  #   %\VignetteEncoding{UTF-8}
---




```r
library(automater)
automater::validate_package("deeplr")
automater::validate_package("dplyr")
```


Translate with package deeplr. 


```r
api_key <- "set_your_key"
  # Example: from "I am a cat" by Soseki Natsume
sentences <- c("I am a cat. I don't have a name yet.", 
               "I have no idea where I was born.")
tibble::tibble(en = sentences) %>%
  dplyr::mutate(`:=`("jp", deepl_api(en, api_key = api_key)))
}
```

Read files, translate, and write them. 


```r
api_key <- "set_your_key"
files <- list.files(pattern = "\\.txt")
for(file in files){
  txt <- utils::read.table(file, sep = "\t", col.names = "en")
  txt <- dplyr::mutate(txt, `:=`("jp", deepl_api(str = en, api_key = api_key)))
  utils::write.table(txt, paste0("translated_", file), quote = FALSE, sep = "\t", row.names = FALSE)
}
```


To run automater::deepl_api() automatically and save contents into text files, 
use translate_deeplr.rsc in rsc directory within automater package.
When input file name is "neko.txt", output file will be "translated_neko.txt" 

- Save deepl_api.rsc (and deepl_api.command, then chmod deepl_api.command "755" on Mac) to a directory.    
  You can set deepl_api.rsc (and deepl_api.command on Mac) by code below.    


```r
file <- "deepl_api"
path <- "c:/" # set your path
automater::set_rsc(file, path)
```

- On Windows Associate extension .rsc with Rscript.exe.    
  https://www.computerhope.com/issues/ch000572.htm    

- Set your deepl api key in translate_deeplr.rsc (required).    
  api_key <- "set_your_key"   
- Copy text files (*.txt) to the same directory with translate_deeplr.rsc.   
- Click deepl_api.rsc on Windows (deepl_api.command on Mac).   
- Then a black command windows will be opened and wait a moment.   
- At the first time to run deepl_api.rsc, it may take few minutes to install packages.   


Contents of translate_deeplr.rsc is shown below. 


```r
rsc <- system.file("rsc/translate_deeplr.rsc", package = "automater")
cat(readtext::readtext(rsc, verbosity = 0)$text)
#>   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
#>   # 
#>   # See https://github.com/matutosi/automater/blob/main/vignettes/translate_deeplr.md
#>   # 
#>   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
#> 
#>   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
#>   #  
#>   # Setting (required)
#>   #  
#>   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
#>   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
#>   #  
#> api_key <- "set_your_key"
#>   #  
#>   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
#> 
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
#> automater::validate_package("deeplr")
#> automater::validate_package("dplyr")
#> 
#>   # Run
#> api_key <- "set_your_key"
#> files <- list.files(pattern = "\\.txt")
#> for(file in files){
#>   txt <- utils::read.table(file, sep = "\t", col.names = "en")
#>   txt <- dplyr::mutate(txt, `:=`("jp", deepl_api(str = en, api_key = api_key)))
#>   utils::write.table(txt, paste0("translated_", file), quote = FALSE, sep = "\t", row.names = FALSE)
#> }
```

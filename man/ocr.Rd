% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ocr_tesseract.R
\name{ocr}
\alias{ocr}
\alias{ocr_tesseract}
\title{Wrapper functions for ocr using package tesseract.}
\usage{
ocr_tesseract(img, lng = "jpn", binarization = NULL)
}
\arguments{
\item{img}{A string of image file path.}

\item{lng}{A string with language for tesseract engine
See detail in tesseract::ocr and tesseract::tesseract.
Need to download engine by tesseract_download().}

\item{binarization}{A string with the type of binarization to use.
See detail in image.binarization::image_binarization.}
}
\value{
A string.
}
\description{
Package tesseract \url{https://cran.r-project.org/web/packages/tesseract/index.html}
}
\examples{
\donttest{
library(automater)
tmp <- tempfile()
curl::curl_download("https://jeroen.github.io/images/testocr.png", tmp)
ocr_tesseract(tmp)
}

}

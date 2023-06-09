% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/translate_deeplr.R
\name{deeplr}
\alias{deeplr}
\alias{deepl_api}
\title{Wrapper functions to use deepl translation using package deeplr}
\usage{
deepl_api(str, api_key, source_lang = "EN", target_lang = "JA")
}
\arguments{
\item{str}{A string.}

\item{api_key}{A string of deepl api key}

\item{source_lang, target_lang}{A character to select language.}
}
\value{
A character translated by deepl
}
\description{
Package deeplr \url{https://cran.r-project.org/web/packages/deeplr/index.html}
}

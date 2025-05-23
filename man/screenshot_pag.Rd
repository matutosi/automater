% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pyautogui.R
\name{screenshot_pag}
\alias{screenshot_pag}
\title{Get screenshot.}
\usage{
screenshot_pag(path, region = NULL, pag = NULL)
}
\arguments{
\item{path}{A string of path to save image.}

\item{region}{A integer vector including four elements.
c(x-axis, y-axis, width, height)}

\item{pag}{A python.builtin.module built
by reticulate::import("pyautogui")}
}
\value{
\if{html}{\out{<div class="sourceCode">}}\preformatted{A invisible string of image path.
}\if{html}{\out{</div>}}
}
\description{
Get screenshot.
}
\examples{
python_path <- find_python()
reticulate::use_python(python_path)
pag <- reticulate::import("pyautogui")
screenshot_pag("ss.png", pag = pag)
screenshot_pag("ss.png", region = c(100, 100, 100, 100), pag = pag)

}

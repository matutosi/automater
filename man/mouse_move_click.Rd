% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/keyboardsimulator.R
\name{mouse_move_click}
\alias{mouse_move_click}
\title{Wrapper function for mouse.move() and mouse.click()}
\usage{
mouse_move_click(x, y, button = "left", hold = FALSE, sleep_sec = 0.5)
}
\arguments{
\item{x, y}{A numeric to move.}

\item{button}{A string. "left", "right", or "middle".}

\item{hold}{A logical. If the button should be held down.}

\item{sleep_sec}{A numeric to sleep.}
}
\value{
Invisible NULL.
}
\description{
Wrapper function for mouse.move() and mouse.click()
}
\examples{
mouse_move_click(100, 100)

}

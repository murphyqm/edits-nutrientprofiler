% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/npm-assess.R
\name{NPMAssess}
\alias{NPMAssess}
\title{NPMAssess function}
\usage{
NPMAssess(row)
}
\arguments{
\item{row, }{the row from an NPMScore call}
}
\value{
a data.frame containing A score, C score, NPM score, and NPM assessment for each row
}
\description{
This function aims to apply the various scoring functions
across a data.frame on a row by row basis.
It is expected that you would use this function in conjunction with a
call to \code{lapply} or on a single row.
The function returns a data.frame containing the A score, C score,
NPM score and NPM assessment.
}

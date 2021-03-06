% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SCEtoMatrix.R
\name{SCEtoMatrix}
\alias{SCEtoMatrix}
\title{Turns an SCE into a nicely formatted counts matrix}
\usage{
SCEtoMatrix(sce, rowList = NULL, colList = NULL, addRowData = TRUE,
  addColData = TRUE, transpose = FALSE)
}
\arguments{
\item{sce}{the sce to format}

\item{rowList}{numeric vector indicating which rows to subset the matrix to. Defaults to NULL}

\item{colList}{numeric vector indicating which cols to subset the matrix to. Defaults to NULL}

\item{addRowData}{logical. Should the function add the original rowdata from the matrix. Defaults to TRUE}

\item{addColData}{logical. Should the function add the original coldata from the matrix. Defaults to TRUE}

\item{transpose}{whether to tranpose the matrix before returning}
}
\description{
This function takes an SCE and returns its counts matrix. It has additional features, such as adding the column/row names to the data, and subsetting the matrix automatically.
}
\keyword{counts}
\keyword{data}
\keyword{matrix}
\keyword{sce}

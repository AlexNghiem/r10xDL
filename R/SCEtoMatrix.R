#' Turns an SCE into a nicely formatted counts matrix
#'
#' This function takes an SCE and returns its counts matrix. It has additional features, such as adding the column/row names to the data, and subsetting the matrix automatically.
#' @param sce the sce to format
#' @param rowList numeric vector indicating which rows to subset the matrix to. Defaults to NULL
#' @param colList numeric vector indicating which cols to subset the matrix to. Defaults to NULL
#' @param addRowData logical. Should the function add the original rowdata from the matrix. Defaults to TRUE
#' @param addColData logical. Should the function add the original coldata from the matrix. Defaults to TRUE
#' @param transpose whether to tranpose the matrix before returning
#' @keywords sce counts matrix data
#' @export

SCEtoMatrix <- function(sce, rowList = NULL, colList = NULL, addRowData = TRUE, addColData = TRUE, transpose = FALSE) {
  if (!is.null(rowList)) {
    sce <- tryCatch({
      (sce[rowList,])
    }, warning = function(w) {
      paste("Manual warning in SCEtoMatrix row subsetting:", w)
    }, error = function(e) {
      paste("Manual error in SCEtoMatrix row subsetting:", e)
    })
  }
  if (!is.null(colList)) {
    sce <- tryCatch({
      (sce[,colList])
    }, warning = function(w) {
      paste("Manual warning in SCEtoMatrix column subsetting:", w)
    }, error = function(e) {
      paste("Manual error in SCEtoMatrix column subsetting:", e)
    })
  }
  data <- as.matrix(counts(sce))
  if (addRowData) {
    rownames(data) <- as.vector(as.matrix(rowData(sce)[1]))
  }
  if (addColData) {
    colnames(data) <- as.vector(as.matrix(colData(sce)[1]))
  }
  if (transpose) {
    return(t(data))
  }
  data
}
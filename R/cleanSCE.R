#' Cleans a SCE to remove all cells with zero libraries
#'
#' This function takes an SCE, removes all cells which have no library (no non-zero entries in its column), and returns the SCE. Used to clean the SCE for later processing
#' @param sce the sce to clean
#' @keywords sce clean
#' @export

cleanSCE <- function(sce) {
  helper <- function(i) {
    counts1 = counts(sce)[,i]
    any(counts1 != 0)
  }
  nonzero = unlist(lapply(1:ncol(sce), helper))
  sce[,nonzero]
}
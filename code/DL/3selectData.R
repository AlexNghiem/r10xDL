# Now I will choose which genes and which proteins to use in my matrix
# I have access to: cleaned and normalized protein data matrices and gene SCE's


#find highly variable genes
library(scran)
fit <- trendVar(geneTrainingSCE, use.spikes = FALSE)
dec <- decomposeVar(geneTrainingSCE, fit)
hvg <- dec$bio > 0 # save vector of genes


getGeneMatrix <- function(x) {
  #subset both SCE's with that set of genes
  x[hvg,] %>%
  logcounts() %>%
  t()
}

trainingData <- getGeneMatrix(geneTrainingSCE)
testingData <- getGeneMatrix(geneTestingSCE)

#choose output protein(s)
#trainingLabels <- proteinTrainingData
#testingLabels <- proteinTestingData
select <- c(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE)
  #rep(TRUE, 14)#colnames(proteinTrainingData) == "CD45RA" | colnames(proteinTrainingData) == "CD45RO"

trainingLabels <- proteinTrainingData[,select]
testingLabels <- proteinTestingData[,select]

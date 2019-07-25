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
# 1: CD3, 2: CD19, 3: CD45RA, 4: CD4, 5: CD8a, 6: CD14, 7: CD45RO, 8: CD279_PD_1, 9: IgG1, 10: IgG2a, 11: IgG2b, 12: CD127, 13: CD197_CR7, 14: HLA_DR

trainingLabels <- proteinTrainingData[,select]
testingLabels <- proteinTestingData[,select]

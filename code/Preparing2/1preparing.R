# In this file I will read in the 10X data, process it slightly, and then sit it in memory
# I will not remove any protein data or gene data without leaving a reference

library(DropletUtils)
library(BiocManager)
library(SingleCellExperiment)
##55206 cells
SCE <- read10xCounts("../10Xdata/vdj_v1_hs_aggregated_donor1_filtered_feature_bc_matrix.h5") 


trainingSize = 30000 #how many cells to train on
testingSize = 1000 #how many cells to test on

trainingSCE <- SCE[,1:trainingSize] #takes the first however many cells as training data
testingSCE <- SCE[,(trainingSize+1):(trainingSize+testingSize)] #takes the next however many cells as testing data

#get AG data matrices
AGlist <- 33553:33602
getAGMatrix <- function(x) {
  x[AGlist] %>%
    counts() %>%
    as.matrix() %>%
    t()
}
library(purrr)
library(compositions)
AGTrainingData <- getAGMatrix(trainingSCE)
AGTestingData <- getAGMatrix(testingSCE)


geneTrainingSCE <- trainingSCE[rowData(trainingSCE)$Type == "Gene Expression"]
geneTestingSCE <- testingSCE[rowData(testingSCE)$Type == "Gene Expression"]

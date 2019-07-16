# In this file I will read in the 10X data, process it slightly, and then sit it in memory
# I will not remove any protein data or gene data without leaving a reference

library(DropletUtils)
library(BiocManager)
library(SingleCellExperiment)
##55206 cells
SCE <- read10xCounts("vignettes/10Xdata/vdj_v1_hs_aggregated_donor1_filtered_feature_bc_matrix.h5") 


trainingSize = 30000 #how many cells to train on
testingSize = 5000 #how many cells to test on

geneTrainingSCE <- SCE[,1:trainingSize] #takes the first however many cells as training data
geneTestingSCE <- SCE[,(trainingSize+1):(trainingSize+testingSize)] #takes the next however many cells as testing data

proteinGREP <- "CD.*|Ig.*|HLA-DR"
proteinList <- grep(proteinGREP, rowData(geneTrainingSCE)$ID)
getProteinMatrix <- function(x) { #from an SCE, gets the transposed matrix of proteins
  x[proteinList] %>%
    counts() %>%
    as.matrix() %>%
    t() %>%
    clr()
}

# TENSORFLOW WILL BREAK if fed any dashes!! we will replace dashes in the protein names with underscores
fixProteinColNames <- function(x) {
  colnames(x)[colnames(x) == "CD279_PD-1"] <- "CD279_PD_1"
  colnames(x)[colnames(x) == "HLA-DR"] <- "HLA_DR"
  x
}

#get normalized protein data matrices
library(purrr)
library(compositions)
proteinTrainingData <- geneTrainingSCE %>%
  getProteinMatrix() %>%
  fixProteinColNames()
proteinTestingData <- geneTestingSCE %>%
  getProteinMatrix() %>%
  fixProteinColNames()



geneTrainingSCE <- geneTrainingSCE[rowData(geneTrainingSCE)$Type == "Gene Expression"]
geneTestingSCE <- geneTestingSCE[rowData(geneTestingSCE)$Type == "Gene Expression"]

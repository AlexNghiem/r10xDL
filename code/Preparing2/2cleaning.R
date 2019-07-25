# In this file I will take the objects from 1preparing.R
# (These are the protein data matrices and gene SCEs)
# I will clean them and prepare them to be used in the model

# I may later add to this phase a denoising step

#fix count matrices
counts(geneTrainingSCE) <- as.matrix(counts(geneTrainingSCE))
counts(geneTestingSCE) <- as.matrix(counts(geneTestingSCE))

#remove low frequency genes from the SCE (keep those with 1 read in at least 5% of cells)
min_reads <- 1
min_cells <- 0.05 * ncol(geneTrainingSCE) 
#calculate a boolean vector for which genes to keep
keep <- rowSums(counts(geneTrainingSCE) >= min_reads) >= min_cells
#subset both SCEs using this vector
geneTrainingSCE <- geneTrainingSCE[keep, ]
geneTestingSCE <- geneTestingSCE[keep, ]

#for readability, swap rownames from row ID to row symbol
library(scater)
featureNames <- uniquifyFeatureNames(ID = rowData(geneTrainingSCE)$ID, names = rowData(geneTrainingSCE)$Symbol)
rownames(geneTrainingSCE) <- featureNames
rownames(geneTestingSCE) <- featureNames

#normalize
geneTrainingSCE <- normalize(geneTrainingSCE)
geneTestingSCE <- normalize(geneTestingSCE)


#remove cells with very low AG expression
keep <- rowSums(AGTrainingData) > 5
geneTrainingSCE <- geneTrainingSCE[, keep]
AGTrainingData <- AGTrainingData[, keep]



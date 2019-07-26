#Remove cells with no faust annotation
#sce <- sce[,!is.na(sce$faustAnnotation)]

library(scater)
library(umap)

sce <- sce[grep("CD.*|IgG.*|HLA-DR", rowData(sce)$ID),]

sce <- scater::normalize(sce)
sce <- scater::runUMAP(sce)
sceumap <- umap(t(as.matrix(counts(sce))))

plotUMAP(sce)



















getGGPlot <- function(pNum) { #pNum is the row number of the protein we want to see
  sceUMAP <- reducedDim(sce) #manually grab the UMAP data from the SingleCellExperiment object
  
  ggplot(data.frame(sceUMAP),  aes(sceUMAP[,1], sceUMAP[,2], colour = logcounts(sce)[pNum,])) + #we want cells colored to their expression of the given protein
    geom_point() +
    scale_colour_gradientn(colours = rainbow(4), name = paste("log of", rowData(sce)$ID[pNum], "expression")) +
    ggtitle(rowData(sce)$ID[pNum])
}


getGGPlot <- function(num) { #pNum is the row number of the protein we want to see
  sceUMAP <- reducedDim(sce[,sce$faustAnnotation==]) #manually grab the UMAP data from the SingleCellExperiment object
  
  ggplot(data.frame(sceUMAP),  aes(sceUMAP[,1], sceUMAP[,2])) + #we want cells colored to their expression of the given protein
    geom_point() +
    ggtitle(rowData(sce)$ID[class])
}

lapply(1:14, getGGPlot)

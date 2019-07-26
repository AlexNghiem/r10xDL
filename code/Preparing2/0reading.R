#Sets up a single large sce object

library(BiocManager)
library(SingleCellExperiment)
library(DropletUtils)

data <- readRDS("10Xdata/faustResults.rds")

sce <- read10xCounts("10Xdata/vdj_v1_hs_aggregated_donor1_filtered_feature_bc_matrix.h5")
#sce$Sample <- "donor1"
# 
# sceTemp <- read10xCounts("10Xdata/vdj_v1_hs_aggregated_donor2_filtered_feature_bc_matrix.h5")
# #sceTemp$Sample <- "donor2"
# sce <- cbind(sce, sceTemp)
# 
# sceTemp <- read10xCounts("10Xdata/vdj_v1_hs_aggregated_donor3_filtered_feature_bc_matrix.h5")
# #sceTemp$Sample <- "donor3"
# sce <- cbind(sce, sceTemp)
# 
# sceTemp <- read10xCounts("10Xdata/vdj_v1_hs_aggregated_donor4_filtered_feature_bc_matrix.h5")
# #sceTemp$Sample <- "donor4"
# sce <- cbind(sce, sceTemp)



v <- data$faustAnnotation
names(v) <- data$barcode

v <- v[sce$Barcode]
v <- unname(v)

sce$faustAnnotation <- v

#cleans extra objects from memory
remove(sceTemp, data, v)

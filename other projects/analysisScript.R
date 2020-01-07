## PROCESSING =========================================================================
### loading ###
## load your data and create the SingleCellExperiment object
library(DropletUtils)
fname <- file.path("../10Xdata/5k_pbmc_protein_v3_nextgem_filtered_feature_bc_matrix.h5")
sce.pbmc <- read10xCounts(fname, col.names=TRUE)

### gene-annotation ###
library(scater)
rownames(sce.pbmc) <- uniquifyFeatureNames(rowData(sce.pbmc)$ID, rowData(sce.pbmc)$Symbol)

library(EnsDb.Hsapiens.v86)
location <- mapIds(EnsDb.Hsapiens.v86, keys=rowData(sce.pbmc)$ID, 
                   column="SEQNAME", keytype="GENEID")

### cell-detection ###
### ONLY IF IT HAS NOT BEEN PREFILTERED ###
### IF IT HAS (aka if it has ~3-10k cells), SKIP THIS STEP
# set.seed(100)
# counts(sce.pbmc) <- as.matrix(counts(sce.pbmc))
# e.out <- emptyDrops(counts(sce.pbmc))
# sce.pbmc <- sce.pbmc[,which(e.out$FDR <= 0.001)]

### quality-control ###
sce.pbmc <- calculateQCMetrics(sce.pbmc, feature_controls=list(Mito=which(location=="MT")))
high.mito <- isOutlier(sce.pbmc$pct_counts_Mito, nmads=3, type="higher")
sce.pbmc <- sce.pbmc[,!high.mito]

### normalization ###
library(scran)
set.seed(1000)
clusters <- quickCluster(sce.pbmc)
sce.pbmc <- computeSumFactors(sce.pbmc, min.mean=0.1, cluster=clusters)
sce.pbmc <- normalize(sce.pbmc)

### feature-selection ###
fit.pbmc <- trendVar(sce.pbmc, use.spikes=FALSE)
dec.pbmc <- decomposeVar(fit=fit.pbmc)
o <- order(dec.pbmc$bio, decreasing=TRUE)
chosen.hvgs <- rownames(dec.pbmc)[head(o, 2000)]

### dimensionality-reduction ###
set.seed(10000)
sce.pbmc <- runPCA(sce.pbmc, feature_set=chosen.hvgs, ncomponents=25,
                   BSPARAM=BiocSingular::IrlbaParam())

set.seed(100000)
sce.pbmc <- runTSNE(sce.pbmc, use_dimred="PCA")

set.seed(1000000)
sce.pbmc <- runUMAP(sce.pbmc, use_dimred="PCA")

### clustering ###
g <- buildSNNGraph(sce.pbmc, k=10, use.dimred = 'PCA')
clust <- igraph::cluster_walktrap(g)$membership
sce.pbmc$cluster <- factor(clust)

### Cell classification - performed at cluster level, with main labels
bpe <- BlueprintEncodeData() # reference dataset
ann.main <- SingleR(test = sce.pbmc, ref = bpe, labels = bpe$label.main,
                    method = 'cluster', clusters = sce$cluster,
                    BNPARAM = AnnoyParam())
sce.pbmc$label <- ann.main[sce.pbmc$cluster, ]$labels # use rownames as indices

## TODO: we may want to run eventually with method = 'single' to classify
## at single-cell level and get back a "score" for T-cell-ness, and look at that
## as a way of scoring per cell (e.g. score of T-cell-ness vs predicted/actual CD3 protein)


## CITE-seq Processing ================================================================
## Make sure you log-normalize the CITE-seq data


## VISUALIZATION OF PBMC PROPERTIES ===================================================

## Make a plot of UMAP showing the assigned labels
## e.g. plotUMAP(sce, colour_by = 'label', text_by = 'label')

## Table of number of cells per cell type for your two PBMC datasets

## Make violin plots of expression distributions across each of the CITE proteins
## for every cluster
## i.e. for each PBMC dataset
## - on the x axis, each cell type
## - on the y axis, a given CITE protein
## so you should have 32 plots, one per CITE-seq protein. we should see that for example,
## only B cells express CD19 protein at high levels

## Plots of gene vs protein
## For each dataset, do a protein vs gene plot of the cognate protein/gene pairs
## FOr each of the plots, color the dots by the cluster label
## Make sure you have consistent colors across all these plots


## DL STUFF ===========================================================================
## Setup the experiment of dropout layers vs learning rate as a grid
## Also keep track of timing to see how long each run takes
## So you can create plots of time across dropout rates for a given learning rate (or vice versa)

## Measure performance
## Do correlation plots of actual vs predicted protein
## Colour each dot based on the cell type ascertained in the processing/SingleR section
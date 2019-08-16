#Remove cells with no faust annotation
#sce <- sce[,!is.na(sce$faustAnnotation)]

library(scater)
library(umap)
library(purrr) #for piping
library(gridExtra)
psceFull <- sce[grep("CD.*|IgG.*|HLA-DR", rowData(sce)$ID),]

psceFull <- scater::normalize(psceFull)
logcounts(psceFull) <- as.matrix(logcounts(psceFull))

# pumapFull <- psceFull %>%
#   logcounts() %>%
#   as.matrix() %>%
#   t() %>%
#   umap()
# pumap <- pumapFull

psce <- psceFull[,!is.na(psceFull$faustAnnotation)]
pumapClean <- psce %>%
  logcounts() %>%
  as.matrix() %>%
  t() %>%
  umap()
pumap <- pumapClean

# psce <- psceFull[,!is.na(psceFull$faustAnnotation)]
# psce <- psce[grep("CD.*|HLA-DR", rowData(psce)$ID),]
# pumapCleanNoIgG <- psce %>%
#   logcounts() %>%
#   as.matrix() %>%
#   t() %>%
#   umap()
# pumap <- pumapCleanNoIgG

#pumap <- pumapFull$layout

uplot <- function() {
  par(mfrow = c(1,1))
  plot(pumap$layout[,1], pumap$layout[,2], pch = '.', main = "Basic UMAP")
}

#sum(pumap$layout[,2]>12)
xrange <- range(pumap[,1])
yrange <- range(pumap[,2])

pplot <- function(pNum) { #pNum is the row number of the protein we want to see
  ggplot(data.frame(pumap),  aes(pumap[,1], pumap[,2], colour = logcounts(psce)[pNum,])) + #we want cells colored to their expression of the given protein
    geom_point(stroke = 0, shape='.') +
    scale_colour_gradientn(colours = rev(rainbow(4)), name = paste("Log", rowData(psce)$ID[pNum])) +
    ggtitle(rowData(psce)$ID[pNum])
}

pplots <- function() {
  grid.arrange(grobs = lapply(1:dim(counts(psce))[1], pplot), nrow = 3)
}



tab <- table(sce$faustAnnotation)

aplot <- function(num) { #num is the number of the annotation we want to see
  s <- !is.na(psce$faustAnnotation) & psce$faustAnnotation==names(tab[num])
  m <- pumap[s,]
  plot(m[,1], m[,2], xlim = xrange, ylim = yrange, main = names(tab[num]), pch = '.', col = psce$color[s])
}
aplots <- function() {
  par(mfrow = c(3,4))
  lapply(1:dim(tab), aplot)
}

ggplot(data.frame(pumap),  aes(pumap[,1], pumap[,2], colour = psce$faustAnnotation)) + #we want cells colored to their expression of the given protein
  geom_point(stroke = 0, size = .2)


dplot <- function(donor) {
  donor <- paste("donor", donor, sep = '')
  s <- psce$Sample == donor
  m <- pumap[s,]
  plot(m[,1], m[,2], xlim = xrange, ylim = yrange, main = donor, pch = '.', col = psce$color[s])
}
dplots <- function() {
  par(mfrow = c(2,2))
  lapply(1:4, dplot)
}






xrange <- range(pumap[,1])
yrange <- range(pumap[,2])

dplot <- function(donor) {
  donorChar <- paste("donor", donor, sep = '')
  s <- gsce$Sample == donorChar
  m <- gumap[s,]
  plot(m[,1], m[,2], xlim = xrange, ylim = yrange, main = donorChar, pch = '.', col = psce$color[s])
}

par(mfrow = c(1,4)) # 2,2 may be better to see detail
invisible(lapply(1:4, dplot)) # invisible removes the print output of lapply


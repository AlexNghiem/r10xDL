# Tests the model against the testing data.


scatter <- function(x, y=".") {
  
  
  plot(testingLabels[,x], unlist(predict(model, testingData)[x]), xlab = paste(colnames(testingLabels)[x],"log value from data"), ylab = "Log value predicted by model", pch = y)
  
}

scatters <- function() {
  par(mfrow = c(3,5))
  lapply(1:14, scatter)
}

lossPlots <- function() {
  par(mfrow = c(3,5))
  plot(history$metrics$val_CD3_mean_absolute_error, xlab="epoch", ylab="CD3")
  plot(history$metrics$val_CD19_mean_absolute_error, xlab="epoch", ylab="CD19")
  plot(history$metrics$val_CD45RA_mean_absolute_error, xlab="epoch", ylab="CD45RA")
  plot(history$metrics$val_CD4_mean_absolute_error, xlab="epoch", ylab="CD4")
  plot(history$metrics$val_CD8a_mean_absolute_error, xlab="epoch", ylab="CD8a")
  plot(history$metrics$val_CD14_mean_absolute_error, xlab="epoch", ylab="CD14") #5
  plot(history$metrics$val_CD45RO_mean_absolute_error, xlab="epoch", ylab="CD45RO")
  plot(history$metrics$val_CD279_PD_1_mean_absolute_error, xlab="epoch", ylab="CD279_PD_1")
  plot(history$metrics$val_IgG1_mean_absolute_error, xlab="epoch", ylab="IgG1")
  plot(history$metrics$val_IgG2a_mean_absolute_error, xlab="epoch", ylab="IgG2a")
  plot(history$metrics$val_IgG2b_mean_absolute_error, xlab="epoch", ylab="IgG2b") #10
  plot(history$metrics$val_CD127_mean_absolute_error, xlab="epoch", ylab="CD127")
  plot(history$metrics$val_CD197_CCR7_mean_absolute_error, xlab="epoch", ylab="CD197_CCR7")
  plot(history$metrics$val_HLA_DR_mean_absolute_error, xlab="epoch", ylab="HLA_DR")
}

correlations <- function(){
  predictions <- predict(model, testingData)
  total <- 0
  for (i in 1:dim(trainingLabels)[2]) {
    corr <- cor(as.numeric(unlist(predictions[i])), testingLabels[,i])
    if (!is.na(corr)){
      print(paste("The correlation between predicted and actual values for", colnames(testingLabels)[i], "is", corr))
      if (corr > 0) {
        total <- total + corr^2
      }
      else {
        total <- total - corr^2
      }
    }
  }
  print(paste("The sum of squared correlations is", total))
}

# Tests the model against the testing data.

#g
#plot(qplot(testingLabels, predict(model, testingData)))
#print(cor(testingLabels, predict(model, testingData)))

scatter <- function(x) {
  
  
  plot(testingLabels[,x], unlist(predict(model, testingData)[x]), xlab = paste(colnames(testingLabels)[x],"log value from data"), ylab = "Log value predicted by model", pch = ".")
  
}

par(mfrow = c(3,5))

scatters <- function(x) {lapply(x, scatter)}

plot(history$metrics$val_CD45RO_mean_absolute_error, xlab="epoch", ylab="CD45RO_val_mae")
plot(history$metrics$val_CD45RA_mean_absolute_error, xlab="epoch", ylab="CD45RA_val_mae")
plot(history$metrics$val_CD45RA_mean_absolute_error, xlab="epoch", ylab="CD45RA_val_mae")



# Train the model



history <- model %>% fit(
  x = trainingData,
  y = lapply(1:dim(trainingLabels)[2], function(x) {trainingLabels[,x]}),
  batch_size = batch_size,
  epochs = epochs,
  validation_split = 0.2,
  verbose = 0,
  callbacks = list(print_dot_callback)
)

toPlot <- c("CD45RA", "CD45RO")

plot(history, metrics = paste(toPlot, "_mean_absolute_error", sep = ""), smooth = FALSE)

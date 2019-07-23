# Here I will benchmark various different hyperparameters and architectures.

library(keras)
library(tfruns)

FLAGS <- flags(
  flag_integer("dense_units1", 8),
  flag_numeric("dropout1", 0.3),
  flag_string("activation1", 'relu'),
  
  flag_integer("dense_units2", 4),
  flag_numeric("dropout2", 0.0),
  flag_string("activation2", 'relu'),
  
  flag_integer("dense_units3", 2),
  flag_numeric("dropout3", 0.0),
  flag_string("activation3", 'relu'),
  
  flag_integer("dense_units4", 4),
  flag_numeric("dropout4", 0.0),
  flag_string("activation4", 'relu'),
  
  flag_string("loss", "mse"),
  flag_integer("epochs", 50),
  flag_integer("batch_size", 128),
  flag_numeric("learning_rate", 0.005),
  
  flag_numeric("CD3_loss", 1),
  flag_numeric("CD19_loss", 1),
  flag_numeric("CD45RA_loss", 1),
  flag_numeric("CD4_loss", 1),
  flag_numeric("CD8a_loss", 1),
  flag_numeric("CD14_loss", 1),
  flag_numeric("CD45RO_loss", 1),
  flag_numeric("CD279_PD_1_loss", 1),
  flag_numeric("IgG1_loss", 1),
  flag_numeric("IgG2a_loss", 1),
  flag_numeric("IgG2b_loss", 1),
  flag_numeric("CD127_loss", 1),
  flag_numeric("CD197_CR7_loss", 1),
  flag_numeric("HLA_DR_loss", 1)
)

inputs <- layer_input(shape = c(dim(trainingData)[2]))
output0 <- inputs %>%
  layer_dropout(rate = FLAGS$dropout1) %>%
  layer_dense(units = FLAGS$dense_units1, activation = eval(FLAGS$activation1)) %>%
  
  layer_dropout(rate = FLAGS$dropout2) %>%
  layer_dense(units = FLAGS$dense_units2, activation = eval(FLAGS$activation2)) %>%
  
  layer_dropout(rate = FLAGS$dropout3) %>%
  layer_dense(units = FLAGS$dense_units3, activation = eval(FLAGS$activation3)) %>%
  
  layer_dropout(rate = FLAGS$dropout4) %>%
  layer_dense(units = FLAGS$dense_units4, activation = eval(FLAGS$activation4))

makeOutputLayer <- function(x) {
  layer_dense(output0, units=1, name= colnames(trainingLabels)[x])
}


outputs <- lapply(1:dim(trainingLabels)[2], makeOutputLayer)

model <- keras_model(inputs=inputs, outputs=outputs)

corFUN <- custom_metric("correlation", function(y_true, y_pred) {
  k_dot(y_true, y_pred)
})

model %>% compile(
  loss = "mse",
  optimizer = optimizer_rmsprop(lr = FLAGS$learning_rate),
  metrics = c("mean_absolute_error", corFUN)
  #loss_weights = c(FLAGS$CD3_loss, FLAGS$CD19_loss, FLAGS$CD45RA_loss, FLAGS$CD4_loss, FLAGS$CD8a_loss, FLAGS$CD14_loss, FLAGS$CD45RO_loss, FLAGS$CD279_PD_1_loss, FLAGS$IgG1_loss, FLAGS$IgG2a_loss, FLAGS$IgG2b_loss, FLAGS$CD127_loss, FLAGS$CD197_CR7_loss, FLAGS$HLA_DR_loss)
)

model %>% summary()

# Display training progress by printing a single dot for each completed epoch.
print_dot_callback <- callback_lambda(
  on_epoch_end = function(epoch, logs) {
    if (epoch %% 50 == 0) cat("\n")
    cat(".")
  }
)    

history <- model %>% fit(
  x = trainingData,
  y = lapply(1:dim(trainingLabels)[2], function(x) {trainingLabels[,x]}),
  batch_size = FLAGS$batch_size,
  epochs = FLAGS$epochs,
  validation_split = 0.2,
  verbose = 0,
  callbacks = list(print_dot_callback)
)


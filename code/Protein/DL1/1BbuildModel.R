# Build the keras model

library(keras)

inputs <- layer_input(shape = c(dim(trainingData)[2]))
output0 <- inputs %>%
  layer_dropout(rate = .3) %>%
  layer_dense(units = 8, activation = 'relu') %>%
  layer_dense(units = 4, activation = 'relu') %>%
  layer_dense(units = 2, activation = 'relu') %>%
  layer_dense(units = 4, activation = 'relu')

makeOutputLayer <- function(x) {
  layer_dense(output0, units=1, name= colnames(trainingLabels)[x])
}

outputs <- lapply(1:dim(trainingLabels)[2], makeOutputLayer)

model <- keras_model(inputs=inputs, outputs=outputs)

model %>% compile(
  loss = "mse",
  optimizer = optimizer_rmsprop(lr = .0006),
  metrics = list("mean_absolute_error"),
  loss_weights = c(.5,.5,1,.5,.5,.5,1,.5,.5,.5,.5,.5,.5,.5)  #
)

model %>% summary()

# Display training progress by printing a single dot for each completed epoch.
print_dot_callback <- callback_lambda(
  on_epoch_end = function(epoch, logs) {
    if (epoch %% 50 == 0) cat("\n")
    cat(".")
  }
)    
epochs <- 70
batch_size <- 128


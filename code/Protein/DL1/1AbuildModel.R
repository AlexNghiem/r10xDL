# Build the keras model

library(keras)
buildModel <- function() {
  model <- keras_model_sequential() %>%
    layer_dropout(rate = .4, input_shape = dim(trainingData)[2]) %>%
    layer_dense(units = 8, activation = "relu") %>%
    layer_dense(units = 4, activation = "relu") %>%
    layer_dense(units = 2, activation = "relu") %>%
    layer_dense(units = 1)
  
  model %>% compile(
    loss = "mse",
    optimizer = optimizer_rmsprop(lr = .0005),
    metrics = list("mean_absolute_error")
  )
  
  model
}

model <- buildModel()
model %>% summary()

# Display training progress by printing a single dot for each completed epoch.
print_dot_callback <- callback_lambda(
  on_epoch_end = function(epoch, logs) {
    if (epoch %% 50 == 0) cat("\n")
    cat(".")
  }
)    
epochs <- 50
batch_size <- 128


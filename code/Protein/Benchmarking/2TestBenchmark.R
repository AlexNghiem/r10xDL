# 

# run various combinations of dropout1 and dropout2
runs <- tuning_run("code/Benchmarking/1BuildBenchmark.R", flags = list(
  dropout1 = c(0.0, 0.3, 0.6),
  dense_units1 = c(2, 4, 8)
))

# find the best evaluation accuracy
runs[order(runs$eval_acc, decreasing = TRUE), ]

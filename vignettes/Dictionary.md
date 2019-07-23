Dictionary
================

# Terms

  - hyperparameter - control aspect of training, rather than get trained
    (ie how fast the model learns)
  - dimensionality reduction - for a given data set with
    high-dimensional input, it projects the variable space onto a
    smaller space, while attempting to preserve most of the observed
    variance. Specifically, it attempts to keep the distances
  - autoencoder - a neural net that is trained to takes in an input set
    representing an object, reduce it through a bottleneck layer, and
    then recreate it on the other side
  - bottleneck layer - in an autoencoder, it is the smallest layer in
    the network (the least number of dimensions which the data is
    squeezed through).
  - p(y|x;\(\theta\)) - this is the probability of y given a data set x
    and a set of hyperparameters \(\theta\)
  - log loss - [youtube
    video](https://www.youtube.com/watch?v=IYzc_2rY9k8) a sum of error
    in a model. The calculation involves the averaging the negative log
    loss per sample from the data set, where the log loss in each sample
    is the natural log of the probability given by the model of the
    output occurring. For example, if my model predicts an 80% chance of
    it raining tomorrow, and it indeed rains tomorrow, then my model
    accrues from that sample a -ln(.8) in error. As the model becomes
    more confident in an answer, it will be punished less for getting it
    right and more for getting it wrong. To minimize log loss, our model
    must find a balance between confidence and caution.
  - max pooling - [youtube
    video](https://www.youtube.com/watch?v=ZjM_XQa5s6s) basically it
    finds the maximum value in some block of the previous layer, and
    propagates only that value forwards, while preserving spatial
    relationships between blocks. This has the effect of vastly reducing
    the dimensionality of the network. Also possibly is average-value
    pooling, which obviously averages values in the pool. The blocks can
    overlap or not (usually not). The stride is how far the block moves
    each time, so if stride equals block size, there will be no overlap.
  - data manifold - the underlying biological data beneath the
    measurement noise. generally a model seeks to capture the nature of
    this data manifold
  - GAN (generative adversarial network) - 2014 framework for machine
    learning. Create TWO models, one generative (G) and one
    discriminative (D) and train them to compete against each other. G
    creates a fake sample, and D tries to ascertain the likelihood that
    the sample came from training data. Theoretically G should win and
    create such good fake samples that D cannot tell them apart from
    real samples. At the end both models are useful, G for generating
    realistic fake samples and D for telling whether a sample is part of
    a larger data set.
  - ZINB (Zero-Inflated Negative Binomial) - a negative binomial
    distribution with added zero inflation (perhaps due to some
    artificial effect like measurement failure in scRNA-seq data)
  - SVM (Support Vector Machine) - Translates data into
    higher-dimensional space, where it can potentially be clustered
    linearly (sounds like black magic to me).
  - Bias - a measure of how poorly a given TYPE OF MODEL can predict the
    true data relationship. For example, a linear model will always be
    biased against exponential data
  - Variance - for a given TYPE OF MODEL, the variance is a measure of
    how variant the sums of squares are for different data sets. For
    example, a hyper-overfitted model will have low bias (given that the
    training data follows the true data relationship), but high
    variance. Critically, as a type of model gets closer to the true
    data relationship (as bias decreases), its variance should also go
    to 0, as most data sets will have similar distributions around that
    true relationship.
  - BAGGing (Bootstrap AGGregatING) - samples a small population from a
    larger population, and trains a model on that subset (this is
    bootstrapping). then aggregates these models when discriminating new
    samples (aggregating).
  - Boosting - iteratively follows this pattern: trains a weak learner
    and then re-weights the samples.

# Tools

  - scVI (Single Cell Variational Inference) - 2018 tool for scRNA-seq
    data analysis. Can perform dim red, visualization, clustering,
    normalization, and lots of error reductions. uses deep learning to
    clean data. beats out methods such as MAGIC and DCA, might lose to
    GAN
  - PCA (Principal Components Analysis) - linearly transforms an input
    space into a reduced dimension space. Notably, this is a form of
    linear autoencoder
  - t-SNE (t-distributed stochastic neighbor embedding) - a strange
    method of dimensional reduction that projects data in high
    dimensions onto a lower dimensional space, and then slowly adjusts
    the data points until the original distances are preserved. Notably,
    this process is only useful for visualizing. The dimensions don’t
    have semantic meaning anymore, as all of the data points get shifted
    simply to preserve distance.
  - DCA (Deep Count Autoencoder) - a method using DL to denoise gex
    data. Scales linearly for large data, so very tractable
  - scImpute - imputation method which first calculates likely dropout
    values and then subsequently imputes only those selected values. (it
    is not clear to me how this is a bad thing)
  - Splatter - a method to simulate scRNA-seq data, with or without
    dropout
  - Leave one out - A method of testing optimal parameters: with n
    samples, we train on n-1 of them and test on the remaining one. Then
    we repeat this process n times, each time leaving a different sample
    out and training on it.
  - confusion matrix - the matrix of actual positives vs negatives, and
    predicted positives vs negatives. This tabulates true positives,
    false positives, true negatives, and false negatives.

# Unknown

  - MAGIC (Markov Affinity-based Graph Imputation of Cells) -
  - SAVER (Single-cell Analysis Via Expression Recovery) -
  - k-NN classification
  - Gradient Boosted Tree
  - ChIP-seq (Chromatin Immunoprecipitation sequencing) - a method used
    to analyze protein interactions with DNA

# To investigate

  - Ridge Regression - standard linear regression optimized with
    sum-of-squares error, but with a twist. you add an error term to the
    classic sum of squared error, which is (\(\lambda\) \* \[slope^2\]).
    Lambda is a positive coefficient determined by trial and error, and
    slope^2 is actually the sum of the squared slopes for the
    coefficients of each term in the linear regression. For example, the
    equation y = a + bx + cy, then the error is \[standard sum of
    squares error\] + \(\lambda\)(b^2 + c^2). This has the effect of
    making it safer for the algorithm to assume less of a relationship
    between the independent and dependent variable. For example, when
    predicting weight of a person from height, we want to guess a
    slightly lower upward slope than the data suggest just to be safe.
    this helps account for the fact that we are more likely to
    overestimate the slope than underestimate it.
  - Lasso Regression - similar to ridge regression, but instead of
    squaring each slope term, we take the absolute value of it. The key
    difference betweeen ridge regression and lasso regression is that
    the error term in lasso regression approaches 0 much slower as the
    slope approaches 0. Therefore, lasso will sometimes incentivize
    completely zeroing out slopes, whereas ridge regression will almost
    always suggest at least some very small slope, as this marginally
    reduces residuals without really affecting the new error term.
  - Elastic Net Regression - Really just a combination of ridge and
    lasso: for arbitrary non-negative values \(\lambda_1\) and
    \(\lambda_2\), we calculate error using error = standard sum of
    error + \(\lambda_1\) \* (\[slope^2\]) + \(\lambda_2\) \* (|slope|).
    Setting different lambdas to 0 reduces this to either type of
    regression. Somehow the combination of effects makes it better at
    dealing with correlated parameters.
  - Decision Tree -
  - Random Forest -
  - Boosted Forest -
  - Gradient Boosted Decision Forest -

### Automatic model selection

library(tidyverse) #data carpentry
library(leaps) # model selection functions
library(ISLR) # for the data

hitters <- na.omit(ISLR::Hitters)   #hitting info for 322 mlb players
dim(hitters)
head(hitters)

# A. Best subset search

# 1. select the null model with no predictors
# 2. go through all models with one predictor from list of predictors
# 3. go through all models with two predictors from list ....
# 4. etc....
# 5. select best model using AIC, BIC or adjusted R2 
#    for each number of predictors (1,2,3,4 etc.)
# note the default is to use RSS as measure of 'best' (Residual Sum Squares)

best_subset <- regsubsets(Salary ~ ., hitters, nvmax = 19)
summary(best_subset)

# for 1 parameter,  CRBI is the predictor (best model)
# for 2 the model is Salary ~ CRBI + Hits

# This plot can help visualize the results
plot(best_subset, scale = "adjr2")
plot(best_subset, scale = "bic")


# B. Stepwise Selection

# obviously subset search will fail if the number of 
# possible predictors are too large.
# also using subset search increases risk of finding overfitted models 
# that don't validate well.

# Forward stepwise:
# 1. select the null model with no predictors
# 2. find best model after adding each of the predictors
# 3. to that model add each predictor in turn and find the best.
# 4. repeat 2&3 until added all predictors.
# 5. select best model from those kept.

forward <- regsubsets(Salary ~ ., hitters, nvmax = 19, method = "forward")

# Bacwards stepwise:
# similar logic to forward stepwise, but begin with all and iteratively remove one predictor.

backward <- regsubsets(Salary ~ ., hitters, nvmax = 19, method = "backward")
summary(backward)

plot(forward, scale = "adjr2")
plot(forward, scale = "bic")

plot(backward, scale = "adjr2")
plot(backward, scale = "bic")




## Examine on Training vs Test Datasets ----

# create training - testing data
set.seed(17)
sample1 <- sample(c(TRUE, FALSE), nrow(hitters), replace = T, prob = c(0.75,0.25))
train <- hitters[sample1, ]
test <- hitters[!sample1, ]

# Forward Stepwise Selection
best_subset <- regsubsets(Salary ~ ., train, nvmax = 19, method = "forward")
res <- summary(best_subset)
res

# extract and plot results
data.frame(predictors = 1:19,
       adj_R2 = res$adjr2,
       Cp = res$cp,
       BIC = res$bic) %>%
  gather(statistic, value, -predictors) %>%
  ggplot(aes(predictors, value, color = statistic)) +
  geom_line(show.legend = F) +
  geom_point(show.legend = F) +
  facet_wrap(~ statistic, scales = "free")

which.max(res$adjr2)
## [1] 9
which.min(res$bic)
## [1] 8
which.min(res$cp)
## [1] 8


# 9 variable model
coef(best_subset, 9)

# 8 variable model
coef(best_subset, 8)



## Different subsetting procedures and different indirect error test 
# estimate statistics will produce different 'best' models


## This approach is susceptible to variation in results based on e.g. how the data were split
## Better to use k-fold cross-validation to compare models selected from a series of training subsamples
## with their respective test generated predicted data.
## Can calculate Mean Square Error for each and use that to pick appropriate model.



## Other approaches can be included:
# e.g.
# recursively removing predictors that are non-significant
# recursively removing predictors with VIF > 4

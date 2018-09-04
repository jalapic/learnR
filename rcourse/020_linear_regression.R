#### 4.2 Linear Regression


### loading libraries ----
library(ggplot2) # for plotting
library(outliers) # for outlier detection
library(ggfortify) # for ggplot style diagnostic plots
library(broom) # for model summaries
library(GGally)# for model summaries
library(modelr) # for making predictions
library(tidyverse) # for data carpentry


# we can use built in dataset of 'cars'
dim(cars)
head(cars)



## Scatterplots ----

#basic, base R quick plots:
plot(x=cars$speed, y=cars$dist)
scatter.smooth(x=cars$speed, y=cars$dist) 
scatter.smooth(x=cars$speed, y=cars$dist, main="Dist~Speed") 

#ggplot
ggplot(cars, aes(x = speed, y = dist)) + geom_point()

ggplot(cars, aes(x = speed, y = dist)) + geom_point() + stat_smooth() # add smoothed trendline

ggplot(cars, aes(x = speed, y = dist)) + geom_point() + stat_smooth(method='lm') # add linear trendline

ggplot(cars, aes(x = speed, y = dist)) + 
  geom_point() + 
  stat_smooth(method='lm', se=F) # remove shaded area




## Outlier detection ----

# this function identifies points that are > 1.5*IQR which some consider an outlier
boxplot.stats(cars$speed)
boxplot.stats(cars$dist)

# $out
# [1] 120

# graph boxplots quickly
par(mfrow=c(1,2))
boxplot(cars$speed, main="speed")
boxplot(cars$dist, main="distance")

#more formally using a grubbs test for outlier detection
outliers::grubbs.test(cars$speed)
outliers::grubbs.test(cars$dist)




## Basic linear regression model ----

mod1 <- lm(dist ~ speed, data=cars)  # build regression model

mod1

# Call:
#   lm(formula = dist ~ speed, data = cars)
# 
# Coefficients:
#   (Intercept)        speed  
#       -17.579        3.932  

# dist = -17.579 + 3.932*speed


# summary statistics

summary(mod1)

#  Call:
#   lm(formula = dist ~ speed, data = cars)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -29.069  -9.525  -2.272   9.215  43.201 
# 
# Coefficients:
#               Estimate Std. Error t value Pr(>|t|)    
#   (Intercept) -17.5791     6.7584  -2.601   0.0123 *  
#   speed         3.9324     0.4155   9.464 1.49e-12 ***
#   ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 15.38 on 48 degrees of freedom
# Multiple R-squared:  0.6511,	Adjusted R-squared:  0.6438 
# F-statistic: 89.57 on 1 and 48 DF,  p-value: 1.49e-12


# Residual standard error, also called 'sigma', is a measure of the fit of the regression line
# It represents the average distance each observed value is from predicted value (in units of Y)


## 95% confidence intervals around estimates
confint(mod1)
confint(mod1, level = 0.95)

anova(mod1) # test null hypothesis of zero slope.

# AIC (Akaike's information criterion) and BIC (Bayesian information criterion)
# Further measures of goodness of fit.
# For model comparison, the model with the lowest AIC and BIC score is preferred.
# these measures are adjusted based on number of parameters in model - so can be compared across models

AIC(mod1) # 419.1569
BIC(mod1) # 424.8929


## Make a simple regression plot:
plot(cars$speed, cars$dist)
abline(mod1)



## predicting values

newdata <-data.frame(speed=15.5) # wrap the parameter
predict(mod1, newdata)    # apply predict 

#        1 
# 43.37324 

predict(mod1, newdata, interval = "confidence") 

#        fit      lwr      upr
# 1 43.37324 38.99931 47.74717



## Add predictions
library(modelr)

cars %>%
  modelr::add_predictions(mod1)






## Residuals ----

mod1
summary(mod1)
str(mod1) #there's lots of stuff in here

mod1$residuals  # these are the residuals:  observed - predicted.

mean(mod1$residuals)  # should be 0.  [1] 8.65974e-17

resid(mod1) #residuals
rstandard(mod1) #standardized residuals (residuals / standard deviation of residuals)
rstudent(mod1) # studentized residuals  (residuals controlled for leverage)



## Checking assumptions  ----


# Assumption:  Linear relationship between X and Y

ggplot(cars, aes(speed, dist)) +
  geom_point() +
  geom_smooth(method = "lm") +
  geom_smooth(se = FALSE, color = "red")



# Assumption: Homoscedasticity of residuals

par(mfrow=c(2,2))  # set 2 rows and 2 column plot layout
plot(mod1)

#top-left:  fitted values (x) against residuals (y) - also tests for non-linearity

#bottom-left: fitted values (x) against square-root of standardized residuals (y)
# expect an approximately flat red line (no overall pattern) for both if homoscedasticity



# Assumption: Normality of residuals


# top-right plot = Normal QQ plot
# If points lie exactly on the line then they come from a perfectly normal distribution
# Some deviation is expected, particularly at the tails.

shapiro.test(mod1$residuals) # these residuals do not appear to be normally distributed
#shapiro test can be overly conservative, rejecting normality too easily, for larger samples(e.g. >100)


#bottom-right plot:  leverage against standardized residuals, showing Cook's distances (see below)


## leverage
# leverage is a measure of how much the predicted value would change if the observation is moved one unit in the y-direction

lev <- hat(model.matrix(mod1)) #this gets the leverage of each data point
lev
plot(lev)

# Studentized residuals are residuals standardized for their leverage
rstudent(mod1)

# An overly influential point is one with a disproportionately large leverage or outlier or both
# Cook's Distance is a measure of influence  >1 generally indicates overly high influence

cook <- cooks.distance(mod1)
cook
plot(cook)



## examples of patterns
par(mfrow=c(2,2)) 
mod2 <- lm(mpg ~ disp, data=mtcars)  
summary(mod2)
plot(mod2)


# to generate plots yourself
dev.off() # to reset graphics

qqnorm(mod1$residuals)
qqline(mod1$residuals)
hist(mod1$residuals)



## ggplot style diagnostic plots
library(ggfortify)
autoplot(mod1, label.size = 3)

# can actually plot more than base-r basic diagnostic plots

autoplot(mod1, which = 1:6, ncol = 3, label.size = 3)




# Assumption: The X variables and residuals are uncorrelated

cor.test(cars$speed, mod1$residuals) # no correlation.







## Additional summarizing and plotting of model results

library(broom)
library(GGally)

GGally::ggcoef(mod1)
GGally::ggcoef(mod1, color = "purple", size = 5, shape = 18) #you can customize it in many ways.

broom::tidy(mod1) # coefficients in data frame

broom::glance(mod1) # model level statistics in a dataframe

broom::augment(mod1) # observation level statistics in a dataframe


# e.g. look at top 5 Cook's distances

library(tidyverse)
broom::augment(mod1) %>%
  top_n(5, wt = .cooksd)






## Testing prediction accuracy of models ----

# Create Training and Test data -
set.seed(17)  #Set random number generator so can replicate results

# randomly select 80% of rownumbers
training.rows <- sample(1:nrow(cars), 0.8*nrow(cars))  

#training data - 80% of dataset
trainingData <- cars[training.rows, ]

#test data - 20% of dataset
testData  <- cars[-training.rows, ] 

# Model based on training data only
fit.train <- lm(dist ~ speed, data=trainingData)
predicted.values <- predict(fit.train, testData)

# Check model fit as before
summary(fit.train)
AIC(fit.train)

# we can correlate actual values against predicted values
cor(testData$dist, predicted.values) #.85

# we can add in predictions as a column into our data
library(tidyverse)
library(modelr)

trainingData <- trainingData %>%  modelr::add_predictions(fit.train)
trainingData



# We should assess if the out-of-sample (test data) mean squared error (MSE) (mean squared prediction error), 
# is notably greater than the MSE for the in-sample (training data).

trainingData %>% summarise(MSE = mean((dist - pred)^2))

#       MSE
# 1 201.565

testData <- testData %>% modelr::add_predictions(mod1) 
testData
testData %>% summarise(MSE = mean((dist - pred)^2))

#        MSE
# 1 325.9917



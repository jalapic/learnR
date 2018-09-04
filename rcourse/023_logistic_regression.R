### Generalized Linear Regression

## When response variable is discrete and error terms do not follow the normal distribution

# The glm() command performs generalized linear models (regressions) on:
# - binary outcome data
# - count data
# - proportion data
# - probability data
# - etc


### Logistic Regression    aka. logit regression


library(caret)
library(pscl) # for MacFadden's R2

# response variable Y is categorical.

# we can predict the probability of a categorical repsonse based on one or more predictors.

#default <-  ISLR::Default
default <- readr::read_csv("default.csv")
head(default)


## Let's plot the data

default %>%
  mutate(prob = ifelse(default == "Yes", 1, 0)) %>%
  ggplot(aes(balance, prob)) +
  geom_point(alpha = .15) 

default %>%
  mutate(prob = ifelse(default == "Yes", 1, 0)) %>%
  ggplot(aes(balance, prob)) +
  geom_point(alpha = .15) +
  geom_smooth(method = "glm", method.args = list(family = "binomial")) +
  ggtitle("Logistic regression model fit") +
  xlab("Balance") +
  ylab("Probability of Default")


# split data into training and testing 

default$default01 <- ifelse(default$default == "No", 0, 1)

set.seed(123)
sample1 <- sample(c(TRUE, FALSE), nrow(default), replace = T, prob = c(0.6,0.4))
train <- default[sample1, ]
test <- default[!sample1, ]




#note - if big discrepancy in proportion of Y/response variable
# some suggest building models based on roughly equal proportions of this variable.


mod1 <- glm(default01 ~ balance, family = "binomial", data = train)
mod1

summary(mod1)  #remember estimates are on log-likelihood scale.
glance(mod1)

# The lower the deviance, the better the fit of the model.

# Null deviance is how well the response variable is predicted only including the intercept (grand mean) 
# and no other parameters.
# Residual deviance (or just 'deviance') is how well the response variable is predicted 
# including the parameters in the model.
# We are looking for a substantial decrease in deviance from null deviance

# Other measures of fit:

# Akaike Information Criterion (AIC)
# based on deviance but penalizes for adding parameters to the model.
# Useful for comparing similar models, the number by itself isn't super meaningful (unlike e.g. adjusted R2)
summary(mod1)$aic #912.6874 



tidy(mod1)

#a one-unit increase in balance is associated with an increase in the log odds of default by 0.0057 units.

coef(mod1)
coef(summary(mod1))
# the coefficients are in log odds - which can be hard to interpret, so transform to probabilities...

exp(coef(mod1)) 
# so a one dollar increase in monthly balance carried leads to odds of customer defaulting by 1.0057,
#which is an increase of 0.0057, or a .5% increase in defaulting probability



confint(mod1)



# compute odds of each estimate
exp(coef(mod1))  # above 1 sho

#95% confidence interval
exp(confint.default(mod1))


## Making predictions----

predict(mod1, data.frame(balance = c(1000, 2000)), type = "response") 

#response gives values in probabilities rather than log odds

#           1           2 
# 0.004785057 0.582089269  

# Note how the probability of defaulting shifts from 0.5% to 58% with a balance going from $1000 to $2000



### Visualizing effects ----


# Can use the 'effects' package to look at predicted values across a range of values visually
library(effects)
plot(allEffects(mod1)) # if more than one predictor, will make separate plots for all



# Base-r version:

range(train$balance) #[1]    0.000 2654.323
range.x <- seq(0, 2700, 0.1)  #create a range of x values between min/max of x
ypredict <- predict(mod1, list(balance = range.x),type="response")  #predict y values for range of x using model
default01 <- ifelse(train$default=="No", 0 ,1) #making sure default is 0or1 (as no/yes, plot converts to 1or2)
plot(train$balance, default01, pch = 16, 
     xlab = "Balance $", ylab = "Default Probability", 
     main = "Probability of Defaulting based on Balance") # plot
lines(range.x, ypredict,  col = "red", lwd = 2)







## Qualitative Predictors ----

mod2 <- glm(default01 ~ student, family = "binomial", data = train)

tidy(mod2)
summary(mod2)

# positive coefficient means Students (YES) have higher probability of defaulting than non-students (NO).

predict(mod2, data.frame(student = factor(c("Yes", "No"))), type = "response")

#          1          2 
# 0.04261206 0.02783019





### Multiple Logisitic Regression ----

mod3 <- glm(default01 ~ balance + income + student, family = "binomial", data = train)
tidy(mod3)
summary(mod3)  #The student estimate has turned to negative.

# This is due to  balance & student being correlated.


car::vif(mod3) #test for collinearity
# balance   income  student 
# 1.078081 2.697636 2.801508 





# predictions for multiple logistic regression

predictdf <- data.frame(balance = 1500, income = 40, student = c("Yes", "No"))
predict(mod3, predictdf, type = "response")

#          1          2 
# 0.05437124 0.11440288

# student is about half as likely to default than a non-student for a balance of 1500 and income 40.




### Model Diagnostics----


# 1. Likelihood Ratio Test - tests if our models are improving the fit.

anova(mod1, mod3, test = "Chisq")  
# significant so model 3 is an improved fit (reduces residual deviance)
# the likelihood ratio statistic is chisq = deviance (18.9)

# to test the null hypothesis that estimates are 0.

mod0 <- glm(default01 ~ 1, family = "binomial", data = train)
anova(mod0, mod1, mod3, test = "Chisq") #p<.05 can reject null.




# 2. Pseudo R2.  (McFadden's R2) - nb. there is no exact R2 statistics as in OLS Regression.

# use the function pR2 from 'pscl' package.
# McFadden's R2 ranges from 0-1, but highly unlikely to ever get to 1
# A McFadden's R2 around .40 represents a very good fit.

list(mod1 = pscl::pR2(mod1)["McFadden"],
     mod2 = pscl::pR2(mod2)["McFadden"],
     mod3 = pscl::pR2(mod3)["McFadden"])

# $`mod1`
# McFadden 
# 0.4726215 
# 
# $mod2
# McFadden 
# 0.004898314 
# 
# $mod3
# McFadden 
# 0.4805543 


# mod2 (student only) is a bad fit
# mod1 and mod3 are very good, but mod3 doesn't improve vastly on mod1



# 3. Residuals

# Residuals do not have to be normally distributed for logistic regression.
# Variance does not have to be constant for logisitic regression


mod1.r <- augment(mod1) %>%  mutate(index = 1:n())

ggplot(mod1.r, aes(index, .std.resid, color = default01)) + 
  geom_point(alpha = .5) +
  geom_ref_line(h = 3)

# any standardized residuals > 3 may be possible outliers.
# remember, standardized residuals are similar to z-scores: residuals / standard.error. residuals

mod1.r %>%  filter(abs(.std.resid) > 3)  # tends to be defaulters who had small balances.



# 4. Cook's Distances
plot(mod1, which = 4, id.n = 5) #which=4 means show the Cook's Distances plot.  id.n=5 means highlight top 5

mod1.r %>%  top_n(5, .cooksd)  #defaulters with low balances,  non-defaulters with high balances.



## Validation with Out-of-Sample Data ----

# generate predicted data from test dataset
m1 <- predict(mod1, newdata = test, type = "response")
m2 <- predict(mod2, newdata = test, type = "response")
m3 <- predict(mod3, newdata = test, type = "response")


# generate proportion tables (tables showing whether we successfully classified or not)
list(
  mod1 = table(test$default, m1 > 0.5) %>% prop.table() %>% round(3),
  mod2 = table(test$default, m2 > 0.5) %>% prop.table() %>% round(3),
  mod3 = table(test$default, m3 > 0.5) %>% prop.table() %>% round(3)
)

# $`mod1`
# 
#     FALSE  TRUE
# No  0.962 0.003
# Yes 0.025 0.010
# 
# $mod2
# 
#     FALSE
# No  0.965
# Yes 0.035
# 
# $mod3
# 
#     FALSE  TRUE
# No  0.963 0.003
# Yes 0.026 0.009

# e.g. for model 1, 96% of cases are true negatives.  1% of cases are true positives
# but 2.5% are false negatives, and 0.3% are false positives.


# to calculate the error rate - confusion matrix:
table(test$default, m1 > 0.5)

#     FALSE TRUE
# No   3803   12
# Yes    98   40

#     FALSE TRUE
# No   3873   22      #error rate is low as only 12/3803 wrongly classed as defaulters (0.03%) = high specificity
# Yes    91   44      #only 44/138 defaulters succesfully predicted = 29%, so low precision/sensitivity


#accuracy
(3803 + 40) / (3803 + 12 + 98 + 40) #0.97

tab <- table(test$default, m1 > 0.5)
sum(diag(tab)) / sum(tab)




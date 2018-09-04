## Multiple Regression ----


### loading libraries ----
library(ggplot2) # for plotting
library(modelr) # for some model functions
library(broom) # for some model functions

### loading data ----

advertising <- read.csv("Advertising.csv")
head(as.data.frame(advertising))


# Generate model
mod2 <- lm(sales ~ TV + radio + newspaper, data = advertising)
summary(mod2)

#confidence intervals
confint(mod2)





# Simple linear regression from before
mod1 <- lm(sales ~ TV, data = advertising)

list(mod1 = broom::glance(mod1), mod2 = broom::glance(mod2))


# Model 2 R2 > Model 1 R2
# Model 2 Adj R2 > Model 1 Adj R2 (Adj R2 adjusted for number of predictors in the model)
# Model 2 sigma (residual standard error) < Model 1 sigma
# Model 2 therefore has better fit of predicted values
# (remember sigma = the mean distance the observed values are from the regression line)

summary(mod1)
summary(mod2)

# Model2 F-statistic > Model 1 F-statistic



# Generate comparison of fit of model1 vs model2
model1_results <- broom::augment(mod1, advertising) %>% mutate(Model = "Model 1")
model2_results <- broom::augment(mod2, advertising) %>% mutate(Model = "Model 2")

rbind( model1_results, model2_results ) %>%
 ggplot(., aes(.fitted, .resid)) +
  geom_ref_line(h = 0) +
  geom_point() +
  geom_smooth(se = FALSE) +
  facet_wrap(~ Model) +
  ggtitle("Residuals vs Fitted")

# Model 1 has issues with heteroskedasticity.
# Model 2 has issues with linearity (pattern in residuals).



# Further Diagnostics
par(mfrow=c(1, 2))

# Model 1
qqnorm(model1_results$.resid); qqline(model1_results$.resid)

# Model 2
qqnorm(model2_results$.resid); qqline(model2_results$.resid) #issues with normality of residuals

dev.off()



### Making Predictions----

# 1. split into train/test datasets
set.seed(17)
my.sample <- sample(c(TRUE, FALSE), nrow(advertising), replace = T, prob = c(0.75,0.25))
train <- advertising[my.sample, ]
test <- advertising[!my.sample, ]

# 2. Calculate MSE for both models
test %>%
  modelr::gather_predictions(mod1, mod2) %>%
  group_by(model) %>%
  summarise(MSE = mean((sales-pred)^2))

#      model    MSE
#      <chr>  <dbl>
#     1 mod1  9.62
#     2 mod2  1.78

# Model 2 has better fit against training data than Model1
# but there are still issues to do with the normality of residuals



### Interactions ----

# option A
mod3 <- lm(sales ~ TV + radio + TV * radio, data = advertising)

# option B
mod3 <- lm(sales ~ TV * radio, data = advertising)


tidy(mod3)

list(model1 = broom::glance(mod1), 
     model2 = broom::glance(mod2),
     model3 = broom::glance(mod3))




#### Collinearity ----

# When two or more predictor variables are closely related to each other
# Makes it difficult to parse out respective influence of each predictor

credit<-read.csv("credit.csv")
head(credit)

mod4 <- lm(Balance ~ Age + Limit, data = credit)
mod5 <- lm(Balance ~ Rating + Limit, data = credit)

list(`Model 1` = tidy(mod4),
     `Model 2` = tidy(mod5))

summary(mod4)
summary(mod5)

# Mod4: age and limit are highly significant 
# Mod5, collinearity between limit and rating leads to hugely increase standard error of the limit coefficient
# leads to this estimate not being significant

# Plot a correlation of the predictors
plot(credit$Rating, credit$Limit)


# However, we also need to more formally test this
# it is theoretically possible for collinearity to exist between multiple variables
# and this may even occur without 2 variables appearing to be too highly correlated

# Multicolinearity

# Test with Variance Inflation Factor (VIF)

# So use variance inflation factor (VIF). (if close to 1 indicates an absence of collinearity)
# none VIF=1, moderately 1<VIF<5, ** highly VIF>5
# Some suggest that highest VIF should be <10, and average of all predictors should be close to 1.


car::vif(mod4)
#      Age    Limit 
# 1.010283 1.010283 

car::vif(mod5)
#   Rating    Limit 
# 160.4933 160.4933 

# Mod5 has collinearity




## Durbin Watson Test

# To test that there are independent errors
# redidual terms should be uncorrelated (no patterns - autocorrelation is an issue)
# DW stat ranges from 0-4 (with 2 being indicator of no correlation between residual terms)

car::durbinWatsonTest(mod4)
car::durbinWatsonTest(mod5)
# both pvalues > .05 so no evidence that this assumption is violated.





######


### Testing a subset of variables using partial F-test

# tests if certain variables significantly add to the model or not.

housing <- read_csv("housing.csv")
head(housing)

simple <-lm(price ~ sqft, data=housing) #Simple model
reduced = lm(price ~ sqft + bedrooms, data=housing) # Reduced model
full = lm(price ~ sqft + bedrooms + baths, data=housing) # Full model


anova(simple,reduced, full)

# Analysis of Variance Table
# 
# Model 1: price ~ sqft
# Model 2: price ~ sqft + bedrooms
# Model 3: price ~ sqft + bedrooms + baths
#   Res.Df        RSS Df  Sum of Sq      F Pr(>F)
# 1     81 3.9969e+12                            
# 2     80 3.8991e+12  1 9.7842e+10 1.9913 0.1621
# 3     79 3.8817e+12  1 1.7399e+10 0.3541 0.5535

summary(simple)
summary(reduced)
summary(full)

# both p>.16 so cannot reject null, 
# therefore, appears adding baths to model does not contribute signifciantly improved fit.

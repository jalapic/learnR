### 5.1 Poisson Regression

## Response variable are the number of occurrences (frequency) of an event with no uppper bound.
#  the response variable must allow for counts of 0 however.

## e.g. number of aggressive acts per animal
## e.g. number of awards earned by each student in a high school
## e.g. number of robberies per month


# Why linear model won't work:
# often the mode value is 0, the next most common is 1, then 2 etc.
# transforming data in any way monotonically will never shift the mode to the middle of the distribution
# also count data are bounded by 0 as a lower limit - linear regression assumes a continuous response variable -infinity to +infinity
# with count data, variance is very unlikely to be constant

# Count data often fall into a Poisson distribuion, so a poisson regression can be used.
# as with logistic regression - poisson regression uses maximum likelihood estimation
# as with logistic regression - the response variable (Y) is transformed via a link function
# the link function in natural log (so need to transform coefficients back for interpretation)




## Load libraries ----

library(ggplot2)


## Import Data ----
elephants <- read.csv("elephants.csv")  
dim(elephants)
head(elephants)


## Visualize Data ----

# histogram
ggplot(elephants, aes(x = Matings)) + geom_histogram(color='white', bins=10)

# scatterplot
ggplot(elephants, aes(x = Age, y = Matings)) + geom_point(size = 2)

table(elephants$Matings)



## Building the model ----

mod1 <- glm(Matings ~ Age, data = elephants, family = "poisson")

summary(mod1)

# If the residual deviance is much higher than degrees of freedom, indicator that there is over-dispersion
# i.e. there is variance not being accounted for by the model.
# need to account for this --

# some suggest if residual deviance / df  > 1.5 then use a quasi-poisson model instead.
51.02 / 39  #1.31


# If variance > mean - also indicative of over-dispersion
mean(elephants$Matings) # 2.682927
var(elephants$Matings)  # 5.071951



coef(mod1)

#  positive beta coefficient indicates that the more years, significantly more matings
#  again, the estimates are logs so hard to interpret, but if we exponentiate:

exp(coef(mod1))
# for one unit of increase in Age, there is a 7.1% increase in mean number of matings.
# for one unit of increase in Age, the total number of matings will increase and will be multiplied by 1.07.

# 95% confidence interval
exp(confint.default(mod1))

## broom functions also work
glance(mod1)
tidy(mod1)




# Get predicted values ----
data.frame(elephants,pred=mod1$fitted)


range(elephants$Age) #[1]    27 52
range.x <- seq(27, 52, .1)  #create a range of x values between min/max of x
ypredict <- predict(mod1, list(Age = range.x),type="response")  #predict y values for range of x using model

plot(elephants$Age, elephants$Matings, pch = 16, 
     xlab = "Age", ylab = "Matings", 
     main = "Poisson Regression Model") # plot
lines(range.x, ypredict,  col = "red", lwd = 2)




## Other model checks ----

# No observed counts should be substantially more or less than expected based on a Poisson distribution
# i.e. there should not be more 0s than expected by a Poisson distribution with a given mean.


# proportion of each Y value in real data
table(elephants$Matings)
table(elephants$Matings)/sum(table(elephants$Matings))

#observed mean
obs.mean <- mean(elephants$Matings)
obs.mean

# Generate Y values expected from a Poisson distribution
dpois(0:9, lambda = obs.mean)

# put both into a dataframe so we can plot these
df <- data.frame(number = c(names(table(elephants$Matings)), 0:9),
           proportion = c(table(elephants$Matings)/sum(table(elephants$Matings)), dpois(0:9, lambda = obs.mean)),
           group = c(rep("observed",9), rep("expected",10)))

df %>% tidyr::complete(number,group, fill = list(proportion = 0)) -> df #there is no 8 matings in original, so this adds a row for 8matings = 0

df

ggplot(df, aes(x=number, y=proportion, fill=group)) + geom_col(position='dodge')

ggplot(df, aes(x=as.numeric(as.character(number)), y=proportion, color=group)) + geom_line(lwd=1) +
  scale_x_continuous(breaks=0:9) + xlab("Number of Matings")

# this is a good visual guide, but can be hard to know how much of a deviation is satisfactory. 
# in this case, use a Chi-squared test:


totalN <- sum(elephants$Matings)

df %>% mutate(count=proportion * totalN) %>% 
  dplyr::select(group,number,count) %>% 
    spread(group,count) -> df1

df1

chisq.test(df1$observed, df1$expected)

# Pearson's Chi-squared test
# 
# data:  df1$observed and df1$expected
# X-squared = 60, df = 54, p-value = 0.2673

## The chi-square test here says that expected and observed 
## are likely to come from the same population





#Pearson's chi2 dispersion statistic (Hilbe 2011)
# A value of 1 indicates that the variances of the observed and predicted response variables are the same
# values greater than 1 are indicative of over dispersion (Hilbe 2011)

# Hilbe recommends overdispersion if >1.25 for moderate size models, and >1.05 for large numbers of observerations
# (Hilbe p82 Modeling Count Data 2016)


N <- length(elephants$Age)
p <- length(coef(mod1))
sum(mod1.resids^2) / (N-p) #1.157334   

#function
msme::P__disp(mod1)

# pearson.chi2   dispersion 
#    45.136039     1.157334 



## Deviance Goodness of Fit Test ----

# we test how much variation in observed vs predicted outcomes we would expect if the model is a good fit
# the deviance follows a chi-squared distribution, with df = n - p  (n is number of observation, p is number of parameters)

pchisq(mod1$deviance, mod1$df.residual, lower.tail = F) #0.094
1-pchisq(mod1$deviance, mod1$df.residual) #0.094 #sometimes written like this

# Cannot reject null hypothesis that our model is correctly specified
# so fairly good evidence that the model does fit the data


# Scale-Location plot
plot(mod1,which=3)


## quasi-poisson model.----

# Overdispersion leads to underestimating standard errors of estimates.
# Can accomodate this by scaling standard errors in quasipoisson model.


mod2 <- glm(Matings ~ Age, data = elephants, family = "quasipoisson")
# in a standard poisson regression, the dispersion parameter is 1.
# here it is estimated.
# what is this and what are ok values ?
# it is essentially how many times larger the variance is than the mean

summary(mod2)

coef(mod2)
coef(summary(mod2))





## Negative Binomial Regression ----

mod3 <- MASS::glm.nb(Matings ~ Age, data = elephants)
summary(mod3)

coef(mod3)
coef(summary(mod3))

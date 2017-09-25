### the broom package - takes ugly stats output of R and puts into tidy dataframe.

library(broom)
library(tidyverse)

# examples taken from:  https://github.com/tidyverse/broom


# 3 major functions

# * `tidy`: constructs a data frame that summarizes the model's statistical findings. 
#           This includes coefficients and p-values for each term in a regression, per-cluster
#           information in clustering applications, or per-test information for `multtest` functions.


# * `augment`: add columns to the original data that was modeled. 
#              This includes predictions, residuals, and cluster assignments.


# * `glance`: construct a concise *one-row* summary of the model. 
#             This typically contains values such as R^2, adjusted R^2, and residual standard 
#             error that are computed once for the entire model.



lmfit <- lm(mpg ~ wt, mtcars)
lmfit
summary(lmfit)
coef(summary(lmfit))

tidy(lmfit)  #using broom's tidy()

head(augment(lmfit)) #augment() gets the residuals for each observation into a df

glance(lmfit) #  summary info of whole model


# Can make simple coefficient plots:
td <- tidy(lmfit, conf.int = TRUE)
ggplot(td, aes(estimate, term, color = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high)) +
  geom_vline(xintercept = 0)




### Generalized linear and non-linear models

glmfit <- glm(am ~ wt, mtcars, family="binomial")
tidy(glmfit)
head(augment(glmfit))
glance(glmfit)



### Nonlinear least squares
nlsfit <- nls(mpg ~ k / wt + b, mtcars, start=list(k=1, b=0))
tidy(nlsfit)
head(augment(nlsfit, mtcars))
glance(nlsfit)



### Hypothesis testing

#t-test
tt <- t.test(wt ~ am, mtcars)
tt
tidy(tt)
glance(tt) #same

# wicox test
wt <- wilcox.test(wt ~ am, mtcars)
wt
tidy(wt)
glance(wt) #same





## dplyr and broom examples

data(Orange)

dim(Orange)
head(Orange)

ggplot(Orange, aes(age, circumference, color = Tree)) + geom_line()

#correlation between tree age and circumference - but this is across all groups
cor(Orange$age, Orange$circumference)

# correlation within each tree type
Orange %>% group_by(Tree) %>% summarize(correlation = cor(age, circumference))

# a correlation test returns much more info:
cor.test(Orange$age, Orange$circumference)


# we can use dplyr's "do" to make this tidy:
Orange %>% group_by(Tree) %>% do(tidy(cor.test(.$age, .$circumference)))


# similar example but using a linear regression:
lm(age ~ circumference, data=Orange)
summary(lm(age ~ circumference, data=Orange))

Orange %>% group_by(Tree) %>% do(tidy(lm(age ~ circumference, data=.)))





### More complex example:
data(mtcars)
head(mtcars)

mtcars %>% group_by(am) %>% do(tidy(lm(wt ~ mpg + qsec + gear, .)))


regressions <- mtcars %>% group_by(cyl) %>%
  do(fit = lm(wt ~ mpg + qsec + gear, .))
regressions

regressions %>% tidy(fit)
regressions %>% augment(fit)
regressions %>% glance(fit)












#### More interesting worked example
# https://baseballwithr.wordpress.com/2016/07/01/the-broom-package-and-home-run-trajectories/

library(Lahman)

head(Master)
head(Batting)

full_join(Batting, Master) %>%
  group_by(playerID) %>%
  mutate(totalHR = sum(HR, na.rm=T)) %>%
  filter(totalHR >= 500) %>%
  mutate(Age = yearID  - birthYear) %>%
  unite("name", c("nameFirst","nameLast")) %>%
  ungroup() %>%
  select(name, yearID, Age, AB, H, HR, totalHR)  -> S500

head(S500)



lm((HR / AB) ~ Age + I(Age ^ 2), data=S500)


# do regression for every player:

rgs <- S500 %>% group_by(name) %>%
  do(tidy(lm((HR / AB) ~ Age + I(Age ^ 2), data=.)))

rgs

# plot peak age for various players
S <- summarize(rgs %>% group_by(name),
               peak_age=- estimate[2] / 2 / estimate[3])

S

ggplot(S, aes(name, peak_age)) + geom_point() +
  coord_flip() + ylim(20, 40) +  
  ggtitle("Age of Peak Performance of Home Run Rate")


individual <- S500 %>% group_by(name) %>%
  do(augment(lm((HR / AB) ~ Age + I(Age ^ 2), data=.)))

library(ggthemes)
ggplot(individual, aes(Age, .fitted)) + 
  geom_line(color="red", size=1.5) +
  facet_wrap(~ name) +
  geom_point(data=S500, aes(Age, HR / AB), color="blue") +
  ggtitle("Career Trajectories of the 500 Home Run Club") +
  theme_fivethirtyeight()



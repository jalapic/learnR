# Distributions


library(tidyverse)

# load data
dlf <- read.csv("dlf.csv")
dim(dlf)
head(dlf)

#low scores indicate poorer hygeine


#### Examining Normality:


### visualize distributions using histogram and density plots ----

ggplot(dlf, aes(x = day1)) + geom_histogram(color='white')

ggplot(dlf, aes(x = day1)) + geom_histogram(aes(y = ..density..), color='white')

# add a normal curve
ggplot(dlf, aes(x = day1)) + geom_histogram(aes(y = ..density..), color='white') +
  stat_function(fun = dnorm, 
                args = list(mean = mean(dlf$day1, na.rm=T, sd = sd(dlf$day1, na.rm=T))),
                color="red",
                size = 1)

# change binwidth
ggplot(dlf, aes(x = day1)) + geom_histogram(aes(y = ..density..), color='white', bins=40) +
  stat_function(fun = dnorm, 
                args = list(mean = mean(dlf$day1, na.rm=T, sd = sd(dlf$day1, na.rm=T))),
                color="red",
                size = 1)


# to plot a smoothed density plot
ggplot(dlf, aes(x = day1)) + geom_density()



### QQ plot ----

# Quantile-Quantile plots 
# plot the proportion of cases below each value
# plots the cumulative values in our data against theoretical cumulative values from normal distribution

qplot(sample = dlf$day1)



#another way
qqnorm(dlf$day1)
qqline(dlf$day1, col="red") # adds a line to existing one



# Days 1, 2 and 3 together

#devtools::install_github("thomasp85/patchwork")
library(patchwork)
library(ggplot2)


p1a <- ggplot(dlf, aes(x = day1)) + geom_histogram(aes(y = ..density..), color='white', bins=40) +
  stat_function(fun = dnorm, args = list(mean = mean(dlf$day1, na.rm=T, sd = sd(dlf$day1, na.rm=T))), 
                color="red",size = 1)

p2a <- ggplot(dlf, aes(x = day2)) + geom_histogram(aes(y = ..density..), color='white', bins=20) +
  stat_function(fun = dnorm, args = list(mean = mean(dlf$day2, na.rm=T, sd = sd(dlf$day2, na.rm=T))), 
                color="red",size = 1)

p3a <- ggplot(dlf, aes(x = day3)) + geom_histogram(aes(y = ..density..), color='white', bins=20) +
  stat_function(fun = dnorm, args = list(mean = mean(dlf$day3, na.rm=T, sd = sd(dlf$day3, na.rm=T))), 
                color="red",size = 1)


p1b <- qplot(sample = dlf$day1)
p2b <- qplot(sample = dlf$day2)
p3b <- qplot(sample = dlf$day3)

# layout in a 3 x 2 grid
(p1a | p1b) /(p2a | p2b) / (p3a | p3b)


### Descriptives ----

# 'describe' from the 'psych' package gives useful information:
psych::describe(dlf$day1)
psych::describe(dlf$day2)

# 'stat.desc' from the 'pastecs' package is also useful:
pastecs::stat.desc(dlf$day1, basic = F, norm = T)
pastecs::stat.desc(dlf$day2, basic = F, norm = T)

pastecs::stat.desc(dlf[,3:5], basic = F, norm = T)
round(pastecs::stat.desc(dlf[,3:5], basic = F, norm = T), 3)

# skew and kurtosis should be 0 in a truly normal distribution.
# positive skew values mean a long right tail (more scores on left of distribution)
# positive kurtosis values = pointy and heavy-tailed distribution
# negative kurtosis values = flatter and thinner-tailed distribution

# convert skew or kurtosis to a Z score (S-0 / SES, K-0 / SEK) to evaluate significance
# here, if skew.2SE/kurt.2SE > 1 (or < -1) then likely significant
# for alpha = .01 cut-off is 1.29, for alpha = 0.001 cut-off is 1.65
# this holds true only for smaller samples (<200)

# normtest.W   normtest.p  - these are outcomes of Shapiro-Wilk test (discussed in a moment)



### analyzing by group ----

# load data
exam <- read.csv('exam.csv')
head(exam)
str(exam)

# all numeric variables
round( pastecs::stat.desc(exam[,1:4], basic = F, norm = T) , 3)

# remember to visualize data too!
ggplot(exam, aes(x = numeracy)) + geom_histogram(aes(y = ..density..), color='white',binwidth = 1)
ggplot(exam, aes(x = exam)) + geom_histogram(aes(y = ..density..), color='white')


# by group
by(data = exam$exam, INDICES = exam$uni, FUN = psych::describe)
by(data = exam$exam, INDICES = exam$uni, FUN = pastecs::stat.desc, basic = F, norm = T)
by(data = exam[,1:4], INDICES = exam$uni, FUN = pastecs::stat.desc, basic = F, norm = T)

# when comparing individual groups, appears that data is normally distributed within groups

ggplot(exam, aes(x = exam)) + geom_histogram(aes(y = ..density..), color='white') + facet_wrap(~uni)

ggplot(exam, aes(x = exam)) + 
  geom_histogram(aes(y = ..density.., fill=uni), alpha =.6, position="identity", color='white') +
  scale_fill_manual(values = c("dodgerblue", "orange"))



### Shapiro-Wilk Test ----

# compare sample to a normal distribution with mean and sd same as the sample
# if p<.05 distributions significantly differ 
# can be overly sensitive with large samples
# combine with visual inspection (histograms, qqplot) and evaluation of skew and kurtosis

shapiro.test(exam$exam)
shapiro.test(exam$numeracy)

by(data = exam$exam, 
   INDICES = exam$uni, 
   FUN = shapiro.test) # when comparing groups, need to know the distribution within each group

by(data = exam$numeracy, 
   INDICES = exam$uni, 
   FUN = shapiro.test)



### Levene's Test ----

# Test for homogeneity of variance across all levels of a variable
# Essentially a one-way anova across groups on deviations of each score from its group mean

car::leveneTest(exam$exam, exam$uni) #1st = continuous outcome variable, 2nd = grouping variable

# if p-value <.05 suggests that there are differences in variances across groups (i.e. heterogeneity)

# also has issues with being overly sensitive for large sample sizes 
# (power of test leads to increased sensitivity)



## Hartley's Fmax (variance ratio)
# ratio of the biggest group variance to smallest group variance.
# An assumption is that there are an equal number of participants in each group.
# It's also very sensitive with deviations from normality
# This can be calculated easily - but the value needs to be compared to a critical table
# e.g. http://archive.bio.ed.ac.uk/jdeacon/statistics/table8.htm

vars <- by(data = exam$numeracy, 
   INDICES = exam$uni, 
   FUN = var)

vars
vars[2]/vars[1] #largest/smallest  #2.21  #critical value (approx 2.0), so NS



### Some Normality Test Extensions ---- 

library(nortest)

# Most statisticians suggest using Shapiro-Wilk (along with visual inspection and skew/kurtosis),
# as it has more power than others - but several others exist:
# e.g. Kolmogorov Smirnov Test (though sensitive to outliers)
# e.g. Lilliefors Test (less conservative than KS)

nortest::lillie.test(exam$exam) #Lillie
nortest::ad.test(exam$exam) #Anderson-Darling


by(data = exam$exam, INDICES = exam$uni, FUN = nortest::lillie.test)
by(data = exam$exam, INDICES = exam$uni, FUN = nortest::ad.test)

# the package 'nortest' has several other normality tests, as does the package 'normtest'

# 'normtest' also includes some more robust skewness/kurtosis tests:


library(normtest)

by(data = exam$exam, INDICES = exam$uni, FUN = nortest::lillie.test)

examA <- subset(exam, uni == "Uni-A")
examB <- subset(exam, uni == "Uni-B")

normtest::kurtosis.norm.test(examA$numeracy, nrepl=2000)  #p>.05,  ok for kurtosis
normtest::skewness.norm.test(examA$numeracy, nrepl=2000)  #p>.05,  ok for skewness






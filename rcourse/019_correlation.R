#### 4.1 Correlations


### loading libraries ----

library(Hmisc) # for 'rcorr' function
library(ppcor) # for partial correlation functions
library(psych) # for multiple comparisons
library(ltm) # for point-biserial correlation
library(polycor)  # for point-biserial correlation
library(ggplot2) #for plotting
library(GGally) #for plotting 


### loading data ----

exams <- readr::read_csv("exams.csv") #note this is not the 'exam.csv' which is different
dim(exams)
head(exams)


## Check for complete data
sapply(exams, function(x) sum(is.na(x)))  # ugly, but quick

exams[is.na(exams$anxiety),]  #find those in 'anxiety' variable that are NA (missing values)



## Scatterplots ----

plot(exams$revise, exams$exam) #base-r way of doing things - good to get a quick overview.
plot(exams$anxiety, exams$exam) 

# we can also get quick inspection of all relevant scatterplots by choosing columns of interest
plot(exams[,2:4]) 
plot(exams[c(2,3,4)]) #another way of writing the above line - better if have non consecutive columns


# It is possible to customize base-r plots and make very nice looking plots....
# It's just not worth it, when ggplot2 exists:


# these lines take you step by step through how we would build a scatterplot in ggplot2:
ggplot(exams)
ggplot(exams, aes(x=revise, y=exam))
ggplot(exams, aes(x=revise, y=exam)) + geom_point()
ggplot(exams, aes(x=revise, y=exam))  + geom_point(shape = 21)
ggplot(exams, aes(x=revise, y=exam)) + geom_point(shape = 21, colour = "navy", fill = "dodgerblue")
ggplot(exams, aes(x=revise, y=exam)) + geom_point(size=2)
ggplot(exams, aes(x=revise, y=exam, color=gender)) + geom_point(size=1)



# to make a quick overview of our data easy to use the "GGally" package functions:

ggscatmat(exams, columns = 2:4)

GGally::ggscatmat(exams, columns = 2:4, color="gender", alpha=0.8)


ggscatmat(exams, columns = 2:4, corMethod="pearson")
ggscatmat(exams, columns = 2:4, corMethod="spearman")
ggscatmat(exams, columns = 2:4, corMethod="kendall")

# if you include non numeric data as one of the column types - then use 'ggpairs'
# this takes longer than "ggscatmat"
ggpairs(exams, columns = 2:5)
ggpairs(exams, columns = 2:5, mapping = aes(color = gender), alpha=0.8) #note - specify color slightly differently to above


# Back to our scatterplots...
ggscatmat(exams, columns = 2:4)


## Test for normality using Shapiro-Wilks tests ----

shapiro.test(exams$revise)
shapiro.test(exams$exam)
shapiro.test(exams$anxiety)


# Because the shapiro-Wilks tests are all significant we should use non-parametric correltations
# For illustration, we'll use the same dataset to calculate both pearson and spearman correlations

#these plots givey you a bit more of a sense of the distribution of each variable
qqnorm(exams$revise)
qqnorm(exams$exam)
qqnorm(exams$anxiety)




## Getting a correlation matrix.----

cor(exams[,2:4], use = "everything")
cor(exams[,2:4])  # the default is to use everything

#            revise      exam anxiety
# revise  1.0000000 0.3967207      NA
# exam    0.3967207 1.0000000      NA
# anxiety        NA        NA       1


cor(exams[,2:4],use = "complete.obs")
#             revise       exam    anxiety
# revise   1.0000000  0.3787481 -0.6603021
# exam     0.3787481  1.0000000 -0.4309643
# anxiety -0.6603021 -0.4309643  1.0000000



## Getting correlations between specific variables.----

cor(exams$revise, exams$anxiety, use = "everything",  method = "pearson") #NA values prevent this from working
cor(exams$revise, exams$anxiety, use = "complete.obs",  method = "pearson")

cor(exams$revise, exams$anxiety, use = "complete.obs",  method = "spearman")  #Pearson, Spearman, Kendall methods available



## Significance testing----

cor.test(exams$revise, exams$anxiety)  #'cor.test' doesn't mind NA data

# 
# Pearson's product-moment correlation
# 
# data:  exams$revise and exams$anxiety
# t = -8.7923, df = 100, p-value = 4.363e-14
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#   -0.7575042 -0.5344582
# sample estimates:
#        cor 
# -0.6603021 


cor.test(exams$revise, exams$anxiety, alternative = "less")
cor.test(exams$revise, exams$anxiety, alternative = "greater")
cor.test(exams$revise, exams$anxiety, method="spearman")


#note that you can specify confidence intervals
cor.test(exams$revise, exams$anxiety, method ="pearson", conf.level = 0.99)  #note only calculates CI for Pearson





## A matrix of correlation values and p-values----


#examMatrix <- as.matrix(exams[, c("exam", "anxiety", "revise")])

examMatrix <- as.matrix(exams[, 2:4])  # converts data into a 'matrix' format

Hmisc::rcorr(examMatrix) # use 'rcorr' from package Hmisc


#         revise  exam anxiety
# revise    1.00  0.40   -0.66
# exam      0.40  1.00   -0.43
# anxiety  -0.66 -0.43    1.00
# 
# n
#         revise exam anxiety
# revise     103  103     102
# exam       103  103     102
# anxiety    102  102     102
# 
# P
#         revise exam anxiety
# revise          0    0     
# exam     0           0     
# anxiety  0      0          



Hmisc::rcorr(examMatrix, type="spearman")




## Controlling for multiple comparisons ----

psych::corr.test(examMatrix, method="spearman", adjust="holm")

psych::corr.test(examMatrix, method="spearman", adjust="bonferroni")

# What adjustment for multiple tests should be used? 
# ("holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"). 
# See p.adjust for details about why to use "holm" rather than "bonferroni").








## Partial Correlation----

# replot to remind ourselves of the raw data
ggscatmat(exams, columns = 2:4)


#another way of getting three correlations next to each other
p1 = ggplot(exams, aes(x=revise, y=exam)) + geom_point() + xlab("Revision Time") + ylab("Exam Score")
p2 = ggplot(exams, aes(x=revise, y=anxiety)) + geom_point() + xlab("Revision Time") + ylab("Exam Anxiety")
p3 = ggplot(exams, aes(x=anxiety, y=exam)) + geom_point() + xlab("Exam Anxiety") + ylab("Exam Score")

gridExtra::grid.arrange(p1,p2,p3,nrow=1)



# for partial correlations we need complete observations - no missing data allowed.

exams1 <- exams[!is.na(exams$anxiety),] # removing the one line with an NA in it.

dim(exams) #103 5
dim(exams1) #102 5


# get a matrix of partial correlations
ppcor::pcor(exams1[,2:4]) #default is Pearson's

ppcor::pcor(exams1[,2:4], method = "spearman")



# to do for individual variables

cor(exams$anxiety, exams$exam, use = "complete.obs",  method = "spearman")

ppcor::pcor.test(x=exams1$anxiety, y=exams1$exam, z=exams1$revise, method="spearman")

#     estimate    p.value statistic   n gp   Method
# 1 -0.2482843 0.01229718 -2.550253 102  1 spearman





### Point-Biserial Correlation----

cats <- read_csv("cats.csv")  # Do Male cats (1) wander further from their house than Female cats (0)

# data is continuous (time) vs nominal (gender)
dim(cats)
head(cats)

#make a scatterplot
ggplot(cats, aes(gender,time)) + geom_point()
  
# tidying up the axes and adding a trendline (more on this later)
ggplot(cats, aes(gender,time)) + geom_point() +
  scale_x_continuous(breaks=c(0,1))+
  stat_smooth(method='lm',se=F)


## there are 3 options for running a point-biserial correlation

# each uses a slightly different algorithm, the 'cor.test' is probably the worst approximation.
# the best is probably 'polycor::polyserial'


# running correlation  (x=continuous_variable, y=dichotomous_variable)
# dichotomous variable can be numbers (0/1) or character string (male/female)
polycor::polyserial(cats$time,cats$gender, std.err = T)

# Polyserial Correlation, 2-step est. = 0.46 (0.1245)
# Test of bivariate normality: Chisquare = 15.64, df = 5, p = 0.007967

ltm::biserial.cor(cats$time,cats$gender, level = 2) #[1] 0.3784542

# using pearson (works if dichotomous variable is coded 0/1)
cor.test(cats$time, cats$gender) #0.3784542

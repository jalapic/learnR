
### One-way anova

# generate a data.frame
libido <- c(3,2,1,1,4,5,2,4,2,3,7,4,5,3,6)
dose<-gl(3,5,labels=c("Placebo","Low Dose","High Dose"))
viagra <- data.frame(dose,libido)
viagra


## visualize descriptive statistics of data
by(viagra$libido, viagra$dose, summary)
by(viagra$libido, viagra$dose, pastecs::stat.desc)


# QQ plot


# visualize data with plot
ggplot(viagra, aes(x=dose, y = libido)) +
  geom_boxplot()


# Levene's Test
car::leveneTest(viagra$libido, viagra$dose)
# does variance vary across levels of IV? p>.05 so ok

# Alternative Homogeneity of Variance Test
bartlett.test(libido ~ dose, data = viagra) # p>.05 so equal variances can be assumed


# Generate a model using 'aov'
mod1 <- aov(libido ~dose, data=viagra)
mod1
summary(mod1)


## Diagnostics
par(mfrow=c(2,2)) 
plot(mod1)
dev.off() # to reset graphics


## Welch's correction applied using oneway.test - 
mod2 <- oneway.test(libido ~dose, data=viagra)
mod2


## Planned contrasts
mod3 <- lm(libido~dose, data=viagra)
summary(mod3)

anova(mod3)

contrasts(viagra$dose)

contrast1 <- c(-2,1,1)
contrast2 <- c(0,-1,1)
contrasts(viagra$dose) <- cbind(contrast1,contrast2)

contrasts(viagra$dose)

mod4 <- lm(libido~dose, data=viagra)
summary(mod4)
#important note - these p-values are 2-tailed.
#if we have planned comparisons, we can divide these by 2 to get 1-tailed p-values


# linear or quadratic relationship ?
contrasts(viagra$dose) <- contr.poly(3) #there are 3 groups
contrasts(viagra$dose)

mod5 <- lm(libido~dose, data=viagra)
summary(mod5)  
# this indicates that there is a linear relationship, but no quadratic relationship


## posthoc testing

#2-tailed posthoc tests
pairwise.t.test(viagra$libido, viagra$dose, p.adjust.method = "bonferroni")
pairwise.t.test(viagra$libido, viagra$dose, p.adjust.method = "holm")

#Perform Tukey HSD posthoc tests
TukeyHSD(mod1)


library(multcomp) #need R version > 3.5
posthocs <- glht(mod1, linfct=mcp(dose="Dunnett"), base=1)
summary(posthocs)
confint(posthocs)


### Model output tidied

##effect size
library(broom)
glance(mod1)  #r2 sometimes called eta-squared in one-way ANOVA
#effect size is the sqrt(R2)

tidy(mod1) 


library(sjstats)
anova_stats(mod1)


# You can convert t-statistics into an r value for estimates
# these can be used for effect sizes.

# rcontrast function for effect sizes of comparisons

# for individual estimates
summary.lm(mod4)
rcontrast <- function(t,DF){sqrt(t^2/(t^2 + DF))}
rcontrast(2.474, 12) #0.48






## Non-parametric alternatives

kruskal.test(libido ~ dose, data=viagra)

library(PMCMRplus)
PMCMRplus::kwAllPairsNemenyiTest(libido ~ dose, data = viagra, p.adjust.method="bonferroni")


## Resampling Methods

# When assumptions cannot be met you cannot assume random sampling from well defined populations
# One alternative is to use resampling methods e.g. Monte-Carlo Simulations
# It's possible to set these up yourself in R, but some shortcut methods already exist:

# http://finzi.psych.upenn.edu/R/library/coin/doc/coin.pdf



library(coin)
oneway_test(libido ~ dose, data = viagra, distribution=approximate(B=10000))






###  CAUTION !!!

# R uses Type 1 Sequential SS not the default Type III marginal SS used in many other stats packages (e.g. SAS, SPSS)
# We will discuss this later



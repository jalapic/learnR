# ANCOVAs


## load data
viagrac <- read.csv("viagrac.csv")
head(viagrac)



## Assumption:  homogeneity of regression slopes 
# assumed that relationship between covariate and response variable is consistent across levels/groups
# e.g. partner's libido relationship with libido equivalent across high/low/placebo groups


#visualize data
library(tidyverse)
viagrac %>% gather(id, value, 2:3) -> viagrac1
ggplot(viagrac1, aes(x=Dose, y=value)) + facet_wrap(~id) + geom_boxplot()

## Equal variances Across Groups ?
car::leveneTest(viagrac$Libido, viagrac$Dose)


## One-Way ANOVA without accounting for covariate

mod0 <- aov(Libido ~ Dose, data = viagrac)
summary(mod0)  #not significant 





## Test if predictor variable and covariate are independent
modx <- aov(Partner_Libido ~ Dose, data = viagrac)
summary(modx)
#p>.05, yes - we are ok to proceed


## Fit the ANCOVA model.

# add in the covariate
mod1 <- aov(Libido ~ Dose + Partner_Libido, data = viagrac)
mod2 <- aov(Libido ~ Partner_Libido + Dose, data = viagrac)

mod1
mod2

summary(mod1)
summary(mod2)


## Order matters !

# R uses type I sequential sums of squares 
# any predictor entered into a model is evaluated only after prior predictors.


## Use Type III Sums of Squares method:
car::Anova(mod1, type = "III")
car::Anova(mod2, type = "III")

# Some general recommendations:
# Type 1: Sequential method. 
# Type 2: All predictors are evaluated after taking into account all others except interactions.
# Type 3: All predictors are evaluated after taking into account all others.
# Type 4: (similar to type 3 but accounts for missing data)

# Type 1: Unless predictors are completely independent (unlikely) not very useful.
# Type 2: If interested in MAIN EFFECTS only.
# Type 3: Default for most stats packages - better with uneven sample sizes and interactions.


# So, if want type I method - enter covariate first into model
mod2 <- aov(Libido ~ Partner_Libido + Dose, data = viagrac)
mod2

## Another note - type III Sums of Squares requires contrasts to be orthogonal
# by default R uses dummy coding 
# we can set our own contrasts using the 'contrasts' function

contrasts(viagrac$Dose) <- contr.helmert(3) # 3 groups, this sets a Helmert contrast

# set our own planned comparisons
contrast1 <- c(1,1,-2)
contrast2 <- c(1,-1,0)
contrasts(viagrac$Dose) <- cbind(contrast1,contrast2)

contrasts(viagrac$Dose) #check

# Run the model
mod3 <- aov(Libido ~ Partner_Libido + Dose, data = viagrac)
car::Anova(mod3, type="III")


# So a significant effect of Dose here is after adjusting for the signficant effect of the covariate
# We still need to interpret this effect of Dose -
# Get adjusted means - means adjusted for effects of covariates
# aka. marginal means or least squares (LS) means

library(effects)
adjmeans <- effect("Dose", mod3, se=T)

adjmeans #means
summary(adjmeans) #confidence limits
adjmeans$se #standard errors


## Identifying which Adjusted Means Differ:


# Planned Contrasts
summary.lm(mod3)
# contrast 1 compares the adjusted mean of placebo (2.93) to mean of adjusted means of other two groups
# contrast 2 comapres adjusted means of low and high dose groups
# clearly, the covariate (partner's libido) & outcome (libido) have a positive relationship also.

# Posthoc tests (has to be Tukey or Dunnet as need to compare adjusted means)
posthocs1 <- multcomp::glht(mod3, linfct=multcomp::mcp(Dose="Tukey"))
posthocs2 <- multcomp::glht(mod3, linfct=multcomp::mcp(Dose="Dunnet"))

summary(posthocs1)
confint(posthocs1)

summary(posthocs2)
confint(posthocs2)


## Diagnostic Plots
par(mfrow=c(2,2))  # set 2 rows and 2 column plot layout
plot(mod3)
dev.off()



## Homogeneity of Regression Slopes

# the relationship between covariate and outcome variable should be consistent across groups
# e.g. partner's libido and libido should have the same relationship across high/low/placebo

# visualize
ggplot(viagrac, aes(x = Partner_Libido, y = Libido, color=Dose)) + geom_point() + 
  stat_smooth(method="lm", se=F) # this plot seems problematic

# test assumption - include interaction term
mod4 <- aov(Libido ~ Partner_Libido * Dose, data = viagrac)
summary(mod4)

# nb. could also have done this:
mod5 <- update(mod3, .~. + Partner_Libido:Dose)
summary(mod5)

# to use type III 
car::Anova(mod4, type="III")

## because there is a significant interaction between covariate + predictor,
# we cannot assume a consistent relationship across groups
# this means our findings should be interpreted with caution.


## Effect Sizes for ANCOVA
library(broom)
glance(mod3)
tidy(mod3)

# partial eta squared for model
summary.lm(mod3)

#partial eta squared  - proportion of variance that each variable explains, not explained by others
# = SSeffect / (SSeffect + SSresidual)

library(sjstats)
sjstats::eta_sq(mod3, partial=T)
sjstats::anova_stats(mod3)

# for individual estimates
summary.lm(mod3)
rcontrast <- function(t,DF){sqrt(t^2/(t^2 + DF))}
rcontrast(2.785, 26) #0.48



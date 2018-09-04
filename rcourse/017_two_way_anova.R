### FACTORIAL ANOVA

# two or more IVs.

## Two-Way ANOVA example

df <- read.csv("drink.csv")
head(df)
dim(df)

table(df$alcohol)
table(df$gender)
str(df)

## check levels
levels(df$gender)
levels(df$alcohol)

# reorder factor
df$alcohol <- factor(df$alcohol, levels = c("None", "2 Pints", "4 Pints"))

## visualize data

#boxplot
ggplot(df, aes(alcohol, extraversion)) + geom_boxplot() + facet_wrap(~gender)

#line plot of means
df %>% group_by(gender, alcohol) %>% 
  summarize(mean_ext = mean(extraversion), sd_ext = sd(extraversion),
            n_ext = n(), serr_ext = sd_ext/sqrt(n_ext)) %>%
  ggplot(., aes(x= alcohol, y=mean_ext, color=gender, group=gender))  +
  geom_point() + geom_line() +
  geom_pointrange(aes(ymin = mean_ext - serr_ext, ymax = mean_ext + serr_ext))


## Levene's Test

# could do over both independent variables
car::leveneTest(df$extraversion, df$gender)
car::leveneTest(df$extraversion, df$alcohol)

# but we're mainly interested in interaction effects - so test over all 6 groups
# (male-none, male-2, male-4, female-none, female-2, female-4)

car::leveneTest(df$extraversion, interaction(df$gender, df$alcohol)) # ok, assumption met.





## Contrasts (planned comparisons) ----
contrasts(df$gender)
contrasts(df$gender) <- c(-1,1)
contrasts(df$gender)

contrasts(df$alcohol)
contrasts(df$alcohol) <- cbind(c(-2,1,1), c(0,-1,1))
contrasts(df$alcohol)


## Fitting the Model ----

mod1 <- aov(extraversion ~ gender + alcohol + gender:alcohol, data = df)
summary(mod1)

mod1 <- aov(extraversion ~ gender * alcohol, data = df)
summary(mod1)

# Type III
Anova(mod1, type="III")

# Looking at the line plot and these results, clear that for females alcohol has no 
# real effect on extraversion of who they talk with, but for males
# there is a large effect with the highest alcohol value.


# Other summary methods
library(broom)
glance(mod1)  
tidy(mod1) 
tidy(car::Anova(mod1, type="III"))


# Summary of contrast results
summary.lm(mod1)

# this summarizes test for differences in means between the following groups:

# gender1 - 1st contrast for gender (female vs male)
# alcohol1 - 1st contrast for alcohol (any alcohol vs no-alcohol)
# alcohol2 - 2nd contrst for alcohol (2 pints vs 4 pints)
# gender1:alcohol1 - is the effect of alcohol1 different by gender?
# gender1:alcohol2 - is the effect of alcohol2 different by gender?


## Visualize Results

# alcohol vs no-alcohol
df %>% mutate(alcohol1 = ifelse(alcohol == "None", "No Alcohol", "Alcohol")) %>%
  group_by(gender,alcohol1) %>%
  summarize(mean_ext = mean(extraversion), sd_ext = sd(extraversion)) %>%
 ggplot(., aes(x= alcohol1, y=mean_ext, color=gender, group=gender))  +
  geom_point() + geom_line() +
  geom_pointrange(aes(ymin = mean_ext - sd_ext, ymax = mean_ext + sd_ext))

#2 pints vs 4 pints
df %>% filter(alcohol != "None") %>%
  group_by(gender,alcohol) %>%
  summarize(mean_ext = mean(extraversion), sd_ext = sd(extraversion)) %>%
  ggplot(., aes(x= alcohol, y=mean_ext, color=gender, group=gender))  +
  geom_point() + geom_line() +
  geom_pointrange(aes(ymin = mean_ext - sd_ext, ymax = mean_ext + sd_ext))



## Simple Effects Analysis ----

# create new category variable 'simple' for each possible comination of IVs
df <- as.data.frame.matrix(df)
df$simple <- factor(paste(df$gender,df$alcohol,sep="_"))
df
str(df)

# create contrasts to examine effect of gender for each level of alcohol
contrasts(df$simple)

gender_0 <- c(0,0,-1,0,0,1)
gender_2 <- c(-1,0,0,1,0,0)
gender_4 <- c(0,-1,0,0,1,0)

contrasts(df$simple) <- cbind(gender_0, gender_2, gender_4)
contrasts(df$simple)

mod.simple <- aov(extraversion ~ simple, data = df)
summary(mod.simple)
summary.lm(mod.simple)



## Posthoc Tests ----

#nb. given a significant interaction, these aren't very informative,
# but if only main effects significant, this is how to do posthoc tests

# e.g. for main effect of alcohol...

#option 1
pairwise.t.test(df$extraversion, df$alcohol, p.adjust.method = 'bonferroni')

#option 2
library(multcomp) #need R version > 3.5
posthocs <- glht(mod1, linfct=mcp(alcohol="Dunnett"), base=1)
summary(posthocs)
confint(posthocs)


## Diagnostics ----


par(mfrow=c(2,2))  # set 2 rows and 2 column plot layout
plot(mod1)  #residuals appear normally distributed, possibly some funneling of residuals (heteroscedasticity)
dev.off()



##effect size

library(sjstats)
anova_stats(mod1)

# for individual estimates
summary.lm(mod1)
rcontrast <- function(t,DF){sqrt(t^2/(t^2 + DF))}
rcontrast(4.074, 42) #0.53


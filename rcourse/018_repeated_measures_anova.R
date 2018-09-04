### Repeated-Measures ANOVA  (Within-Subjects ANOVA)


library(tidyverse)

### Import Data
df <-read.csv("tucker.csv")
head(df)

df %>% gather(Animal, Retch, 2:5) -> df
df$Animal <- factor(df$Animal)
head(df)




# visualize data
by(df$Retch, df$Animal, pastecs::stat.desc)

ggplot(df, aes(Animal, Retch)) + geom_boxplot()


## Basic Repeated Measures One-Way ANOVA

mod1 <- aov(Retch ~ Animal + Error(participant/Animal), data=df)
summary(mod1)

library(ez)
ezANOVA(data = df, dv = .(Retch), wid = .(participant), within = .(Animal),
        detailed = T, type = 3)

# sphericity is an issue if you have 3 or more levels of your IV

pairwise.t.test(df$Retch, df$Animal, p.adj="bonferroni", paired=T)


## Multilevel approach
# sphericity can be ignored

# Setting contrasts
levels(df$Animal)

PartvsWhole <- c(-1,-1,1,1)
TesticlevsEye <- c(1,-1,0,0)
StickvsGrub <- c(0,0,-1,1)

# positive compared against negatives and zeros are ignored

contrasts(df$Animal) <- cbind(PartvsWhole, TesticlevsEye, StickvsGrub)

contrasts(df$Animal)


# run the model
library(nlme)
mod2 <- nlme::lme(Retch ~ Animal, random = ~1|participant/Animal, data = df, method = "ML")
summary(mod2)

baseline <- lme(Retch ~ 1, random = ~1|participant/Animal, data = df, method = "ML")

anova(baseline,mod2)


# posthoc-test (e.g. if we hadn't previously set contrasts)

library(multcomp)
summary(multcomp::glht(mod2, linfct=multcomp::mcp(Animal="Tukey")))

confint(glht(mod2, linfct=mcp(Animal="Tukey")))




### Effect Sizes
ezANOVA(data = df, dv = .(Retch), wid = .(participant), within = .(Animal),
        detailed = T, type = 3)

# the 'ges' column gives effect sizes (generalized eta squared)


# to get 'r' effect sizes - convert from t-values
summary(mod2)

rcontrast <- function(t,DF){sqrt(t^2/(t^2 + DF))}
rcontrast(3.149752, 21) #0.567








## Factorial Repeated-Measures Designs

# participants had 3 sessions
# in each sesssion they watched 3 adverts
# one advert for a beer, one for water, one for wine
# these were paired with positive/negative/neutral imagery
# over the 3 sessions all combinations (e.g. beer + negative) were watched by each participant
# participants rated their attitude towards the drinks after each session on a scale of -100 to +100

#import data
attitude <- read.csv("attitude.csv")
head(attitude)

# visualize data

ggplot(attitude, aes(x=drink, y=attitude)) + geom_boxplot() + facet_wrap(~imagery)

by(attitude$attitude, list(attitude$drink, attitude$imagery),  pastecs::stat.desc)

## ezANOVA approach

library(ez)
mod5 <- ezANOVA(data = attitude, dv = .(attitude), wid = .(participant), within = .(imagery, drink),
        type=3, detailed=T)
mod5

# need to correct for sphericity for main effects but not interaction term


## plot the significant interaction

attitude %>% group_by(drink, imagery) %>%
  summarize(mean_attitude = mean(attitude),
            std = sd(attitude),
            n = n(),
            serr_attitude = std/sqrt(n)) %>%
  ggplot(., aes(drink, mean_attitude, group=imagery, color=imagery)) +
  geom_line()+
  geom_point() +
  geom_pointrange(aes(ymin=mean_attitude-serr_attitude, ymax=mean_attitude+serr_attitude))

# appears that neutral and positive imagery have similar patterns of attitudes across drinks
# but the pattern is different for wine in the negative condition

## posthoc tests

pairwise.t.test(attitude$attitude, attitude$groups, paired = T, p.adjust.method = 'bonferroni')



## Factorial repeated measures design as a GLM


# setting contrasts
levels(attitude$drink)
AlcoholvsWater <- c(1,-2,1)
BeervsWine <- c(-1,0,1)
contrasts(attitude$drink) <- cbind(AlcoholvsWater,BeervsWine)

levels(attitude$imagery)
NegativevsOther <- c(-2,1,1)
PositivevsNeutral <- c(0,1,-1)
contrasts(attitude$imagery) <- cbind(NegativevsOther,PositivevsNeutral)


head(attitude)

## baseline model
baseline <- nlme::lme(attitude ~ 1, random = ~1|participant/drink/imagery, data = attitude, method="ML")

# update models adding one variable at a time
drinkModel <- update(baseline, .~. + drink)
imageryModel <- update(drinkModel, .~. + imagery)
attitudeModel <- update(imageryModel, .~. + drink:imagery)

# compare models
anova(baseline, drinkModel, imageryModel, attitudeModel)

# summary of models
summary(attitudeModel)

# visualize

#                                                 Value Std.Error  DF   t-value p-value
#drinkAlcoholvsWater:imageryNegativevsOther    0.190278 0.2761553 114  0.689024  0.4922
#drinkBeervsWine:imageryNegativevsOther        3.237500 0.4783151 114  6.768551  0.0000


attitude %>% 
  mutate(drinktype = ifelse(drink=="Water", "Water", "Alcohol"),
         imagerytype = ifelse(imagery=="Negative", "Negative", "Control")) %>%
  group_by(drinktype,imagerytype) %>%
  summarize(mean_att = mean(attitude),
            sd_att = sd(attitude),
            n = n(),
            serr_att = sd_att/sqrt(n)) -> summary1

ggplot(summary1, aes(drinktype, mean_att, color = imagerytype, group = imagerytype)) + geom_point() + 
  geom_line() + geom_pointrange(aes(ymin = mean_att - serr_att, ymax = mean_att + serr_att))

attitude %>% 
  filter(drink != "Water") %>%
  mutate(imagerytype = ifelse(imagery=="Negative", "Negative", "Control")) %>%
  group_by(drink,imagerytype) %>%
  summarize(mean_att = mean(attitude),
            sd_att = sd(attitude),
            n = n(),
            serr_att = sd_att/sqrt(n)) -> summary2

ggplot(summary2, aes(drink, mean_att, color = imagerytype, group = imagerytype)) + geom_point() + 
  geom_line() + geom_pointrange(aes(ymin = mean_att - serr_att, ymax = mean_att + serr_att))


# Calculating effect sizes for contrasts

# e.g.
#drinkBeervsWine:imageryNegativevsOther        3.237500 0.4783151 114  6.768551  0.0000
rcontrast(6.77, 114) #0.5354952







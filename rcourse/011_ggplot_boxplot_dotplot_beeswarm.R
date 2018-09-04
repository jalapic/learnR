
### ggplot - Boxplots

library(ggplot2)


### Basic Boxplot

states <- read.csv("states.csv")

states <- subset(states, !is.na(region)) #dropping DC


ggplot(states)

ggplot(states, aes(x=region, y=toxic))

ggplot(states, aes(x=region, y=toxic)) + geom_boxplot()

#nb. x axis has to be factor- if it's not, you can make sure it's treated as if it is like this:

ggplot(states, aes(x=factor(region), y=toxic)) + geom_boxplot()


# one way to define the order on the x-axis is as follows:
levels(states$region)
states$region <- factor(states$region, levels=c("N. East", "Midwest", "West", "South"))

ggplot(states, aes(x=region, y=toxic)) + geom_boxplot()


#outlier size
ggplot(states, aes(x=region, y=toxic)) + geom_boxplot(outlier.size=1)
ggplot(states, aes(x=region, y=toxic)) + geom_boxplot(outlier.size=NA)
ggplot(states, aes(x=region, y=toxic)) + geom_boxplot(outlier.size=1, outlier.colour = "red", outlier.shape = 4)
  
  

# colors, fills 
ggplot(states, aes(x=region, y=toxic)) + geom_boxplot()

ggplot(states, aes(x=region, y=toxic)) + geom_boxplot(fill="lightsalmon", color="firebrick")

ggplot(states, aes(x=region, y=toxic, fill=region, color=region)) + 
  geom_boxplot()

ggplot(states, aes(x=region, y=toxic, fill=region, color=region)) + 
  geom_boxplot() +
  scale_color_manual(values=c("orange","orangered2","orangered3","orangered4"))+
  scale_fill_manual(values=c("lavenderblush","mistyrose1","mistyrose2","mistyrose3"))

# alpha
ggplot(states, aes(x=region, y=toxic, fill=region, color=region)) + 
  geom_boxplot(alpha=.3, outlier.size=1) +
  scale_color_manual(values=c("orange","orangered2","orangered3","orangered4"))+
  scale_fill_manual(values=c("lavenderblush","mistyrose1","mistyrose2","mistyrose3")) +
  theme_classic() +
  theme(legend.position='none')


#overlaying data points
ggplot(states, aes(x=region, y=toxic, fill=region, color=region)) + 
  geom_boxplot(alpha=.1, outlier.size=1) +
  scale_color_manual(values=c("orange","orangered2","orangered3","orangered4"))+
  scale_fill_manual(values=c("lavenderblush","mistyrose1","mistyrose2","mistyrose3")) +
  theme_classic() +
  theme(legend.position='none') +
  geom_point()



## Comparing two variables:

head(states)
states$income_grp <- ifelse(states$income>median(states$income), 'high', 'low')
states$pop_grp <- ifelse(states$pop>median(states$pop,na.rm=T), 'high', 'low')
table(states$income_grp, states$pop_grp)


ggplot(states, aes(x=pop_grp, y=toxic)) + geom_boxplot(alpha=.1, outlier.size=1) 

ggplot(states, aes(x=pop_grp, y=toxic, fill=income_grp)) + geom_boxplot(alpha=.1, outlier.size=1) 





### Dotplots and beeswarms  (sometimes called stripplots)

ggplot(states, aes(x=region, y=toxic, fill=region, color=region)) + 
  scale_color_manual(values=c("orange","orangered2","orangered3","orangered4"))+
  scale_fill_manual(values=c("lavenderblush","mistyrose1","mistyrose2","mistyrose3")) +
  theme_classic() +
  theme(legend.position='none') +
  geom_point()


p <- ggplot(states, aes(x=region, y=toxic, fill=region, color=region)) + 
  scale_color_manual(values=c("orange","orangered2","orangered3","orangered4"))+
  scale_fill_manual(values=c("lavenderblush","mistyrose1","mistyrose2","mistyrose3")) +
  theme_classic() +
  theme(legend.position='none') 

p

p + geom_point()

p + geom_dotplot(binaxis = "y", stackdir = "center", binwidth = 2)

# altogether
ggplot(states, aes(x=region, y=toxic, fill=region, color=region)) + 
  scale_color_manual(values=c("orange","orangered2","orangered3","orangered4"))+
  scale_fill_manual(values=c("lavenderblush","mistyrose1","mistyrose2","mistyrose3")) +
  theme_classic() +
  theme(legend.position='none') + 
  geom_dotplot(binaxis = "y", stackdir = "center", binwidth = 2)


library(ggbeeswarm) ## if you have many, many datapoints-  this might be better
p +  geom_beeswarm()
p +  geom_beeswarm(cex = 1.1, priority = 'density')







### Statistical Summary Plots:

# These are some built-in quick ways of viewing stat summaries
# We will do some customized versions in another tutorial


# superimpose summary stat e.g. median.
p + geom_point() +  
  stat_summary(fun.y = median, geom = "point", size = 11, color='black', pch="-")


# or you might just want to plot the mean and ranges
p + stat_summary(fun.y = mean, fun.ymin = min, fun.ymax = max, color = "red")


#Mean and Standard Deviation
library(Hmisc)
p + stat_summary(fun.data=mean_sdl, fun.args = list(mult=1), 
                 geom="crossbar", width=0.5)

#Mean and Standard Deviation
p + stat_summary(fun.data=mean_sdl, fun.args = list(mult=1), 
                 geom="pointrange", color="red")




## An alternative way using geom_crossbar:

# first you need another summary datfame of what you want to plot:
library(tidyverse)
states_summary <- states %>% group_by(region) %>% summarise(med = median(toxic, na.rm=T))
states_summary

p + geom_point() + 
  geom_crossbar(data=states_summary, aes(x=region, group=region, y=med, ymin=med, ymax=med), width=0.5)



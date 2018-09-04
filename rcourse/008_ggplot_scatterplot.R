
### ggplot - scatterplots

library(tidyverse)
library(ggplot2)

#### Example 1. ----

# HDI = human development index
# CPI = corrputions perception index

econ <- read.csv("EconomistData.csv")

head(econ)
dim(econ)
table(econ$Region)

plot(econ$CPI, econ$HDI) #base-r way of doing things - good to get a quick overview.

# It is possible to customize base-r plots and make very nice looking plots.... It's just not worth it, when ggplot exists:


## you would not normally build a graph step by step like this
## I'm just going through for illustrative purposes

ggplot(econ) #just plots a canvas but knows we are using the 'econ' dataset

ggplot(econ, aes(x=CPI, y=HDI))  # add axes for X and Y

ggplot(econ, aes(x=CPI, y=HDI)) + geom_point() # add dots

ggplot(econ, aes(x=CPI, y=HDI)) + geom_point(shape = 21) #shape the dots

ggplot(econ, aes(x=CPI, y=HDI)) + geom_point(shape = 21, colour = "navy", fill = "dodgerblue") #add colors

ggplot(econ, aes(x=CPI, y=HDI)) + geom_point(size=2) #resize

ggplot(econ, aes(x=CPI, y=HDI)) + geom_point(size=2, 
                                             shape = 21, colour = "navy", fill = "dodgerblue",
                                             alpha=.5) #add transparency



ggplot(econ, aes(x=CPI, y=HDI, color=Region)) + geom_point(size=1) #color by Region

ggplot(econ, aes(x=CPI, y=HDI, color=Region)) + geom_point(size=1) + stat_smooth() # add a trendline

ggplot(econ, aes(x=CPI, y=HDI, color=Region, fill=Region)) + geom_point(size=1) + stat_smooth()

ggplot(econ, aes(x=CPI, y=HDI, color=Region, fill=Region)) + geom_point(size=1) + stat_smooth(alpha=.1)

ggplot(econ, aes(x=CPI, y=HDI, color=Region)) + geom_point(size=1) + stat_smooth(se=F)

ggplot(econ, aes(x=CPI, y=HDI, color=Region)) + geom_point(size=1) + stat_smooth(se=F, method="lm")


## adding linear trendlines
ggplot(econ, aes(x=CPI, y=HDI)) + geom_point(size=1) + stat_smooth(se=F, method="lm")

ggplot(econ, aes(x=CPI, y=HDI, group=Region)) + geom_point(size=1) + stat_smooth(se=F, method="lm")

# facet_wrap() will make a panel of plots
ggplot(econ, aes(x=CPI, y=HDI, group=Region)) + 
  geom_point(size=1) + 
  stat_smooth(se=F, method="lm") + 
  facet_wrap(~Region)

# we can control the scales
ggplot(econ, aes(x=CPI, y=HDI, group=Region)) + 
  geom_point(size=1) + stat_smooth(se=F, method="lm") + facet_wrap(~Region, scales = "free_x")

ggplot(econ, aes(x=CPI, y=HDI, group=Region)) + 
  geom_point(size=1) + stat_smooth(se=F, method="lm") + facet_wrap(~Region, scales = "free_y")

ggplot(econ, aes(x=CPI, y=HDI, group=Region)) + 
  geom_point(size=1) + stat_smooth(se=F, method="lm") + facet_wrap(~Region, scales = "free")

ggplot(econ, aes(x=CPI, y=HDI, group=Region, color=Region)) + 
  geom_point(size=2) + stat_smooth(se=F, method="lm") + facet_wrap(~Region, scales = "free")

ggplot(econ, aes(x=CPI, y=HDI, group=Region, color=Region)) + 
  geom_point(size=2) + stat_smooth(se=F, method="lm") + facet_wrap(~Region)



ggplot(econ, aes(x=CPI, y=HDI, group=Region, color=Region)) + 
  geom_point(size=2) + 
  stat_smooth(se=F, method="lm") + 
  facet_wrap(~Region) +
  scale_color_manual(values=c("red", "blue", "green", "firebrick", "orange", "dodgerblue")) 
#number of colors must be equal to number of groups




# colors - an aside.

### http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
### Many types of built in color scales exist in R. see: https://www.stat.ubc.ca/~jenny/STAT545A/block14_colors.html
### viridis package for excellent color scales: https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html






#### Example 2 ----


states <- read.csv("states.csv")

head(states)
dim(states)

ggplot(states)

ggplot(states, aes(income, college))

ggplot(states, aes(income, college)) + geom_point()

ggplot(states, aes(income, college, color=region)) + geom_point()  #NA ???

table(states$region)
states[is.na(states$region),]



#set limit of axes and decide which values to show/exclude

range(states$income)
range(states$college)

ggplot(states, aes(income, college, color=region)) + geom_point() + xlim(20000,50000)

ggplot(states, aes(income, college, color=region)) + geom_point() + xlim(20000,50000) + ylim(10,35)

ggplot(states, aes(income, college, color=region)) + geom_point() + scale_x_continuous(limits=c(20000,50000))

ggplot(states, aes(income, college, color=region)) + geom_point() + scale_x_continuous(limits=c(20000,50000), breaks=c(20000,50000))




# Axes, Titles, subtitles, annotations

p <- ggplot(states, aes(income, college, color=region)) + geom_point()

p

p + xlab("Mean Income ($)") + ylab("% with College Degree")

p <- p + xlab("Mean Income ($)") + ylab("% with College Degree")



p + ggtitle("Mean Income versus % with College Degree")

p + ggtitle("You can also write \n  on the next line")

p + ggtitle("This is the main title", subtitle="and this is a sub-title")


  
# Annotate text manually:
states[is.na(states$region),]  # Remember DC ???   - college=33.3,  income=35807

p + annotate("text", x=37500, y=32.5, label="DC") 



## all of this together would have looked like this:

ggplot(states, aes(income, college, color=region)) + 
  geom_point(size=2) + 
  xlab("Mean Income ($)") + 
  ylab("% with College Degree") + 
  ggtitle("State Mean Income vs. College Graduation Rates", subtitle="An example ggplot2 chart") + 
  annotate("text", x=37500, y=32.5, label="DC") +
  theme_bw()







## Other ways of labeling points:

ggplot(states, aes(income, college, color=region)) + geom_point()

ggplot(states, aes(income, college, color=region, label=state)) + geom_text()


library(ggrepel)
ggplot(states, aes(income, college, color=region, label=state)) + geom_text_repel()

ggplot(states, aes(income, college, color=region, label=state)) + geom_text_repel() + geom_point()

# this is not pretty - but you may have a use:  
ggplot(states, aes(income, college, color=region, label=state)) + 
  geom_point() +
  geom_label_repel(
    fontface = 'bold', color = 'black',
    box.padding = unit(0.35, "lines"),
    point.padding = unit(0.5, "lines")
  ) 

  
# just label some points:  e.g. only college over 25%
subset(states, college > 25)  

ggplot(states, aes(income, college, color=region, label=state)) + 
  geom_point(size=2) + 
  geom_text_repel(data = subset(states, college > 25)) 

  
  




### exporting your chart:

# You could save or copy from the Plot Window and export to your illustrator/paint package.

# Better to export like this:

p1 <- ggplot(states, aes(income, college, color=region, label=state)) + geom_text_repel() + geom_point()


ggsave("myplot.png", p1, width=8, height=6)  #play with width / height to work out what works best for your plot


## another example:

myplot <- ggplot(econ, aes(x=CPI, y=HDI, group=Region, color=Region)) + 
           geom_point(size=2) + 
           stat_smooth(se=F, method="lm") + 
           facet_wrap(~Region) +
           scale_color_manual(values=c("red", "blue", "green", "firebrick", "orange", "dodgerblue")) 

ggsave("bestplot.png", myplot, width=8, height=8) 
#play with width / height to work out what works best for your plot





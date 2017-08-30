
### ggplot - scatterplots

library(ggplot2)

#### Example 1. ----

# HDI = human development index
# CPI = corrputions perception index

econ <- read.csv("datasets/EconomistData.csv")

head(econ)
dim(econ)
table(econ$Region)

plot(econ$CPI, econ$HDI) #base-r way of doing things - good to get a quick overview.

# It is possible to customize base-r plots and make very nice looking plots.... It's just not worth it, when ggplot exists:

ggplot()


ggplot(econ)

ggplot(econ, aes(x=CPI, y=HDI))

ggplot(econ, aes(x=CPI, y=HDI)) + geom_point()

ggplot(econ, aes(x=CPI, y=HDI)) + geom_point(shape = 21)

ggplot(econ, aes(x=CPI, y=HDI)) + geom_point(shape = 21, color = "navy", fill = "dodgerblue")

ggplot(econ, aes(x=CPI, y=HDI)) + geom_point(size=2)

ggplot(econ, aes(x=CPI, y=HDI, color=Region)) + geom_point(size=1)

ggplot(econ, aes(x=CPI, y=HDI, color=Region)) + geom_point(size=1) + stat_smooth()

ggplot(econ, aes(x=CPI, y=HDI, color=Region, fill=Region)) + geom_point(size=1) + stat_smooth()

ggplot(econ, aes(x=CPI, y=HDI, color=Region, fill=Region)) + geom_point(size=1) + stat_smooth(alpha=.1)

ggplot(econ, aes(x=CPI, y=HDI, color=Region)) + geom_point(size=1) + stat_smooth(se=F)

ggplot(econ, aes(x=CPI, y=HDI, color=Region)) + geom_point(size=1) + stat_smooth(se=F, method="lm")

ggplot(econ, aes(x=CPI, y=HDI)) + 
  geom_point(size=1) + 
  stat_smooth(se=F, method="lm")


ggplot(econ, aes(x=CPI, y=HDI, color=Region)) + 
  geom_point(size=1) + 
  stat_smooth(se=F, method="lm", fullrange = T)

ggplot(econ, aes(x=log(CPI), y=HDI, color=Region)) + 
  geom_point(size=1) 




ggplot(econ, aes(x=CPI, y=HDI, group=Region)) + geom_point(size=1) + stat_smooth(se=F, method="lm")

ggplot(econ, aes(x=CPI, y=HDI, group=Region)) + geom_point(size=1) + stat_smooth(se=F, method="lm") + facet_wrap(~Region)

ggplot(econ, aes(x=CPI, y=HDI, group=Region)) + geom_point(size=1) + stat_smooth(se=F, method="lm") + facet_wrap(~Region, scales = "free_x")

ggplot(econ, aes(x=CPI, y=HDI, group=Region)) + geom_point(size=1) + stat_smooth(se=F, method="lm") + facet_wrap(~Region, scales = "free_y")

ggplot(econ, aes(x=CPI, y=HDI, group=Region)) + geom_point(size=1) + stat_smooth(se=F, method="lm") + facet_wrap(~Region, scales = "free")

ggplot(econ, aes(x=CPI, y=HDI, group=Region, color=Region)) + 
  geom_point(size=2) + 
  stat_smooth(se=F, method="lm") + 
  facet_wrap(~Region, scales = "free")


ggplot(econ, aes(x=CPI, y=HDI, group=Region, color=Region)) + 
 geom_point(size=2) + 
  stat_smooth(se=F, method="lm") + 
  facet_wrap(~Region)



ggplot(econ, aes(x=CPI, y=HDI, group=Region, color=Region)) + 
  geom_point(size=2) + 
  stat_smooth(se=F, method="lm") + 
  facet_wrap(~Region) +
  scale_color_manual(values=c("red", "blue", "green", "firebrick", "orange", "dodgerblue"))  #number of colors must be equal to number of groups

ggplot(econ, aes(x=CPI, y=HDI, group=Region, color=Region)) + 
  scale_color_manual(values=c("red", "blue", "green", "firebrick", "orange", "dodgerblue"))  #number of colors must be equal to number of groups\
  geom_point(size=2) + 
  stat_smooth(se=F, method="lm") 
  


# colors - an aside.

### http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
### Many types of built in color scales exist in R. see: https://www.stat.ubc.ca/~jenny/STAT545A/block14_colors.html
### viridis package for excellent color scales: https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html









#### Example 2 ----


states <- read.csv("datasets/states.csv")

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

ggplot(states, aes(income, college, color=region)) + 
  geom_point() + 
  xlim(20000,50000)

ggplot(states, aes(income, college, color=region)) +
  geom_point() + 
  xlim(20000,50000) + 
  ylim(10,35)

ggplot(states, aes(income, college, color=region)) + 
  geom_point() + 
  scale_x_continuous(limits=c(20000,50000))


ggplot(states, aes(income, college, color=region)) + 
  geom_point() + 
  scale_x_continuous(limits=c(20000,50000), 
                     labels=c("20k", "30k", "40k", "50k"))


ggplot(states, aes(income, college, color=region)) + 
  geom_point() + 
  scale_x_continuous(limits=c(20000,50000), breaks=c(20000,50000))




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



## Other ways of labeling points:

ggplot(states, aes(income, college, color=region)) + geom_point()

ggplot(states, aes(income, college, color=region, label=state)) + geom_text()


library(ggrepel)
ggplot(states, aes(income, college, color=region, label=state)) + 
  geom_text_repel()

ggplot(states, aes(income, college, color=region, label=state)) + 
  geom_text_repel() + geom_point()

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


# even higher quality images are possible (advanced tutorial)



### Things to Consider - we will do in future tutorial:

#' - themes: how to customize other aspects of chart
#' - legend: how to customize place and color/style of legend.




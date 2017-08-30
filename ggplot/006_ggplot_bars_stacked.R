
### Stacked Bar Graphs  

library(ggplot2)
library(tidyverse)

# see ggplot_means for introduction to simple bar charts.

crime <- read.csv("datasets/nyccrime.csv")
head(crime)
tail(crime)




# When bar length or height already exists in data (i.e. we have counts pre-processed), use stat = 'identity'

ggplot(crime, aes(x=year, y=murder, fill=borough))
  
ggplot(crime, aes(x=year, y=murder, fill=borough))  + geom_bar(stat='identity')  

## reorder levels.
crime$borough <- factor(crime$borough, levels=c("Staten Island", "Manhattan", "Queens", "The Bronx", "Brooklyn"))

ggplot(crime, aes(x=year, y=murder, fill=borough))  + geom_bar(stat='identity')



# this could be done more programatically:
# this might be useful if you're ordering many levels and do not want to write out by hand:
crime %>% filter(year==2010) %>% arrange(murder) %>% .$borough -> mylevels
mylevels
crime$borough <- factor(crime$borough, levels=mylevels)




# Make a bit more attractive:

p <- ggplot(crime, aes(x=year, y=murder, fill=borough))  + geom_bar(stat='identity', width = .7, colour="black", lwd=0.1)

p

p + coord_flip()

p + coord_flip() + scale_x_reverse()

p






## add labels  [ this requires a bit more than basic R knowledge ]

p + geom_text(aes(label=murder))  #oops

# we need to position the labels on the y axis at the cumulative position - not the raw data position
# we need another value for this.

crime <- crime %>% group_by(year) %>% arrange(borough) %>% mutate(cum_murder = cumsum(murder))
p + geom_text(data=crime, aes(label=murder, y=cum_murder)) #oops again


crime <- crime %>% group_by(year) %>% arrange(-as.numeric(borough)) %>% mutate(cum_murder = cumsum(murder))
p + geom_text(data=crime, aes(label=murder, y=cum_murder)) #oops again

  
#this one works
crime <- crime %>% group_by(year) %>% arrange(-as.numeric(borough)) %>% mutate(cum_murder = cumsum(murder) - 0.5*murder)
p + geom_text(data=crime, aes(label=murder, y=cum_murder))


#I still don't like it, I want to only show labels if value greater than 10.
p + geom_text(data=crime, aes(label=ifelse(murder>10,murder,""), y=cum_murder))





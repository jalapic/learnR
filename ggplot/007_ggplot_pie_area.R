### Area Charts,  Pie Charts, Waffle Charts


library(ggplot2)
library(tidyverse)

# see ggplot_means for introduction to simple bar charts.

crime <- read.csv("datasets/nyccrime.csv")
head(crime)
tail(crime)


ggplot(crime, aes(x=year, y=murder, fill=borough))
ggplot(crime, aes(x=year, y=murder, fill=borough)) +  geom_area() 

ggplot(crime, aes(x=year, y=murder, fill=borough)) +  geom_area()  + scale_fill_brewer(palette="Blues")

#let's order what gets plotted in what order:
crime %>% filter(year==2010) %>% arrange(murder) %>% .$borough -> mylevels
mylevels
crime$borough <- factor(crime$borough, levels=mylevels)


ggplot(crime, aes(x=year, y=murder, fill=borough)) +  geom_area()  

ggplot(crime, aes(x=year, y=murder, fill=borough)) +  geom_area()  + scale_fill_brewer(palette="Blues")


## Rather than plot numbers - plot percentages:

ggplot(crime, aes(x=year, y=murder, fill=borough)) +  geom_area(position="fill")  + scale_fill_brewer(palette="Blues")







#### Pie Charts ----

crime2014 <- subset(crime, year==2014)
crime2014

ggplot(crime2014, aes(x="", y=murder, fill=borough))+ geom_bar(width = 1, stat = "identity")

pie <- ggplot(crime2014, aes(x="", y=murder, fill=borough))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0)
pie


p <- pie 

p


## make borders.

ggplot(crime2014, aes(x="", y=murder, fill=borough)) + 
  geom_bar(width = 1, stat = "identity", color="black", lwd=1) + 
  coord_polar("y", start=0) + 
  scale_fill_brewer(palette="Blues") + 
  theme_void()



## add labels

# Easiest Way:
ggplot(crime2014, aes(x="", y=murder, fill=borough)) + 
  geom_bar(width = 1, stat = "identity", color="black", lwd=1) + 
  geom_text(aes(label = murder), position = position_stack(vjust = 0.5)) +
  coord_polar("y", start=0) +
  scale_fill_brewer(palette="Blues") + 
  theme_void() 



## Facet our Pie Charts

crime

ggplot(crime, aes(x="", y=murder, fill=borough)) + 
  geom_bar(width = 1, stat = "identity", color="black", lwd=1) + 
  geom_text(aes(label = murder), position = position_stack(vjust = 0.5)) +
  coord_polar("y", start=0) +
  scale_fill_brewer(palette="Blues") + 
  theme_void() +
  facet_grid(year ~ ., scales = "free")





### Some Extra Pie-Chart Stuff:

## 1. More control on facets:

# this is what happens if you don't set scales='free'
ggplot(crime, aes(x="", y=murder, fill=borough)) + 
  geom_bar(width = 1, stat = "identity", color="black", lwd=1) + 
  geom_text(aes(label = murder), position = position_stack(vjust = 0.5)) +
  coord_polar("y", start=0) +
  scale_fill_brewer(palette="Blues") + 
  theme_void() +
  facet_grid(year ~ .)


# but we can't have that....
# let's work out the percentage ourselves.
crime <- crime %>% group_by(year) %>% mutate(murder_pct = murder/sum(murder))

ggplot(crime, aes(x="", y=murder_pct, fill=borough)) + 
  geom_bar(width = 1, stat = "identity", color="black", lwd=1) + 
  geom_text(aes(label = murder), position = position_stack(vjust = 0.5)) +
  coord_polar("y", start=0) +
  scale_fill_brewer(palette="Blues") + 
  theme_void() +
  facet_grid(year ~ .)

# we can now use facet_wrap safely:
ggplot(crime, aes(x="", y=murder_pct, fill=borough)) + 
  geom_bar(width = 1, stat = "identity", color="black", lwd=1) + 
  geom_text(aes(label = murder), position = position_stack(vjust = 0.5)) +
  coord_polar("y", start=0) +
  scale_fill_brewer(palette="Blues") + 
  theme_void() +
  facet_wrap(~year)






### 2. More fine control over labels:


# I know this is a bit annoying:
crime2014$pos  <- crime2014$murder / 2 + c(0, cumsum(crime2014$murder)[-length(crime2014$murder)])
crime2014

ggplot(crime2014, aes(x="", y=murder, fill=borough)) + 
  geom_bar(width = 1, stat = "identity", color="black", lwd=1) + 
  geom_text(aes(x=1, y = pos, label=murder)) +
  coord_polar("y", start=0) +
  scale_fill_brewer(palette="Blues") + 
  theme_void() 

geom_text(aes(label = Cnt), position = position_stack(vjust = 0.5)) +
  


ggplot(crime2014, aes(x="", y=murder, fill=borough)) + 
  geom_bar(width = 1, stat = "identity", color="black", lwd=1) + 
  geom_text(aes(x=1, y = pos, label=murder)) +
  coord_polar("y", start=0) +
  scale_fill_brewer(palette="Blues") + 
  theme_void() 


## Adjust position of label
ggplot(crime2014, aes(x="", y=murder, fill=borough)) + 
  geom_bar(width = 1, stat = "identity", color="black", lwd=1) + 
  geom_text(aes(x=1.25, y = pos, label=murder)) +
  coord_polar("y", start=0) +
  scale_fill_brewer(palette="Blues") + 
  theme_void() 


## labels on outside
ggplot(crime2014, aes(x="", y=murder, fill=borough)) + 
  geom_bar(width = 1, stat = "identity", color="black", lwd=1) + 
  geom_text(aes(x=1.65, y = pos, label=murder)) +
  coord_polar("y", start=0) +
  scale_fill_brewer(palette="Blues") + 
  theme_void() 





### Other types of circular chart are available, e.g. donut, radar, etc. but shouldn't be used either.



#### Waffle Charts ----

# see advanced tutorial



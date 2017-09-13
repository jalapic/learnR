### Slope Charts

# Excellent way of showing change over time with line graphs

library(tidyverse)
library(babynames)  # for the example data

# Let's look at 10 Most Popular Girls Names in 2010 and see where they are in 2014 (last year of data)
head(babynames)
tail(babynames)

# get top 10 from 2010
babynames %>%
  filter(sex=="F" & year==2010) %>%
  arrange(-n) %>%
  head(10) %>%
  mutate(rank = row_number() ) %>%
  select(name,rank,year) -> y2010

y2010

# get ranks of all females from 2014 and only keep if name was in top10 from 2010
babynames %>%
  filter(year==2014 & sex=="F") %>%
  arrange(-n) %>%
  mutate(rank = row_number() ) %>%
  filter(name %in% y2010$name) %>%
  select(name,rank,year) -> y2014

y2014


df <- rbind(y2010,y2014)


#plot
library(ggjoy) #only using this for theme_joy()

ggplot(df, aes(x=as.character(year), y=rank, group=name,color=name)) + 
  geom_line(lwd=1) +
  geom_point(size=4) +
  scale_y_reverse(breaks=c(1:18)) +
  scale_x_discrete(expand = c(0.01, 0.1))+
  theme_joy()+
  ylab("Rank") +
  xlab("Year")


df$rank1 <-  ifelse(df$year==2014, df$rank, NA)

library(ggrepel)
ggplot(df, aes(x=as.character(year), y=rank, group=name) ) + 
  geom_line(lwd=1) +
  geom_point(size=4) +
  scale_y_reverse(breaks=c(1:18)) +
  theme_joy()+
  ylab("Rank") +
  xlab("") +
  geom_text_repel(
    data = subset(df, year == 2014),
    aes(label = name),
    size = 5,
    nudge_x = 50,
    segment.color = NA
    
  )



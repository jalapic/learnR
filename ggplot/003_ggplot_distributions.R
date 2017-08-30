
library(tidyverse)

  


## Data
library(babynames)
head(babynames)
tail(babynames)

girls <- subset(babynames, sex=="F")
girls

boys <- subset(babynames, sex=="M")
boys

since1950 <- subset(babynames, year>=1950)
since1950


## Number of unique names per year.

ggplot(boys)

ggplot(boys, aes(x=year))

ggplot(boys, aes(x=year)) + geom_bar()

ggplot(girls, aes(x=year)) + geom_bar()

ggplot(babynames, aes(x=year)) + geom_bar() + facet_wrap(~sex)

ggplot(babynames, aes(x=year)) + geom_bar(width=.7) + facet_wrap(~sex)



#girls boys on same chart
ggplot(since1950, aes(x=year, fill=sex)) + geom_bar()

ggplot(since1950, aes(x=year, fill=sex)) + geom_bar(position='dodge')


## If counts are pre-known use stat= identity

patricia <- babynames %>% filter(name=="Patricia")

patricia

patricia %>% arrange(-n)

ggplot(patricia, aes(x=year, y=n)) + geom_bar(stat='identity')

ggplot(patricia, aes(x=year, y=n)) + geom_bar(stat='identity', color='black', lwd=.5, fill='gray33',width=.9)






### Histograms ----

library(Lahman)

head(Batting)

Batting_sum <- Batting %>% 
  group_by(playerID) %>% 
  summarise(totalH = sum(H),
            totalAB = sum(AB),
            avg = totalH/totalAB
  )

Batting_sum <- Batting_sum %>% filter(totalAB>200)


hist(Batting_sum$avg) #quick look using base-r


ggplot(Batting_sum, aes(x=avg)) + geom_histogram()

ggplot(Batting_sum, aes(x=avg)) + geom_histogram(color='darkgreen',fill='lightgreen')

ggplot(Batting_sum, aes(x=avg)) + geom_histogram(bins = 150,color='darkgreen',fill='lightgreen')

ggplot(Batting_sum, aes(x=avg)) + geom_histogram(binwidth = .005, color='darkgreen',fill='lightgreen')

ggplot(Batting_sum, aes(x=avg)) + geom_density()

ggplot(Batting_sum, aes(x=avg)) + geom_density(fill='mistyrose')

# default for histogram is count, but can make it density like this
ggplot(Batting_sum, aes(x=avg)) + geom_histogram(aes(y=..density..),color='darkgreen',fill='lightgreen')
  

## Add a line
ggplot(Batting_sum, aes(x=avg)) + 
  geom_histogram(bins = 150,color='darkgreen',fill='lightgreen') +
  geom_vline(aes(xintercept=0.3), color="black", linetype="dashed", size=1)
  



### Side by side Histograms----

# e.g. players prior to 1920 vs players after 1990

Batting_early <- Batting %>%
  filter(yearID<=1920) %>%
  group_by(playerID) %>% 
  summarise(totalH = sum(H),
            totalAB = sum(AB),
            avg = totalH/totalAB
  ) %>%
  mutate(period='early')


Batting_late <- Batting %>%
  filter(yearID>=1990) %>%
  group_by(playerID) %>% 
  summarise(totalH = sum(H),
            totalAB = sum(AB),
            avg = totalH/totalAB
  ) %>%
  mutate(period='late')


Batting_early
Batting_late

Batting_all <- rbind(Batting_early, Batting_late)

Batting_all <- Batting_all %>% filter(totalAB>100)


# Overlaid histograms
ggplot(Batting_all, aes(x=avg, fill=period)) +  geom_histogram(position="identity")

ggplot(Batting_all, aes(x=avg, fill=period)) +  geom_histogram(position="identity", alpha=.7, binwidth=.005)

ggplot(Batting_all, aes(x=avg, fill=period)) +  geom_histogram(position="identity", alpha=.7, binwidth=.005) + facet_wrap(~period)

ggplot(Batting_all, aes(x=avg, fill=period)) +  geom_density(alpha=.7, binwidth=.005) 

# Interleaved histograms
ggplot(Batting_all, aes(x=avg, fill=period)) +  geom_histogram(position="dodge")


  
  
  


### Extra:   Back to Back histograms  (see advanced tutorial)

# e.g. popularity of unisex names like Skylar over decades
# e.g. population pyramids

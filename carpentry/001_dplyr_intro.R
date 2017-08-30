### Basic Data Manipulation with Dplyr

library(tidyverse) #contains library(dplyr)

# makes creating, selecting, renaming, variables easy
# makes summarizing data easy.

# group_by
# mutate
# select
# summarise
# filter
# arrange
# n()
# row_number()


weather <- read.csv("datasets/lgaweather.csv")

str(weather)
head(weather)
dim(weather)

## What is the average max temperature by month across years ?

weather %>%
  summarise(mean_temp = mean(Max_TemperatureF))

weather %>%
  group_by(Year) %>%
  summarise(mean_temp = mean(Max_TemperatureF))

weather_by_year <- weather %>%
  group_by(Year) %>%
  summarise(mean_temp = mean(Max_TemperatureF)) 

weather_by_year 

as.data.frame(weather_by_year)

write.csv(weather_by_year, "weatherbyyear.csv", row.names=F)

head(weather)

weather %>%
  group_by(Year, Month) %>%
  summarise(mean_temp = mean(Max_TemperatureF))

# what if you also wanted the standard deviation?
weather %>%
  group_by(Year, Month) %>%
  summarise(mean_temp = mean(Max_TemperatureF), sd_temp = sd(Max_TemperatureF))

# other common functions for descriptive statistics:
# min, max, median, sum, quantile, var, range
# standard error is not default in base-r....  the following function makes it....
sem <- function(x) sd(x,na.rm=T)/sqrt(length(x))



# what if you only cared about July?
weather %>%
  filter(Month==7)

weather %>%
  filter(Month==7) %>%
  group_by(Year) %>%
  summarise(mean_temp = mean(Max_TemperatureF), sd_temp = sd(Max_TemperatureF))

july_weather <- weather %>%
  filter(Month==7) %>%
  group_by(Year) %>%
  summarise(mean_temp = mean(Max_TemperatureF), sd_temp = sd(Max_TemperatureF))

july_weather

#I'll explain what's going on with this code later
ggplot(july_weather, aes(x=Year, y=mean_temp)) + geom_line()





#### Different Dataset

library(Lahman)
dim(Batting)
head(Batting)

# what is the change in mean batting average by year?

Batting %>% 
  mutate(avg = H / AB)

Batting %>% 
  mutate(avg = H / AB) %>%
  select(playerID, yearID, teamID, lgID, AB, H, avg)


Batting %>% 
  mutate(avg = H / AB) %>%
  select(playerID, yearID, teamID, lgID, AB, H, avg) %>%
  head


#let's only keep if have over 50 hits in year
Batting %>% 
  mutate(avg = H / AB) %>%
  select(playerID, yearID, teamID, lgID, AB, H, avg) %>%
  filter(AB>50) %>%
  head

Batting %>% 
  mutate(avg = H / AB) %>%
  select(playerID, yearID, teamID, lgID, AB, H, avg) %>%
  filter(AB>50) %>%
  group_by(yearID) %>%
  summarise(mean_avg = mean(avg), sd = sd(avg), median = median(avg))

batting.avg <- Batting %>% 
  mutate(avg = H / AB) %>%
  select(playerID, yearID, teamID, lgID, AB, H, avg) %>%
  filter(AB>50) %>%
  group_by(yearID) %>%
  summarise(mean_avg = mean(avg), sd = sd(avg), median = median(avg))

batting.avg

ggplot(batting.avg, aes(x=yearID, y=mean_avg)) + geom_line()


## what if we wanted to compare NL vs AL leagues?

table(Batting$lgID)  # check what leagues we have - we need to filter to keep only NL vs AL

#  |  this means OR      ==  means 'is equal to'

batting.avg <- Batting %>% 
  filter(lgID=="NL" | lgID=="AL") %>%
  mutate(avg = H / AB) %>%
  select(playerID, yearID, teamID, lgID, AB, H, avg) %>%
  filter(AB>50) %>%
  group_by(yearID, lgID) %>%
  summarise(mean_avg = mean(avg), sd = sd(avg), median = median(avg))

ggplot(batting.avg, aes(x=yearID, y=mean_avg, color=lgID)) + geom_line()




## Number of players per year   - n() counts total per group

Batting %>% 
  group_by(yearID) %>%
  summarise(total = n())

Batting %>% 
  group_by(yearID, lgID) %>%
  summarise(total = n())

table(Batting$yearID, Batting$lgID) # another way of quickly visualizing this




### Sorting:

Batting %>% arrange(H)   # sorts numbers ascending
 
Batting %>% arrange(-H)   # the - sign makes it go descending

Batting %>% group_by(yearID) %>% arrange(-H)   # within each year arrange

Batting %>% group_by(yearID) %>% arrange(-H) %>% filter(row_number()==1)   # only keep top one per year

Batting %>% group_by(yearID) %>% filter(H==max(H))   # if more than one player have same max hits - then both kept



### Who had most home runs in career?

Batting %>% group_by(playerID) %>% summarise(total_hits = sum(HR)) %>% arrange(-total_hits)





#### Some Extensions We Could Try:




### Summarise over multiple columns at once:
head(Batting)

# get means of at-bats, hits, runs by year.
Batting %>%
  group_by(yearID) %>%
  summarise_each(funs(mean=mean(., na.rm=TRUE)), AB, H, HR)


Batting %>%
  group_by(yearID) %>%
  summarise_each(funs(mean=mean(., na.rm=TRUE)), 6:16) 







###  What if wanted to plot BB and SB per 100 at bats on same graph? - only include if >100 at bats

Batting %>%
  filter(AB>100) %>%
  group_by(yearID) %>%
  mutate(SBper100 = 100*(SB/AB), BBper100 = 100*(BB/AB)) %>%
  summarise_each(funs(mean=mean(., na.rm=TRUE)), SBper100, BBper100) 

per100 <-Batting %>%
  filter(AB>100) %>%
  group_by(yearID) %>%
  mutate(SBper100 = 100*(SB/AB), BBper100 = 100*(BB/AB)) %>%
  summarise_each(funs(mean=mean(., na.rm=TRUE)), SBper100, BBper100) 


# need to make long form of dataframe using "gather"
per100_long <- per100 %>% gather(key,value,2:3) 

ggplot(per100_long, aes(x=yearID, y=value, color=key)) + geom_line()

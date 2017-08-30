## Very Brief guide to tidyr.


# Another common issue in data analysis is to convert a "wide" dataframe to a "long" one.

# e.g. this measles dataset.


library(tidyverse)

measles <-read.csv("datasets/measles.csv")

head(measles)
tail(measles,100)


# to plot the data we need "long" data - we need the value we wish to plot in one column.

# we need a dataframe that has:
# - "measles rate" in one column (these values are in cells right now)
# -  year and week as columns
# -  a column that has 'state'.

#   gather()  can make a wide dataframe a 'long' dataframe

ncol(measles)

measles.long <- measles %>% gather(state,measles_rate,3:53)
head(measles.long)


## some analysis:

measles.long.summary <- measles.long %>% 
  group_by(YEAR,state) %>%
  summarise(measles_rate_avg = mean(measles_rate, na.rm=T))

head(measles.long.summary)



## some plotting:

library(viridis) #has the fill scale I like
ggplot(measles.long.summary, aes(x=YEAR, y=state, fill=measles_rate_avg)) +
  geom_tile() +
  scale_fill_viridis(direction=-1,option="B",na.value = "white") +
  theme_minimal()

# What year was vaccine introduced?
ggplot(measles.long.summary, aes(x=YEAR, y=state, fill=measles_rate_avg)) +
  geom_tile() +
  scale_fill_viridis(direction=-1,option="B",na.value = "white") +
  theme_minimal() +
  geom_vline(xintercept = 1963, color='black', lty=2,lwd=1)

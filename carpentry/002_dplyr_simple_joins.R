### dplyr joins basics

library(tidyverse)

## A common issue in data analysis is when you have two or more files that you
## need to join together in some way. 

# this might be two dataframes of same length where you simply join

# this might be unequal lengths of two dataframes

# you may want to join based on one column, or multiple columns.




### Example 1.   - 'full_join' - join all columns of x to all columns of y.

# simplest case:  Both datframes have one column each with all cases/names we wish to join on.


#  new york state data

# columns you're joining on don't have to be in same order
# columns you're joining on have to have name in common.

plumbum <- read.csv("datasets/nyc_children_lead.csv")
population <- read.csv("datasets/new_york_population.csv")

head(plumbum)
head(population)

tail(plumbum)
tail(population)

dim(plumbum)
dim(population)

population %>% full_join(plumbum) #Error: No common variables. Please specify `by` param.

colnames(plumbum)
colnames(plumbum)[1]<-"county"
colnames(plumbum)

population %>% full_join(plumbum)
full_join(population,plumbum)  # you can also write it like this











### Example 2 - 

#  i. full_join can work on multiple columns that uniquely identify rows.
#  ii. full_join will give NA if cannot join (i.e. no value exists in one of datasets), but will try.


# Some bird data

birds_pct <- read.csv("datasets/birds_pct.csv")
birds_group <- read.csv("datasets/birds_group.csv") 

# two columns match (name / state) - 
# e.g. House Finch is in Arizona & New Mexico, House Sparrow is in all 3 states

birds_pct
birds_group

full_join(birds_pct, birds_group)  # warning message is ok..

# we have 12 unique bird-state combinations - 
# and the full_join() fills all available information together from both dataframes.
# NA is given if it cannot fill.







### Several other types of join exist.....   
# e.g. what if we had multiple matches to join on in the 2nd dataframe to the 1st dataframe.





### Example 3 -  'left_join()'

# return all rows from x and all columns from x and y.
# if 2nd datafame (y) has more than one match - will return all of them

teams <- data.frame(
  team = c("New York Yankees", "Chicago Cubs", "New York Mets"),
  league = c("AL", "NL", "NL")
)

players <- data.frame(
  player = c("Derek Jeter", "Mariano Rivera", "Don Mattingly",
             "Ernie Banks", "Jake Arietta",
             "Mike Piazza", "Keith Hernandez", "Dwight Gooden"),
  team = c("New York Yankees", "New York Yankees", "New York Yankees", 
           "Chicago Cubs", "Chicago Cubs",
           "New York Mets","New York Mets","New York Mets")
)

teams
players

teams %>% left_join(players)
players %>% left_join(teams)




### REFERENCES for more join types:

# http://stat545.com/bit001_dplyr-cheatsheet.html

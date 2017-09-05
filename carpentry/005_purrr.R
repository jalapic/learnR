### A very gentle introduction to "purrr"



# What is a list ?

l <- list("a", "b", "c")
l 

list(
  data.frame(name="a", number = 1),
  data.frame(name="b", number = 2),
  data.frame(name=c("c","d"), number = c(3,4))
   )
  




# Data from "https://www.massshootingtracker.org/data"

mst2013  <- read.csv("datasets/MST2013.csv")
mst2014  <- read.csv("datasets/MST2014.csv")
mst2015  <- read.csv("datasets/MST2015.csv")
mst2016  <- read.csv("datasets/MST2016.csv")
mst2017  <- read.csv("datasets/MST2017.csv")

mst <- list(mst2013, mst2014, mst2015, mst2016, mst2017)

library(purrr)
library(readr)

# Faster way:  dir() %>% map(read_csv)


# Look at list.

mst

mst[[4]]
colnames(mst[[4]])

mst %>% map(colnames)


mst %>% map(~ sum(.$killed))  # count total killed per year.






### Something a bit more advanced.


library(lubridate)  #helps deal with date formats

mdy(mst[[4]]$date) # date format for 2016

mst %>% map(~ mdy(.$date))  #dates in new format for all years

mst <- mst %>% map(~ mutate(., newdate = mdy(date)) ) #add a column called newdate to all dfs

mst <- mst %>% map(~ select(., c(killed,city,state,newdate)))

mst <- mst %>% map(~ mutate(., month = month(newdate)))

mst.month <- mst %>% map(~ group_by(., month)) %>% map(~ summarise(., total = sum(killed)))

mst.month <- Map(cbind, mst.month, year = 2013:2017)

mst.all <- do.call('rbind', mst.month)
mst.all <- mst.all[-57,]

ggplot(mst.all, aes(x=month, y=total, color=factor(year))) + geom_line()

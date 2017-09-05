### tidyr II

# Intro ----


# gather()
# spread()
# unite()
# separate()

# Examples from Data Science with R - Gromelund & Wickham - http://garrettgman.github.io/tidying/


# Install dataset package
devtools::install_github("garrettgman/DSR")

# Load package
library(DSR)

# Load tidyr
library(tidyr) # only load tidyr package
library(tidyverse) # loads all tidyverse packages


# Look at different ways of representing similar data
# Each table includes four variables country, year, population, and cases...

table1 # tidy !!!

table2

table3

table4

table5



# table 1 is tidy - which makes it easy to do things like calculate rates...

table1$rate <- table1$cases / table1$population * 10000
table1



## quick recap of gather() ----

table4

#remember the last argument dictates which columns to 'gather':

gather(table4, "year", "population", 2:3)      # 2 to 3

gather(table4, "year", "population", c(2, 3))  # 2 and 3

gather(table4, "year", "population", -1)       # not 1






## spread() - spreads a  column into wide format and adds in appropariate values ----

table2 #use this as an example

# spread() adds a new column for each unique value of the "key" column. 
# spread(., key, value)  

# inside spread() - arguments are:
# 1. dataframe/table (optional)
# 2. key - the column to make new columns for each unique value
# 3. value - the column to get values from to populate new columns


spread(table2, type, count) # don't normally do it this way - but can

table2 %>% spread(type, count) # more commonly do it this way




#### A little aside on spread.....         ----

# ... also learn about set.seed() & "wakefield" package


# Some spread() extras..

library(wakefield)

set.seed(15)
people <- wakefield::name(10)
animals  <- wakefield::animal(10)

pets <- data.frame(name = sample(people,20, T), 
                   pet = sample(animals,20, T), 
                   count = sample(1:3,20, T)
                   )

pets

# step 1. make sure "duplicate" rows are summed  - e.g. Daniel/Moose Daniel/Speactacled Bear.

library(dplyr)

pets %>% group_by(name,pet) %>% summarize(count=sum(count)) -> pets

pets

# say you wanted to list all pets in columns and count in cells  for each person.
# you know if a pet-person pair isn't listed in the table that the value is 0
# can use 'fill'

# "fill"

pets %>% spread(pet, count)

pets %>% spread(pet, count, fill = 0)

#notice that column headers with 2 words have `` around them - best not to have 2 words as col header...



# but what about those other pets that could have been included in data? 
# They don't have columns as nobody had them.

pets$pet     # notice  it says '10 levels' - we have 6 columns 

levels(pets$pet)  # - where are black rhino, hummingbird, silver dollar, welsh corgi?


pets %>% spread(pet, count, fill = 0, drop = T )  # this is default

pets %>% spread(pet, count, fill = 0, drop = F )  # puts them in




## separate()  ----

#  separate() turns a single character column into multiple columns 
#   splitting the values of the column wherever a separator character appears.

table3
separate(table3, rate, into = c("cases", "population"))

table3 %>% separate(rate, into = c("cases", "population"))

table3 %>% separate(rate, into = c("cases", "population"), remove=F) #keeps original column

t3 <- table3 %>% separate(rate, into = c("cases", "population"))

str(t3) #notice default is to make new columns characters

t3 <- table3 %>% separate(rate, into = c("cases", "population"), convert=T)

str(t3) #by using convert=T, we prevent this behavior.



## separating on specific characters....


# from the 'help'  argument sep  ...  sep = "[^[:alnum:]]+"  ... this means anything but letter/number

# you can tell it exactly what to split on ...

df1 <- data.frame(col1 = c("james.curley", "marie-louise.leblanc", "martin.o'neill"))

df1 %>% separate(col1, into = c("first", "last"))  # nope

df1 %>% separate(col1, into = c("first", "last"), sep=".")  # nope

df1 %>% separate(col1, into = c("first", "last"), sep="\\.")  #that's better






## unite()   ----

# unite() does the opposite of separate() - it combines multiple columns into a single column.

table5

unite(table5, "new", century, year, sep = "")

table5 %>% unite("new", century, year, sep = "")

table5 %>% unite("new", century, year, sep = "", remove=F)




#### Tuberculosis Example.----

# Explore Dataset

dim(who)
View(who)

head(who)
tail(who)

str(who)

# "who" provides a realistic example of tabular data in the wild. 
#  It contains redundant columns, odd variable codes, and many missing values. 
#  In short, who is messy.


# cols 1-3 are country names and country codes
# col 4 are years

# cols 5-60 contain various info:


#' The first three letters of each column denote whether the column contains new or old cases of TB. 
#' In this data set, each column contains new cases.
#' 
#' 
#' The next two letters describe the type of case being counted. 
#' 
#' rel stands for cases of relapse
#' ep stands for cases of extrapulmonary TB
#' sn stands for cases of pulmonary TB that could not be diagnosed by a pulmonary smear (smear negative)
#' sp stands for cases of pulmonary TB that could be diagnosed be a pulmonary smear (smear positive)
#' 
#' 
#' The sixth letter describes the sex of TB patients. The data set groups cases by males (m) and females (f).
#' 
#' The remaining numbers describe the age group of TB patients. 
#' The data set groups cases into seven age groups:
#' 
#' 014 stands for patients that are 0 to 14 years old
#' 1524 stands for patients that are 15 to 24 years old
#' 2534 stands for patients that are 25 to 34 years old
#' 3544 stands for patients that are 35 to 44 years old
#' 4554 stands for patients that are 45 to 54 years old
#' 5564 stands for patients that are 55 to 64 years old
#' 65 stands for patients that are 65 years old or older


# e.g. "new_sn_f5564" = new pulmonary TB (smear negative) in females aged 55-64.


## CLEAN UP

## put all values in columns 5 to 60 into one column with number of cases in.
## the other new column should be what the value refers to..

who %>% gather("code", "value", 5:60)

who %>% gather("code", "value", 5:60) -> who

head(who)
tail(who)
nrow(who) # 405440


## work on the codes - we'll want to split by the underscores.

unique(who$code) # what do you notice ?



who$code <- gsub("newrel", "new_rel", who$code)

unique(who$code) # better

who %>% separate(code, c("new", "var", "sexage")) -> who

head(who)
tail(who)
nrow(who) # 405440


## work on the sexage column:  - with separate you can also separate by position with a number:

who %>% separate(sexage, c("sex", "age"), sep = 1)

who %>% separate(sexage, c("sex", "age"), sep = 1) -> who

head(who)
tail(who)


## some plotting:

hist(who$value)
max(who$value,na.rm=T)

who %>% arrange(-value) #outbreaks


ggplot(who, aes(x=age, y=value, color=sex)) + facet_wrap(~var) + geom_point() #not that informative.

range(who$year)  # to look at range of years


#  Let's look at China & India sp cases by year

# all together
who %>% 
  filter(country=="China" | country=="India") %>%
  filter(var=="sp") %>%
  group_by(year, country,sex) %>%
  summarize(total = sum(value)) %>%
  ggplot(aes(x=year, y=total, color=country))+
  geom_point() +
  geom_line() +
  facet_wrap(~sex)


# break it up
who %>% 
  filter(country=="China" | country=="India") %>%
  filter(var=="sp") %>%
  group_by(year, country,sex) %>%
  summarize(total = sum(value)) -> indiachina

  ggplot(indiachina, aes(x=year, y=total, color=country))+
  geom_point() +
  geom_line() +
  facet_wrap(~sex)



  
## Spreading :

head(who)
tail(who)

  
# We could move the rel, ep, sn, and sp keys into their own column names with spread().

who %>% spread(var, value)



### Exercise 1. Intro to dplyr.


# Install 'babynames' package from CRAN (using Packages tab in RStudio)

# Load the 'babynames' library and look at the first 6 rows of the dataset 'babynames'

# this dataset shows how many births of every name/gender there were per year since 1880.

library(babynames)
head(babynames)

# you should see this:

# # A tibble: 6 x 5
# year sex name n prop
# <dbl> <chr> <chr> <int> <dbl>
# 1 1880 F Mary 7065 0.0724
# 2 1880 F Anna 2604 0.0267
# 3 1880 F Emma 2003 0.0205
# 4 1880 F Elizabeth 1939 0.0199
# 5 1880 F Minnie 1746 0.0179
# 6 1880 F Margaret 1578 0.0162


# Load the tidyverse library
library(tidyverse)


# 1. Use 'filter' to subset the 'babynames' dataframe to only keep females called "Mary".
# assign this dataframe to be called "mary".
# 2. Run the following code - if step 1 was done correctly, you should get a graph:


mary <- babynames %>% filter(name == "Mary")

mary <- babynames %>% filter(name == "Mary") %>% filter(sex=="F")
mary <- babynames %>% filter(name == "Mary", sex=="F")
mary <- babynames %>% filter(name == "Mary" & sex=="F")
mary <- filter(babynames, name == "Mary" & sex=="F")

mary

ggplot(mary, aes(x=year, y=n)) + geom_line()



# 3. Sort the 'n' column using 'arrange' by size in descending order.
# Which are the top 5 years of Mary's popularity?

mary %>% arrange(-n)
mary %>% arrange(desc(n))

# 4. Using the 'babynames' dataframe, use 'filter' to only keep male names, call this dataset 'males'.

males <- babynames %>% filter(sex=="M")


# 5. Using the 'males' dataset, use 'group_by', 'summarize', and 'sum' to calculate the total number of births since 1880 for each name. You can call the new column summarizing the total births as 'totalbirths'. Call this new dataframe 'totals'.

# 6. Using the 'totals' dataframe, use 'arrange' to descend the 'totalbirths' column in descending order. What are the most popular five boys names ever ?



males %>% summarize(totalbirths = sum(n))
males %>% group_by(name) %>% summarize(totalbirths = sum(n))

males %>% group_by(name) %>% tally(n)
males %>% group_by(name) %>% tally(n, sort=TRUE)

males %>% group_by(name) %>% summarize(totalbirths = sum(n)) %>% arrange(-totalbirths)

males %>% group_by(name) %>% summarize(totalbirths = sum(n)) %>% arrange(-totalbirths) %>% head(5)

males %>% group_by(name) %>% summarize(totalbirths = sum(n)) %>% arrange(-totalbirths) %>% top_n(5)

totals <- males %>% group_by(name) %>% summarize(totalbirths = sum(n)) %>% arrange(-totalbirths)


# if your totals dataframe is correct, you should be able to use the following code to find the most popular boys names ever beginning with a Q.
totals %>% filter(grepl("Q", name)) %>% arrange(-totalbirths)
totals %>% filter(grepl("jj", name)) %>% arrange(-totalbirths)



### Slightly harder questions....

# 7. Can you determine the most popular boys name for every year since 1880?
# which boys name has been most popular for the most years ? How many years?
# hint: use '%>% top_n(1)' to select the first row of every group in a grouped dataframe
# second hint: email me for help if you need it!

babynames %>% filter(sex=="M") %>% group_by(year) %>% arrange(-n) %>%
  top_n(1)

babynames %>% filter(sex=="M") %>% group_by(year) %>% 
  filter(n == max(n))
  
babynames %>% filter(sex=="M") %>% group_by(year) %>% 
  filter(n == max(n)) %>% group_by(name) %>% summarize(total = n() )

babynames %>% filter(sex=="M") %>% group_by(year) %>% 
  filter(n == max(n)) %>% group_by(name) %>% count()

babynames %>% filter(sex=="M") %>% group_by(year) %>% 
  filter(n == max(n)) %>% group_by(name) %>% count(name)

babynames %>% filter(sex=="M") %>% group_by(year) %>% 
  filter(n == max(n)) %>% group_by(name) %>% count(sort=T)


# 8. Run the following code. It will create a new dataframe with the total Male and total Female births of all time for each name. Try to work out how I did it, but don't worry if you dont' get it just yet.

totalMF <- babynames %>% group_by(name) %>% summarize(totalM = sum(n[sex=="M"]), totalF = sum(n[sex=="F"]))
totalMF

# Using this dataframe, create a new column using 'mutate' that is the total births (sum of totalM and totalF). Call this column 'totalbirths'. Also create a column that is the ratio of totalM births to all births (totalbirths). Call this column "Mratio". Call the new dataframe 'ratioMF'.

totalMF %>% 
  mutate(totalbirths = totalM + totalF, 
                   Mratio = totalM/totalbirths) %>%
  filter(totalbirths>=10000, Mratio>.4, Mratio<.6) %>%
  arrange(-totalbirths)

# Use filter to keep all names that have a Mratio between 0.4 and 0.6 and at least 10000 children were born with that name.
# which name has the most births ever with an Mratio between 0.4 and 0.6

# not necessarily unrelated - here is a graph of interest to the above (just run this code).
# you could alter it to run any name you'd like...

babynames %>% filter(name=="Casey") %>% ggplot(aes(x=year, y=n, color=sex)) + 
  geom_line() + scale_color_manual(values=c("black", "red")) + theme_light()


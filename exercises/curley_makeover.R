### Makeover Challenge Exercise Example
# James Curley

# Data Source
# Data source: ONS (Table 1 & Table 3)
# http://www.makeovermonday.co.uk/data/


## Link to original article:  http://www.bbc.co.uk/news/health-39785742



## Steps:


# Downloaded data as "Alcohol Consumption in Britain.xlsx"

# Changed filename to "alcoholuk.xlsx"

# load tidyverse
library(tidyverse)

# Import Data
df <- read_xlsx("datasets/alcoholuk.xlsx")  # this function comes from readxl package - part of the tidyverse


head(df) #always good to check

colnames(df) <- c("year", "age_range", "gender", "question", "prop") 

head(df) #always good to check

# Learn a bit more about the dataset
table(df$year, df$age_range)
table(df$gender, df$question) #note gender as "Men", "Women", "All persons"

# separate data into 'all persons' and 'men/women'
allpersons <- df %>% filter(gender=="All persons")
df1 <- df %>% filter(gender!="All persons")

head(df1) #always good to check


# Exploratory plots to get to know the data
ggplot(df1, aes(x = year, y = prop, color=gender)) + geom_line() + facet_grid(~question*age_range) + theme_bw()


# First thoughts?
#' men drink more than women.
#' the data include an age category of "16+" which includes all individuals
#' data includes teetotal which is reciprocal of two other drinking categories
#' broadly a decline in drinking behavior over time, except perhaps in 65+ category.
#' far fewer individuals drank on five days in a week than on one day.
#' fewer individuals drank on five days in a week than were teetotal
#' young people appear to drink less than older people
#' 


## What to focus on ?  - and which variables to plot as lines/colors/annotations/facets ?

#'  want to show decline in drinking
#'  perhaps but all age ranges on same chart? 
#'  split by gender? 
#'  separate plots for 5 days drinking vs 1 day drinking ?
#'  

# split data by drinking level, and remove 16+ age range.

df2 <- df1 %>% filter(age_range!="All 16+" & question=="Drank alcohol on five on more days in the last week")
df3 <- df1 %>% filter(age_range!="All 16+" & question=="Drank alcohol in the last week")

head(df2)

ggplot(df2, aes(x=year, y=prop, group=age_range)) + facet_wrap(~gender) + geom_line()


# what's best way to identify lines ?  color or annotation ?

#color
ggplot(df2, aes(x=year, y=prop, color=age_range)) + facet_wrap(~gender) + geom_line() # of course, we could choose better colors

#annotation - this is one way - there are others, e.g. using cowplot
library(ggrepel)
df2 <- df2 %>% mutate(label = if_else(year == max(year), as.character(age_range), NA_character_))
  
ggplot(df2, aes(x=year, y=prop, group=age_range)) + 
  facet_wrap(~gender) + 
  geom_line() +
  geom_text_repel(aes(label = label),
                 nudge_x = 1,
                 na.rm = TRUE)

#both  - you could play around with 'nudge' to line up the annotation where you want it
ggplot(df2, aes(x=year, y=prop, color=age_range)) + 
  facet_wrap(~gender) + 
  geom_line() +
  geom_text_repel(aes(label = label),
                   nudge_x = 1,
                   na.rm = TRUE)

# manually change colors, add minimal theme and thicken line
p <- ggplot(df2, aes(x=year, y=prop, color=age_range)) + 
  facet_wrap(~gender) + 
  geom_line(lwd=1) +
  geom_text_repel(aes(label = label),
                  nudge_x = 1,
                  na.rm = TRUE) +
  scale_color_manual(values=c("darkred", "red", "darkorange", "goldenrod3")) +
  theme_minimal() 

p # I like warm colors for plots. The 'gradient' goes from young to old here.


# add axis labels, title and subtitle
p <- p + 
  xlab("Year") + 
  ylab("Proportion") +
  ggtitle("Proportion of Brits drinking alcohol 5 days in a week",
          subtitle = "Data from ONS") +
  theme(plot.subtitle=element_text(face="italic", color="gray22"))

p

# Remove figure legend - we don't need it as we labeled the lines.

p <- p + theme(legend.position = "none")

p



# Increase font size of "Men" and "Women" ?
p <- p + theme(strip.text.x = element_text(size = 12))
p



## Do same for drinking once in a week.

df3 <- df3 %>% mutate(label = if_else(year == max(year), as.character(age_range), NA_character_))

p1 <- ggplot(df3, aes(x=year, y=prop, color=age_range)) + 
  facet_wrap(~gender) + 
  geom_line(lwd=1) +
  geom_text_repel(aes(label = label),
                  nudge_x = 1,
                  na.rm = TRUE) +
  scale_color_manual(values=c("darkred", "red", "darkorange", "goldenrod3")) +
  theme_minimal()  + 
  xlab("Year") + 
  ylab("Proportion") +
  ggtitle("Proportion of Brits drinking alcohol 1 day in a week",
          subtitle = "Data from ONS")+ 
  theme(legend.position = "none")+
  theme(strip.text.x = element_text(size = 12)) +
  theme(plot.subtitle=element_text(face="italic", color="gray22"))


p1


# Arrange plots using grid.extra

library(gridExtra)

grid.arrange(p1,p, nrow=2)


### Questions ?   

#' What do you like/dislike about this viz?
#' Is it informative?
#' Does it mislead in anyway?
#' Did we miss any key messages?
#' What information should be included/excluded?
#' What other ways could you visualize these data ?


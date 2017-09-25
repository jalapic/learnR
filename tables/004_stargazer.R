#### Stargazer


# Examples based on: https://www.jakeruss.com/cheatsheets/stargazer/



## But first run these functions so you can see the stargazer output in your viewer pane.
## it's best to run stargazer with RMarkdown, but here I just want to show you output as we go.
## this means that we're going to wrap "stargazer" functions with "viewtable" - sorry about that.

# you'll need to install 'rstudioapi' package:

viewtable <- function(X){
  tempDir <- tempfile()
  dir.create(tempDir)
  htmlFile <- file.path(tempDir, "output.html")
  writeLines(X, htmlFile)
  rstudioapi::viewer(htmlFile)
}

# this one is if you want to view table in web browser
viewtable1 <- function(X){
  writeLines(X, 'output.html')
  rstudioapi::viewer('output.html')
}


# packages we'll need
library(tidyverse)
library(nycflights13)
library(AER) # Applied Econometrics with R
library(stargazer)






# get data
head(flights)

daily <- flights %>%
  filter(origin == "EWR") %>%
  group_by(year, month, day) %>%
  summarise(delay = mean(dep_delay, na.rm = TRUE))

daily_weather <- weather %>%
  filter(origin == "EWR") %>%
  group_by(year, month, day) %>%
  summarise(temp   = mean(temp, na.rm = TRUE),
            wind   = mean(wind_speed, na.rm = TRUE),
            precip = sum(precip, na.rm = TRUE))

# Merge flights with weather data frames
both <- full_join(daily,daily_weather) %>% data.frame()

# Create an indicator for quarter
both$quarter <- cut(both$month, breaks = c(0, 3, 6, 9, 12), 
                    labels = c("1", "2", "3", "4"))

# Create a vector of class logical
both$hot <- as.logical(both$temp > 85)

head(both)


## distributions
hist(both$delay,breaks=20)
hist(both$temp,breaks=20)
hist(both$wind,breaks=20)
hist(both$precip,breaks=20)


# step 1.  Generate automatic summary table:

stargazer(both) #latex
stargazer(both, type="html") #html
stargazer(both, type="html") %>% viewtable()   # silly thing we're doing to see it in our viewer pane


# When supplied a data frame, by default stargazer creates a table with summary statistics.
stargazer(both, type = "html", summary = FALSE, rownames = FALSE) %>% viewtable()  #if summary=F, prints dataframe


# Specify what stats to see
stargazer(both, type = "html", nobs = FALSE, mean.sd = TRUE, median = TRUE, iqr = TRUE) %>% viewtable()


# or this way
stargazer(both, type = "html", summary.stat = c("n", "p75", "sd")) %>% viewtable()


# prevent logicals showing up - i.e. TRUE/FALSE 0/1
stargazer(both, type = "html", summary.logical = FALSE) %>% viewtable()


# Flip the table axes
stargazer(both, type = "html", flip = TRUE) %>% viewtable()






#### Part 2. Regression Tables Output

# Basic linear models
output  <- lm(delay ~ temp + wind + precip, data = both)
output2 <- lm(delay ~ temp + wind + precip + quarter, data = both)

summary(output)
summary(output2)


stargazer(output, type = "html")
stargazer(output, type = "html") %>% viewtable()


stargazer(output, output2, type = "html")
stargazer(output, output2, type = "html") %>% viewtable()





## Various  academic journal styles
stargazer(output, output2, type = "html", style = "qje") %>% viewtable()
stargazer(output, output2, type = "html", style = "ajps") %>% viewtable()
stargazer(output, output2, type = "html", style = "ajps") %>% viewtable1()


# Add a title; change the variable labels

stargazer(output, output2, type = "html", 
          title            = "These are awesome results!",
          covariate.labels = c("Temperature", "Wind speed", "Rain (inches)",
                               "2nd quarter", "3rd quarter", "Fourth quarter"),
          dep.var.caption  = "A better caption",
          dep.var.labels   = "Flight delay (in minutes)")  %>% viewtable()


#column names
stargazer(output, output2, type = "html", column.labels = c("Model 1", "Model 2")) %>% viewtable()

# remove column names
stargazer(output, output2, type = "html", 
          dep.var.labels.include = FALSE,
          model.numbers          = FALSE) %>% viewtable()


# example of four columns in 2 larger cols
stargazer(output, output, output2, output2, type = "html", 
          column.labels   = c("Good", "Better"),
          column.separate = c(2, 2)) %>% viewtable()


#add rows to bottom
stargazer(output, output2, type = "html",
          add.lines = list(c("Fixed effects?", "No", "No"),
                           c("Results believable?", "Maybe", "Try again later"))) %>% viewtable()


# reporting other stats other than standard errors, e.g. t-staistics
stargazer(output, output2, type = "html",
          report = "vct*")  %>% viewtable()


#CIs
stargazer(output, output2, type = "html",
          ci = TRUE) %>% viewtable()


#Adjust CIs
stargazer(output, output2, type = "html",
          ci = TRUE, ci.level = 0.90, ci.separator = "; ")  %>% viewtable()



# put everything on one row
stargazer(output, output2, type = "html",
          single.row = TRUE) %>% viewtable()


# Remove statistics and notes sections completely
stargazer(output, output2, type = "html", 
          omit.table.layout = "sn") %>% viewtable()


# Include everything except the statistics and notes sections - another way
stargazer(output, output2, type = "html", 
          table.layout = "-ld#-t-") %>% viewtable()


#Omit the degrees of freedom
stargazer(output, output2, type = "html", 
          df = FALSE) %>% viewtable()

#Statistical significance options
stargazer(output, output2, type = "html", 
          star.char = c("@", "@@", "@@@"))  %>% viewtable()


#Change the cutoffs for significance
stargazer(output, output2, type = "html", 
          star.cutoffs = c(0.05, 0.01, 0.001))  %>% viewtable()

#Make an addition to the existing note section
stargazer(output, output2, type = "html", 
          notes = "I make this look good!") %>% viewtable()


# Table aesthetics - Use html tags to modify table elements

stargazer(output, output2, type = "html", 
          title = "These are <em> awesome </em> results!",  # Italics
          dep.var.caption  = "A <b> better </b> caption") %>%  # Bold
  viewtable()   



# Change decimal character
stargazer(output, output2, type = "html", 
          decimal.mark = ",") %>% viewtable()

# Control the number of decimal places
stargazer(output, output2, type = "html", 
          digits = 1)  %>% viewtable()



# Drop leading zeros from decimals
stargazer(output, output2, type = "html", 
          initial.zero = FALSE) %>% viewtable()

# Change the order of the variables
stargazer(output, output2, type = "html", 
          order = c(4, 5, 6, 3, 2, 1))  %>% viewtable()


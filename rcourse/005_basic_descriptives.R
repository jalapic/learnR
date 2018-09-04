### Descriptive Statistics

## There are several ways of getting descriptive statistics.
# I'll introduce you to some that may be useful for getting quick summaries


# Use the wheels.csv dataset
df<-read.csv("wheels.csv") # read in wheels.csv dataset


# the crudest way of getting a quick summary of an entire dataset 
# is to use the summary() function:

summary(df) #some summary stats



# Some ways from other packages

psych::describe(df)

pastecs::stat.desc(df)

# quick visualization snapshot
plot(df) #ugh
plot(df[,2:5])



## do it by group
by(df, INDICES = df$strain, summary)

by(df, INDICES = df$strain, psych::describe)
psych::describeBy(df, group="strain")


## Let's just focus on the swiss mice
swiss <- subset(df, strain=="Swiss")
swiss
swiss[,2:5]


## do it by row
apply(swiss[,2:5], 1, min) #1 indicates rows
apply(swiss[,2:5], 1, mean)

## do it by column
apply(swiss[,2:5], 2, min) #2 indicates columns
apply(swiss[,2:5], 2, mean) 





### Basic Statistics Data Summary functions
# we've already encountered some but...
# there are some traps...

range(df$day1)
min(df$day1)
max(df$day1)

mean(df$day1)
median(df$day1)
sd(df$day1)

mean(df$day4)
mean(df$day4, na.rm = T)
sd(df$day4)
sd(df$day4, na.rm = T)

quantile(df$day1, .25)
quantile(df$day1, .75)
IQR(df$day1)


# what about standard error?
length(df$day1) # we need to know the N to calculate the SEM
sd(df$day1) / sqrt(length(df$day1)) #SEM by hand

sem <- function(x){sd(x) / sqrt(length(x))} # a function to get SEM

sem(df$day1) #using the function

# please note  - if you have missing data use this one:
sem <- function(x){sd(x,na.rm=T) / sqrt(length(na.omit(x)))}






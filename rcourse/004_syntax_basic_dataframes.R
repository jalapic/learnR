#### Navigating Our Way around datasets ####



# Firstly, let's get rid of some stuff

rm(list = ls(all = TRUE))  # ugly code that you can literally just run - or use icon on RHS of RStudio




#### Let's start with dataframes ####

#set working directory if you haven't already done so
getwd() #check working directory location
setwd("folder_location")  #put your folder address here

df<-read.csv("wheels.csv") # read in wheels.csv dataset

df

head(df)
tail(df)

str(df)

ncol(df)
nrow(df)

dim(df)

length(df) #for dataframes same as ncol - i.e. how much across

colnames(df)

rownames(df) #not that relevant in this example as they don't have names just numbers 

dimnames(df) #both rows and cols together -  also useful for other objects too (talk about later)


#To look at data in individual columns/variables
df$id
df[,1]  #column/variable1 after column

df$day4
df[,5]  #column/variable5

#NA means missing data.


#to look at individual observations/rows - before comma
df[15,]  #row15
df[70,]  #row70

#to look at a specific row/col i.e. obs/variable (what you'd consider to be a cell in excel)
df[57,4]  #e.g. observation/row 57,  column 4 which is the day3 score



summary(df) #some summary stats

table(df$strain)
table(df$wheel)
table(df$wheel, df$strain)

View(df) #look at the data sheet - you can also double-click on name on RHS





#### To change column names ####

colnames(df)

#saving the original names as a new object
names_x<-colnames(df)
names_x

# you can change all of them together
colnames(df)<-c("idddddd", "dayyyy1", "dayyyy2", "dayyyy3", "dayyyy4", "dobbb", "mothhhher", "sexxx", "strainnn", "WHEEL", "START")
colnames(df)
head(df)

# you can change just one at a time
colnames(df)[6]
colnames(df)[6] <- "dob"
head(df)

# you can change several at once
colnames(df)[2:5] <-c("day1", "day2", "day3", "day4")
colnames(df)
head(df)

# you can change all this way too
names_x
colnames(df)<-names_x
head(df)




### Adding / Removing a column

df$totalruns <- df$day1 + df$day2 + df$day3 + df$day4
head(df)

df$totalruns <- NULL
head(df)



### Subsetting Data
table(df$strain)

subset(df, strain=="Swiss")





#### Summary

# basic operations on & navigating around dataframes
# there are other ways to do all of these things but it's important to know these basic ways




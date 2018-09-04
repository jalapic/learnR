
####  Importing and Exporting Data ----


## Getting Data into R - 1.----

# There are ways of doing so from text file, csv file, excel file, other stats packages files, 
# webpages (HTML), XML, RData objects, fitbit, google drive, open docs, almost everything....
# special consideration maybe needed if you have really, really large files.
# see refs


# Example - csv file in working directory called pga.csv"
pga <- read.csv("C:/Users/James Curley/Dropbox/dataviz course/data/pga.csv", stringsAsFactors=FALSE)
head(pga)
tail(pga)

pga <- read.csv("pga.csv", stringsAsFactors=FALSE) 
# this will overwrite previous pga - be careful naming objects in R....   
# ok to use ".", "_", don't start with numbers


## A faster (and some say better) way is to use the 'readr' package

library(tidyverse)
readr::read_csv("pga.csv") # note the underscore, note no "stringsAsFactors=FALSE"

pga <- readr::read_csv("pga.csv") # to save/assign dataset with name "pga"

# this can also be done using the "Import Datset" tab



# Some basic dataframe functions 
head(pga) # see top 6 rows
tail(pga) # see bottom 6 rows
dim(pga)  # get rows and columns sizes
nrow(pga) # how many rows in dataset
ncol(pga) # how many columns in dataset

names(pga) # names of variables
colnames(pga) # column names
rownames(pga) # row names

str(pga) # get the structure of the data


View(pga) # See whole dataset in new tab
          # As you get more used to RStudio, 
          # you will likely not use this as much (useful for beginners though) 
          #or just double click data in Global Environment

pga   # look at data in console (if used read_csv it will be a truncated neat output)



## Getting Data into R - 2. - From Text Files ----
read.delim("pets.txt", header=T)



## Getting Data into R - 3. - From Excel ----

# both of these can be performed using the RStudio Import Dataset Tab
readxl::read_xlsx("mydata.xlsx")
readxl::read_xls("mydata.xls")


## Getting Data into R - 4. - From Other Statistics Packages ----

library(haven)


# SAS
read_sas("mtcars.sas7bdat")

# SPSS
read_sav("mtcars.sav")

# Stata
read_dta("mtcars.dta")



## Getting Data into R - 5. - From websites ----

read.csv("https://gist.githubusercontent.com/jalapic/424f6b04a72539e6866044625a9f69e0/raw/ca60926f900324f6137467a09c7bdb7823104afa/lifeExp.csv")
readr::read_csv("https://gist.githubusercontent.com/jalapic/424f6b04a72539e6866044625a9f69e0/raw/ca60926f900324f6137467a09c7bdb7823104afa/lifeExp.csv")



## Getting Data into R - 4. - Typing it in ----

df <- data.frame(
  country = c("Brazil", "Germany", "Italy", "Argentina", "Uruguay",
              "France", "England", "Spain", "Netherlands", "Czech_",
              "Hungary", "Sweden"),
  wins = c(5,4,4,2,2,1,1,1,0,0,0,0),
  runnerups = c(2,4,2,3,0,1,0,0,3,2,2,1),
  confed = c("COMMEBOL", "UEFA", "UEFA", "COMMEBOL", "COMMEBOL", "UEFA",
             "UEFA", "UEFA", "UEFA", "UEFA", "UEFA", "UEFA")
)

df

df$finals <- df$wins + df$runnerups


colnames(df)
colnames(df)[3]<-"finalists"
colnames(df)
colnames(df)<-c("Country", "Wins", "Finalists", "Confederation", "Finals")
df







#### Exporting Data.


# the most common way will be to write a csv file of your data

write.csv(df, "mydata.csv", row.names = F) #row names prevents an extra column of indices being produced
getwd() # you can find where your working directory is - this is where the file will be saved

## for bigger files, or more complex data structures:

# you may also wish to store data as an RData object
saveRDS(df, file = "mydata.rds")

# these can be read like this:
readRDS(file = "mydata.rds")

## you can also export as other statistics package files using 'haven'
haven::write_sas(mtcars, "mtcars.sas7bdat")
haven::write_sav(mtcars, "mtcars.sav")
haven::write_dta(mtcars, "mtcars.dta")






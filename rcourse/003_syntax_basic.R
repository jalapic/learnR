
### Basic Syntax Introduction


## Objects  ----

# Objects are things like data (in any of its forms), functions, etc.

## Here we will learn about 'vectors' and 'dataframes' - the main two data types.



# <-    This thing is the 'assignment operator' - it tells us to store something on the RHS as the name on the LHS
# =     this also works (but don't use it just yet) - it is better to use    <-



# Vectors are one type of object -
mycolors <- c("blue", "red", "yellow")
mycolors #[1] "blue"   "red"    "yellow" 

mynums <- 1:100  # the colon means 'to' 
mynums #prints 1 to 100 in the console


x  <- c("just", "some", "things", 1, 2, 3, "james") #can combine numbers and characters - all will be characters
x #[1] "just"   "some"   "things" "1"      "2"      "3"      "james"




## Function examples- 

# we already used one function above 'c' means to 'concatenate'

print(mycolors)  #print to console  - [1] "blue"   "red"    "yellow"

sample(mycolors)  # R has built in functions - e.g. sample - pick colors without replacement, ... run it a few times


sample(mycolors, size=1)  # functions often have more than one 'argument' , this tells it to pick one

sample(mycolors, 1) #you often don't need to add the argument name - it works it out

sample(mycolors, 2, replace=T)  #another argument in sample is 'replace', here we sample WITH replacement - run a few times


str(mycolors)  # str is a very useful function - it will tell us what type of object we have. "chr" means 'character'
str(mynums)  #int means integers

length(mycolors)  #how many are in the vector?
length(mynums)

rep(mycolors,2) # rep is useful - it repeats the vector like this
rep(mycolors,each=2) # or like this






#### do something similar for shapes ----

shapes<-c("square", "oblong", "diamond", "triangle", "circle", "oval", "star")

myshapes <- sample(shapes,10,replace=T)




#### some things such as numbers and letters are made easy for us to type in.

LETTERS

letters

1:20

c(1:5, 15:20)



# let's pick 5 LETTERS at random
sample(LETTERS,5)

#and randomly get 10 of these chosen letters
myletters<-sample(LETTERS, 10, replace=T)
myletters



### Picking random numbers

runif(5)  #default is between 0 and 1

runif(5, min=0, max=100) 

numbers<-runif(5, min=0, max=100) 
numbers
round(numbers,digits=2) 
round(numbers,digits=1)  
round(numbers,digits=0) #round to nearest number

floor(numbers)  #round down
ceiling(numbers) #round up

#get 10 integers between 0 and 100

numbers <- runif(10, min=0, max=100)
mynumbers<-round(numbers, digits=0)
mynumbers


# We've now created three vectors:
myshapes
myletters
mynumbers

str(myshapes)
str(myletters)
str(mynumbers)



## Data-type 2  = data.frame .....  

data.frame(myshapes,myletters,mynumbers)

mydf <- data.frame(myshapes,myletters,mynumbers)

mydf

str(mydf)

head(mydf)


mydf$myshapes
mydf$myletters
mydf$mynumbers

str(myshapes)
str(mydf$myshapes)



### We could manually type things into a datafame like this:

df <- data.frame(
                 numbers = 1:5,
                 pet = c(T,F,T,F,F), 
                 animal = c("cat", "pig", "dog", "cow", "armadillo")
                 )


df





#### What if we want to add in a new variable/column into a pre-existing dataframe.......


df$sizes<- c("small", "big", "small", "big", "unsure")

df

df$age <- 10  #if only give one value, will make whole column this value

df

#can overwrite 
df$sizes <-c("small", "big", "medium", "big", "medium")
df

#get rid of a column
df$age <- NULL




### Summary:

# Data type 1 =  vector
# Data type 2 = data.frame
# Functions do things

# all above are 'objects'





### Primer for Writing Functions in R


### the basic structure of any function:

my_function_name <- function(){
  
}

# my_function_name  can be anything you want to call it - make it memorable.

# the () of the brackets is where you'll put "arguments" (sometimes called parameters)
# these are the inputs that your function will need

# within the curly brackets are where all the code goes.

# the function will output the very last thing that it produces



### Example 1.

addfive <- function(n){
  n + 5
}

addfive(n = 14)
addfive(4)  # there's only one argument, it will automatically recognize it



### Example 2 - more than one argument

get_fraction <- function(x, y){
  x / y
}

get_fraction(x=10, y=2)
get_fraction(9,2)  # you don't need to put x, y - it recognizes the order.
get_fraction(19,7)



### Example 3 - specifying what to return

get_fraction1 <- function(x, y){
  b <- x / y
  result <- round(b,2)
  return(result)  
}

get_fraction1(19,7)

# note you can write code on successive lines and it goes all the way to the end of the function.

### Please note ....  things that go on inside of functions ARE NOT saved to the namespace (global environment)
### BUT - if you use the same name as an object inside of the function as something that exists outside - it MIGHT interfere


## the above function could be written like this to be shorter:

get_fraction2 <- function(x, y){
  return(round( (x/y) ,2) )
}

get_fraction2(123,11)




### Example 4 - return more than one thing from a function

twothings <- function(x,y){
  a <- round( (x/y), 2)
  b <- round( x*y, 2)
}

twothings(12,7) # it doesn't know what to return



twothings <- function(x,y){
  a <- round( (x/y), 2)
  b <- round( x*y, 2)
  return(list(a,b))
}

twothings(12,7)



# you can name what you return:

twothings <- function(x,y){
  a <- round( (x/y), 2)
  b <- round( x*y, 2)
  return(list(division = a, multiplication = b))
}

twothings(12,7)







####  Functions are particularly useful when working with dataframes and doing repetitive tasks.


#### Example - from the babynames function we wish to get the births by year plot for any name. ----


name_plot <- function(myname){
library(babynames)
library(tidyverse)
  babynames %>% filter(name==myname)
}

name_plot("James")
name_plot("Hannah")


# what if you didn't supply a name ?
name_plot()


# you can add a default.
name_plot <- function(myname="Cosmo"){
  library(babynames)
  library(tidyverse)
  babynames %>% filter(name==myname)
}
name_plot()


# Add plot part
name_plot <- function(myname="Cosmo"){
  library(babynames)
  library(tidyverse)
  babynames %>% filter(name==myname) %>%
    ggplot(aes(x=year, y=n, color=sex))+
    geom_line()+
    scale_color_manual(values=c("firebrick","dodgerblue")) +
    theme_minimal()
  }

name_plot()
name_plot("Skylar")


## What if we wanted the option of plotting "n" or "prop"
head(babynames)

name_plot <- function(myname="Cosmo", yaxis = "n"){
  library(babynames)
  library(tidyverse)
  babynames %>% filter(name==myname) %>%
    ggplot(aes_string(x='year', y=yaxis, color='sex'))+
    geom_line()+
    scale_color_manual(values=c("firebrick","dodgerblue")) +
    theme_minimal()
  }
# note I'm using "aes_string" here to allow for manually changing column names.

name_plot("Skylar")
name_plot("Skylar", yaxis='prop')

name_plot("Taylor", yaxis='prop')



name_plot("Elizabeth", yaxis='n')    # this is the only name I can find with 3 'peaks'
name_plot("Elizabeth", yaxis='prop')




### Loading Functions

# 1. Run/execute function in script.  (as we just did above)

# 2. "source" from an external source (e.g. another script on your computer, in your project folder, or online)
   ### this is the 'neater' option - and easier to troubleshoot by grouping functions together.

source("R/plotting-fun.R")





### One slightly more advanced concept   - using an ellipsis to pass optional arguments to a lower level function (one that is inside your function code).


plot_reds <- function(x, y, ...) {
  plot(x, y, col="red", ...)
}

plot_reds(runif(100),runif(100))

plot_reds(runif(100),runif(100), xlab = "Random x numbers", ylab = "Random y numbers", main = "Snazzy title")  # these wouldn't work without the ellipsis ... in the original function.


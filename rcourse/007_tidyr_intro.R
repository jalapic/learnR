
### tidyr intro

# gather()  - convert data from wide to long formats
# spread()  - convert data from long to wide formats
# separate() - convert one variable into two
# unite() - convert two or more variables into one


# let's generate some data
# this is untidy data as we have multiple columns for observations
# this is commonly how many other stats packages may have their data formatted however
# and it is commonly seen in excel etc.

set.seed(17) 
# this is just setting the random number generator so all of our outputs will be the same
# we are going to generate some random number in columns, so this is why we set it.

# Here we are measuring anxiety levels before, during and after a therapy session

df <- data.frame(
  id = c("James", "Patrick", "Steve", "Margaret", "Eileen", "Sheila"), 
  gender = c("Male", "Male", "Male", "Female", "Female", "Female"),
  before = rnorm(n = 6, mean = 12, sd = 3.5), 
  during = rnorm(n = 6, mean = 7, sd = 3),
  after = rnorm(n = 6, mean = 10, sd = 4)
)

df

## Use gather() to convert from wide to long

df %>%  gather(time, anxiety, c(before, during, after)) # name columns
 
df %>% gather(time, anxiety, 3:5) # number columns


## Use spread() to convert from long to wide

df1 <- df %>% gather(time, anxiety, 3:5) # number columns

df1 %>% spread(time, anxiety)


## Use unite() to join variables together
# inside unite put: name of new variable, names of variables to join
df %>% gather(time, anxiety, 3:5) %>%
  unite(group, gender, time)

## Use separate() to separate joined variables 
df %>% gather(time, anxiety, 3:5) %>%
  unite(group, gender, time) %>%
  separate(col = group, into = c("gender", "timeperiod"), sep = "_")

# you can separate on a character, or a number to indicate how many places



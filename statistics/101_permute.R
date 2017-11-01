######  PERMUTATION / RANDOMIZATION TESTS  .... introduction   ######



###### there are lots of built in ways of permuting/randomizing data in R. 


## First one is combn()
## produces all combination of set of elements of a given size. - does not take order into account.

combn(c("purple", "pink", "green", "yellow", "orange", "white"), 4)

mycolors <- c("purple", "pink", "green", "yellow", "orange", "white")
mycolors
combn(mycolors, 3)

combn(letters[1:4],2)



## we probably remember sample()

sample(mycolors)                 # run it a few times
sample(mycolors,3)               # run it a few times
sample(mycolors,3, replace=T)    # run it a few times



## replicate() can be useful here too

replicate(10, sample(mycolors,3))   # see what it did ?




# there are lots of fun things in R to do with permutations/randomizations/sambling/combinations,
# we'll do more in later tutorials.....




#### Permuting/Randomizing Data  - Some introductory comments ####

# General principle:   Is the pattern in the data that we observe likely to have arisen by chance, or not?

# Essentially we will randomly shuffle our data (or e.g. the groups our data belong to) and examine how often
# our data lead to an observed parameter (mean, sum) of a group, 
# or how ofen our observed statistic (e.g. t-statistic, F-value) arises, compared to N shuffles of the data.

## Advantages:
# We do not have to worry about whether our data are normally distributed or groups have equal variances
# We are not assuming our data are sampled from some general population/distribution
# Very useful for skewed data, small sample sizes.

## Things to remember:
# data should still be independent of one another                                                                                                                                                                                                                                                                        
# One criticism of permutation/randomization tests is whether their results are generalizable to a theoretical general population
# The degree to which they are generalizable is dependent upon how 'at random' our sample was drawn from a general population

# a good reference: http://biol09.biol.umontreal.ca/PLcourses/Statistical_tests.pdf
                                                    




# It's best to learn their utility from some simple examples ...




#### Example 1.  - A complete permutation test  ####

x <- c(25.17, 20.57, 19.03)
y <- c(25.88, 25.20, 23.75, 26.99)

length(x)         # [1] 3
length(y)         # [1] 4
length(c(x,y))    # [1] 7

choose(7,3) # [1] 35, There are 35 ways of dividing the 7 observations into samples of size 3 and 4
choose(7,4) # [1] 35, it's the same.


sum(x) # [1] 64.77

combn(c(x,y),3)  #produces all 35 combinations of picking any 3 of our sample of 7

apply(combn(c(x,y),3),2,sum) #for all columns (denoted by the '2') apply the function sum

sort(apply(combn(c(x,y),3),2,sum)) #and sort them

2/35 # p is 2/35 or how much of the distribution are less than or equal to the observed 
     # [1] 0.05714286
     # Note that only in the case of no x-y overlap is a p-value below .05 possible here.







#### Example 2.  Comparing 2 groups - randomized permutation t-test ####


# e.g. comparing the reaction times of two groups

group1 <- c(36.30,  42.07,  39.97,  39.33,  33.76,  33.91,  39.65,  84.92,  40.70,  39.65,
39.48,  35.38,  75.07,  36.46,  38.73,  33.88,  34.39,  60.52,  53.63,  50.62)

group2 <- c(49.48,  43.30,  85.97,  46.92,  49.18,  79.30,  47.35,  46.52,  59.68,  42.89,
49.29,  68.69,  41.61,  46.81,  43.75,  46.55,  42.33,  71.48,  78.95,  42.06)

mydata <- data.frame(values=c(group1,group2), group=rep(c("group1", "group2"),each=20))

mydata

boxplot(values~group,mydata)
t.test(values~group,mydata)                        # t=-2.1496, p=0.03802

hist(mydata$values)
shapiro.test(mydata$values)                        # not normally distributed
bartlett.test(mydata$values, mydata$group)         # variances equal


mydata$group
sample(mydata$group)  # run this a few times to see what happens

split(mydata$values, sample(mydata$group))  # run this a few times to see what happens

#run the beneath 4 lines a few times
a <- split(mydata$values, sample(mydata$group))
a[[1]]
a[[2]]
t.test(a[[1]],a[[2]])

mytest <- t.test(a[[1]],a[[2]])
mytest
str(mytest)
mytest$statistic
mytest[[1]]

t.test(a[[1]],a[[2]])$statistic  #these look awful, but return the t-statistic effectively
t.test(a[[1]],a[[2]])[[1]]



## going to put above into a for loop.....

results <- vector("list",10000)  # this will store our results

# might take 1 minute.   Store all t-statistics generated from 10000 randomizations (each [i])

for(i in 1:10000){
  a <- split(mydata$values, sample(mydata$group))
  results[[i]] <- t.test(a[[1]],a[[2]])[[1]]
}

results # these results are stored as a list because we told it to

unlist(results) #unpack from the list
 
as.numeric(unlist(results)) #we don't need the t...

randomts <- as.numeric(unlist(results)) #we don't need the t...

hist(randomts)      # t values we would be likely to obtain when the null is true
abline(v= -2.1496)  #this was the t-statistic from our initial observed data

sum(randomts <= -2.1496)  #182 (yours may vary slightly as your randomizations won't be exactly the same)

sum(randomts <= -2.1496) / 10000   # our generated 'exact' p-value for one tailed # [1] 0.0182


abline(v= 2.1496) # what about the other end of the distribution ?
sum(randomts <= -2.1496)
sum(randomts >=  2.1496)

(sum(randomts <= -2.1496) + sum(randomts >=  2.1496))  #375 - number of instance of a t-statistic as

(sum(randomts <= -2.1496) + sum(randomts >=  2.1496))  / 10000    # [1] 0.0375



# another tip:   If your data contain many 'ties' as often is the case using scaled data,
# you might want to consider using something like the mean or sum of group 1 to compare to randomized data,
# rather than a continuous variable like the t-statistic.






#### Example 3.  Randomized One-Way ANOVA ####

# The basic idea is that if the null is true, the group labels are arbitrary
# you don't change the distributions by shuffling them.


# Say we've measured the amount of iron in rocks
# We have collected 10 samples from 3 different regions (a=Arizona, b=Bermuda, c=Colorado)

# We do a One-Way ANOVA and I get a difference between the 3 regions. 

# But was this chance?

# Perhaps we had non normality and/or heterogeneous variances between groups...
# and a non-parametric test suggests no differences...

# Options ?  - transform data?, do One-Way ANOVA with Welchs correction ?, Permutation test?


# Advantage of Permutations/Ranomizations:
# - you don't need to worry as much about normality/equal variances



# Example 3a

rocks <- read.csv("rocks.csv")

rocks

boxplot(value1 ~ ids1, rocks)

summary(aov(value1 ~ ids1, rocks))              # significant p=0.0467, F=3.441
kruskal.test(value1 ~ ids1, rocks)              # not signficiant
shapiro.test(rocks$value1)                      # not normal
bartlett.test(rocks$value1, rocks$ids1)         # non equal variances


## lets do a randomization test.
# we will randomize the order of the ids here.

rocks$value1
ironvalue <- rocks$value1
ironvalue

rocks$ids1
place <- rocks$ids1
place
table(place)

# a  b  c 
# 10 10 10 

sample(place) # run this a few times - it generates reordered versions of ids1.

summary(aov(ironvalue ~ place))              # same as before  -  p=0.0467, F=3.441

summary(aov(ironvalue ~ sample(place)))      # keep running, will be different

myoutput <- summary(aov(ironvalue ~ sample(place)))      
myoutput
str(myoutput)

summary(aov(ironvalue ~ sample(place)))[[1]][4]  #first thing in list, fourth index = F-value
summary(aov(ironvalue ~ sample(place)))[[1]][[4]]  #double bracket gets rid of some of the text
summary(aov(ironvalue ~ sample(place)))[[1]][[4]][1]  #this is the F-value !!!

#now let's get that F-value 10,000 times

replicate(10000, summary(aov(ironvalue ~ sample(place)))[[1]][[4]][1])   #this will take about 1-2 minutes

myp <- replicate(10000, summary(aov(ironvalue ~ sample(place)))[[1]][[4]][1])

hist(myp)
abline(v=3.441, col="red", lwd=2)

sum(myp>=3.441) #the proportion of myp 's F statistics that are >= the observed value of 3.441
# [1] 417

sum(myp>=3.441) /10000     # [1] 0.0417   - only 4.17% of samples had F values higher than our observed




#####  Example 3b

boxplot(value2 ~ ids2, rocks)

summary(aov(value2 ~ ids2, rocks))              # not significant   p=.0808, F=2.766
kruskal.test(value2 ~ ids2, rocks)              # not signficiant   p=.1554
shapiro.test(rocks$value2)                      # not normal
bartlett.test(rocks$value2, rocks$ids2)         # non equal variances

myp <- replicate(10000, summary(aov(rocks$value2 ~ sample(rocks$ids2)))[[1]][[4]][1])   #this will take about 1-2 minutes

hist(myp)
abline(v=2.766, col="red", lwd=2)
sum(myp>=2.766) /10000  #[1] 0.0558

#note: 10,000 randomizations are probably the minimum you'd want to do - could do e.g. up to 100,000




# Example 3c  - from bloodwork.csv

boxplot(immuncount ~ state, df)

summary(aov(immuncount ~ state, df))
pairwise.t.test(df$immuncount,df$state , p.adjust.method="holm")


summary(aov(immuncount ~ state, df))              # not significant   p=.0782, F=2.805
kruskal.test(immuncount ~ state, df)              # not signficiant   p=.1257
shapiro.test(df$immuncount)                       # not normal
bartlett.test(df$immuncount, df$state)            # variances are equal

myp <- replicate(10000, summary(aov(df$immuncount ~ sample(df$state)))[[1]][[4]][1])   #this will take about 1-2 minutes

hist(myp)
abline(v=2.805, col="red", lwd=2)
sum(myp>=2.805) /10000  #what do you think it will turn out to be ?



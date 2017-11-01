#### RANKING ####



#### Ranking with dplyr ####

df <- data.frame(name=c("A","B","C","D"), score=c(10,10,9,8))
df

library(dplyr)

df %>% mutate(rank = row_number(desc(score)))

df %>% mutate(rank = dense_rank(desc(score)))

df %>% mutate(rank = min_rank(desc(score)))

df %>% mutate(rank = percent_rank(desc(score)))

df %>% mutate(rank = cume_dist(desc(score)))


## ranking within groups in dplyr
scores<-c(5,6,7,8,9,10)
set.seed(1)
df <- data.frame(name = rep(LETTERS[1:3], each=4), score=sample(scores, 12, replace=T) )
df

df %>% group_by(name) %>% mutate(rank = row_number(desc(score)))

df %>% group_by(name) %>% mutate(rank = dense_rank(desc(score)))

df %>% group_by(name) %>% mutate(rank = min_rank(desc(score)))

df %>% group_by(name) %>% mutate(rank = percent_rank(desc(score)))

df %>% group_by(name) %>% mutate(rank = cume_dist(desc(score)))





#### Ranking in base r ####

set.seed(1)
x<-rnorm(15, 10, 2)
x
rank(x)
data.frame(value=x,rank1=rank(x))

temp <- data.frame(value=x,rank1=rank(x))
temp

temp$value2<-c(5, NA, 3, NA, 6, 9, 10, NA, 5, 7, 10, 1, 2, 8, 6)
temp

#different ranking methods & dealing with NAs

temp$rank2 <- rank(temp$value2)   #notice the NAs
temp
temp %>% arrange(value2)  #help you see 

temp$rank2avg <- rank(temp$value2, ties.method=c("average")) #default
temp$rank2first <- rank(temp$value2, ties.method=c("first"))
temp$rank2rand <- rank(temp$value2, ties.method=c("random"))
temp %>% arrange(value2)  #help you see 


x <- temp$value2
x
rank(x)

rank(x, na.last=T)   
rank(x, na.last=F)
rank(x, na.last=NA)
rank(x, na.last="keep")

# how make all NAs to be last?

length(x) #there are 15 elements
rank(x, na.last="keep")
z <- rank(x, na.last="keep")
z

z[is.na(z)] <- length(z) 
z




#### Ranking by group ####

set.seed(14)
mydf<-data.frame(colors=rep(c("green", "blue", "red"), each=7), value=round(rnorm(21,50,20),digits=1))
mydf

mydf$rank <- ave( mydf$value, mydf$colors, FUN=rank )
mydf

mydf$desc <- ave (-mydf$value, mydf$colors, FUN=rank)  #rank in the opposite direction by negating the value var.
mydf

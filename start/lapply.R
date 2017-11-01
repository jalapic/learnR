
### apply

df <- data.frame(name = c("james","steve","colin","hannah","rachel","jasmine"),
           v1  = runif(6),
           v2 =  runif(6),
           v3 = runif(6),
           v4 = runif(6))

df

df$vmean <- apply(df[,2:5],1, mean)
df$vmax <- apply(df[,2:5],1, max)

df
apply(df[,2:5], 2, mean)



### lapply

library(gapminder)
library(tidyverse)

head(gapminder)

newdf <- split(gapminder, gapminder$country)

newdf

newdf[44]
newdf[[44]]

mean(newdf[[44]]$lifeExp)

lapply(newdf, function(x)  mean(x$lifeExp) )


gapminder %>% group_by(country) %>% summarise(mean = mean(lifeExp))



### mapply

nos <- 1:10
randoms2 <- runif(10)

nos
randoms2

mapply(function(x,y) x*y , x=nos,  y=randoms2)



# match

library(gapminder) # for data
library(tidyverse)

 countries <- gapminder %>% select(country,continent) %>% unique

 caps <-  data.frame(cty = c("Bahrain", "Mexico", "Uganda","Cuba", "Guinea-Bissau"),
            capital = c("Manama", "Mexico City", "Kampala", "Havana", "Bissau"))
 
 
 countries
 
 caps
 

 match(countries$country, caps$cty)
 
 match(countries$country, caps$cty, nomatch = 0)

 match(caps$cty, countries$country)
 
 countries$continent[ match(caps$cty, countries$country)]

 caps$continent <- countries$continent[ match(caps$cty, countries$country)]
 
 caps

 # for dataframes - join from dplyr works well
 
 caps <-  data.frame(cty = c("Bahrain", "Mexico", "Uganda","Cuba", "Guinea-Bissau"),
                     capital = c("Manama", "Mexico City", "Kampala", "Havana", "Bissau"))
 
 caps #just resetting to original

 caps %>% left_join(countries, by = c("cty" = "country"))  # only add info that we want to original first df (caps)
 
 caps %>% full_join(countries, by = c("cty" = "country"))  # notice difference in behavior to left_join
 
 
 
 
### Match is a very nice quick way of working with vectors.
 
v <- c(A=1, B=3, C=3, D=2, E=1, F=4, G=2, H=4, I=1, J=8)
 
v
  
vowels <- c('A','E','I',"O","U")
consonants <- LETTERS[!LETTERS[1:24] %in% vowels]
consonants

match(consonants, names(v))

m  <- match(consonants, names(v))
m[!is.na(m)]

v[m[!is.na(m)]]


# of course - easier to use in  here but you get the point.
v[names(v) %in% consonants]
 
  
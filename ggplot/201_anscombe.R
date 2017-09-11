
### Why you should always plot your data


# Anscombe's quartet  .......... and more

library(tidyverse)

## The original quartet

head(anscombe)


anscombe.1 <- data.frame(x = anscombe[["x1"]], y = anscombe[["y1"]], Set = "Anscombe Set 1")
anscombe.2 <- data.frame(x = anscombe[["x2"]], y = anscombe[["y2"]], Set = "Anscombe Set 2")
anscombe.3 <- data.frame(x = anscombe[["x3"]], y = anscombe[["y3"]], Set = "Anscombe Set 3")
anscombe.4 <- data.frame(x = anscombe[["x4"]], y = anscombe[["y4"]], Set = "Anscombe Set 4")

anscombe.data <- rbind(anscombe.1, anscombe.2, anscombe.3, anscombe.4)

head(anscombe.data)

# each of the four sets have the same mean and standard deviation
anscombe.data %>%
  group_by(Set) %>%
  summarize(mean_x = mean(x),
            mean_y = mean(y),
            sd_x = sd(x),
            sd_y = sd(y)
            )
  
# x and y for each have same pearson correlation r
split(anscombe.data, anscombe.data$Set) %>%
  map(~ cor(.$x,.$y))


# each have the same results from a linar model.
model1 <- lm(y ~ x, subset(anscombe.data, Set == "Anscombe Set 1"))
model2 <- lm(y ~ x, subset(anscombe.data, Set == "Anscombe Set 2"))
model3 <- lm(y ~ x, subset(anscombe.data, Set == "Anscombe Set 3"))
model4 <- lm(y ~ x, subset(anscombe.data, Set == "Anscombe Set 4"))

summary(model1)
summary(model2)
summary(model3)
summary(model4)


# Must be the same data ?
ggplot(anscombe.data, aes(x = x, y = y)) + 
  geom_point(color = "black") + 
  facet_wrap(~Set, ncol = 2) + 
  geom_smooth(method="lm",se=F)



## Even More Examples

# Load the datasauRus package
install.packages("datasauRus")

library(datasauRus)
ggplot(datasaurus_dozen, aes(x=x, y=y, colour=dataset))+
  geom_point()+
  theme_void()+
  theme(legend.position = "none")+
  facet_wrap(~dataset, ncol=3)


# to prove they have same mean and sd

datasaurus_dozen

datasaurus_dozen %>%
  group_by(dataset) %>%
  summarize(mean_x = mean(x),
            mean_y = mean(y),
            sd_x = sd(x),
            sd_y = sd(y)
  )

# x and y for each have same pearson correlation r
split(datasaurus_dozen, datasaurus_dozen$dataset) %>% map(~ cor(.$x,.$y) ) %>% rbind

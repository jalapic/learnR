## ggjoy - multiple density plots

## taken from vignette at https://github.com/clauswilke/ggjoy

install.packages("ggjoy")
library(ggjoy)


# Density joyplots

ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_joy()
ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_joy2()  #slightly nicer imo

# if y-axis is categorical, no need for group. If numeric  - needs group.
# modified dataset that represents species as a number

iris$Species_num <- as.numeric(iris$Species)
ggplot(iris, aes(x = Sepal.Length, y = Species_num, group = Species_num)) + geom_joy2()

# cut off trailing tails
ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_joy2(rel_min_height = 0.01)


#Smaller scale values create a separation between the curves, and larger values create more overlap.

# scale = 0.9, not quite touching
ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_joy(scale = 0.9)

# scale = 1, exactly touching
ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_joy(scale = 1)

# scale = 5, substantial overlap
ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_joy(scale = 5)



##  ggjoy has its own theme that helps make things look nicer:
ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_joy() + theme_joy()


# also  use 'expand' helps the labels and text on axis look nicer: 
ggplot(iris, aes(x = Sepal.Length, y = Species)) + 
  geom_joy() + theme_joy() +
  scale_x_continuous(expand = c(0.01, 0)) +
  scale_y_discrete(expand = c(0.01, 0))


# remove background grid if desired:
ggplot(iris, aes(x = Sepal.Length, y = Species)) + 
  geom_joy() + theme_joy(grid = FALSE) +
  scale_x_continuous(expand = c(0.01, 0)) +
  scale_y_discrete(expand = c(0.01, 0))




## Cyclical scales

ggplot(diamonds, aes(x = price, y = cut, fill = cut)) + 
  geom_joy(scale = 4) 

ggplot(diamonds, aes(x = price, y = cut, fill = cut)) + 
  geom_joy(scale = 4) + 
  scale_fill_cyclical(values = c("blue", "green")) # will cycle between 2 colors given

ggplot(diamonds, aes(x = price, y = cut, fill = cut)) + 
  geom_joy(scale = 4) + 
  scale_fill_cyclical(values = c("blue", "green", "pink")) # will cycle between 3 colors given


## Can also  plot mini-histograms
ggplot(iris, aes(x = Sepal.Length, y = Species, height = ..density..)) + 
  geom_joy(stat = "binline", bins = 20, scale = 0.95, draw_baseline = FALSE)




## Cute examples


# Evolution of movie lengths over time

library(ggplot2movies)
ggplot(movies[movies$year>1912,], aes(x = length, y = year, group = year)) +
  geom_joy(scale = 10, size = 0.25, rel_min_height = 0.03) +
  theme_joy() +
  scale_x_continuous(limits=c(1, 200), expand = c(0.01, 0)) +
  scale_y_reverse(breaks=c(2000, 1980, 1960, 1940, 1920, 1900), expand = c(0.01, 0))


# Results from Catalan regional elections, 1980-2015
# Modified after a figure originally created by Marc Belzunces.

library(tidyverse)
library(forcats)
Catalan_elections %>%
  mutate(YearFct = fct_rev(as.factor(Year))) %>%
  ggplot(aes(y = YearFct)) +
  geom_joy(aes(x = Percent, fill = paste(YearFct, Option)), 
           alpha = .8, color = "white", from = 0, to = 100) +
  labs(x = "Vote (%)",
       y = "Election Year",
       title = "Indy vs Unionist vote in Catalan elections",
       subtitle = "Analysis unit: municipalities (n = 949)",
       caption = "Marc Belzunces (@marcbeldata) | Source: Idescat") +
  scale_y_discrete(expand = c(0.01, 0)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  scale_fill_cyclical(breaks = c("1980 Indy", "1980 Unionist"),
                      labels = c(`1980 Indy` = "Indy", `1980 Unionist` = "Unionist"),
                      values = c("#ff0000", "#0000ff", "#ff8080", "#8080ff"),
                      name = "Option", guide = "legend") +
  theme_joy(grid = FALSE)




# Temperatures in Lincoln, Nebraska
# Modified from a blog post by Austin Wehrwein.

library(viridis)
ggplot(lincoln_weather, aes(x = `Mean Temperature [F]`, y = `Month`, fill = ..x..)) +
  geom_joy_gradient(scale = 3, rel_min_height = 0.01, gradient_lwd = 1.) +
  scale_x_continuous(expand = c(0.01, 0)) +
  scale_y_discrete(expand = c(0.01, 0)) +
  scale_fill_viridis(name = "Temp. [F]", option = "C") +
  labs(title = 'Temperatures in Lincoln NE',
       subtitle = 'Mean temperatures (Fahrenheit) by month for 2016\nData: Original CSV from the Weather Underground') +
  theme_joy(font_size = 13, grid = TRUE) + theme(axis.title.y = element_blank())



# Visualization of Poisson random samples with different means
# Inspired by a ggjoy example by Noam Ross.

# generate data
set.seed(1234)
pois_data <- data.frame(mean = rep(1:5, each = 10))
pois_data$group <- factor(pois_data$mean, levels=5:1)
pois_data$value <- rpois(nrow(pois_data), pois_data$mean)

# make plot
ggplot(pois_data, aes(x = value, y = group, group = group)) +
  geom_joy2(aes(fill = group), stat = "binline", binwidth = 1, scale = 0.95) +
  geom_text(stat = "bin",
            aes(y = group + 0.95*(..count../max(..count..)),
                label = ifelse(..count..>0, ..count.., "")),
            vjust = 1.4, size = 3, color = "white", binwidth = 1) +
  scale_x_continuous(breaks = c(0:12), limits = c(-.5, 13), expand = c(0, 0),
                     name = "random value") +
  scale_y_discrete(expand = c(0.01, 0), name = "Poisson mean",
                   labels = c("5.0", "4.0", "3.0", "2.0", "1.0")) +
  scale_fill_cyclical(values = c("#0000B0", "#7070D0")) +
  labs(title = "Poisson random samples with different means",
       subtitle = "sample size n=10") +
  guides(y = "none") +
  theme_joy(grid = FALSE) +
  theme(axis.title.x = element_text(hjust = 0.5),
        axis.title.y = element_text(hjust = 0.5))




# The most practical use of joyplots will probably be to show Bayesian effects posteriors
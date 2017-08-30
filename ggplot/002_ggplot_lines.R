
### Line Graphs

# geom_line()
# geom_path()
# geom_step()

library(ggplot2)

# Line graphs require a datframe with 2 columns: the x axis and the y axis
# A third column could be for groups


### Example 1.

library(gapminder)

head(gapminder)
tail(gapminder)


d1 <- c("Algeria", "Sudan", "Kenya", "Zimbabwe")

d2 <- subset(gapminder, country %in% d1)


ggplot(d2)

ggplot(d2, aes(x = year, y = lifeExp, color = country))

ggplot(d2, aes(x = year, y = lifeExp, color = country)) +
  geom_line() + 
  geom_point()

ggplot(d2, aes(x = year, y = lifeExp, color = country)) + 
  geom_line(lwd=1) + geom_point()

ggplot(d2, aes(x = year, y = lifeExp, color = country)) + 
  geom_path() + geom_point()

p <- ggplot(d2, aes(x = year, y = lifeExp, color = country)) + 
  geom_line() + 
  geom_point()

p

p + theme(legend.position = "none")


library(ggrepel)

p + 
  theme(legend.position = "none") +
  geom_text_repel(
    data = subset(d2, year==2007),
    aes(label = country),
    size = 4,
    nudge_y = .75,
    nudge_x = 1,
    segment.color=NA
  ) 




ggplot(d2, aes(x = year, y = lifeExp, color = country)) + 
  geom_line(lwd=1) + 
  geom_point() + 
  theme(legend.position = "none") + 
  theme_minimal() +
  scale_color_manual(values=c("navy", "blue", "dodgerblue", "cyan")) +
  xlab("Year") +
  ylab("Life Expectancy") +
  ggtitle("Life Expectancy Since 1950 in select African Countries",
          subtitle = "source: gapminder.org")




### What if we plotted all African countries?

africa <- subset(gapminder, continent=="Africa")

unique(africa$country)

ggplot(africa, aes(x = year, y = lifeExp, color = country)) + geom_line()

ggplot(africa, aes(x = year, y = lifeExp, color = country)) + 
  geom_line() + facet_wrap(~country, ncol=8) + theme(legend.position="none")


zim <- subset(africa, country=="Zimbabwe")

ggplot(africa, aes(x = year, y = lifeExp,group=country)) + 
  geom_line(color="gray66", alpha=.25) + 
  geom_line(data=zim, color="firebrick", lwd=1)+
  theme(legend.position="none") +
  theme_classic() +
  ggtitle("Zimbabwe vs Other African Countries") +
  xlab("Year") +
  ylab("Life Expectancy")
  




### Compare median value of each continent

 ggplot(gapminder, aes(x = year, y = lifeExp,group=country)) + 
  geom_line(color="dodgerblue", alpha=.15) + 
  facet_wrap(~continent, ncol=5)  +
  theme_classic()


library(tidyverse)

medianlife <- gapminder %>% 
              group_by(year,continent) %>% 
              summarise(median=median(lifeExp))


medianlife


#same as above - but 'country' is specific to first set of lines
ggplot(gapminder, aes(x = year, y = lifeExp)) + 
  geom_line(aes(group=country), color="dodgerblue", alpha=.15) + 
  facet_wrap(~continent, ncol=5)  +
  theme_classic()

#can now add median:
ggplot(gapminder, aes(x = year, y = lifeExp)) + 
  geom_line(aes(group=country), color="dodgerblue", alpha=.15) + 
  facet_wrap(~continent, ncol=5)  +
  theme_classic() + 
  geom_line(data=medianlife, aes(x=year,y=median), color="navy", lwd=1) 




### Drop Oceania

gapminder1 <- droplevels(subset(gapminder, continent != "Oceania"))
medianlife1 <- droplevels(subset(medianlife, continent != "Oceania"))

ggplot(gapminder1, aes(x = year, y = lifeExp)) + 
  geom_line(aes(group=country), color="dodgerblue", alpha=.15) + 
  facet_wrap(~continent, ncol=5)  +
  theme_classic() + 
  geom_line(data=medianlife1, aes(x=year,y=median), color="navy", lwd=1) 

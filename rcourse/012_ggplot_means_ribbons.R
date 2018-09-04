### Plotting Means and Standard Errors (or Deviations)


library(ggplot2)

states <- read.csv("states.csv")
  
states <- subset(states, !is.na(region)) #dropping DC

levels(states$region)
states$region <- factor(states$region, levels=c("N. East", "Midwest", "West", "South"))

states$pop_grp <- ifelse(states$pop>median(states$pop,na.rm=T), 'high', 'low')

  
head(states)


# 1. summarise data -  mean, median, sd, se, confindence interval
sem <- function(x) sqrt(var(x,na.rm=T)/length(x))

summary(states$toxic)

states_summary <- 
  states %>% 
  group_by(region, pop_grp) %>% 
  summarise(
    mean=mean(toxic,na.rm=T),
    sd=sd(toxic,na.rm=T),
    se=sem(toxic),
    n = length(toxic)
  )

states_summary





# Bar Graphs ----


# Error bars = standard error of the mean

ggplot(states_summary, aes(x=region, y=mean))


ggplot(states_summary, aes(x=region, y=mean)) + 
  geom_bar(position=position_dodge(), stat="identity") 

ggplot(states_summary, aes(x=region, y=mean, fill=pop_grp)) + 
  geom_bar(position=position_dodge(), stat="identity") 


ggplot(states_summary, aes(x=region, y=mean, fill=pop_grp)) + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=mean-se, ymax=mean+se),
                width=.2,                    
                position=position_dodge(.9))

# can change all aspects of plot, e.g. error bar width
ggplot(states_summary, aes(x=region, y=mean, fill=pop_grp)) + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=mean-se, ymax=mean+se),
                width=.2,                    
                position=position_dodge(.9),
                size=2)


# color bars
ggplot(states_summary, aes(x=region, y=mean, fill=pop_grp)) + 
  geom_bar(position=position_dodge(), stat="identity", alpha=.2) +
  geom_errorbar(aes(ymin=mean-se, ymax=mean+se),
                width=.2,                    
                position=position_dodge(.9)) +
  scale_color_manual(values=c("dodgerblue", "navy")) +
  scale_fill_manual(values=c("dodgerblue", "navy")) +
  theme_classic() 



# color error bars too
ggplot(states_summary, aes(x=region, y=mean, fill=pop_grp)) + 
  geom_bar(position=position_dodge(), stat="identity", alpha=.2) +
  geom_errorbar(aes(ymin=mean-se, ymax=mean+se, color=pop_grp),
                alpha=.5,
                width=.2,                    
                position=position_dodge(.9)) +
  scale_color_manual(values=c("dodgerblue", "navy")) +
  scale_fill_manual(values=c("dodgerblue", "navy")) +
  theme_classic() 







# 2. Line Graphs ----

library(gapminder)

head(gapminder)

asia <- subset(gapminder, continent=="Asia")

ggplot(asia, aes(x=year, y=lifeExp, group=country)) + geom_point() + geom_line()

ggplot(asia, aes(x=year, y=lifeExp, color=country)) + geom_point() + geom_line()


asia_yr <- 
  asia %>% group_by(year)%>% 
  summarise(
    mean=mean(lifeExp,na.rm=T),
    sd=sd(lifeExp,na.rm=T),
    se=sem(lifeExp),
    n = length(lifeExp)
  )

asia_yr


ggplot(asia_yr, aes(x=year, y=mean)) + 
  geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.5, position="identity") +
  geom_line() +
  geom_point()




### By continent and year:
gapminder_yr <- 
  gapminder %>% 
  group_by(year, continent) %>% 
  summarise(
    mean=mean(lifeExp,na.rm=T),
    sd=sd(lifeExp,na.rm=T),
    se=sem(lifeExp),
    n = length(lifeExp)
  )

gapminder_yr

ggplot(gapminder_yr, aes(x=year, y=mean, color=continent)) + 
  geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.5, position="identity") +
  geom_line() +
  geom_point()






### Ribbon graphs ----

ggplot(asia_yr, aes(x=year, y=mean)) + 
  geom_ribbon(aes(ymin = mean-se, ymax = mean+se), fill = "grey70") 


ggplot(asia_yr, aes(x=year, y=mean)) + 
  geom_ribbon(aes(ymin = mean-se, ymax = mean+se), fill = "grey70") +
  geom_line(aes(y = mean))

ggplot(gapminder_yr, aes(x=year, y=mean, color=continent, fill=continent)) + 
  geom_ribbon(aes(ymin = mean-se, ymax = mean+se), alpha=.1) +
  geom_line(aes(y = mean))

# I don't like the edges of the ribbon
ggplot(gapminder_yr, aes(x=year, y=mean, color=continent, fill=continent)) + 
  geom_ribbon(aes(ymin = mean-se, ymax = mean+se), alpha=.1, color=NA) +
  geom_line(aes(y = mean))



### Chaining

gapminder %>% 
  group_by(year, continent) %>% 
  summarise(
    mean=mean(lifeExp,na.rm=T),
    sd=sd(lifeExp,na.rm=T),
    se=sem(lifeExp),
    n = length(lifeExp)
  )%>%
ggplot(aes(x=year, y=mean, color=continent, fill=continent)) + 
  geom_ribbon(aes(ymin = mean-se, ymax = mean+se), alpha=.1, color=NA) +
  geom_line(aes(y = mean))








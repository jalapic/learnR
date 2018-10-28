#### INSTALL PACKAGES ####
library(readxl)
library(tidyverse)
library(chron)
library(psych)
library(jtools)
library(devtools)
install_github("thomasp85/patchwork")
library(patchwork)

#### READ IN DATA #### 
# instagram data
df <- read_excel("Google Drive/Academic/UT/Classes/Fall 2018/R Programming/Assignments/instagramdata.xlsx")
names(df)

names(df) <- c('ID', 'URL', 'Type', 'PostDate', 
               'Likes', 'Comments', 'Hashtags', 'Usertags', 'ImageCount', 
               'CarouselVideo', 'UserID', 'Followers', 'Following', 'Posts', 
               'FirstPost', 'RecordedDate')

#### TIDY DATA ####

df <- df %>% 
  filter(Type == "Photo") %>% distinct(URL, .keep_all = T) %>% 
  separate(col = PostDate, into = c('PDate', 'PostTime'), "T") %>% 
  separate(col = FirstPost, into = c('FirstDate', 'FirstTime'), "T") %>% 
  separate(col = RecordedDate, into = c('RecDate', 'RecTime'), "T") %>% 
  mutate(DatePosted=as.Date(PDate),
         FirstPostDate=as.Date(FirstDate),
         Postweekday=factor(weekdays(DatePosted),levels = c("Monday", "Tuesday", "Wednesday", "Thursday","Friday", "Saturday", "Sunday")),
         PostTime=chron(times = PostTime),
         PostHour=hours(PostTime))

describe(df[, c("Likes", "Followers", "Following", "Hashtags")])

## diagnostic plots

followers <- df %>% filter(Followers < 5000) %>% ggplot(aes(x = Followers)) + 
  geom_histogram(binwidth = 15) + theme_bw()
following <- df %>% filter(Followers < 5000) %>% ggplot(aes(x = Following)) + 
  geom_histogram(binwidth = 15) + theme_bw()
likes <- df %>% filter(Followers < 5000) %>% ggplot(aes(x = Likes)) + 
  geom_histogram(binwidth = 15) + theme_bw()
hashtags <- df %>% filter(Followers < 5000) %>% ggplot(aes(x = Hashtags)) + 
  geom_histogram(binwidth = 1) + theme_bw()
# Sitch plots together
followers + following + likes + hashtags + plot_layout(ncol=2)

## The data are very skewed but oh well

#### EXPLORATORY PLOTS ####

df %>% ggplot(aes(x = Followers, y = Following)) + geom_point() + geom_smooth() + theme_bw()

df %>% filter(Followers < 150000) %>% 
  ggplot(aes(x = Followers, y = Following)) + geom_point() + geom_smooth() + theme_bw()

df %>% filter(Followers < 25000) %>% 
  ggplot(aes(x = Followers, y = Following)) + geom_point() + geom_smooth() + theme_bw()

df %>% filter(Followers < 500) %>% 
  ggplot(aes(x = Followers, y = Following)) + geom_point() + geom_smooth() + theme_bw()

df1 <- df %>% filter(Followers < 5000)
corr.test(df1[, c("Followers", "Following")])

df %>% ggplot(aes(x = Hashtags, y = Followers)) + geom_point() + geom_smooth() + theme_bw()

df %>% filter(Followers < 5000) %>% 
  ggplot(aes(x = Hashtags, y = Followers)) + geom_point() + geom_smooth() + theme_bw()

df %>% filter(Followers < 5000) %>% 
  ggplot(aes(x = Likes, y = Followers)) + geom_point() + geom_smooth() + theme_bw()

df %>% filter(Followers < 150000) %>% 
  ggplot(aes(x = Followers , y = Likes)) + 
  geom_point(aes(colour = Hashtags)) + 
  geom_smooth() +
  theme_bw()
  

#### WHAT GETS LIKES? #####

corr.test(df[, c("Likes", "Comments")])
activtyPCA <- princomp(df[, c("Likes", "Comments")])
df$Activity <- activtyPCA$scores[,1]
getlikes <- lm(Activity ~ Hashtags*Followers, data=subset(df, Followers < 5000))
summary(getlikes)
interact_plot(getlikes, pred = 'Followers', modx = 'Hashtags')
interact_plot(getlikes, pred = 'Followers', modx = 'Hashtags', plot.points = T,
              point.size = .8)


#### WHEN TO POST TO MAXIMIZE LIKES? ####

aesdf <- subset(df, Followers < 600) %>%
  group_by(PostHour, Postweekday) %>% 
  summarise(avehash = mean(Hashtags), avefollower = mean(Followers))

subset(df, Followers < 5000) %>% full_join(aesdf) %>% 
  ggplot(aes(x = factor(PostHour), y = Likes)) + 
  geom_jitter(aes(colour = avehash, size = avefollower, alpha = avehash/avefollower)) +
  geom_boxplot(aes(colour = avehash)) +
  facet_wrap(~Postweekday) 

subset(df, Followers < 500) %>% full_join(aesdf) %>% 
  ggplot(aes(x = factor(PostHour), y = Likes)) + 
  geom_jitter(aes(colour = avehash, alpha = avefollower)) +
  geom_boxplot(aes(colour = avehash)) +
  facet_wrap(~Postweekday) + theme_bw() + 
  xlab("Hour Posted") + ggtitle("Number of likes by hour and weekday")



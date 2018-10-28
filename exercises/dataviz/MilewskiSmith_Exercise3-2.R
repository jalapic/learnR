df <- read.csv("student-por.csv")
df
str(df)
library(tidyverse)
library(dplyr)

# pulling out data to make correlation heat map

df2<- df %>% select("sex", "age", "Medu", "Fedu","traveltime", "studytime", "failures", "activities", "famrel", "freetime", "goout", "Dalc", "Walc", "health", "absences")
df2
str(df2)
df2$age <- as.numeric(df2$age)
df2$Medu <- as.numeric(df2$Medu)
df2$Fedu <- as.numeric(df2$Fedu)
df2$traveltime <- as.numeric(df2$traveltime)
df2$studytime <- as.numeric(df2$studytime)
df2$failures <- as.numeric(df2$failures)
df2$activities <- as.numeric(df2$activities)
df2$famrel <- as.numeric(df2$famrel)
df2$freetime <- as.numeric(df2$freetime)
df2$goout <- as.numeric(df2$goout)
df2$Dalc<- as.numeric(df2$Dalc)
df2$Walc<- as.numeric(df2$Walc)
df2$health<- as.numeric(df2$health)
df2$absences<- as.numeric(df2$absences)
head(df2)

#assigning what data will go into the matrix 
mydata <- df2[, c(2:15)]
mydata
cormat <- round(cor(mydata),2)
cormat


#the start of making the heatmap
library(ggplot2)
library(reshape2)
melted_cormat <-melt(cormat)
head(melted_cormat)
ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile()

get_lower_tri<-function(cormat){
  cormat[upper.tri(cormat)] <- NA
  return(cormat)
}

get_upper_tri <- function(cormat){
  cormat[lower.tri(cormat)]<- NA
  return(cormat)
}
upper_tri <- get_upper_tri(cormat)
upper_tri

melted_cormat <- melt(upper_tri, na.rm = TRUE)

together <- ggplot(data = melted_cormat, aes(Var2, Var1, fill = value))+
  geom_tile(color = "white")+
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal()+ 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1))+
  coord_fixed() +
  ggtitle("Males and Females")+
  geom_text(aes(Var2, Var1, label = value), color = "black", size = 4) +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    legend.justification = c(1, 0),
    legend.position = c(0.6, 0.7),
    legend.direction = "horizontal")+
  guides(fill = guide_colorbar(barwidth = 7, barheight = 1,
                               title.position = "top", title.hjust = 0.5))

together


### Male graph
df3 <- df2 %>% 
  filter(sex == "M")

Mdata <- df3[, c(2:15)]
Mdata

cormat1 <- round(cor(Mdata),2)
cormat1

melted_cormat1 <-melt(cormat1)
head(melted_cormat1)
ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile()

get_lower_tri1<-function(cormat1){
  cormat[upper.tri1(cormat1)] <- NA
  return(cormat1)
}

get_upper_tri1 <- function(cormat1){
  cormat1[lower.tri(cormat1)]<- NA
  return(cormat1)
}
upper_tri1 <- get_upper_tri1(cormat1)
upper_tri1

melted_cormat1 <- melt(upper_tri1, na.rm = TRUE)

Males <- ggplot(data = melted_cormat1, aes(Var2, Var1, fill = value))+
  geom_tile(color = "white")+
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal()+ 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1))+
  coord_fixed()+
  ggtitle("Males")+
  geom_text(aes(Var2, Var1, label = value), color = "black", size = 4) +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    legend.justification = c(1, 0),
    legend.position = c(0.6, 0.7),
    legend.direction = "horizontal")+
  guides(fill = guide_colorbar(barwidth = 7, barheight = 1,
                               title.position = "top", title.hjust = 0.5))

Males

#Female graph 
#filtering out females
df4 <- df2 %>% 
  filter(sex == "F")

#assigning the data we want
Fdata <- df4[, c(2:15)]
Fdata

#
cormat2 <- round(cor(Fdata),2)
cormat2

melted_cormat2<-melt(cormat2)
head(melted_cormat2)
ggplot(data = melted_cormat2,aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile()

get_lower_tri2<-function(cormat2){
  cormat[upper.tri2(cormat2)]<-NA
  return(cormat2)
}

get_upper_tri2 <- function(cormat2){
  cormat2[lower.tri(cormat2)]<- NA
  return(cormat2)
}
upper_tri2 <- get_upper_tri2(cormat2)
upper_tri2

melted_cormat2<- melt(upper_tri2, na.rm = TRUE)

Females <- ggplot(data = melted_cormat2,aes(Var2, Var1, fill = value))+
  geom_tile(color = "white")+
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal()+ 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1))+
  coord_fixed() +
  ggtitle("Females") +
  geom_text(aes(Var2, Var1, label = value), color = "black", size = 4) +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    legend.justification = c(1, 0),
    legend.position = c(0.6, 0.7),
    legend.direction = "horizontal")+
  guides(fill = guide_colorbar(barwidth = 7, barheight = 1,
                               title.position = "top", title.hjust = 0.5))
Females


#### putting all graphs together ######
library(gridExtra)

grid.arrange(Males,together, Females, ncol= 3)    


## graph looking a drinking and age 


se <- function(x) { mean(x) / sqrt(length(x)) }

df %>% group_by(sex,goout) %>%
  summarise(mean = mean(Dalc),
            se = se(Dalc)) -> x
ggplot(x, aes(x=goout, y=mean, color=sex)) + geom_point() + geom_line() + 
  geom_pointrange(aes(ymin=mean-se, ymax=mean+se)) + 
  ylab("Average Week Day Drinking") + xlab("Student Going out Rate") + ggtitle("Average Week Day Drinking and Going Out")

se1 <- function(y) { mean(y) / sqrt(length(y)) }
y <- df%>% group_by(sex,age)%>% summarise(mean1 = mean(Walc), se1 = se(Walc))
ggplot(y, aes(x=age, y=mean1, color=sex)) + geom_point() + geom_line() + 
  geom_pointrange(aes(ymin=mean1-se1, ymax=mean1+se1)) + 
  ylab("Average Weekend Drinking") + xlab("Age") + ggtitle("Student Weekend Drinking")

se2 <- function(z) { mean(z) / sqrt(length(z)) }
z<- df%>% group_by(sex,age)%>% summarise(mean3 = mean(Dalc), se2 = se(Dalc))
ggplot(z, aes(x=age, y=mean3, color=sex)) + geom_point() + geom_line() + 
  geom_pointrange(aes(ymin=mean3-se2, ymax=mean3+se2)) +
  ylab("Average Week Day Drinking") +xlab("Age") + ggtitle("Student Week Day Drinking")

df <- read.csv("student-por.csv")
library(plyr)
library(tidyverse)
library(dplyr)
library(jtools)
# filtering for only under age because there are only 4 studnets above the age of 21. 
f<-df%>% filter(age %in% ages)
ages<- c(15:20)

# attempt at a jtools graph
fiti<- lm(Dalc~goout*sex, data=df)
summ(fiti)
interact_plot(fiti, pred = goout, modx = sex, interval = TRUE, int.width = .8)


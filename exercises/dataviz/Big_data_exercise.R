
library(tidyverse)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(ggthemes)
library(ggrepel)

food<- read.csv("Food_Establishment_Inspection_Scores.csv") # read csv file

str(food) # see structure of data frame
food$Process.Description # look at names in this column

food$Zip.Code <- as.character(as.integer(food$Zip.Code)) # convert Zip code to Character form num
food$Restaurant.Name <- as.character(as.factor(food$Restaurant.Name)) # onvert name to character
food$Inspection.Date <- as.Date(food$Inspection.Date, format = "%m/%d/%Y") # change date format to Date (not characters)

food1 <-food%>%
  select(Restaurant.Name,Zip.Code,Inspection.Date,Score) # Create new data frame with only the info we want.

colnames(food1) <- c("Name", "Zip","Date","Score") #change column names because the original ones have . 
food1$Name # check the names

food2018 <-food1 %>%
  filter(between(Date, as.Date("2018-01-01"),as.Date("2018-09-21")))# new data frame with only those insepctions in 2018

food2018_2<-food2018%>%
  mutate(year=lubridate::year(food2018$Date))%>% # create column year
  group_by(Name,year,Zip)%>% # group by name and year and Zip to keep that Zip columns
  summarise(average_score=mean(Score)) %>% # get the average score
  spread(year,average_score)%>% # create new columns with average of 2018 (in case they had more than one inspection already)
  ungroup()

colnames(food2018_2) <- c("Name", "Zip","Meanscore_2018")  # change column name from 2018 to Meanscore_2018

plot <- ggplot(food2018_2,aes(reorder(Zip, Meanscore_2018), y=Meanscore_2018))+geom_boxplot()+  # boxplot with all zipcodes from 01-01-18 to 09-21-18 (average in case they already had more than one insepction)
  geom_boxplot(data=food2018_2[food2018_2$Zip=="78703",], # Lina Zipcode
               aes(reorder(Zip,Meanscore_2018), y= Meanscore_2018),fill="mediumturquoise")+
  geom_boxplot(data=food2018_2[food2018_2$Zip=="78752",],  # Kevin Zipcode
               aes(reorder(Zip,Meanscore_2018), y= Meanscore_2018),fill="lightseagreen")+
  geom_boxplot(data=food2018_2[food2018_2$Zip=="78731",],  # Mingshuang Zipcode
               aes(reorder(Zip,Meanscore_2018), y= Meanscore_2018),fill="palegreen3")+
  geom_boxplot(data=food2018_2[food2018_2$Zip=="78705",], # Around campus
               aes(reorder(Zip,Meanscore_2018), y= Meanscore_2018),fill="darkorange")+
  geom_boxplot(data=food2018_2[food2018_2$Zip=="78701",], # downtonw
               aes(reorder(Zip,Meanscore_2018), y= Meanscore_2018),fill="coral3")+
  scale_y_continuous(breaks=seq(50,100,by=2))+
  coord_flip() 

plot+ggtitle(" Establishment Inspection Score in Austin", # Add title
             subtitle = "Mean Score 2018") + # subtittle
  xlab("Zip Code")+ylab("Mean score")+ # axis labels
  theme(legend.position = "none")+ # remove legend
  theme(axis.line = element_line(colour = "black"))+ # color line axis
  theme(strip.background = element_rect(colour = "black", fill = "white"))+ # background
  theme(panel.grid.major.x = element_blank())+ 
  theme_bw() # theme black/white - simple

food1$Name <- paste(food1$Name,food1$Zip) # adding zip code to name to distinguish different locations

food1<-food1%>%
  mutate(year=lubridate::year(food1$Date)) %>% # create new column with year only        
  group_by(Name,year,Zip)%>% # group by name and year and Zip to keep that Zip columns
  summarise(averagescore=mean(Score,na.rm=TRUE))%>% # get the average score
  spread(year, averagescore)%>% # create new columns for each year with each average
  ungroup()

food1$Dif1615<-(food1$`2016`-food1$`2015`) # substract column with the difference in the score between 2016 and 2015, NA in some values because some restaurant didn't have a score for a year so the difference can't be calculated
food1$Dif1716<-(food1$`2017`-food1$`2016`) # substract column with the difference in the score between 2017 and 2016
food1$Dif1817<-(food1$`2018`-food1$`2017`) # substract column with the difference in the score between 2018 and 2017

food1_2<- food1%>%
  select(Zip,Dif1615,Dif1716,Dif1817)%>% # keep only Zip code and the difference between years
  group_by(Zip)%>%
  summarise_all(mean,na.rm = TRUE) # get the mean of the difference between years by each zip code
 
food1_2<-food1_2%>% # make it long formart
  gather(Years,Diff,2:4)

food1_3<-food1_2%>%
  filter(Years=="Dif1817") # filter only the difference between 2018 and 2017

food1_3$Diff2<-ifelse(food1_3$Diff < 0,"Got worse","Got better") # look at the column Diff and if the value is lower than 0 add a flag "got worse" and if the value is greater than 0 then add a flag "got better"
food1_3 <- food1_3[order(food1_3$Diff),] #sort
food1_3$Zip<-factor(food1_3$Zip,levels=food1_3$Zip) #convert to factor to retain sorted order in plot.

plot1817<-ggplot(food1_3,aes(x=Zip,y=Diff,label=Diff))+ # plot by Zip code on average the food places got better or worse from 2017 to 2018
  geom_bar(stat="identity",aes(fill=Diff2),width =.5)+ # identity keeps the order, and the filling will correspond to the got better/got worse column
  coord_flip()+ # flip axis
  scale_fill_manual(name="Change", 
                    labels = c("Got better", "Got worse"),
                    values = c("Got worse"="turquoise3", "Got better"="steelblue3"))+
  labs(title= "Averange change in Score",subtitle="2017 - 2018")+
  theme_bw()+
  labs(y="Difference in Score", x="Zip Code")+ # opposite because the axis flipping already happened
  theme(legend.justification=c(1,0), legend.position=c(1,0)) # legend inside graph so it doens't take space out when we put them together.

food1_4<-food1_2%>%  # get the data for the score difference between 2017 and 2016
  filter(Years=="Dif1716")

food1_4$Diff2<-ifelse(food1_4$Diff < 0,"Got worse","Got better") # look at the column Diff and if the value is lower than 0 add a flag "got worse" and if the value is greater than 0 then add a flag "got better"
food1_4 <- food1_4[order(food1_4$Diff),] # sort
food1_4$Zip<-factor(food1_4$Zip,levels=food1_4$Zip) # #convert to factor to retain sorted order in plot. 

plot1716<- ggplot(food1_4,aes(x=Zip,y=Diff,label=Diff))+ # plot shows the average difference between the score in 2017 and 2016 in all zip codes showing if the food places on average got better or worse.
  geom_bar(stat="identity",aes(fill=Diff2),width =.5)+
  coord_flip()+
  scale_fill_manual(name="Change", 
                    labels = c("Got better", "Got worse"),
                    values = c("Got worse"="turquoise3", "Got better"="steelblue3"))+
  labs(title= "Averange change in Score",subtitle="2016 - 2017")+
  theme_bw()+
  labs(y="Difference in Score", x="Zip Code")+ #opposite because the axis flipping already happened
  theme(legend.justification=c(1,0), legend.position=c(1,0)) #legend inside plot so they it doesn't take space out of the graph

library(gridExtra) # to combine plots in one page

grid.arrange(plot1716,plot1817, ncol=2) # Put both plots together

## only our zip codes: ---

food2 <-food%>%
  select(Restaurant.Name,Zip.Code,Inspection.Date,Score) # Create new data frame with only the info we want. I have to this again since big data frame because I overwrote in food1 at the beginning and remove column Score...and now I need it. 
colnames(food2) <- c("Name", "Zip","Date","Score") # change names
food2<-filter(food2,Zip=="78703" | Zip=="78752" | Zip=="78731") # data frame with only our zipcodes
food2_2 <-food2 %>%
  filter(between(Date, as.Date("2018-01-01"),as.Date("2018-09-21"))) # only keep 2018 
food2_2$Name <- paste(food2_2$Name,food2_2$Zip) # add zip code to name to distinguish between different locations

food2_3<-food2_2%>%
  mutate(year=lubridate::year(food2_2$Date)) %>% # create new column with year only        
  group_by(Name,year,Zip)%>% # group by name and year and Zip to keep that Zip columns
  summarise(averagescore=mean(Score,na.rm=TRUE)) # average score during 2018 because some stablishments have had more than 1 inspection already

ggplot(food2_3,aes(Zip,averagescore, group=Zip))+ # Boxplot of the average score in 2018 of foof places in our Zip code
  geom_boxplot(aes(fill=factor(Zip)))+
  scale_y_continuous(breaks=seq(50,100,by=2))+
  geom_dotplot(binaxis='y', stackdir='center', dotsize =.5,binwidth =1)+ #add data points
  theme_bw()+
  theme(legend.position = "none")+
  theme(strip.text.x = element_text(size = 12,face = "bold"))+
  theme(strip.background = element_rect(colour = "black", fill = "white"))+
  ggtitle("Food Establishment Inspection Score in Austin", # Add title
          subtitle = "2018")

  
#####Selected Restaurant ratings over time

food3 <- food %>% 
  select(Restaurant.Name, Zip.Code, Inspection.Date, Score)

colnames(food3) <- c("Restaurant", "Zip", "Year", "Score")

food3$Year <- as.Date(food3$Date, format = "%m/%d/%Y") #arranges date
food3$Zip <- as.factor(food3$Zip) #makes Zip a foctor instead of integer 
food3$RZ <- paste(food3$Restaurant, food3$Zip) #makes duplicate names unique

head(food3)

food3_1 <- filter(food3, RZ %in% c("Taco Joint 78705" , "Titaya's Thai Cuisine 78751", "True Food Kitchen 78701", "Lima Criolla Peruvian Restaurant 78752", "Terry Black's Barbecue, LLC 78704")) #selects some favorites

plottime <- ggplot(food3_1, aes(x=Year, y=Score, group=RZ, color=RZ)) + 
  ylim(80,100) +
  geom_point() + 
  geom_line(lwd=1) + #lwd makes line slightly thicker
  ggtitle("Inspection Scores of Favorite Restaurants", subtitle = "2015-2018") + 
  scale_color_discrete("Restaurant") + #changes legend title
  theme_bw()

#Cumulative Austin Mean Scores Each Year

food4 <- food3 %>% 
  mutate(Year = format(as.Date(food3$Year, format= "%Y/%m/%d"), "%Y")) %>%
  group_by(RZ, Year, Zip) %>%
  summarise(avgscore = mean(Score)) %>%
  spread(Year, avgscore) %>%
  ungroup() %>%
  gather(Year, Score, 3:6, na.rm=TRUE) %>% 
  group_by(Year) %>% 
  summarise(Score=mean(Score)) 

food4$Year <- as.Date(food4$Year, format = "%Y") 

plottimeavg <- ggplot(food4, aes(x=Year, y=Score, group=1)) +
  ylim(80,100) +
  geom_point() + 
  geom_line(lwd=1) + 
  theme_bw() +
  ggtitle("Cumulative Mean Inspection Scores across Austin", subtitle= "2015-2018")

grid.arrange(plottime, plottimeavg, ncol= 2)

ggplot(NULL, aes(x=Year, y=Score)) + 
  geom_line(data=food3_1, aes(group=RZ, color=RZ), lwd=1) +
  geom_line(data=food4, lwd=1.5) +
  scale_color_discrete("Restaurant") + 
  ggtitle("Inspection Scores of Favorite Restaurants", subtitle = "Versus Austin Mean Scores 2015-2018")
  
  
##CRASH- too big?## ggplot(food3, aes(x=Date, y=Score, group=RZ, color=RZ)) + geom_line()

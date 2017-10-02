
### importing .RData file.
load(url("https://github.com/jalapic/learnR/blob/master/datasets/makeover/counted_coord.RData?raw=true"))


### importing csv files.


femalepipe <- read.csv("https://raw.githubusercontent.com/jalapic/learnR/master/datasets/makeover/Female%20Corporate%20Talent%20Pipeline.csv")
counted <- read_csv("https://raw.githubusercontent.com/jalapic/learnR/master/datasets/makeover/the-counted-2015.csv")
internetuse<-read.csv("https://raw.githubusercontent.com/jalapic/learnR/master/datasets/makeover/internetuse.csv")
march_madness <- read.csv("https://raw.githubusercontent.com/jalapic/learnR/master/datasets/makeover/NCAA%20Mens%20March%20Madness%20Historical%20Results.csv")
d <- read.csv("https://raw.githubusercontent.com/jalapic/learnR/master/datasets/makeover/success.csv")
Candidates <- read.csv("https://raw.githubusercontent.com/jalapic/learnR/master/datasets/makeover/CandidateSummaryAction.csv")
anes<-read.csv("https://raw.githubusercontent.com/jalapic/learnR/master/datasets/makeover/anes.csv")





### importing xlsx files.

library(readxl)
library(httr)

url1 <- "https://github.com/jalapic/learnR/blob/master/datasets/makeover/iphone.xlsx?raw=true"
url2 <- "https://github.com/jalapic/learnR/blob/master/datasets/makeover/robots.xlsx?raw=true"
url3 <- "https://github.com/jalapic/learnR/blob/master/datasets/makeover/Australian%20Taxable%20Income.xlsx?raw=true"
url4 <- "https://github.com/jalapic/learnR/blob/master/datasets/makeover/VdaySpend.xlsx?raw=true"
url5 <- "https://github.com/jalapic/learnR/blob/master/datasets/makeover/police_violence.xlsx?raw=true"
url6 <- "https://github.com/jalapic/learnR/blob/master/datasets/makeover/SolarEclipseData.xlsx?raw=true"



GET(url1, write_disk(tf <- tempfile(fileext = ".xlsx")))
iphone <- read_excel(tf, 1L)

GET(url2, write_disk(tf <- tempfile(fileext = ".xlsx")))
robots <- read_excel(tf, 1L)

GET(url3, write_disk(tf <- tempfile(fileext = ".xlsx")))
ati <- read_excel(tf, 1L)

GET(url4, write_disk(tf <- tempfile(fileext = ".xlsx")))
VdaySpend <- read_excel(tf, 1L)

GET(url5, write_disk(tf <- tempfile(fileext = ".xlsx")))
police_violence <- read_excel(tf, 1L)

GET(url6, write_disk(tf <- tempfile(fileext = ".xlsx")))
SE <- read_excel(tf, 1L)


### Student Example Visualizations ###


library(tidyverse)


#######################################################################################################

# 1. Making Over "Female Corporate Talent Pipeline"
# http://www.mckinsey.com/business-functions/organization/our-insights/women-in-the-workplace


femalepipe$Year <- as.factor(femalepipe$Year)
femalepipe$Female <- as.numeric(sub("%", "", femalepipe$Female))
femalepipe$Male <- as.numeric(sub("%", "", femalepipe$Male))

mylevels <- c("Entry Level", "Manager", "Senior Manager / Director", 
              "Vice President", "Senior Vice President", "C-Suite")

femalepipe$Level <- factor(femalepipe$Level, levels = mylevels)

ggplot(femalepipe, aes(x = Level, y = Female, group = Year, color = Year,
                       label = Year)) +
  geom_line(lwd=1) +
  geom_point() +
  ylim(0,100) +
  ylab("Percent of Women in Role\n") + 
  xlab("\nLevel Within Organization") +
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  theme(legend.position = "top") 



#######################################################################################################

# 2. Mapping Police Killings

library(stringr)
library(ggmap)


# taking out Alaska and Hawaii for this assignment
counted <- counted %>%
  filter(!state %in%  c("AK", "HI"))

#----------------------------------------------
# Coordinates for locations of killings
#----------------------------------------------

# Locations of the killings
counted %>%
  select(streetaddress, city)

# Function to obtain coordinates from ggmap
geocode("2500 Speedway, Austin")

# Run the function for all addresses
params <- data_frame(location = paste(counted$streetaddress, counted$city, sep = ", "))
# system.time(counted_coord <- plyr::mdply(params, .fun = geocode)) 


# There were 8 addresses that returned NA's. Got city level coordinates for those

# na_locations <- counted_coord %>%
#   filter(is.na(lat)) %>%
#   mutate(location = str_split_fixed(location, ", ", 2)[,2]) %>%
#   select(1)
# 
# na_map <-  plyr::mdply(na_locations, .fun = geocode)
# 
# counted_coord <- rbind(counted_coord, na_map)
# counted_coord <- filter(counted_coord, !is.na(lon))
# 
# save(counted_coord, file ="counted_coord.RData")


#----------------------------------------------
# Data with the coordinates
#----------------------------------------------
head(counted_coord)


#----------------------------------------------
# Making map of the US
#----------------------------------------------

# ggplot has a function `map_data` that retrieves data from the maps package 
# coordinates to make a map of the us

us_map <- map_data("state")

ggplot(us_map) + 
  geom_polygon(aes(x=long, y=lat, group = group), 
               color = "black")


#----------------------------------------------
# Map locations of police killings 
#----------------------------------------------

ggplot() + 
  geom_polygon(aes(x=long, y=lat, group = group), 
               color = "dodgerblue", 
               fill="white",
               data = us_map) +
  geom_point(aes(x = lon, y = lat), 
             alpha = .6, size = 2, 
             color = "black", data = counted_coord) +  
  ggtitle("Police Killings in 2015", 
          subtitle = "Source: The Guardian") +
  theme_void() +
  theme(plot.title = element_text(size = 15, face = "bold")) +
  theme(plot.subtitle=element_text(size=10, face="italic", color="black"))





#########################################################################################################

# 3. Internet Use Across Countries

head(internetuse)
tail(internetuse)

library(ggthemes)
library(scales)

user_per100_average <- internetuse %>% 
  group_by(year,continent) %>% 
  summarise(mean=mean(internetuserper100))

#add a line showing average internet use for each continent

ggplot(internetuse, aes(x = year, y = internetuserper100)) + 
  geom_line(aes(group=country), color="goldenrod3", alpha=.15) + 
  facet_wrap(~continent, scales="free_x")  +
  theme_few()

ggplot(internetuse, aes(x = year, y = internetuserper100)) + 
  geom_line(aes(group=country), color="goldenrod3", alpha=.15) + 
  facet_wrap(~continent, scales="free_x")  +
  theme_few()+geom_line(data=user_per100_average, aes(x=year,y=mean), color="red", lwd=1) +
  theme(legend.position="none")+theme(text=element_text(size=12,face="bold"))



#drop austrailia, add title 
internetuse <- droplevels(subset(internetuse, continent != "Australia"))

user_per100_average <- droplevels(subset(user_per100_average, continent != "Australia"))

p<-ggplot(internetuse, aes(x = year, y = internetuserper100)) + 
  geom_line(aes(group=country), color="goldenrod3", alpha=.15) + 
  facet_wrap(~continent, scales="free_x")  +
  theme_few()+geom_line(data=user_per100_average, aes(x=year,y=mean), color="red", lwd=1) +
  theme(legend.position="none")+theme(text=element_text(size=12,face="bold"))+
  ggtitle("Internet use across continents (1990-2015)") +theme(plot.title = element_text(hjust = 0.5))+
  xlab("Year") +
  ylab("Internet user per 100")

p



#########################################################################################################

# 4. Top jobs by gender in Australia

colnames(ati)[5] <-'Income'
colnames(ati)[1] <-'Rank'
colnames(ati) 
ati<- ati[,1:5]

# this works out top 20 jobs for each gender
# then get the list of any job that is in top 20 for either gender
# then only keep those jobs for both genders
ati.males <- subset(ati, Gender=='Male' & Rank<=20)
ati.females <- subset(ati, Gender=='Female' & Rank<=20)
occs <- c(ati.males$Occupation,ati.females$Occupation)
occs <- unique(occs)

ati.short <- subset(ati, Occupation %in% occs)

head(ati.short)

#so chart can be ordered by job rank
ati.short %>% filter(Gender=="Male") %>%
  arrange(Rank) %>%
  .$Occupation ->mylevels

ati.short$Occupation <- factor(ati.short$Occupation, levels=rev(mylevels))


library(ggthemes)
ggplot(data = ati.short, 
       aes(x = Occupation, fill = Gender, 
           y = ifelse(Gender == "Male", -Income, Income))) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = abs, limits = max(ati.short$Income) * c(-1,1)) +
  labs(y = "Income") +
  coord_flip() +
  labs(title="Male vs Female Relative Income")+
  theme_tufte() +  # Tufte theme from ggfortify
  theme(plot.title = element_text(hjust = .5), 
        axis.ticks = element_blank()) +   # Put title in Center of plot
  scale_fill_brewer(palette = "Paired")  # Color palette



#########################################################################################################

# 5. March Madness


##first, separate out month, day, and year
march_madness$new_date <- as.Date(march_madness$Date,
                                  format = "%m/%d/%y")
march_madness<-march_madness %>%
  separate(new_date, into = c("year","month", "day"))


#plot correlation between seed differential and point differential by year (should be going down)
march_madness$point_diff<-march_madness$Winning.Score-march_madness$Losing.Score
march_madness$seed_diff<-march_madness$Losing.Seed-march_madness$Winning.Seed

mm_cor<-march_madness %>%
  group_by(year=as.numeric(year))%>%
  summarise(correlation=cor(point_diff,seed_diff))

cor_plot<-ggplot(mm_cor,aes(x=year, y=correlation))+
  geom_point(size=1.5,color = "blueviolet")+
  stat_smooth(se=F, method ="lm",color = "grey25")+
  scale_x_continuous(limits=c(1985,2016), breaks=c(1985,1990,1995,2000,2005,2010,2015))+
  scale_y_continuous(limits=c(0,0.6), breaks=c(0,0.1,0.2,0.3,0.4,0.5))

cor_plot<-cor_plot + xlab("Year") + ylab("Correlation between \n Seed Difference and Score Difference")

cor_plot<-cor_plot + ggtitle("Are NCAA basketball teams becoming more equal?") +
  theme(plot.title = element_text(size = 20,hjust = 0.5))

cor_plot<-cor_plot + theme(axis.text=element_text(size=12))

cor_plot + theme_bw() +theme(plot.title = element_text(size = 20,hjust = 0.5))


#########################################################################################################

# 6. iphone peaked?

iphone$Quarters <- as.factor(iphone$Quarter)


# We want to look at quarterly trends  
QuarterlyTrends<-ggplot(data=iphone,aes(x=Year,y=UnitsSoldinMillions))+
  geom_line()+facet_grid(~Quarters)+
  geom_point(alpha=.75)+facet_wrap(~Quarters)+ 
  xlab("Year") + 
  ylab("Units Sold in Millions") +
  ggtitle("Have Global iPhone Sales Peaked?",
          subtitle = "Yearly trend analysis by fiscal quarter")+
  theme_classic() +
  theme(plot.background = element_rect(fill = "lightcyan3"))+
  theme(legend.position = "none")

QuarterlyTrends


# Graph2_Combined
ggplot(data=iphone)+
  geom_point(aes(x=Year,y=UnitsSoldinMillions))+
  theme(legend.position = "none")+
  geom_line(mapping = aes(x=Year,y=UnitsSoldinMillions,color=Quarters))+
  xlab("Year") + 
  ylab("Units Sold in Millions") +
  ggtitle("Have Global iPhone Sales Peaked?")+
  theme_classic() +
  theme(plot.background = element_rect(fill = "lightcyan3"))


#########################################################################################################

# 7. Risk of Automation
# https://www.theguardian.com/technology/2017/mar/24/millions-uk-workers-risk-replaced-robots-study-warns

## Renaming our columns
colnames(robots)[2] <- "percent_employ"
colnames(robots)[3] <- "percent_auto"
str(robots)


ggplot(data = subset(robots, percent_employ < 1), 
       aes(x = percent_employ, y = percent_auto,
           label = Industry)) +
  geom_point(shape = 5) +
  geom_text_repel(
    data = subset(robots, 
                  percent_auto > .4 | percent_auto < .2)) +
  theme_minimal()

## finishing touches

ggplot(data = subset(robots, percent_employ < 1), aes(x = percent_employ, y = percent_auto, label = Industry, color = percent_auto)) +
  geom_point(shape = 5) +
  geom_text_repel(data = subset(robots, percent_auto > .4 | percent_auto < .2))  +
  scale_color_gradient(low = "blue", high = "red") +
  xlab("Percent of Population Employed in Industry") + ylab("Percent of Jobs at risk of Automation") +
  ggtitle("Scatterplot of Industries at Risk for Automation") 





#######################################################################################################################################

### 8.  Views of success by income 

d$rate=as.numeric(sub("%","",d$rate))
d$strata <- factor(d$strata, levels=c("Poor","Middle class","Rich people"),labels=c("Poor","Middle","Rich"))

#create a category variable to facet plot by based on trends of each group.
d$category <- ifelse(d$reason %in% c("abilities, talents","entreprenurial spirit, courage","hard work"),
       "Rich", ifelse(d$reason %in% c("connections to the right people","cunning, cheating","presence of initial capital"),
              "Poor", "Middle"))

d$category<- factor(d$category, levels=c("Poor","Middle","Rich"),labels=c("Poor Highest","Middle Highest","Rich Highest"))
d$reason<- factor(d$reason, levels=c("abilities, talents","entreprenurial spirit, courage","hard work","connections to the right people","cunning, cheating","presence of initial capital","fortune, good luck","good education, high qualification"),labels=c("abilities,\ntalents","entreprenurial spirit,\ncourage","hard work","connections to\nthe right people","cunning,\ncheating","presence of\ninitial capital","fortune,\n good luck","good education, high qualification"))

#final plot
ggplot(d,aes(x=strata,y=rate,group=reason,color=reason))+
  geom_line(size=1.25)+
  geom_point(size=2.5)+
  facet_wrap(~category,ncol=3)+
  theme_minimal()+
  geom_text_repel(data=subset(d,strata=="Rich"),
                  aes(label=reason),
                  size=5.2,
                  nudge_x =20,
                  nudge_y = -.3,
                  segment.color=NA)+
  xlab("Social Strata")+
  ylab("Percent Saying a Main Reason for Success")+
  scale_color_manual(values=c("hotpink", "darkorchid1", "royalblue1","firebrick1","darkorange","gold1","deepskyblue","green1"))+
  theme(legend.position="none",axis.text=element_text(size=15),
        axis.title=element_text(size=15,face="bold"),
        strip.text = element_text(size=15))


#######################################################################################################################################


### 9. Perceptions of white discrimination and feelings towards Trump. 

#label race
table(anes$race)
anes$race <- c("White", "Black", "Latino", "Asian", "Native American", "Mixed", "Other", "Middle Eastern")[anes$race]
table(anes$race)

#label party affiliation
anes$pid1d <- c("Democrat", "Republican", "Independent", "Something Else", NA,NA,NA,NA,"Skipped Question")[anes$pid1d]


##Plot of feelings towards Trump s feelings towards African-Americans 
ggplot (anes, aes(x=ftblack, y=fttrump, color = pid1d)) + geom_point(shape = 16, alpha=.8) +
  scale_x_continuous (limits = c(0,100), breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)) + 
  scale_y_continuous (limits = c(0,100), breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)) + 
  ylab("Feelings towards Trump") + 
  xlab("Feelings towards African-Americans") +
  theme_minimal() + 
  ggtitle("Racial Sentiments and Trump Support") + theme(plot.title = element_text(hjust =0.5)) +
  labs(color = "Party Identification")+
  facet_wrap(~pid1d)



#####################################################################################################################################

### 10. Candidate Election Contributions

library(stringr)

# But dollar signs and commas 
Candidates$tot_con <- as.numeric(gsub('[$,]', '', Candidates$tot_con))
Candidates$tot_dis <- as.numeric(gsub('[$,]', '', Candidates$tot_dis))
Candidates$cas_on_han_clo_of_per <- as.numeric(gsub('[$,]', '', Candidates$cas_on_han_clo_of_per))
Candidates$oth_com_con <- as.numeric(gsub('[$,]', '', Candidates$oth_com_con))
Candidates$ind_con <- as.numeric(gsub('[$,]', '', Candidates$ind_con))


# Shaping 
House <- Candidates %>% filter(can_off=="H")
HouseGOPandDem <- House %>% filter(can_par_aff=="REP" | can_par_aff=="DEM")
values <- c("can_par_aff", "ind_con", "oth_com_con", "tot_con", "tot_dis", "cas_on_han_clo_of_per")
Slim <- HouseGOPandDem[values]
colnames(Slim)[1:6] <- c("Party","Individual contributions","PAC & other contributions","Total contributions",
                         "Total disbursements","Cash on hand at end of period")


# Gathering 
Long <- Slim %>% gather("Individual contributions", "PAC & other contributions", "Total contributions", "Total disbursements", "Cash on hand at end of period", key="variable", value="amount")

# Dividing by 1M
Long$amount <- (Long$amount/(1000000))

# Getting candidate counts
nrow(HouseGOPandDem %>% filter(can_par_aff=="DEM")) #912
nrow(HouseGOPandDem %>% filter(can_par_aff=="REP")) #517

# Plotting 
library(stringr)
ggplot(Long, aes(x=variable, y=amount, fill=Party)) + 
  geom_bar(stat="sum", position=position_dodge()) + 
  labs(title="US campaign contributions and expenditures",
       subtitle="2016 House races",
       caption="Data from fec.gov",
       x="",
       y="Amount ($ millions)") +
  theme_minimal() + 
  scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) + 
  scale_fill_manual(labels=c("912 Democrats", "517 Republicans"), values=c("#00C3C8", "#FF6A61"))




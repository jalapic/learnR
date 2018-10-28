# Class Project: Group Data Carpentry & Visualization Project
# Yujin Kim & Kelsey Whipple

library(tidyverse)
library(ggplot2)
library(mapproj)

death <- read.csv("cpj.csv")
str(death)

colnames(death)
summary(death)

#' Data have many problems... 
#'a) date formats are mixed
#'b) coverage is a mess.. because it has multiple coverage in one column

df <- death %>% select(Date, Organization,Country_killed, Nationality, Coverage)
head(df)
str(df)

colnames(df) <- c("date","organization","country_killed","nationality","beat")

# a) trimming date; we need only year 
summary(df$date)

# first, we tried a) as.Date() transform and extract years only, and b) use regular expression and detect 4 digits => both failed 
# remove all (special) characters except for(^) Alphabet, numbers, and space
df$date_clean <- str_replace_all(df$date, "[[^a-zA-Z0-9 ]]", "")

# function to find out substring of the last 4 digit
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

# extract year (the last 4 digits from the right) 
df$year <- substrRight(as.character(df$date_clean), 4)
df$year <- as.integer(df$year) # transform into integers (characters automatically into NAs)
summary(df$year)


# b) make a tidy 'beat' (coverage)
summary(df$beat)

# maximum beats in one column --> 7

split_beat <- strsplit(as.character(df$beat), ", ", fixed = TRUE)

# create each column containing one beat

for (i in 1:7) {
  n <- sapply(split_beat, "[", i)
  df[,paste0("b",i)] <- n
}

b8 <- sapply(split_beat, "[", 8) # in case of omission
unique(b8) # NA

# create long format with beats + country_killed by year
beats_long <- df %>% gather(key, value = "beats_all" ,8:14) 

long <- beats_long %>% select(year, beats_all, country_killed)

# select only beats with year
year_beats <- long %>% group_by(year) %>% count(beats_all) %>% na.omit()

# # of Journalist killed by coverages (One journalist can cover multiple items)
ggplot(year_beats, aes(x=year, y=n, color=beats_all)) + geom_line() +  geom_point()

ggplot(year_beats, aes(x=year, y=n, color=beats_all)) + geom_line() +  geom_point() + 
  facet_wrap(~beats_all, ncol=4, scales='free_x') +
  ggtitle("Number of Journalists Killed by Beat") +
  xlab("Year") +
  ylab("Number of Journalists") +
  theme_minimal() +
  theme(legend.position="none", text = element_text(size=13), panel.spacing = unit(1, "lines")) +
  scale_x_continuous(limits=c(1992,2016), breaks=c(1992,1996,2000,2004,2008,2012,2016)) + 
  theme(plot.title = element_text(hjust = 0.5))

# area chart
year_beats <- year_beats[order(year_beats$beats_all, decreasing=T) , ]
year_beats <- year_beats %>% group_by(year) %>% arrange(desc(beats_all))

unique(year_beats$beats_all)

year_beats %>% group_by(beats_all) %>% tally() %>% arrange(-nn) %>% .$beats_all -> blah
year_beats$beats_all <- factor(year_beats$beats_all, levels=blah)
str(year_beats$beats_all)

ggplot(year_beats, aes(x=year, y=n, fill=beats_all)) + geom_area() +
  ggtitle("Number of Journalists Killed by Beat") +
  xlab("Year") +
  ylab("Number of Journalists") +
  theme_minimal() +
  theme(text = element_text(size=13), panel.spacing = unit(1, "lines")) +
  scale_x_continuous(limits=c(1992,2016), breaks=c(1992,1996,2000,2004,2008,2012,2016)) +
  theme(plot.title = element_text(hjust = 0.5))



# select only countries with year 
year_country <- long %>% group_by(year) %>% count(country_killed) %>% na.omit()

ggplot(year_country, aes(x=year, y=n, color=country_killed)) + geom_line() +  geom_point()

# filter blank cells in countries & less than 10 death in a country
year_country_10 <- year_country %>% filter(country_killed != "") %>% filter(n >= 10)

ggplot(year_country_10, aes(x=year, y=n, color=country_killed)) + geom_line() + geom_point() +
  theme_minimal() 

# still hard to see. filter n >= 20, 40 countries

year_country_20 <- year_country %>% filter(country_killed != "") %>% filter(n >= 20)

ggplot(year_country_20, aes(x=year, y=n, color=country_killed)) + geom_line() + geom_point() +
  facet_wrap(~country_killed) +
  theme_minimal() +
  theme(legend.position="none") +
  scale_x_continuous(limits=c(1992,2016), breaks=c(1992,2000,2008,2016))

# line graphs are probably not a good plot for countries;



# world map for country_killed and nationality; aggregated by country? 
summary(df$nationality)
summary(df$country_killed)

# summarize # of journalists by country_killed  (cumulative death between 1992-2016)

df_country_killed <- df %>% select(country_killed, year) %>% group_by(country_killed) %>% count(country_killed) %>% filter(country_killed != "") %>% na.omit() 

# plot # of journalists by country_killed on the map 

worlddata <- map_data('world')
worlddata %>% filter(region != "Antarctica") -> worlddata # exclude Antarctica
#worlddata_noislands <- dplyr::filter(worlddata, !grepl('Islands', region))

p <- ggplot()
p <- p + geom_map(data=worlddata, map=worlddata,
                  aes(x=long, y=lat, group=group, map_id=region),
                  fill="white", colour="#7f7f7f", size=0.5)

# world map for country_killed 
p <- p + geom_map(data=df_country_killed, map=worlddata,
                  aes(fill=n, map_id=country_killed),
                  colour="#7f7f7f", size=0.5)
p

p <- p + scale_fill_continuous(low="thistle2", high="darkred", 
                               guide="colorbar")
p <- p + scale_y_continuous(breaks=c())
p <- p + scale_x_continuous(breaks=c())
p <- p + labs(fill="Number of \nJournalists Killed", title="Journalists Killed by Location", x="", y="")
p <- p + theme_bw()
p <- p + theme(panel.border = element_blank(), legend.position="bottom")
p <- p + theme(plot.title = element_text(hjust = 0.5))

#p <- p + coord_map("polyconic")
p

# make the title center?

# summarize # of journalists by nationality  (cumulative death between 1992-2016)

df_nationality <- df %>% select(nationality, year) %>% group_by(nationality) %>% count(nationality) %>% filter(nationality != "") %>% na.omit() 

# plot # of journalists by nationality on the map 

worlddata <- map_data('world')
worlddata %>% filter(region != "Antarctica") -> worlddata # exclude Antarctica
#worlddata_noislands <- dplyr::filter(worlddata, !grepl('Islands', region))

q <- ggplot()
q <- q + geom_map(data=worlddata, map=worlddata,
                  aes(x=long, y=lat, group=group, map_id=region),
                  fill="white", colour="#7f7f7f", size=0.5)
q

# world map for country_killed 
q <- q + geom_map(data=df_nationality, map=worlddata,
                  aes(fill=n, map_id=nationality),
                  colour="#7f7f7f", size=0.5)

q

q <- q + scale_fill_continuous(low="lightskyblue", high="navy", 
                               guide="colorbar")
q <- q + scale_y_continuous(breaks=c())
q <- q + scale_x_continuous(breaks=c())
q <- q + labs(fill="Number of \nJournalists Killed", title="Journalists Killed by Nationality", x="", y="")
q <- q + theme_bw()
q <- q + theme(panel.border = element_blank(), legend.position="bottom")
q <- q + theme(plot.title = element_text(hjust = 0.5))
#q <- q + coord_map("polyconic")
q

require(gridExtra)
grid.arrange(p, q, ncol=2)

library(tidyverse)

##rename df so I don't have to type a lot
rats <- rat_sightings

head(rats)

str(rats)

##create column for year
library(lubridate)

lubridate::year(rats$created_date)

rats1 <- rats %>%
  group_by('year' = lubridate::year(created_date)) 

##create column for month 

rats2 <- rats1 %>% 
  group_by('month' = lubridate::month(created_date))

library(ggplot2)

#Cases over time 

ggplot(rats1, aes(x=created_date))+
  geom_histogram(color="lightskyblue4", fill="lightskyblue3") +
  theme_minimal() +
  xlab("") +
  ylab("Number of Sightings")+
  ggtitle("Rat Sightings in NYC") +
  theme(axis.text.x=element_text(angle=45, hjust=1))

##Looking at each borough 
#Brooklyn has the most sightings


ggplot(rats1 %>% filter(borough != "Unspecified"),aes(x=created_date,fill=borough)) +
  geom_histogram(alpha=1, position='dodge') +
  theme_minimal() +
  xlab("") +
  ylab("Number of Sightings")+
  ggtitle("Rat Sightings in NYC") +
  theme(axis.text.x=element_text(angle=45, hjust=1)) +
  theme(legend.title=element_blank()) +
  scale_fill_brewer(palette = "Paired")
  

unique(rats1$borough)

#density
ggplot(rats1 %>% filter(borough != "Unspecified"),aes(x=created_date,color=borough,alpha=.1)) +
  geom_density()+
  theme_minimal() +
  xlab("") +
  ylab("Number of Sightings")+
  ggtitle("Rat Sightings in NYC") #+
#  facet_wrap(~borough)





##But Brooklyn also has the most people, so what happens when we account for population differences?
### https://factfinder.census.gov/faces/nav/jsf/pages/community_facts.xhtml (pops)

population <- data.frame(
  borough = c("BRONX", "BROOKLYN", "MANHATTAN","QUEENS", "STATEN ISLAND"),
  pop = c(1471160, 2648771, 1664727, 2358582, 479458))

population

obs <- rats2 %>% 
  filter(year==2017) %>% 
  group_by(borough) %>% 
  count()

obs


newdf <- population %>% full_join(obs)

newdf

per_capita <- newdf %>% 
  mutate(cap = pop/n)

per_capita

##plot this

ggplot(per_capita, aes(x=borough, y=cap, color="lightskyblue4", fill="lightskyblue3")) +
  geom_bar(stat="identity", color="lightskyblue4", fill="lightskyblue3") +
  theme_minimal()+
  theme(axis.text.x=element_text(angle=45, hjust=1))+
  ylab("Sightings per Capita") +
  xlab("")+
  ggtitle("Sightings per Capita in 2017")

##So, accounting for differences in population differences, Queens has the most sightings

##creating a visual of rat sightings that accounts for population

library(tidyverse)
library(choroplethr)
library(mapproj)
library(tigris)
library(choroplethrZip)

# The df_pop_zip dataset has population by zip. 
data(df_pop_zip)
head(df_pop_zip)

#this is NY State population by zip
zip_choropleth(df_pop_zip, state_zoom = "new york", title="Population of New York State by county") + coord_map()   # not sure yet how to change border color or width between zipcode boundaries

## FIPS codes
#The counties New York City are:
# 005 - Bronx
# 047 - Kings (Brooklyn)
# 061 - New York (Manhattan)
# 081 - Queens
# 085 - Richmond (Staten Island)

#Looking at populations in NYC zip codes

nyc_fips = c(36005, 36047, 36061, 36081, 36085)
zip_choropleth(df_pop_zip,
               county_zoom = nyc_fips,
               title       = "2012 New York City ZCTA Population Estimates",
               legend      = "Population")

nyc_zip <-  c(10001, 10002, 10003, 10004, 10005, 10006, 10007, 10009, 10010, 10011, 10012, 10013, 10014, 10016, 10017, 10018, 10019, 10020, 10021, 10022, 10023, 10024, 10025, 10026, 10027, 10028, 10029, 10030, 10031, 10032, 10033, 10034, 10035, 10036, 10037, 10038, 10039, 10040, 10044, 10065, 10069, 10075, 10103, 10110, 10111, 10112, 10115, 10119, 10128, 10152, 10153, 10154, 10162, 10165, 10167, 10168, 10169, 10170, 10171, 10172, 10173, 10174, 10177, 10199, 10271, 10278, 10279, 10280, 10282, 10301, 10302, 10303, 10304, 10305, 10306, 10307, 10308, 10309, 10310, 10311, 10312, 10314, 10451, 10452, 10453, 10454, 10455, 10456, 10457, 10458, 10459, 10460, 10461, 10462, 10463, 10464, 10465, 10466, 10467, 10468, 10469, 10470, 10471, 10472, 10473, 10474, 10475, 11001, 11003, 11004, 11005, 11040, 11101, 11102, 11103, 11104, 11105, 11106, 11109, 11201, 11203, 11204, 11205, 11206, 11207, 11208, 11209, 11210, 11211, 11212, 11213, 11214, 11215, 11216, 11217, 11218, 11219, 11220, 11221, 11222, 11223, 11224, 11225, 11226, 11228, 11229, 11230, 11231, 11232, 11233, 11234, 11235, 11236, 11237, 11238, 11239, 11351, 11354, 11355, 11356, 11357, 11358, 11359, 11360, 11361, 11362, 11363, 11364, 11365, 11366, 11367, 11368, 11369, 11370, 11371, 11372, 11373, 11374, 11375, 11377, 11378, 11379, 11385, 11411, 11412, 11413, 11414, 11415, 11416, 11417, 11418, 11419, 11420, 11421, 11422, 11423, 11424, 11425, 11426, 11427, 11428, 11429, 11430, 11432, 11433, 11434, 11435, 11436, 11451, 11691, 11692, 11693, 11694, 11697)

nyc_zip

## created a data set that only has the zips we care about

df_pop_zip1 <- df_pop_zip %>% filter(region %in% nyc_zip) 

##Map of NYC poplation by zip
zip_choropleth(df_pop_zip1,
               county_zoom = nyc_fips,
               title       = "2012 New York City ZCTA Population Estimates",
               legend      = "Population")

### now calculate the total number of rats per zip from rats
colnames(rats)
ratzips <- rats %>% select(incident_zip) %>% count(incident_zip) 

head(ratzips)
tail(ratzips) #some don't make sense, most do ?  (data is messy)

# join datasets
colnames(ratzips)[1]<-"region" #has to match colnames to join on
ratzips$region<-as.character(ratzips$region) #has to match same type of format of column


df_pop_zip2 <- df_pop_zip1 %>% left_join(ratzips) #if no match, gives NA



# let's add a rats column to rats per 1000 population
df_pop_zip2 <- df_pop_zip2 %>% mutate(rats = ((1000*n)/value) )


df_pop_zip3 <- df_pop_zip2 %>% select(region, value = rats)

#get rid of NA with 0
df_pop_zip3$value <- ifelse(is.na(df_pop_zip3$value), 0, df_pop_zip3$value)

#  plot this
zip_choropleth(df_pop_zip3,
               county_zoom = nyc_fips,
               title       = "Rat Sightings per 1000 people in NYC",
               legend      = "rats / 1000 humans")

##A bunch of things that didn't work

library(maps)
library(mapdata)

counties <- map_data("county")
ny_county <- subset(counties, region == "new york")
head(ny_county)

##Map of New York State 

map <- ggplot(data = ny_county, mapping = aes(x = long, y = lat, group = group)) + 
  coord_fixed(1.3) + 
  geom_polygon(color = "black", fill = 'gray77')  +                    
  geom_polygon(data = ny_county, fill = NA, color = "white") +         
  geom_polygon(color = "black", fill = NA)     +  
  theme_void()

##just looking at NYC

boroughs <- c("queens","new york","kings","bronx","richmond")

NYC <- ny_county %>% filter(subregion %in% boroughs)

# Just plot NYC
ggplot() + 
  geom_polygon(data = NYC, aes(x = long, y = lat, group = group), color='white') +
  coord_fixed(1.5) + # this keeps the map size about right
  theme_void()  #this gets rid of the grid lines


# Adding in rat sightings

head(rats)
rats$latitude # goes on the y-axis
rats$longitude # goes on the x-axis


ggplot() + 
  geom_polygon(data = NYC, aes(x = long, y = lat, group = group), color='white') +
  coord_fixed(1.5) + # this keeps the map size about right
  theme_void() + #this gets rid of the grid lines
  geom_point(data=rats, aes(x=longitude, y=latitude), color='dodgerblue',size=.1,alpha=.1)

##puts rats in the ocean

##trying to use spatial density--works but impossible to see 

library(RColorBrewer)
cols <- rev(brewer.pal(10, "Spectral"))

ggplot(data=rats1) +  
  stat_density2d(aes(x=as.numeric(longitude), 
                     y=as.numeric(latitude), 
                     z=1, 
                     fill = ..density.., 
                     na.rm=TRUE), 
                 geom="tile",  
                 contour = FALSE)+
  scale_fill_gradientn(colours=cols)

## using leaflet to make map

library(leaflet)

mean(rats$latitude, na.rm=T) #40.73897
mean(rats$longitude, na.rm=T) #  -73.93419

m <- leaflet() %>% setView(lng = -73.93419, lat = 40.73897, zoom = 11) %>% 
  addProviderTiles(providers$CartoDB.Positron)

##add points (DON'T RUN. takes forever and looks horrible)

m %>% addProviderTiles(providers$CartoDB.Positron) %>% 
  addCircleMarkers(data = rats1,
                   ~longitude, 
                   ~latitude, 
                   popup = ~as.character(cross_street_1), 
                   label = ~as.character(cross_street_1),
                   radius=0.2)


##making a heatmap

library(leaflet.extras)

##hates missing data so have to drop from df

library(tidyr)

complete <- rats1 %>% drop_na(latitude, longitude)

##this works but doesn't look very good because you can't see the map beneath and it gets weird when you zoom in and out

heatmap<- leaflet() %>% setView(lng = -73.93419, lat = 40.73897, zoom = 11) %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addHeatmap(data=complete, lng = ~longitude, lat = ~latitude,
             blur = 20, max = 0.03, radius = 15)
##tyring something else

library(tigris)

lookup_code("New York", "New York")

nyc <- tracts(state = '36', county = c('061','047','081','005','085'))

nyc              

##NYC by census tracts
x <- plot(nyc) 

## creating map of nyc by zipcode

nyc_zip <- zctas(cb = TRUE, c(10001, 10002, 10003, 10004, 10005, 10006, 10007, 10009, 10010, 10011, 10012, 10013, 10014, 10016, 10017, 10018, 10019, 10020, 10021, 10022, 10023, 10024, 10025, 10026, 10027, 10028, 10029, 10030, 10031, 10032, 10033, 10034, 10035, 10036, 10037, 10038, 10039, 10040, 10044, 10065, 10069, 10075, 10103, 10110, 10111, 10112, 10115, 10119, 10128, 10152, 10153, 10154, 10162, 10165, 10167, 10168, 10169, 10170, 10171, 10172, 10173, 10174, 10177, 10199, 10271, 10278, 10279, 10280, 10282, 10301, 10302, 10303, 10304, 10305, 10306, 10307, 10308, 10309, 10310, 10311, 10312, 10314, 10451, 10452, 10453, 10454, 10455, 10456, 10457, 10458, 10459, 10460, 10461, 10462, 10463, 10464, 10465, 10466, 10467, 10468, 10469, 10470, 10471, 10472, 10473, 10474, 10475, 11001, 11003, 11004, 11005, 11040, 11101, 11102, 11103, 11104, 11105, 11106, 11109, 11201, 11203, 11204, 11205, 11206, 11207, 11208, 11209, 11210, 11211, 11212, 11213, 11214, 11215, 11216, 11217, 11218, 11219, 11220, 11221, 11222, 11223, 11224, 11225, 11226, 11228, 11229, 11230, 11231, 11232, 11233, 11234, 11235, 11236, 11237, 11238, 11239, 11351, 11354, 11355, 11356, 11357, 11358, 11359, 11360, 11361, 11362, 11363, 11364, 11365, 11366, 11367, 11368, 11369, 11370, 11371, 11372, 11373, 11374, 11375, 11377, 11378, 11379, 11385, 11411, 11412, 11413, 11414, 11415, 11416, 11417, 11418, 11419, 11420, 11421, 11422, 11423, 11424, 11425, 11426, 11427, 11428, 11429, 11430, 11432, 11433, 11434, 11435, 11436, 11451, 11691, 11692, 11693, 11694, 11697))

mm <- plot(nyc_zip)

##But we couldn't figure out how to add points or create choropleth

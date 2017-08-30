
### Introduction to Maps in R



# 1. Basic Maps plotting lat-long points on maps (maps package - interacts nicely with ggplot2)

# 2. Advanced: More detailed maps using packages like sp, rgdal, mapproj and rgeos gives similar functionality to e.g. ArcGIS

# 3. Intermediate:  'ggmap' package gives some increased map functionality without being too complex (lacks different projections)



### Basic Maps:

library(tidyverse)
library(maps)
library(mapdata)


# maps and mapdata contain lots of outlines of states, countries, continents etc.
# as well as e.g. city lat/long
  


# ggplot2 can turn these map shapes into 'dataframes' using `map_data()`

map_data("usa")
usa <- map_data("usa")
dim(usa)

head(usa)
tail(usa)

china <- map_data("china")
dim(china)
head(china)
tail(china)



#draw a basic map

p <- ggplot() + 
  geom_polygon(data = usa, aes(x=long, y = lat, group = group)) + 
  coord_fixed(1.3)

# coord_fixed() ensures the aspect ratio stays same no matter how we resize
# 1.3 means y is 1.3 times greater than x.

# group is important !  Otherwise polygons won't connect properly.

p

p + theme_void()



# remove fill (it's the default when using geom_polygon)
ggplot() + 
  geom_polygon(data = usa, aes(x=long, y = lat, group = group), fill = NA, 
               color = "firebrick") + 
  coord_fixed(1.3)



## Points
caps <- read.csv("datasets/state_capitals.csv")
head(caps)

mainland <- subset(caps, longitude>-134)

p + geom_point(data = mainland, aes(x = longitude, y = latitude), color = "darkorange", size = 1) + theme_void()




### Example 2 - Show states on US map

state.df <- map_data("state")
dim(state.df)
head(state.df)
tail(state.df)

ggplot(data = state.df) + 
  geom_polygon(aes(x = long, y = lat, fill = region, group = group), color = "white") + 
  coord_fixed(1.3) +
  theme_void() + theme(legend.position='none')  


# Subset states:
state.df1 <- subset(state.df, region %in% c("california", "nevada", "utah", "arizona"))

ggplot(data = state.df1) + 
  geom_polygon(aes(x = long, y = lat, group=group), fill = "dodgerblue", color = "black", lwd=1) + 
  coord_fixed(1.3) +
  theme_void()




#### Example 3 - county level.

ny_df <- subset(state.df, region == "new york")
head(ny_df)

counties <- map_data("county")
ny_county <- subset(counties, region == "new york")
head(ny_county)


ggplot(data = ny_df, mapping = aes(x = long, y = lat, group = group)) + 
  coord_fixed(1.3) + 
  geom_polygon(color = "black", fill = 'gray77')  +                    #fill background of state gray
  geom_polygon(data = ny_county, fill = NA, color = "white") +         #add counties- borders in white
  geom_polygon(color = "black", fill = NA)     +                       #annoyingly have to add border of state again.
  theme_void()







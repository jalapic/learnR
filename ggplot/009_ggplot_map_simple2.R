
### Maps in ggplot continued.

# plotting county level lead levels.

library(tidyverse)
library(maps)
library(mapdata)


### get data

state.df <- map_data("state")
ny_df <- subset(state.df, region == "new york")

counties <- map_data("county")
ny_county <- subset(counties, region == "new york")


plumbum <-  read.csv("datasets/nyc_children_lead.csv")  
head(plumbum)

ny_county <- ny_county %>% left_join(plumbum)
head(ny_county)

ggplot(data = ny_df, mapping = aes(x = long, y = lat, group = group)) + 
  geom_polygon(data = ny_county, aes(fill = pct_lead) , color = "white") +
  coord_fixed(1.3) + 
  theme_void() +
  scale_fill_gradient(low = "yellow", high = "red") 

library(viridis)
ggplot(data = ny_df, mapping = aes(x = long, y = lat, group = group)) + 
  geom_polygon(data = ny_county, aes(fill = pct_lead) , color = "white") +
  geom_polygon(color = "black", fill = NA)  +
  coord_fixed(1.3) + 
  theme_void() +
  scale_fill_viridis(direction=-1)


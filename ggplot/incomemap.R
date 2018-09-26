library(tidyverse) # for doing stuff
library(maps) # for map data
library(mapdata) # for map data
library(viridis) # for color scheme

state.df <- map_data("state")

states <- read.csv("https://raw.githubusercontent.com/jalapic/learnR/master/datasets/states.csv")

df <- states %>% select(state, income)
df

# columns i wish to join on are not called the same thing.
colnames(df)[1]<-"region"

# in states.df all states are in lower case. 
# but in df they are capitalized.
df
head(state.df)
df$region <- tolower(df$region)

# join in our variable of interest to state.df
state.df <- state.df %>% left_join(df)
head(state.df)
tail(state.df)


ggplot() + 
  geom_polygon(data = state.df, aes(x = long, y = lat, group = group, fill=income), color = "white") +
    coord_fixed(1.3) +
  theme_void() + 
  #theme(legend.position='none')  +
  scale_fill_viridis(direction=-1)
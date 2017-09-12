## Most simple bar chart

# e.g.  we have numeric count data that we wish to plot as a bar graph:

library(tidyverse)

df <- mpg %>% 
      group_by(class) %>% 
      tally() %>% 
      arrange(desc(n)) %>%
      mutate(class = factor(class, levels=class))

  
df


ggplot(df, aes(x = class, y = n, fill = class)) + geom_col() + theme_minimal() 



# make the colors cyclical using ggjoy package

library(ggjoy)
ggplot(df, aes(x = class, y = n, fill = class)) + geom_col() + theme_minimal() +
  scale_fill_cyclical(values = c("#4040B0", "#9090F0")) +
  scale_y_continuous(expand = c(0, 0))

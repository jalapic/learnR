### Functions for babynames report.



name_plot <- function(myname="Cosmo", yaxis = "n"){
  library(babynames)
  library(tidyverse)
  babynames %>% filter(name==myname) %>%
    ggplot(aes_string(x='year', y=yaxis, color='sex'))+
    geom_line()+
    scale_color_manual(values=c("firebrick","dodgerblue")) +
    theme_minimal()
}

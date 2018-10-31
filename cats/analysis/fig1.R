### Analysis 1.

source("functions/cat_functions.R")

shorthair <- readr::read_csv('clean_data/shorthair.csv')

shorthair <- get_age(shorthair)

catcolors <- c("blue", "black","orange",
              "seal","white")

sh1 <- shorthair %>% filter(color %in% catcolors)

head(sh1)
table(sh1$color)

# Figure 1 of our Nature Paper
p <- ggplot(sh1, aes(x = color,fill=color)) + geom_bar() + scale_fill_manual(values=c("black","blue","orange","brown","gray82")) +
  theme_minimal()+
  ggtitle("CATS !")
 
ggsave("img/fig1.png", p, height=4, width=4)

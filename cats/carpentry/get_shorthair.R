### Carpentry of Raw Data

cats <- readr::read_csv("raw_data/cats.csv")

# Count number of breeds
head(cats)
table(cats$breed)

# Keep only Domestic Shorthairs
library(tidyverse)

cats %>% filter(grepl("domestic shorthair", breed)) -> ds

ds  

# Save domestic shorthair file
write.csv(ds, "clean_data/shorthair.csv", row.names=F)
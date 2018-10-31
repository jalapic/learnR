#### Acquiring Raw Data

## Download Raw Data
cats <- read.csv("https://raw.githubusercontent.com/jalapic/learnR/master/datasets/aac_shelter_cat_outcome_eng.csv")

## Write this csv file to "raw_data"
write.csv(cats, "raw_data/cats.csv", row.names = F)

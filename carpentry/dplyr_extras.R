## dplyr extensions

library(tidyverse)


# 1. selecting columns quickly
cols <- c("mpg", "cyl", "gear")
mtcars %>% select(!!cols)

# 2. select columns via regex
iris %>% select(matches("S.+th"))

# 3. reordering columns (select first cols, then everything else)
iris %>% select(Species, everything())

# 4. rename all variables in one go
iris %>%
  rename_all(tolower) %>%
  rename_all(~str_replace_all(., "\\.", "_"))

# 5. clean up  all observations in one go
storms %>%
  select(name, year, status) %>%
  mutate_all(tolower) %>%
  mutate_all(~str_replace_all(., " ", "_"))

# 6. find the N highest/lowest values
mtcars %>% top_n(5, hp)


# 7. add the number of observations
mtcars %>%
  select(-(drat:vs)) %>%
  add_count(cyl) %>% rename(n_cyl = n) %>%
  add_count(am) %>% rename(n_am = n)


# 8. Make new variables (get round multiple if_else statements)
starwars %>%
  select(name, species, homeworld, birth_year, hair_color) %>%
  mutate(new_group = case_when(
    species == "Droid" ~ "Robot",
    homeworld == "Tatooine" & hair_color == "blond" ~ "Blond Tatooinian",
    hair_color == "blond" ~ "Blond non-Tatooinian",
    TRUE ~ "Other Human"
  ))

# 9. Go rowwise
iris %>%
  select(contains("Length")) %>%
  rowwise() %>%
  mutate(avg_length = mean(c(Petal.Length, Sepal.Length)))

# 10. Change column names after summmarise_if
iris %>%
  summarise_if(is.numeric, funs(avg=mean))
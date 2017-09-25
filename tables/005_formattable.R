### Tables of Raw Data


## Formattable

# https://github.com/renkun-ken/formattable


# generates HTML tables

# 1. Can save table as image.
# 2. Excellent for use in dynamic documents (e.g. RMarkdown)


# Packages:

library(formattable)
library(gapminder)
library(tidyverse)


# Example data:

gapminder %>% filter(country=="United States") -> usa

usa

formattable(usa)

# Change color of fonts based on a value
sign_formatter <- formatter("span", 
                            style = x ~ style(color = ifelse(x > 75, "blue", 
                                                             ifelse(x < 75, "red", "black"))))

formattable(usa, list(lifeExp = sign_formatter))


# Change color of fonts based onif value is higher/lower than mean
above_avg_bold <- formatter("span", 
                            style = x ~ style("font-weight" = ifelse(x > mean(x), "bold", NA)))


formattable(usa, list(
  pop = above_avg_bold,
  gdpPercap = above_avg_bold,
  lifeExp = sign_formatter))



#  you can change one column based on value in another:
formattable(usa, list(
  year = formatter("span", 
                        style = ~ style(color = ifelse(gdpPercap >= 20000, "green", "red")))))

# hide a column
formattable(usa, list(continent = FALSE))



formattable(usa, list(accounting(pop)))



####  Example 2

products <- data.frame(id = 1:5, 
                       price = c(10, 15, 12, 8, 9),
                       rating = c(5, 4, 4, 3, 4),
                       market_share = c('0.1%', '0.12%', '0.05%', '0.03%', '0.14%'),
                       revenue = c(55000, 36400, 12000, -25000, 98100),
                       profit = c(25300, 11500, -8200, -46000, 65000))
products

formattable(products)

# sign formatting
sign_formatter <- formatter("span", 
                            style = x ~ style(color = ifelse(x > 0, "blue", 
                                                             ifelse(x < 0, "red", "black"))))

formattable(products, list(profit = sign_formatter))


# color_tile & color_bar formatting 
formattable(products, list(
  price = color_tile("white", "lightpink"),
  rating = color_bar("lightgreen"),
  market_share = color_bar("lightblue"),
  revenue = sign_formatter,
  profit = sign_formatter))




# Area formatting

set.seed(123)
df <- data.frame(id = 1:10, 
                 a = rnorm(10), b = rnorm(10), c = rnorm(10))
df

formattable(df, list(area(col = a:c) ~ color_tile("transparent", "pink")))





#### Example 3 - from the vignette - just to show you what's possible


df <- data.frame(
  id = 1:10,
  name = c("Bob", "Ashley", "James", "David", "Jenny", 
           "Hans", "Leo", "John", "Emily", "Lee"), 
  age = c(28, 27, 30, 28, 29, 29, 27, 27, 31, 30),
  grade = c("C", "A", "A", "C", "B", "B", "B", "A", "C", "C"),
  test1_score = c(8.9, 9.5, 9.6, 8.9, 9.1, 9.3, 9.3, 9.9, 8.5, 8.6),
  test2_score = c(9.1, 9.1, 9.2, 9.1, 8.9, 8.5, 9.2, 9.3, 9.1, 8.8),
  final_score = c(9, 9.3, 9.4, 9, 9, 8.9, 9.25, 9.6, 8.8, 8.7),
  registered = c(TRUE, FALSE, TRUE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE),
  stringsAsFactors = FALSE)


FT <- formattable(df, list(
  age = color_tile("white", "orange"),
  grade = formatter("span", style = x ~ ifelse(x == "A", 
                                               style(color = "green", font.weight = "bold"), NA)),
  area(col = c(test1_score, test2_score)) ~ normalize_bar("pink", 0.2),
  final_score = formatter("span",
                          style = x ~ style(color = ifelse(rank(-x) <= 3, "green", "gray")),
                          x ~ sprintf("%.2f (rank: %02d)", x, rank(-x))),
  registered = formatter("span",
                         style = x ~ style(color = ifelse(x, "green", "red")),
                         x ~ icontext(ifelse(x, "ok", "remove"), ifelse(x, "Yes", "No")))
))

FT


### Saving a formattable as png

# 1. In RStudio use Export > Save_as_Image [but make sure you set dimensions correctly]


# 2. Use this helper function:
 # from: https://stackoverflow.com/questions/38833219/command-for-exporting-saving-table-made-with-formattable-package-in-r

library(htmltools)
library(webshot)    
webshot::install_phantomjs() #need to install this too

export_formattable <- function(f, file, width = "100%", height = NULL, 
                               background = "white", delay = 0.2)
{
  w <- as.htmlwidget(f, width = width, height = height)
  path <- html_print(w, background = background, viewer = NULL)
  url <- paste0("file:///", gsub("\\\\", "/", normalizePath(path)))
  webshot(url,
          file = file,
          selector = ".formattable_widget",
          delay = delay)
}


export_formattable(FT,"FT.png")

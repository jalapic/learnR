
## Waffle Charts in ggplot2.  - "square pie-charts"


## Examples taken from:
# https://github.com/hrbrmstr/waffle
# https://rud.is/b/2015/03/18/making-waffle-charts-in-r-with-the-new-waffle-package/


# devtools::install_github("hrbrmstr/waffle")
library(waffle)
library(tidyverse)


# Basic example
parts <- c(80, 30, 20, 10)
waffle(parts, rows=8)
waffle(parts, rows=5)

# example2
parts <- c(`Un-breached\nUS Population`=(318-11-79), `Premera`=11, `Anthem`=79)
parts

waffle(parts, rows=8, size=1, colors=c("#969696", "#1879bf", "#009bda"), legend_pos="bottom") 
waffle(parts/10, rows=3, colors=c("#969696", "#1879bf", "#009bda")) 

#another example:
savings <- c(`Mortgage\n($84,911)`=84911, `Auto and\ntuition loans\n($14,414)`=14414, 
             `Home equity loans\n($10,062)`=10062, `Credit Cards\n($8,565)`=8565)
savings

#(1 square == $392)
waffle(savings/392, rows=7, size=0.5, legend_pos="bottom",
       colors=c("#c7d4b6", "#a3aabd", "#a0d0de", "#97b5cf"))


# a la pie chart
professional <- c(`Male`=44, `Female (56%)`=56)
professional
waffle(professional, rows=10, size=0.5, colors=c("#af9139", "#544616"))


# Paneling waffle plots
iron(
  waffle(c(thing1=0, thing2=100), rows=5),  
  waffle(c(thing1=25, thing2=75), rows=5)
)

iron(
  waffle(c(thing1=0, thing2=100), rows=5, keep=FALSE),  
  waffle(c(thing1=25, thing2=75), rows=5, keep=FALSE)
)



## multi-panel with iron continued...

pain.adult.1997 <- c(`YOY (406)`=406, `Adult (24)`=24)

A <- waffle(pain.adult.1997/2, rows=7, size=0.5, 
            colors=c("#c7d4b6", "#a3aabd"), 
            title="Paine Run Brook Trout Abundance (1997)", 
            xlab="1 square = 2 fish", pad=3)

pine.adult.1997 <- c(`YOY (221)`=221, `Adult (143)`=143)

B <- waffle(pine.adult.1997/2, rows=7, size=0.5, 
            colors=c("#c7d4b6", "#a3aabd"), 
            title="Piney River Brook Trout Abundance (1997)", 
            xlab="1 square = 2 fish", pad=8)

stan.adult.1997 <- c(`YOY (270)`=270, `Adult (197)`=197)

C <- waffle(stan.adult.1997/2, rows=7, size=0.5, 
            colors=c("#c7d4b6", "#a3aabd"), 
            title="Staunton River Trout Abundance (1997)", 
            xlab="1 square = 2 fish")

iron(A, B, C)








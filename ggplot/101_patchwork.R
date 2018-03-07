### Using 'patchwork' to stitch together plots

## https://github.com/thomasp85/patchwork
  
# install.packages("devtools")
devtools::install_github("thomasp85/patchwork")

## might need to install packages 'digest' and 'scales' if not already installed

library(ggplot2)
library(patchwork)


### Putting plots side by side

p1 <- ggplot(mtcars) + geom_point(aes(mpg, disp))
p2 <- ggplot(mtcars) + geom_boxplot(aes(gear, disp, group = gear))

p1 + p2


# or by writing out joining with a +  
ggplot(mtcars) +
  geom_point(aes(mpg, disp)) +
ggplot(mtcars) + 
  geom_boxplot(aes(gear, disp, group = gear))


### Specify layout types

p1 + p2 + plot_layout(ncol = 1, heights = c(3, 1))


## add a space break

p1 + plot_spacer() + p2

p1 + plot_spacer() + theme_void() + p2


## Nested plots - wrap part of the plots in parentheses 

p3 <- ggplot(mtcars) + geom_smooth(aes(disp, qsec))
p4 <- ggplot(mtcars) + geom_bar(aes(carb))

p4 + {
  p1 + {
    p2 +
      p3 +
      plot_layout(ncol = 1)
  }
} +
  plot_layout(ncol = 1)




#### Advanced Syntantic features

## use a '-' or "/" to indicate a new level

p1 + p2 + p3 + plot_layout(ncol = 1)

p1 + p2 - p3 + plot_layout(ncol = 1)


(p1 | p2 | p3) /  p4


## use & or * to add elements to all subplots. The two differ in that * will only affect the plots on the current nesting level:
  
  (p1 + (p2 + p3) + p4 + plot_layout(ncol = 1)) * theme_bw()


# whereas & will recurse into nested levels:
  
  p1 + (p2 + p3) + p4 + plot_layout(ncol = 1) & theme_bw()


  
  

### Cowplot guide - publication quality figures in ggplot2

devtools::install_github("wilkelab/cowplot")


# Examples from https://github.com/wilkelab/cowplot


## 1. Has a default theme similar to theme_classic() but with bigger font sizes.

library(cowplot)
mpg
ggplot(mpg, aes(x = cty, y = hwy, colour = factor(cyl))) +  geom_point(size = 2.5)


plot.mpg <- ggplot(mpg, aes(x = cty, y = hwy, colour = factor(cyl))) +  geom_point(size = 2.5)
plot.mpg


# use save_plot() instead of ggsave() when using cowplot
save_plot("mpg.png", plot.mpg, base_aspect_ratio = 1.3) #change base_aspect_ratio to what you like.


#want gridlines to be back in...  easier than playing around with theme()....
plot.mpg + background_grid(major = "xy", minor = "none")





## 2.  Arranging graphs into a grid


plot.mpg <- ggplot(mpg, aes(x = cty, y = hwy, colour = factor(cyl))) + geom_point(size=2.5)


plot.diamonds <- ggplot(diamonds, aes(clarity, fill = cut)) + geom_bar() + 
                      theme(axis.text.x = element_text(angle=70, vjust=0.5))


plot.mpg
plot.diamonds


#cowplot will arrange plots in the way it thinks looks best:
plot_grid(plot.mpg, plot.diamonds)

#add labels
plot_grid(plot.mpg, plot.diamonds, labels = c("A", "B"))


#e.g. putting five plots in a panel
plot_grid(plot.mpg, plot.diamonds, plot.mpg, plot.diamonds, plot.mpg)

#could change number of rows.
plot_grid(plot.mpg, plot.diamonds, plot.mpg, plot.diamonds, plot.mpg, nrow = 3)


# Align axes
plot_grid(plot.mpg, plot.diamonds, labels = c("A", "B"))
plot_grid(plot.mpg, plot.diamonds, labels = c("A", "B"), align = "h")


#what if you wanted gaps:
plot_grid(plot.mpg, NULL, NULL, plot.diamonds, labels = c("A", "B", "C", "D"), ncol = 2)

#align axes vertically
plot_grid(plot.mpg, plot.diamonds, labels = c("A", "B"), nrow = 2)
plot_grid(plot.mpg, plot.diamonds, labels = c("A", "B"), nrow = 2, align = "v")


#Save these plots to file:
plot2by2 <- plot_grid(plot.mpg, NULL, NULL, plot.diamonds,
labels=c("A", "B", "C", "D"), ncol = 2)

plot2by2

save_plot("plot2by2.png", plot2by2,
ncol = 2, # we're saving a grid plot of 2 columns
nrow = 2, # and 2 rows
# each individual subplot should have an aspect ratio of 1.3
base_aspect_ratio = 1.3
)






## 3. Putting images into multipanel figures.

library(magick) # need this for images

plot.mpg
plot.diamonds

brain <- ggdraw() + draw_image("img/brain.png") 
brain

birds <- ggdraw() + draw_image("img/birds.jpg") 
birds


plot_grid(plot.mpg, brain, birds, plot.diamonds, labels = c("A", "B", "C", "D"), ncol = 2)








## 4. Generic plot annotations

ggdraw(plot.mpg) #The function ggdraw() sets up the drawing layer

ggdraw(plot.mpg) + draw_plot_label("A", size = 14) 
  
ggdraw(plot.mpg) + 
  draw_plot_label("A", size = 14) + 
  draw_label("DRAFT!", angle = 45, size = 80, alpha = .2)

  




## 5. Arranging plots inside of plots.

library(viridis)

ggdraw() +
  draw_plot(plot.diamonds + theme(legend.justification = "bottom"), 0, 0, 1, 1) +
  draw_plot(plot.mpg + scale_color_viridis(discrete = TRUE) + 
              theme(legend.justification = "top"), 0.5, 0.52, 0.5, 0.4) +
  draw_plot_label(c("A", "B"), c(0, 0.5), c(1, 0.92), size = 15)








### The below is directly from various vignettes.  They are for reference - we won't go over these in detail:





# More complex combinations of plots that don't have the same number of visual elements,

# specify the margin along which you want to align
  plot.iris <- ggplot(iris, aes(Sepal.Length, Sepal.Width)) + 
  geom_point() + facet_grid(. ~ Species) + stat_smooth(method = "lm") +
  background_grid(major = 'y', minor = "none") + # add thin horizontal lines 
  panel_border() # and a border around each panel

  
  plot.iris
  
  plot_grid(plot.iris, plot.mpg, labels = "AUTO", ncol = 1, 
          align = 'v', axis = 'l') # aligning vertically along the left axis


## Another example:
  
  bottom_row <- plot_grid(plot.mpg, plot.diamonds, labels = c('B', 'C'), align = 'h', rel_widths = c(1, 1.3))
  plot_grid(plot.iris, bottom_row, labels = c('A', ''), ncol = 1, rel_heights = c(1, 1.2))
  

# Notice how we used rel_heights to make to bottom row higher than the top row.


  ## Adding labels can be tricky
  
# first align the top-row plot (plot.iris) with the left-most plot of the
# bottom row (plot.mpg)
plots <- align_plots(plot.mpg, plot.iris, align = 'v', axis = 'l')

# then build the bottom row
bottom_row <- plot_grid(plots[[1]], plot.diamonds, 
                        labels = c('B', 'C'), align = 'h', rel_widths = c(1, 1.3))

# then combine with the top row for final plot
plot_grid(plots[[2]], bottom_row, labels = c('A', ''), ncol = 1, rel_heights = c(1, 1.2))




## Adding titles to the middle of arranged plots:

# make a plot grid consisting of two panels
p1 <- ggplot(mtcars, aes(x=disp, y=mpg)) + geom_point(colour = "blue") + background_grid(minor='none')
p2 <- ggplot(mtcars, aes(x=hp, y=mpg)) + geom_point(colour = "green") + background_grid(minor='none')
p <- plot_grid(p1, p2, labels=c('A', 'B'))

# now add the title
title <- ggdraw() + draw_label("MPG declines with displacement and horsepower", fontface='bold')
plot_grid(title, p, ncol=1, rel_heights=c(0.1, 1)) # rel_heights values control title margins






### Shared Legends

library(cowplot)
library(grid) # for "unit"

#diamonds dataset modified...
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]

# Make three plots.
# We set left and right margins to 0 to remove unnecessary spacing in the
# final plot arrangement.
p1 <- qplot(carat, price, data=dsamp, colour=clarity) +
  theme(plot.margin = unit(c(6,0,6,0), "pt"))
p2 <- qplot(depth, price, data=dsamp, colour=clarity) +
  theme(plot.margin = unit(c(6,0,6,0), "pt")) + ylab("")
p3 <- qplot(color, price, data=dsamp, colour=clarity) +
  theme(plot.margin = unit(c(6,0,6,0), "pt")) + ylab("")

p1
p2
p3

# arrange the three plots in a single row
prow <- plot_grid( p1 + theme(legend.position="none"),
                   p2 + theme(legend.position="none"),
                   p3 + theme(legend.position="none"),
                   align = 'vh',
                   labels = c("A", "B", "C"),
                   hjust = -1,
                   nrow = 1
)

# Legend to the side:

# extract the legend from one of the plots
# (clearly the whole thing only makes sense if all plots
# have the same legend, so we can arbitrarily pick one.)
legend <- get_legend(p1)

# add the legend to the row we made earlier. Give it one-third of the width
# of one plot (via rel_widths).
p <- plot_grid( prow, legend, rel_widths = c(3, .3))
p


# Legend at the bottom:

# extract the legend from one of the plots
# (clearly the whole thing only makes sense if all plots
# have the same legend, so we can arbitrarily pick one.)
legend_b <- get_legend(p1 + theme(legend.position="bottom"))

# add the legend underneath the row we made earlier. Give it 10% of the height
# of one plot (via rel_heights).
p <- plot_grid( prow, legend_b, ncol = 1, rel_heights = c(1, .2))
p

# Legend between plots:

# arrange the three plots in a single row, leaving space between plot B and C
prow <- plot_grid( p1 + theme(legend.position="none"),
                   p2 + theme(legend.position="none"),
                   NULL,
                   p3 + theme(legend.position="none"),
                   align = 'vh',
                   labels = c("A", "B", "", "C"),
                   hjust = -1,
                   nrow = 1,
                   rel_widths = c(1, 1, .3, 1)
)

prow + draw_grob(legend, 2/3.3, 0, .3/3.3, 1)


## One more example, now with a more complex plot arrangement:

# plot A
p1 <- ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) + 
  geom_point() + facet_grid(. ~ Species) + stat_smooth(method = "lm") +
  background_grid(major = 'y', minor = "none") + 
  panel_border() + theme(legend.position = "none")

# plot B
p2 <- ggplot(iris, aes(Sepal.Length, fill = Species)) +
  geom_density(alpha = .7) + theme(legend.justification = "top")
p2a <- p2 + theme(legend.position = "none")

# plot C
p3 <- ggplot(iris, aes(Sepal.Width, fill = Species)) +
  geom_density(alpha = .7) + theme(legend.position = "none")

# legend
legend <- get_legend(p2)

# align all plots vertically
plots <- align_plots(p1, p2a, p3, align = 'v', axis = 'l')

# put together bottom row and then everything
bottom_row <- plot_grid(plots[[2]], plots[[3]], legend, labels = c("B", "C"), rel_widths = c(1, 1, .3), nrow = 1)
plot_grid(plots[[1]], bottom_row, labels = c("A"), ncol = 1)





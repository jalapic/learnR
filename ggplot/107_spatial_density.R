
## Super quick introduction to spatial density plots.

library(ggplot2)
library(RColorBrewer) # for color scales

# Make a color palette
cols <- rev(brewer.pal(10, "Spectral"))
cols


## Some spatial data with x and y coordinates.
gana  <- read.csv('datasets/gana.csv')
head(gana)
tail(gana)


#basic look
ggplot(data=gana) +  
  stat_density2d(aes(x=as.numeric(x), 
                     y=as.numeric(y), 
                     z=1, 
                     fill = ..density.., 
                     na.rm=TRUE), 
                     geom="tile",  
                     contour = FALSE) 


#with color palette
ggplot(data=gana) +  
  stat_density2d(aes(x=as.numeric(x), 
                     y=as.numeric(y), 
                     z=1, 
                     fill = ..density.., 
                     na.rm=TRUE), 
                 geom="tile",  
                 contour = FALSE) + 
   scale_fill_gradientn(colours=cols)



### Much more extensive tutorial on this to come.

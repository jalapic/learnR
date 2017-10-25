rpres
========================================================
author: 
date: 
autosize: true



First Slide
========================================================

For more details on authoring R presentations please visit <https://support.rstudio.com/hc/en-us/articles/200486468>.

- Bullet 1
- Bullet 2
- Bullet 3

Slide With Code
========================================================


```r
summary(cars)
```

```
     speed           dist       
 Min.   : 4.0   Min.   :  2.00  
 1st Qu.:12.0   1st Qu.: 26.00  
 Median :15.0   Median : 36.00  
 Mean   :15.4   Mean   : 42.98  
 3rd Qu.:19.0   3rd Qu.: 56.00  
 Max.   :25.0   Max.   :120.00  
```

Slide With Plot
========================================================

![plot of chunk unnamed-chunk-2](second_pres-figure/unnamed-chunk-2-1.png)


Slide With a Title
========================================================

![plot of chunk unnamed-chunk-3](second_pres-figure/unnamed-chunk-3-1.png)


Slide With no Title
========================================================
title: false

![plot of chunk unnamed-chunk-4](second_pres-figure/unnamed-chunk-4-1.png)

Code Only Slide
====================================

```r
babynames %>% filter(name=="Brenda") %>%
  ggplot(aes(x=year,y=n, color=sex))+
  geom_line() + theme_minimal() + ggtitle("Brenda")
```


Slide With Image Left
====================================
![pretty cute](cats.jpg)
***
This text will appear to the right


Slide With Image Right
====================================
This text will appear to the right  

- paws
- whiskers
- meow
- rainbow  

***
![pretty cute](cats.jpg)



Images on Slides
====================================

1. When contained within a column, images fill all available space within the column.

2. When the only content on a slide is an image, then the image will fill all available space on the slide.

3. Standalone images (images that appear in their own paragraph) that appear along with text are limited to 50% of vertical space.

 
Kitten
====================================
title: false
![pretty cute](kitten.jpg)


====================================
![pretty cute](kitten.jpg)



Space betweeen title and text
====================================
<br>

I like whitespace between my title and text.

That's why I put a break at the top.



Standard RMarkdown Rules Apply
====================================
<br>

So you can **bold** text, or *italicize* text, or you __*can do both*__




Two-Column Slide
====================================
First column
***
Second column


Two-Column Slide
====================================

![plot of chunk unnamed-chunk-6](second_pres-figure/unnamed-chunk-6-1.png)
***


```r
babynames %>% filter(name=="Kyle") %>%
  ggplot(aes(x=year,y=n, color=sex))+
  geom_line() + theme_minimal() + ggtitle("Kyle")
```




Two-Column Slide
====================================
left: 70%

By default the columns are split equally across the slide. 

If you want to specify that one column gets proportionally more space you can use the left or right field. 

***

less space on this side


Two-Column Slide
====================================
left: 70%

![plot of chunk unnamed-chunk-8](second_pres-figure/unnamed-chunk-8-1.png)

***

The plot on the left shows the distribution of the name Leslie over time.




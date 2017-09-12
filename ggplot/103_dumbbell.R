
### Dumbbell plots 

# Examples taken from those developed by Bob Rudis:
# https://gist.github.com/hrbrmstr/0d206070cea01bcb0118
# https://rud.is/b/2016/04/17/ggplot2-exercising-with-ggalt-dumbbells/

# It's possible to mae our own dummbell plots in ggplot2 using points/lines, 
# however, Bob Rudis has made geom_dumbbell() which is a nice short-cut.
# It's availabel from the ggalt package.


library(tidyverse)
library(scales) # install.packages("scales")
library(ggalt) # install.packages("ggalt")


df <- data.frame(trt=LETTERS[1:5], l=c(20, 40, 10, 30, 50), r=c(70, 50, 30, 60, 80))




## Get Data
health <- read.csv("datasets/health.csv", stringsAsFactors=FALSE)

head(health)


## plot
gg <- ggplot(health, aes(x=pct_2013, xend=pct_2014, y=area_name, group=area_name))
gg <- gg + geom_dumbbell(color="#a3c4dc", size=1.55, colour_xend ="#0e668b", colour_x = "dodgerblue")
gg <- gg + scale_x_continuous(label=percent)
gg <- gg + labs(x=NULL, y=NULL)
gg <- gg + theme_bw()
gg <- gg + theme(plot.background=element_rect(fill="#f7f7f7"))
gg <- gg + theme(panel.background=element_rect(fill="#f7f7f7"))
gg <- gg + theme(panel.grid.minor=element_blank())
gg <- gg + theme(panel.grid.major.y=element_blank())
gg <- gg + theme(panel.grid.major.x=element_line())
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(legend.position="top")
gg <- gg + theme(panel.border=element_blank())
gg



## Example 2: School Earnings.

### Earnings Dumbbell Chart

# this one I'm making without the ggalt package
# it's probably easier to do with dumbbell, but I wrote it before that came out
# a good exercise is to try to make this with geom_dumbbell()

schoolearnings <- read.csv("datasets/schoolearnings.csv", stringsAsFactors=FALSE)
head(schoolearnings)

#Some reodering of levels.
df <- schoolearnings %>% gather(gender,value,2:3)
men <- df %>% filter(gender=="Men") %>% arrange(desc(value)) %>% .$School
df$School <- factor(df$School, levels=rev(men))
schoolearnings$School <- factor(schoolearnings$School, levels=rev(men))

head(schoolearnings)

# plot
ggplot() + 
  geom_segment(data=schoolearnings, aes(x=Women, xend=Men, y=School, yend=School), color="gray77",lwd=1)+
  geom_point(data=df, aes(value, School, group=gender,color=gender), size=5) +
  scale_color_manual(values=c("thistle4", "tomato4"))+
  scale_x_continuous(breaks = seq(60,160,20), labels=c("$60k", "$80k","$100k","$120k","$140k","$160k")) +
  ggtitle("Gender earnings disparity - 10 years after enrollment") +
  xlab("") + ylab("") +
  theme(
    plot.title = element_text(hjust=0,vjust=1, size=rel(2.3)),
    panel.background = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color="gray70",linetype = c("28")),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    plot.background  = element_blank(),
    text = element_text(color="gray20", size=10),
    axis.text = element_text(size=rel(1.0)),
    axis.text.x = element_text(color="gray20",size=rel(1.8)),
    axis.text.y = element_text(color="gray20", size=rel(1.6)),
    axis.title.x = element_text(size=rel(1.5), vjust=0),
    axis.title.y = element_text(size=rel(1.5), vjust=1),
    axis.ticks.y = element_blank(),
    axis.ticks.x = element_blank(),
    legend.position = "right",
    legend.title=element_blank(),
    legend.text=element_text(size=rel(1.3))
  )











## More complex example - but shows you what is possible. 

# Difference in Social Media usage by country/age

# Taken from here:  https://rud.is/b/2016/04/17/ggplot2-exercising-with-ggalt-dumbbells/

df <- read.csv("datasets/socialmedia.csv", stringsAsFactors = F)

head(df)

# we only want the first line values with "%" symbols (to avoid chart junk)
# quick hack; there is a more efficient way to do this
percent_first <- function(x) {
  x <- sprintf("%d%%", round(x*100))
  x[2:length(x)] <- sub("%$", "", x[2:length(x)])
  x
}

gg <- ggplot()

gg <- gg + geom_segment(data=df, aes(y=country, yend=country, x=0, xend=1), color="#b2b2b2", size=0.15)

gg <- gg + geom_dumbbell(data=df, aes(y=country, x=ages_35, xend=ages_18_to_34),
                         size=1.5, color="#b2b2b2", size_x=3, size_xend=3,
                         colour_x ="#9fb059", colour_xend="#edae52")

#text below points
gg <- gg + geom_text(data=filter(df, country=="Germany"),
                     aes(x=ages_35, y=country, label="Ages 35+"),
                     color="#9fb059", size=3, vjust=-2, fontface="bold")

gg <- gg + geom_text(data=filter(df, country=="Germany"),
                     aes(x=ages_18_to_34, y=country, label="Ages 18-34"),
                     color="#edae52", size=3, vjust=-2, fontface="bold")

# text above points
gg <- gg + geom_text(data=df, aes(x=ages_35, y=country, label=percent_first(ages_35)),
                     color="#9fb059", size=2.75, vjust=2.5, family="Calibri")
gg <- gg + geom_text(data=df, color="#edae52", size=2.75, vjust=2.5, family="Calibri",
                     aes(x=ages_18_to_34, y=country, label=percent_first(ages_18_to_34)))
# difference column
gg <- gg + geom_rect(data=df, aes(xmin=1.05, xmax=1.175, ymin=-Inf, ymax=Inf), fill="#efefe3")
gg <- gg + geom_text(data=df, aes(label=diff, y=country, x=1.1125), fontface="bold", size=3, family="Calibri")
gg <- gg + geom_text(data=filter(df, country=="Germany"), aes(x=1.1125, y=country, label="DIFF"),
                     color="#7a7d7e", size=3.1, vjust=-2, fontface="bold", family="Calibri")
gg <- gg + scale_x_continuous(expand=c(0,0), limits=c(0, 1.175))
gg <- gg + scale_y_discrete(expand=c(0.075,0))
gg <- gg + labs(x=NULL, y=NULL, title="The social media age gap",
                subtitle="Adult internet users or reported smartphone owners who\nuse social networking sites",
                caption="Source: Pew Research Center, Spring 2015 Global Attitudes Survey. Q74")
gg <- gg + theme_bw(base_family="Calibri")
gg <- gg + theme(panel.grid.major=element_blank())
gg <- gg + theme(panel.grid.minor=element_blank())
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(axis.text.x=element_blank())
gg <- gg + theme(plot.title=element_text(face="bold"))
gg <- gg + theme(plot.subtitle=element_text(face="italic", size=9, margin=margin(b=12)))
gg <- gg + theme(plot.caption=element_text(size=7, margin=margin(t=12), color="#7a7d7e"))
gg

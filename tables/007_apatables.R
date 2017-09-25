## Two packages for making tables in APA style.

# library(apaTables)
# library(apaStyle) - I won't go through this one.


devtools::install_github("dstanley4/apaTables")  #is on CRAN but I had some issues so using dev version
library(apaTables)

# See here for more info: https://github.com/dstanley4/apaTables/issues


head(attitude)  # example data
dim(attitude)



### Correlation table

apa.cor.table(attitude)
apa.cor.table(attitude, show.conf.interval=FALSE)
apa.cor.table(attitude, filename="Table1.doc")
apa.cor.table(attitude, show.conf.interval=FALSE, filename="Table2.doc")
apa.cor.table(attitude, filename="Table1_APA.doc", table.number=1)



### Regression table

head(album)

# Single block example
blk1 <- lm(sales ~ adverts + airplay, data=album)
summary(blk1)
apa.reg.table(blk1)
apa.reg.table(blk1,filename="exRegTable.doc")


# Two block example, more than two blocks can be used
blk1 <- lm(sales ~ adverts, data=album)
blk2 <- lm(sales ~ adverts + airplay + attract, data=album)
apa.reg.table(blk1,blk2,filename="exRegBlocksTable.doc")


# Interaction product-term test with blocks
blk1 <- lm(sales ~ adverts + airplay, data=album)
blk2 <- lm(sales ~ adverts + airplay + I(adverts * airplay), data=album)
apa.reg.table(blk1,blk2,filename="exInteraction1.doc")


# Interaction product-term test with blocks and additional product terms
blk1<-lm(sales ~ adverts + airplay, data=album)
blk2<-lm(sales ~ adverts + airplay + I(adverts*adverts) + I(airplay*airplay), data=album)
blk3<-lm(sales~adverts+airplay+I(adverts*adverts)+I(airplay*airplay)+I(adverts*airplay),data=album)
apa.reg.table(blk1,blk2,blk3,filename="exInteraction2.doc")

#Interaction product-term test with single regression (i.e., semi-partial correlation focus)
blk1 <- lm(sales ~ adverts + airplay + I(adverts * airplay), data=album)
apa.reg.table(blk1,filename="exInteraction3.doc")





### 1-way ANOVA
head(viagra)
table(viagra$dose, viagra$libido)

options(contrasts = c("contr.sum", "contr.poly")) #read more on contasts here: http://faculty.nps.edu/sebuttre/home/R/contrasts.html
lm_output <- lm(libido ~ dose, data=viagra) #make sure variables are factors.
summary(lm_output)


apa.aov.table(lm_output,filename="Figure4_APA.doc",table.number = 4)


# The apa.1way.table function creates a table with the mean and sd for each cell; see Table 5.
apa.1way.table(iv=dose,dv=libido,data=viagra,filename="Figure5_APA.doc",table.number = 5)

# The apa.d.table function show a d-value (with confidence interval) for each paired comparison; see Table 6.
apa.d.table(iv=dose,dv=libido,data=viagra,filename="Figure6_APA.doc",table.number = 6)


### N-way ANOVA tables: 2-way Example

head(goggles)
table(goggles$gender, goggles$alcohol)

options(contrasts = c("contr.sum", "contr.poly"))
lm_output <- lm(attractiveness ~ gender*alcohol, data=goggles)
apa.aov.table(lm_output,filename="Figure7_APA.doc",table.number = 7)

apa.2way.table(iv1=gender,iv2=alcohol,dv=attractiveness,data=goggles,filename="Figure8_APA.doc",table.number = 8)

library(apaTables)
library(dplyr)
goggles.men   <- filter(goggles,gender=="Male")
goggles.women <- filter(goggles,gender=="Female")

apa.d.table(iv=alcohol,dv=attractiveness,data=goggles.men,filename="Table9_APA.doc",table.number = 9)
apa.d.table(iv=alcohol,dv=attractiveness,data=goggles.women,filename="Table10_APA.doc",table.number = 10)





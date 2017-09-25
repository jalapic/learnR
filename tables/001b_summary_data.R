
### Making Some Custom Tables of Summary Data


# see stargazer, apaTables for examples too.  e.g. for APA or other journal styles.


# This example shows you how to make your own custom table.  
# you can adapt this to be the way you want your table to look.




## Simple summary statistics.

library(gapminder)
library(tidyverse)

gapminder %>% filter(year==2007) %>% group_by(continent) %>%
  summarise(mean=mean(lifeExp, na.rm=T), 
            sd=sd(lifeExp, na.rm=T),
            total = n(), 
            se = sd/sqrt(total),
            median=median(lifeExp, na.rm=T),
            lqr=quantile(lifeExp, .25),
            uqr=quantile(lifeExp,.75)
            ) -> df

df


# example: means +/- se. (one dp) and N

df1 <-df[c(1,2,5,4)]
df1[,2:3]<-round(df1[,2:3],1) #round to 1dp
df1$mean.se <- paste(paste(df1$mean, '\u00B1'),df1$se)
df2 <- df1[c(1,5,4)]
colnames(df2)<-c("Continent", paste(paste("Mean",'\u00B1',"SEM")), "N")



df2 #this is our summary table




#viewing in html table in browser
library(xtable)
print.xtable(xtable(df2), type="html", file="output.html", include.rownames=F)

rstudioapi::viewer("output.html") #just using this to make it pop up in browser

## you could copy and paste the above and then put into word (==bad, but if it works....)



#if want to view in viewer pane
file.copy("~/output.html", file.path(tempdir(), "test.html"))
myViewer(file.path(tempdir(), "test.html"))





#if you want to export it to a word document...

# 1. Just open the 'output.html' file above and copy/paste to word (ugh)


# 2. You can  also do this.... but it's also very sub-optimal:
write.table(df2, file = "summarystats.txt", sep = ",", quote = FALSE, row.names = F)
# copy .txt text to word and select  Table>Convert_Text_To_Table  (ugh)


# 3. with "rtf" package:   (this is the best option for export).

library(rtf)
rtffile <- RTF("rtf.doc")  # this can be an .rtf or a .doc
addParagraph(rtffile, "Title of the table followed by a line-break:\n")
addTable(rtffile,df2)
done(rtffile)






####  Example 2:
library(BaM) # for data

head(fdr)

sem <- function(x) {sd(x)/sqrt(length(x))} # standard error function

#when wanting to get results for all columns - creates new columns
fdr %>%
  group_by(FDR) %>%
  select(-State) %>%
  summarise_each(funs(mean,sem))


#pasting means/sem for one column - note round's behavior for 1 dp when ends in .0
fdr %>%
  group_by(FDR) %>%
  select(-State) %>%
  summarise(PreDep = paste( round(mean(PRE.DEP),1),  " [", round(sem(PRE.DEP),1), "]", sep="" ))


## by the way... round does have bad behavior in one other instance:

round(0.501, 1)
round(0.5, 1)
round(0.501, 0)
round(0.5, 0) #hmm
round(1.5, 0)

#use this instead
round_ = function(x, n=0) {scale<-10^n; trunc(x*scale+sign(x)*0.5)/scale}

round_(0.5, 0)
round_(1.5, 0)


#better to use format with round
fdr %>%
  group_by(FDR) %>%
  select(-State) %>%
  summarise(PreDep = paste( 
                       format(round(mean(PRE.DEP),1), nsmall = 1),  
                        " [", 
                       format(round(sem(PRE.DEP),1), nsmall = 1), 
                       "]", 
                       sep="" )
            )





#do that for all 3 groups - just copy and edit the parts for each column.

fdr %>%
  group_by(FDR) %>%
  select(-State) %>%
  summarise(

  PreDep = paste( 
    format(round(mean(PRE.DEP),1), nsmall = 1),  
    " [", 
    format(round(sem(PRE.DEP),1), nsmall = 1), 
    "]", 
    sep="" ),
  
  PostDep = paste( 
    format(round(mean(POST.DEP),1), nsmall = 1),  
    " [", 
    format(round(sem(POST.DEP),1), nsmall = 1), 
    "]", 
    sep="" ),
  
  Farm = paste( 
    format(round(mean(FARM),1), nsmall = 1),  
    " [", 
    format(round(sem(FARM),1), nsmall = 1), 
    "]", 
    sep="" )
  
  ) -> fdr1


fdr1
fdr1$FDR <- c("NO", "YES")
fdr1

#export to word
library(rtf)
rtffile <- RTF("rtf.doc")  # this can be an .rtf or a .doc
addParagraph(rtffile, "Table 1. Income and % Farming by States FDR Voting:\n")
addTable(rtffile,fdr1)
done(rtffile)

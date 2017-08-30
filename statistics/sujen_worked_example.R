###  STEM SRL Data File  - from Su-Jen

# Packages
library(tidyverse)


# 1. Set Working Directory.

getwd() #what is current directory R is working from?
setwd("C:/Users/James Curley/Dropbox/Work/R/sujen/")




# 2. Import Data. - either by running code below, or by using "Import Dataset" Menu on right hand side.

srl_data <- readxl::read_excel("datasets/srl_data.xlsx")

# notice that the raw data has two rows at the top that are column/variable header types.
# "tidy data" practice asks us to only have one


# I'm going to save the questions so we can refer back to them:
df <- data.frame(question = colnames(srl_data)) #notice duplicated variable headers

srl_data[1,] #first row of our R dataframe (was 2nd row of excel file).

df$question2 <- unlist(srl_data[1,])

df[1:10,]

df[17,] #e.g. 17th row - Q29_11 = "Please rate your agreement with the following statements.-Scientific laws, theories, and concepts are continually being tested."

write.csv(df, "datasets/srl_questions.csv", row.names=F)  ## Saving the Questions as a separate csv file:






# 3. reimport from csv, but skip some rows

# You can do this from the dropdown menu, or use code
# I'm doing this from a 'csv' rather than 'xls' file as csv is kinder to dates (doesn't try to convert to numbers)

srl <- readr::read_csv("datasets/srl_data.csv", col_names = FALSE, skip = 2)

dim(srl)
head(srl)


# I'm now going to add back in the colnames from the previous file to help us know what's what.

colnames(srl)

colnames(srl) <- colnames(srl_data)

colnames(srl)

srl <- as.data.frame(srl) # I'm making it a dataframe so we can see everything in next few steps #don't need to do this

srl[1:5,1:10]



#### 4. Fix those pesky column names.
colnames(srl)

duplicated(colnames(srl))

ifelse(duplicated(colnames(srl)), paste0('x', colnames(srl)), colnames(srl))

colnames(srl) <- ifelse(duplicated(colnames(srl)), paste0('x', colnames(srl)), colnames(srl))



# In the original data, there are actually a number of duplicates - Q29, Q30, Q31, Q32, Q33
# However read.excel worked this out and made them e.g. Q29_1, Q33_1

# the first Q33 (8th column is "What's the name of your school")
# the second Q33 (9th column is "What's your survey id")


srl[,8]  # this is basically empty (except one answer)
srl[,9]  # this has a number of survey ids, though not all rows do.  In the next-step we're asked to only keep data where the is a survey id.




colnames(srl)

# we really should rename that problem column:
colnames(srl)[9] <- "survey.id"





# 5. Clean data: remove rows with no survey IDs (Q33, column I) = 9th column

srl[,9] #just to remind us


colnames(srl)

srl$survey.id  #same as srl[,9] now


is.na(srl$survey.id)

srl[is.na(srl$survey.id),] # select all the rows where TRUE is

srl[!is.na(srl$survey.id),] # select all the rows where FALSE is

srl2 <- srl[!is.na(srl$survey.id),]




### 6. Reversals: Reverse code some variables so 5-->1, 4-->2, 3-->3, 2-->4, and 1-->5; 
# Variables Q16_8 (column L), Q29_10 (column P), Q35_3 (column S), Q35_8 need to be reverse coded

srl2[,'Q16_8']
srl2$Q16_8
srl2[,12]

rates <- data.frame(rating=1:5, newrating=5:1)

srl2$Q16_8 <- rates$newrating[match(srl2$Q16_8, rates$rating)]
srl2$Q29_10 <- rates$newrating[match(srl2$Q29_10, rates$rating)]
srl2$Q35_3 <- rates$newrating[match(srl2$Q35_3, rates$rating)]
srl2$Q35_8 <- rates$newrating[match(srl2$Q35_8, rates$rating)]




### 7. Scale reliability: check reliability using Chronbach's alpha (psych package). 


# Set of questions that make up the STEM literacy scale: 
# (Q16_2, Q16_4, Q16_8, Q16_11, Q16_12, Q29_9, Q29_10, Q29_11, Q29_13, Q35_3R, Q35_6, Q35_9, Q35_7, Q35_8)    

colnames(srl2)
colnames(srl2)[10:23]  #These are the columns we need for STEM literary scale

srl_cron <- srl2[,10:23]

psych::alpha(srl_cron)

psych::alpha(srl_cron,check.keys=TRUE)



### 8. If reliable (alpha>.7), calculate mean STEM literacy score for each respondent and make a new variable.

srl2$meanSTEM <- apply(srl_cron, 1, mean, na.rm=T)
srl2$nSTEM <- apply(srl_cron, 1, function(x) sum(x>0, na.rm=T))

hist(srl2$meanSTEM)



### 9. Identify groups: 
# Create new variable to label schools (Q32, column G) as control or experimental 
# Control schools were: 35, 38, 40, 41, 43, 46, 60, 66, 68, 69. 
# Experimental schools were all the rest: 37, 39, 44, 47, 48, 51, 53, 54, 55, 56, 59, 61, 63, 67, 70. 
# Other = 100

srl2[,7]
srl2$Q32


schools <-
  data.frame(
    group = c(rep("control", 10), rep("experimental", 20), NA),
    number = c(35,38,40,41,43,46,60,66,68,69,37,39,44,47,48,51,53,54,55,56,59,61,63,67,70,35,38,40,43,54,100)
  )




schools

srl2$school.group <- schools$group[match(srl2$Q32, schools$number)]

srl2$school.group

srl2 <- srl2[!is.na(srl2$school.group),]  

srl2[1:10,1:10]

### 10. Question: Did respondent STEM literacy differ between the control and experimental groups?

ggplot(srl2, aes(x=school.group, y=meanSTEM, color=school.group, fill=school.group)) +
  geom_boxplot(alpha=.05) + geom_point()


# remove values where we have too few values from STEM questionairre
srl3 <- srl2[srl2$nSTEM>=5,]

# plot by school group
ggplot(srl3, aes(x=school.group, y=meanSTEM, color=school.group, fill=school.group)) +
  geom_boxplot(alpha=.05) + geom_point()

# beeswarm plot
library(ggbeeswarm)
ggplot(srl3, aes(x=school.group, y=meanSTEM, color=school.group)) +
  geom_beeswarm(cex=1.2,priority='density')

# plot by school
ggplot(srl3, aes(x=factor(Q32), y=meanSTEM, color=school.group, fill=school.group)) +
  geom_boxplot(alpha=.05) + geom_point()



## Using a GLM (though this doesn't account for school level effects)
fit <- glm(meanSTEM ~ school.group, data=srl3)
summary(fit)
plot(fit) #not great fit for model


# I would probably analyze using a mixed-effects model.
library(lme4)
library(lmerTest)
fit1 <- lmer(meanSTEM ~ (1|Q32) + school.group, data=srl3)
summary(fit1)
plot(fit1)
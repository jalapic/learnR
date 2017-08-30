### Basic Factor Analysis

library(tidyverse)
library(psych)

df <- read.csv("datasets/personality.csv")  # personality measures of 240 people on 32 traits (self-report).
# data from Bertram Malle (Stanford)


## Data needs to be in numeric only columns
head(df)


#Validate sampling adequacy.
psych::KMO(df)  #KMO of >0.8 is "mertitourious"  / "MSA" = measure of sampling adequacy
psych::cortest.mat(cor(df), n1=240)   #Bartlett Test is significant = good.


# you may wish to scale your variables
df = as.data.frame(scale(df))


#Parallel analysis:
psych::fa.parallel(df) #5 factors.


#Run Factor Analysis
fit<-psych::fa(df,nfactors=5, rotate="varimax", scores="regression")  #rotate="none" if no rotation wanted.
fit  
plot(fit)


## Just get loadings
## Highlight those scores >.5
fit$loadings

as.data.frame.matrix(fit$loadings)

df.loadings <- as.data.frame.matrix(fit$loadings)
df.loadings
df.loadings[abs(df.loadings)<.5]<-NA

df.loadings



# Individual Factor Scores
res <- psych::factor.scores(df,fit, method = c("Thurstone"))
res  
res$scores
hist(res$scores)

# Are factors independent of each other?
plot(res$scores[,1], res$scores[,2])
cor.test(res$scores[,1], res$scores[,2])



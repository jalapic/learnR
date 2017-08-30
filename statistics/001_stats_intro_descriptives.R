
### Basic Stats ----

states <- read.csv("datasets/states.csv")

head(states)


## Correlations + simple linear regression:


## Need data for correlation analysis in two columns - each row being an observation of x vs y.


#Does gdpPercap and lifeExp correlate?

plot(states$high, states$income)


cor(states$high, states$income) # default is Pearson's

cor.test(states$high, states$income) # default is Pearson's

cor.test(states$high, states$income, method='spearman') # do Spearman instead


fit <- lm(income ~ high, data=states)  # ~  means 'is predicted by'
summary(fit)
plot(fit)

# The first plot is a standard residual plot showing residuals against fitted values.
# Points that tend towards being outliers are labeled. 
# If any pattern is apparent in the points on this plot, then the linear model may not be the appropriate one.

# The second plot is a normal quantile plot of the residuals. Check for normal distribution of residuals.

# The last plot shows residuals vs. leverage (undue influence). 
# Labeled points on this plot represent cases we may want to investigate as possibly having undue 
# influence on the regression relationship. 






### Testing Differences: 2 sample T-tests / Mann-Whitney Test ---

# need two vector values

## e.g. difference in college degree % between Dem vs Republican states in 2016 election?

dems <- subset(states, election16=="D")
repubs <- subset(states, election16=="R")

ggplot(states, aes(x=election16, y=income)) + geom_point()


t.test(dems$income, repubs$income)
t.test(dems$income, repubs$income, var.equal=T) #SPSS default



#testing for normality
hist(states$income)
shapiro.test(states$income) 

wilcox.test(dems$income, repubs$income)



## One-tailed test.
t.test(dems$high, repubs$high, alternative="greater")

t.test(states$college, mu=22) # is college education sig different from mean of 22





### Paired T-tests:

library(gapminder)

head(gapminder)

gap1952 <- subset(gapminder, year==1952)
gap2007 <- subset(gapminder, year==2007)

t.test(gap1952$lifeExp, gap2007$lifeExp, paired=T)

wilcox.test(gap1952$lifeExp, gap2007$lifeExp, paired=T)


gap1 <- subset(gapminder, year==1952 | year==2007)
gap1
ggplot(gap1, aes(x=year, y=lifeExp)) + geom_point()
ggplot(gap1, aes(x=year, y=lifeExp,group=country)) + geom_point() + geom_line(alpha=.4)









### Basic Stats: One Way ANOVA & post-hoc tests ----

head(states)

boxplot(msat~region, data=states) 

aov(msat~region, data=states) 

fit <- aov(msat~region, data=states) 
summary(fit)


# post-hoc tests - various correction methods
pairwise.t.test(states$msat, states$region, p.adj = "none")
pairwise.t.test(states$msat, states$region, p.adj = "bonf")
pairwise.t.test(states$msat, states$region, p.adj = "holm")





### Kruskal Wallis Tests - non-parametric between groups 

kruskal.test(msat~region, data=states) 


# multiple-comparisons - there's a useful function in PMCMR for this:
PMCMR::posthoc.kruskal.nemenyi.test(msat~region, data=states, dist="Chisquare")









####   binomial, chi-sq, fisher-exact tests

binom.test(x=20, n=55)  #x = number of successes,  n = number of trials


# for chi-sq and fisher tests, we need data in tables (or matrices):

table(states$region, states$election16)
M <- table(states$region, states$election16)
M

chisq.test(M)
fisher.test(M)







#### Summary of Descriptive Stats Functions

min(states$college, na.rm=T)
max(states$college, na.rm=T)
range(states$college, na.rm=T)
IQR(states$college, na.rm=T)
median (states$college, na.rm=T)
mean (states$college, na.rm=T)

quantile(states$college, 0.25)
quantile(states$college, 0.75)

quantile(states$college, c(0.25, 0.5, 0.75), type = 9, na.rm=T)   #look up help function for types

standarddev <- sd(states$college, na.rm=T)

n <- length(states$college)
serr <- standarddev / sqrt(n)

sem <- function(x) sd(x, na.rm=T)/sqrt(length(x))

sem(states$college)

summary(states)
psych::describe(states)     # gives way more detail than summary() from base package






### Some simple character string manipulations and other helpful things

# paste
# round/format
# gsub/sub
# substr
# grepl
# regex
# tolower/toupper
# strplit




### paste

paste("james", "curley")
paste("james", "curley", sep=" ")
paste("james", "curley", sep=":")


paste(c("james", "rachel"), c("curley", "smith"), sep=":")

first <- c("james", "brad", "hannah", "steve")
second <- c("jones", "brown", "garcia", "evans")

first
second
paste(first, second, sep="-")

paste0(first,second)
paste("james", "curley", sep="")



# nb. pasting multiple things together.
# can do all in one paste - but have to keep same "sep".  If need different "sep"s need different paste().
x<-4.5
y<-1.3
paste(x," [", y, "]")
paste(x," [", y, "]", sep="")
paste(x,": ", y, sep="")



### using round to print numbers - watch out for decimal place behavior.

round(0.501, 1)
round(0.5, 1)
round(0.501, 0)
round(0.5, 0) #hmm
round(1.5, 0)

#use this instead
round_ = function(x, n=0) {scale<-10^n; trunc(x*scale+sign(x)*0.5)/scale}

round_(0.5, 0)
round_(1.5, 0)


#  Use format with round to ensure correct behavior.

x <- 3.0045
round(x,2)
format(round(x,2), nsmall=2) #forces it into text.

paste("Mean  = ", round(x,2))
paste("Mean  = ", format(round(x,2), nsmall=2))









### gsub / sub

# gsub replaces specific text with other text
  vals <- c("80%", "45%", "99%")
  vals
  as.numeric(gsub("%", "",vals))
  gsub("%", "***$$$***",vals)
  

  x <- c("This is a sentence and is written out.")
  
  gsub("is", "is not", x)   #hmmm
  gsub(" is", " is not", x) #one way round it   - better is to use regex
  sub("is", "is not", x)     # sub only picks first "is"
  sub(" is", " is not", x)   # again 'sub' only replaces first one
  
  #gsub = "global sub"
  
  
  
## Some regex examples as a sample/taster (longer tutorial on regex available)  
  # [there are more than 1 way of doing each...]
# see here also: http://stat545.com/block022_regular-expression.html  
  
# only keep numbers

x <-  c("asdfa34934", "dsfa454", "432dsfadsf234", "34ZZP:a")
regmatches(x,gregexpr('[0-9]+',x))

gsub("[0-9]","",x)  # remove digits
gsub("[^0-9]","",x)  # only keep digits



# only keep  letters
gsub("[A-Za-z]","",x)   #remove upper + lower case
gsub("[^A-Za-z]","",x)  # only keep upper + lower case

gsub("[^a-z]","",x)  
gsub("[^A-Z]","",x)


  
# remove all punctuation (only keep letters,numbers,spaces)
x <- c("thi$$//\\s 9$099sf == in+oinf @@ safxsdf", "sdf@9a,,sdf", "xa.sdf!a32")  
x
gsub("[^[:alnum:][:space:]]","",x)
gsub("[^[A-Za-z0-9][:space:]]","",x)




# only  keep info after last full-stop
x <- c("james.curley", "john.johnson", "julie.alex.anderson", "a.n.other")  
x
sub('.*\\.', '', x)  
  



# only keep info before first slash
x <- c("23/12/1934","2/1/30", "01/11")
x
sub('\\/.*', '', x) # looks for first / then replaces everything after it with "" i.e. nothing



    
# extract everything between brackets
x <- c("what is [redacted]", "i [redacted] did not [something]")  
x

gsub("\\[[^\\]]*\\]", "", x, perl=TRUE);  # keep everything outside

regmatches(x, gregexpr("\\[.*?\\]", x))

lapply(regmatches(x, gregexpr("\\[.*?\\]", x)), function(x) gsub("[^[:alnum:][:space:]]","", x)) #this is sub-optimal



# remove all whitespace

trim.leading <- function (x)  sub("^\\s+", "", x) # returns string w/o leading whitespace
trim.trailing <- function (x) sub("\\s+$", "", x) # returns string w/o trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)   # returns string w/o leading or trailing whitespace

x <- c("    trailing at front", "trailing at back        ", "   trailing in both directions    ")  
  
x 

trim.leading(x)  
trim.trailing(x)  
trim(x)  





### change case and letters
tolower(c("JAMES", "appLE", "53x34op"))
toupper(c("JAMES", "appLE", "53x34op"))
LETTERS[1:4]
letters[1:10]


## Capitalizing
x <- c("james", "john", "junior")
gsub("\\b(\\w)",    "\\U\\1",       x, perl=TRUE)

x <- c("james curley", "anne-marie harrison")
gsub("(\\w)(\\w*)", "\\U\\1\\E\\2\\U\\3", x, perl=TRUE)  
gsub("(\\w)(\\w*)(\\w)", "\\U\\1\\E\\2\\U\\3", x, perl=TRUE)   #silly

  

###  substring from left or right - get n characters
  
  ids <- c("00304953434", "003043433333434", "0034343432334342")
  ids1 <- c("0303","0334", "0454")
  ids1  
  
  nchar(ids)
  
  substr(ids1, 2, 4)

substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

substrRight(ids, 4)






### grepl - filter and look for stuff

sam <- c("Peru","Argentina", "Bolivia", "Colombia", "Venezuela", "Paraguay", "Chile",
  "Brazil", "Ecuador", "Guyana", "Suriname", "Uruguay", "Falkland Islands",
  "French Guiana", "South Georgia and the South Sandwich Islands")

sam

grepl("x",  sam)

grepl("z",  sam)
sam[grepl("z",  sam)]

grepl("gu",  sam)
sam[grepl("gu",  sam)]




## strsplit

x <- c("sometimes/words/need/to/be/split/by/the/same/thing")
x
strsplit(x,"/")



x <- c(as = "asfef", qu = "qwerty", "yuiop[", "b", "stuff.blah.yech")
strsplit(x, "e")




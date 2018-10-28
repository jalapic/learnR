# learning packages exercise: topicmodels
# Yujin Kim (EID: yk6863)
# reference sources: https://www.tidytextmining.com/topicmodeling.html & https://www.kaggle.com/rtatman/nlp-in-r-topic-modelling
#  I only share this partial data of the comments data that articles have more than 2000 comments.

library(tm) # text mining 
library(data.table) # for fast reading csv files
library(tidytext) # tidy implimentation of NLP methods

library(tidyverse)
library(ggplot2)
library(topicmodels) # for LDA topic modeling

#' already stemmed comments in NYT from 01/01/2012 ~ 12/31/2012
#' nyt_comment2012 <- fread("stem_2012.csv",sep=",", header=TRUE)

#' assetid: identifies the article on which the comment was posted. We don't know what the original article was about (only have comments data)
#' length(unique(nyt_comment2012$assetid)) # 50196.

#' numcommentsarticle: an article-level variable that provides a count of the number of comments posed on an article
#' summary(unique(nyt_comment2012$numcommentsarticle)) # summary of unique # of comments posted on an article
#' hist(unique(nyt_comment2012$numcommentsarticle))
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1.0   271.5   543.0   639.1   848.0  3825.0

#' for convenience, only use the articles with # of comments posted more than 2000; 
#' previously tried topic modeling with the multiple comment datasets a) more than the median (543 comments; takes about 30% of the total dataset) and b) more than 1000 comments; takes 10% of the total dataset. Still it's too large for article-level and takes a long time to process in R
#' to compare supervised topic modeling, dataset with # of comments posted more than 2000 is used.
#' note: still, this is little bit sketchy to extract dataset because the 2012 year is randomly chosen and some comments are omitted before and after 2012.

#' partial data that I shared
#' comment_2000 <- nyt_comment2012 %>% select(stem, assetid, numcommentsarticle, NumWords, date) %>% filter(numcommentsarticle >= 2000 )

#' write.csv(comment_2000,"comment_2000.csv", row.names = FALSE)

# filter comments more than 3 words (I only share this partial data)
comment_2000 <- fread("comment_2000.csv",sep=",", header=TRUE)
comment_2000 <- comment_2000 %>% filter(NumWords > 3 ) # filter # of words more than 3


# 58022/2788025*100 = 2.08% (out of the entire dataset)
length(unique(comment_2000$assetid)) # 23 articles

### Pre-processing for informative words

# create a document term matrix to clean
commentCorpus <- Corpus(VectorSource(comment_2000$stem)) # creating a vector source of raw text and making it as corpus
commentDTM <- DocumentTermMatrix(commentCorpus) # construct corpus as document term matrix

# convert the document term matrix to a tidytext corpus
commentDTM_tidy <- tidy(commentDTM) # long format as each row has each word from one comment

# original text didn't remove hyperlinks such as urls (I found them after trying this modeling a couple of times)
custom_stop_words <- tibble(word = c("href", "blank", "http")) 

# take the tidy dtm and remove both English and custom stopwords
commentDTM_tidy_cleaned <- commentDTM_tidy %>% 
  anti_join(stop_words, by = c("term" = "word")) %>% 
  anti_join(custom_stop_words, by = c("term" = "word"))

# reconstruct cleaned documents # this takes a lot of time if the dataset is too large..
cleaned_documents <- commentDTM_tidy_cleaned %>%
  group_by(document) %>% 
  mutate(terms = toString(rep(term, count))) %>%
  select(document, terms) %>%
  unique()

head(cleaned_documents)

### Unsupervised topic modeling with LDA (Latent Dirichlet Allocation)
### Unsupervised modeling finds natural groups of items even when we’re not sure what we’re looking for, or it's used if you don't have labeled examples of the thing you're trying to figure out.
### Each document is going to have some subset of topics in it, and that each topic is associated with a certain subset of words. 
### but words can also belong to more than one topic.

# LDA (Latent Dirichlet Allocation) is one method for fitting a topic model (weighting term frequency)
Corpus <- Corpus(VectorSource(cleaned_documents$terms)) 
DTM <- DocumentTermMatrix(Corpus) 

unique_indexes <- unique(DTM$i) # get the index of each unique value
DTM <- DTM[unique_indexes,] # get a subset of only those indexes

# modeling LDA
system.time({ 
  lda <- LDA(DTM, k = 23, control = list(seed = 1234)) # k means the number of topics; set seed for consistent results; I tried k as 5 and 10. Later I chose k as 23 because I know the number of articles in data. If the number of topics increase, it takes longer time... 
})

### time: 200 sec (3 min 20 sec) on my mac.

topics <- tidy(lda, matrix = "beta") # beta means the per-topic-per-word probabilities from the model

top_terms <- topics  %>% # take the topics data frame and..
  group_by(topic) %>% # treat each topic as a different group
  top_n(10, beta) %>% # get the top 10 most informative words
  ungroup() %>% # ungroup
  arrange(topic, -beta)

# plotting
p <- top_terms %>% # take the top terms
  mutate(term = reorder(term, beta)) %>% # sort terms by beta value 
  ggplot(aes(term, beta, fill = factor(topic))) + # plot beta by theme
  geom_col(show.legend = FALSE) + # remove legend
  facet_wrap(~ topic, scales = "free") + 
  labs(x = NULL, y = "Beta") + # no x label, change y label 
  coord_flip() # turn bars sideways

p

#' Try supervised topic modeling with TF-IDF (term frequency-inverse document frequency) because we know how many articles are in the dataset.
#' to reflect how important a word is to a document in a collection or corpus (weighting)
#' a) term frequency: the number of times a term occurs in a document 
# 'b) an inverse document frequency: taking both decreasing the weight of terms that occur very frequently in the document (e.g., "the") and increasing the weight of terms that occur rarely.
#' A term will recieve a high weight if it's common in a specific document and also uncommon across all documents.

# get the count of each word in each comment
words <- comment_2000 %>%
  unnest_tokens(word, stem) %>%
  count(assetid, word) %>% 
  ungroup()

# get the number of words per article
total_words <- words %>% 
  group_by(assetid) %>% 
  summarize(total = sum(n))

# combine the two dataframes we just made
words <- left_join(words, total_words, by = "assetid")

# get the tf_idf (binding the term frequency and inverse document frequency) & order the words by degree of relevence
tf_idf <- words %>%
  bind_tf_idf(word, assetid, n) %>% 
  arrange(desc(tf_idf)) %>%
  mutate(word = factor(word, levels = rev(unique(word)))) 

# plotting
q <-  tf_idf %>% 
  group_by(assetid) %>% 
  top_n(10) %>%
  ggplot(aes(word, tf_idf, fill = as.factor(assetid))) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "tf-idf") +
  facet_wrap(~assetid, scales = "free") +
  coord_flip()

q

#' Comparing both unsupervise (LDA) and supervised (TF-IDF) models, supervised modeling seems to yield accurate classification because it has more information from the data. To produce useful findings from unsupervised modeling, it may need to optimize the model and reduce noise from the dataset. 

#' found the actual articles by using the top 10 words on Google;
#' for 3314334: https://www.nytimes.com/2012/04/03/us/justices-approve-strip-searches-for-any-offense.html # APRIL 2, 2012
#' for 3318923: https://www.nytimes.com/2012/05/06/magazine/romneys-former-bain-partner-makes-a-case-for-inequality.html # MAT 1, 2012
#' for 3320221: https://www.nytimes.com/2012/05/07/us/politics/biden-expresses-support-for-same-sex-marriages.html # MAY 6, 2012
#' for 3326657: https://www.nytimes.com/2012/06/21/opinion/a-pointless-partisan-fight.html #JUNE 20, 2012
#' for 3330866: https://www.nytimes.com/2012/07/21/us/shooting-at-colorado-theater-showing-batman-movie.html # JULY 20, 2012
#' for 3339689: https://www.nytimes.com/2012/09/19/us/historian-says-piece-of-papyrus-refers-to-jesus-wife.html # SEP 18, 2012
#' for 3346426: https://www.nytimes.com/2012/09/23/magazine/nate-silver-solves-the-swing-state-puzzle.html # SEP 18, 2012
#' for 3349425: https://www.nytimes.com/2012/11/28/us/politics/after-benghazi-meeting-3-republicans-say-concerns-grow-over-rice.html # NOV 27
#' for 3351844: https://www.nytimes.com/2012/12/17/us/politics/bloomberg-urges-obama-to-take-action-on-gun-control.html # DEC 16, 2012

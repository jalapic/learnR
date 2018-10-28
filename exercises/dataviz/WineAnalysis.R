#https://www.kaggle.com/zynicide/wine-reviews
#~130,000 wine reviews
#"description: A few sentences from a sommelier describing the wine's taste, smell, look, feel, etc."
#"variety: The type of grapes used to make the wine (ie Pinot Noir)"

setwd("~/Desktop/R for Behavioral Scientists/Datasets")
library(tidyverse)
library(quanteda)
wines <- read_rds("winereviews.Rdata")

#select top 10 wines
topten <- wines %>%
  select(description, variety) %>%
  group_by(variety) %>%
  tally() %>%
  arrange(-n) %>%
  head(10) %>%
  .$variety

#concatenate characters by wine type
winesten <- wines %>%
  mutate(color = case_when(variety %in% c("Merlot", 
                                          "Cabernet Sauvignon", 
                                          "Pinot Noir", 
                                          "Red Blend", 
                                          "Bordeaux-style Red Blend", 
                                          "Syrah") ~ "Red",
                           variety %in% c("Chardonnay", 
                                          "Sauvignon Blanc", 
                                          "Riesling", 
                                          "Rosé") ~ "White")) %>%
  filter(variety %in% topten) %>%
  group_by(variety, color) %>%
  summarise(descr = paste0(description, collapse = ""))
  
#create corpus
winestencorpus <- corpus(winesten, text_field = "descr")
docnames(winestencorpus) <- docvars(winestencorpus)$variety
summary(winestencorpus)

#create document feature matrix
my_dfm_wine <- dfm(winestencorpus, tolower = TRUE, stem = FALSE, remove_punct = TRUE, remove = c(stopwords("english"), "wine", "Merlot", "Cabernet", "Sauvignon", "Pinot", "Noir", "Blend", "Bordeaux-style", "Syrah", "Chardonnay", "Riesling", "Rosé"))

#create frequency plot for top 50 words across all wine types
features_dfm <- textstat_frequency(my_dfm_wine, n = 50)
features_dfm$feature <- with(features_dfm, reorder(feature, -frequency))

ggplot(data = features_dfm) +
  geom_point(mapping = aes(x = feature, y = frequency)) +
  labs(title = "Top 50 most frequent words") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 

#plot raw frequency of usage of target word for each wine types
freq_grouped <- textstat_frequency(my_dfm_wine, groups = "variety")
freq_group_tannins <- subset(freq_grouped, freq_grouped$feature %in% "tannins")  

ggplot(freq_group_tannins, aes(x = group, y = frequency)) +
  geom_point() + 
  xlab(NULL) + 
  labs(title = "Raw frequency of word 'tannins' in descriptions of each wine type",
       y = "Frequency") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

#plot relative frequency of usage of target word for every 100 words for each wine types
dfm_rel_freq_wine <- dfm_weight(my_dfm_wine, scheme = "prop") * 100
rel_freq_grouped <- textstat_frequency(dfm_rel_freq_wine, groups = "variety")
rel_freq_group_tannins <- subset(rel_freq_grouped, feature %in% "tannins")  

ggplot(rel_freq_group_tannins, aes(x = group, y = frequency)) +
    geom_point() + 
    xlab(NULL) + 
    labs(title = "Expected frequency of word 'tannins' in descriptions of each wine type, for every 100 words",
         subtitle = "Count of target word divided by count of all words in description times 100",
         y = "Frequency") +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))

#create document-feature matrix grouped by wine color
color_group_wine_dfm <- dfm(winestencorpus, groups = "color", tolower = TRUE, stem = FALSE, remove_punct = TRUE, remove = c(stopwords("english"), "wine", "Merlot", "Cabernet", "Sauvignon", "Pinot", "Noir", "Blend", "Bordeaux-style", "Syrah", "Chardonnay", "Riesling", "Rosé"))

#plot keyness of words
result_keyness <- textstat_keyness(color_group_wine_dfm, target = "Red")
textplot_keyness(result_keyness, color = c("red", "gray")) +
  labs(title = "Keyness of words in descriptions of red vs. white wines",
       subtitle = "Degree to which word is distinguishing feature of descriptions of red vs. white wine")


library(keras)
library(dplyr)
library(ggplot2)
library(purrr)

#install_keras()
imdb <- dataset_imdb(num_words = 10000)  # keep top 10000 most used words
#c(train_data, train_labels) %<-% imdb$train
#c(test_data, test_labels) %<-% imdb$test
train_data <- imdb$train$x
train_labels <- imdb$train$y
test_data <- imdb$test$x
test_labels <- imdb$test$y


#decode integers back into original reviews
word_index <- dataset_imdb_word_index()  #download index mapping words to integers
reverse_word_index <- names(word_index)
names(reverse_word_index) <- word_index

#paste0("Training entries: ", length(train_data), ", labels: ", length(train_labels))
train_data[[1]]
length(train_data[[1]])

word_index_df <- data.frame(
  word = names(word_index),
  idx = unlist(word_index, use.names = FALSE),
  stringsAsFactors = FALSE
)

word_index_df <- word_index_df %>% mutate(idx = idx + 3)
word_index_df <- word_index_df %>%
  add_row(word = "<PAD>", idx = 0)%>%
  add_row(word = "<START>", idx = 1)%>%
  add_row(word = "<UNK>", idx = 2)%>%
  add_row(word = "<UNUSED>", idx = 3)  # The first 4 indices are reserved  
word_index_df <- word_index_df %>% arrange(idx)

decode_review <- function(text){
  paste(map(text, function(number) word_index_df %>%
              filter(idx == number) %>%
              select(word) %>% 
              pull()),
        collapse = " ")
}
decode_review(train_data[[1]])

#hot encode (pad) lists as vectors of length 10000 full of 1s and 0s
# vectorize_sequences <- function(sequences, dimension = 10000) {
#   # Creates an all-zero matrix of shape (length(sequences), dimension)
#   results <- matrix(0, nrow = length(sequences), ncol = dimension) 
#   for (i in 1:length(sequences))
#     # Sets specific indices of results[i] to 1s
#     results[i, sequences[[i]]] <- 1 
#   results
# }
# x_train <- vectorize_sequences(train_data)
# x_test <- vectorize_sequences(test_data)
# y_train <- as.numeric(train_labels)
# y_test <- as.numeric(test_labels)


train_data <- pad_sequences(
  train_data,
  value = word_index_df %>% filter(word == "<PAD>") %>% select(idx) %>% pull(),
  padding = "post",
  maxlen = 256
)
test_data <- pad_sequences(
  test_data,
  value = word_index_df %>% filter(word == "<PAD>") %>% select(idx) %>% pull(),
  padding = "post",
  maxlen = 256
)
length(train_data[1,])


#build neural network
model <- keras_model_sequential() %>% 
  layer_dense(units = 16, activation = "relu", input_shape = c(10000)) %>% 
  layer_dense(units = 16, activation = "relu") %>% 
  layer_dense(units = 1, activation = "sigmoid")

model %>% summary()

model %>% compile(
  optimizer = "rmsprop",
  loss = "binary_crossentropy",
  metrics = c("accuracy")
)


#create validation set
val_indices <- 1:10000
x_val <- x_train[val_indices,]
partial_x_train <- x_train[-val_indices,]
y_val <- y_train[val_indices]
partial_y_train <- y_train[-val_indices]


# train model
history <- model %>% fit(
  partial_x_train,
  partial_y_train,
  epochs = 20,
  batch_size = 512,
  validation_data = list(x_val, y_val)
)


#plot accuracy and loss
plot(history)


#train new model and evaluate test data
model %>% fit(x_train, 
              y_train, 
              epochs = 4, 
              batch_size = 512)
results <- model %>% evaluate(x_test, y_test)
results
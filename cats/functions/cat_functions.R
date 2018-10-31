## Function to Make Age Column

get_age <- function(df){

x <- df %>% separate(col=age_upon_outcome,
                  into = c("age_number","time"),
                  sep=" ") 

x$age_number <- as.numeric(x$age_number)

x$age <- ifelse(grepl("day", x$time)==T, x$age_number*1, ifelse(grepl("week", x$time)==T, x$age_number*7,
ifelse(grepl("month", x$time)==T, x$age_number*30,
ifelse(grepl("year", x$time)==T, x$age_number*365,
NA))))

return(x)  
}
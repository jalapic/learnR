setwd("C:/Users/James Curley/Dropbox/Work/R/sujen")

library(wakefield)

set.seed(1)
df=data.frame(
  animal=animal(300), dob=dob(300), sex=sex(300), 
  grade=grade(300), likert1=likert(300), likert2=likert_7(300),
  val1= r_sample(300), val2=r_sample(300),
  val3=r_sample_binary(300),val4=r_sample_binary(300),zip=zip_code(300)
)
df
write.csv(df, "animals.csv", row.names=F)

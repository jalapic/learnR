Computers. You are strongly encouraged to bring a laptop to class with R and RStudio installed. Both programs are freely available.  

R for Windows, Mac and Linux can be downloaded and installed from this webpage: https://cran.cnr.berkeley.edu/ . 

Follow the links for your respective operating system and click on the link that states “install R for the first time”.  

Once R is installed, RStudio can be downloaded and installed from this webpage: 
https://www.rstudio.com/products/rstudio/download/#download . 

If you have previously downloaded R and RStudio it is recommended that you reinstall the latest versions.

After installing RStudio, please install the following add-on packages for R. To install the libraries, make sure you have an Internet connection and then launch R Studio. Copy the following line of text and paste them in to R's command prompt, located in the window named "Console"). After inserting the text press enter. You may be prompted occasionally with a question asking if you wish to install. Type “Y” and then enter. 

install.packages(c("tidyverse", "broom", "coefplot", "gapminder", "ggrepel",  "car", "Hmisc", "psych", "ggm",
"outliers",  "gvlma",  "gplots", "HH", "babynames", "ggplot2", "reshape2", "GGally", "ppcor", "ltm", "polycor", "scales", "MASS", "devtools"), repos = "http://cran.rstudio.com")

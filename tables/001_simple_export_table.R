### Exporting tables in R


### e.g. Simple raw data - want to store it in a table format.



# example data
library(gapminder)
library(tidyverse)

gapminder %>% filter(country=="China") -> china
china


##  CSV


#  save dataset (without rownames) as a csv file to your working directory:
write.table(china, "china.csv", row.names=F)










### What options are there if you just want to save it as a PDF or word document ?


# The simplest is probably to use the 'rtf' package:
library(rtf)
rtffile <- RTF("china.doc")  # this can be an .rtf or a .doc
addParagraph(rtffile, "Life-Expectancy, Population and GDP in China:\n")
addTable(rtffile,china)
done(rtffile)





# A crude but it works option -  view as HTML table, copy/paste (don't do it, but it is a shortcut)

library(xtable)
china.xt<-xtable(china)
print.xtable(china.xt, type="html", file="filename.html")  #saved to your WD.

# Open the generated HTML file in your browser
# Copy the table contents and paste them into your word processor
# Might be a quick way of formatting tables in e.g. Word.  (I'm still not a fan of doing this, but you can)




## Another option... (can also use this to add images/plots etc to word document)

# This works, but you should just skip to the pandoc package below:

library(ReporteRs)

doc <- docx() #initiate a new word document
doc <- addTitle(doc, "Table 1. Chinese Life Expectancy")
doc <- addFlexTable( doc, FlexTable(china))
doc <- addParagraph(doc, c("", "")) # 2 line breaks
writeDoc(doc, file = "newfile.docx")

# see: http://www.sthda.com/english/wiki/create-and-format-word-documents-using-r-software-and-reporters-package





### More advanced, but better option...  pandoc package:


library(pander)
# installr::install.pandoc()  #need to run this first., takes a while.

pandoc.table(china)
pandoc.table(china, style = "grid", caption = "China's Population, Life Expectancy & GDP by Year")

# see http://rapporter.github.io/pander/#pander-an-r-pandoc-writer for more info



# Making a report using pandoc

## Initialize a new Pandoc object
myReport <- Pandoc$new()

## Add author, title and date of document
myReport$author <- 'James Curley'
myReport$title  <- 'Important Project'

## Add a header
myReport$add.paragraph('# Supplementary Table 1')

## Add dataset
myReport$add(china)

## View report
myReport

## Exporting to PDF (default)
myReport$export()

## Or to docx in tempdir():
myReport$format <- 'docx'
myReport$export(tempfile())

## To go back to PDF
myReport$format <- 'pdf'
myReport$export()


# This should also work well if dataset is very long or wide.


# See pandoc tutorial for  more longer tutorial.

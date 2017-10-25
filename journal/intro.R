### Using papaja to write APA articles

### 1. Get the latest versions of RStudio and R

# RStudio > v1.0.44 
# R  > v3.3.2. 




### 2. Install TeX

##  Windows: MikTeX https://miktex.org/
##  Mac: MacTeX: http://www.tug.org/mactex/




### 3. Install the papaja R package from GitHub

# install.packages("devtools")   # In case you don't have devtools installed
devtools::install_github("crsh/papaja")
library(papaja)


### 4. Make files

# New File -> RMarkdown -> From Template -> APA Style
# template appears - you can edit this. (look at my edits in second example)

# Adding/Updating a bibtex file.  .bib file
# File -> New File -> Text File. 
# save this blank file as "references.bib"  (or "anything.bib").


# BibTeX is a reference format:
# You can get BibTeX references from Google Scholar, Zotero,  Endnote.



### 5. Tell your RMarkdown where your .bib file is.

# update the name of the bibliography file in the appropriate fields at the top of your .Rmd document.
# the template has 3 places to change.
# if not in same folder as .Rmd doc then make sure to tell it where it is.





### Some tips:

# when displaying tables, useful to put [   results='asis' ] in R chunk.
# e.g. with the apa_table() function that will format a table in APA style


# if you get  an error about encoding - it might be that a foreign letter is in your .bib file. Check this.









### Example BibTeX format:
@online{harry_largest_2017,
  title = {The largest Git repo on the planet},
  url = {https://blogs.msdn.microsoft.com/bharry/2017/05/24/the-largest-git-repo-on-the-planet/},
  author = {Harry, Brian},
  urldate = {2017-06-20},
  date = {2017},
  note = {00000}
}

@article{markowetz_five_2015,
  title = {Five Selfish Reasons to Work Reproducibly},
  volume = {16},
  rights = {2015 Markowetz.},
  issn = {1465-6906},
  doi = {10.1186/s13059-015-0850-7},
  timestamp = {2016-08-17T16:37:37Z},
  langid = {english},
  number = {1},
  journaltitle = {Genome Biology},
  author = {Markowetz, Florian},
  urldate = {2015-12-09},
  date = {2015-12-08},
  pages = {274},
  note = {00000},
  keywords = {Reproducibility,Scientific career}
}

@book{bryan_happy_2017,
  title = {Happy {{Git}} and {{GitHub}} for the {{useR}}},
  url = {http://happygitwithr.com/},
  timestamp = {2017-05-29T19:57:38Z},
  author = {Bryan, Jennifer},
  urldate = {2017-04-24},
  date = {2017},
  note = {00000}
}




# learnR

This repo contains materials related to teaching _"R Programming for Behavioral Scientists"_ - taught by Prof Curley - UT Austin, Psychology, Fall 2017.

The materials are  designed to be used during class with instruction by Prof Curley, but can be read alone also.

  
   
<br/>   


---    
 

<br/>


## Weekly Material

<br/>

### Week 1.  Introduction to R – Data Structures & Syntax

Aim: The first week will introduce the R programming language. Students will become familiar with basic programming concepts such as data structures, functions, and objects. Students will learn basic R syntax and become familiar with commonly used base R functions.

During the first class students will also take a background skills and knowledge questionnaire, as well as a values questionnaire where students will describe their thoughts related to how important they value particular concepts such as reproducibility and data visualization.


Values Questionnaire: https://tinyurl.com/y8dzthga

Skills Questionnaire: https://tinyurl.com/y98ctpbh

 

Reading: Please read Chapter 3-6 of R. Cotton, Learning R: A Step-by-Step Function Guide to Data Analysis, O’Reilly, 2013. 
 
<br/>
 

### Week 2. Data Carpentry

Aim: Students will learn how to import and export data from RStudio. Students will learn how to summarize data and how to reorganize and work flexibly with raw data.

Reading: Chapter 5, 11 & 12 of G. Grolemund & H.Wickham, R for Data Science, O’Reilly, 2016. You can access this book online for free here:   http://r4ds.had.co.nz/

Please familiarize yourself  with the material. Don't worry if you get lost with the code - we will work through it together in class.  I would like you to get a sense of the purpose of being able to transform data in different ways using code.

After class, students will complete a data carpentry challenge to be submitted prior to class of week 3.

 
<br/>
 

 

### Weeks 3-4   Data Visualization I & II

Aim: Students will learn how to visualize and explore data using the ggplot2 package. Students will become familiar with how to choose the most appropriate data visualization for different data types by adjust aesthetics and chart types. Students will learn Leland Wilkinson’s grammar of graphics approach to data visualization.

Before Class II (week4): Students will complete a makeover challenge assignment and submit prior to the class. This challenge will consist of a poor visualization of data that the students will be asked to improve or come up with different ways in which the data could be visually represented.

 

The following reading materials are for reference.  Please have a look through to familiarize yourself for the class:

<br/> 

_Overview of "grammar of graphics" principles:_

Chapter 3 of G. Grolemund & H.Wickham, R for Data Science, O’Reilly, 2016.  http://r4ds.had.co.nz/

<br/>

_Overview of good data visualization principles with reference to ggplot2:_

Data Visualization for Social Science: A practical introduction with R and ggplot2 - Kieran Healy   -  http://socviz.co/

<br/>

_A very helpful blogpost containing many tips to making ggplot2 charts look beautiful:_

Zev Ross blog post - http://zevross.com/blog/2014/08/04/beautiful-plotting-in-r-a-ggplot2-  cheatsheet-3/

<br/> 

_The ggplot2 help pages are also a great guide_

The most up to date would be here: http://ggplot2.tidyverse.org/index.html

<br/>



**Makeover challenge for Week 4:**
The goal of this exercise is to 'improve' a data visualization that is loose in the wild.  In particular, I want you to think about data visualization principles that we have discussed in class. What are the key messages to illustrate?  What is the most effective type of plot for these data?  How many/much color, annotation, text, lines or shapes should I include in the visualization?  Alternatively, you may decide that the original visualization did not highlight important findings and you think there is a more interesting story in the data to show.

Which dataset/visualization should I choose to makeover? 

-  The best resource for this makover challenge is the community website - "#MakeoverMonday - A weekly social data project".  If you go here: http://www.makeovermonday.co.uk/data/ you will find scores of raw datasets and links to articles that have included visualizations based on the dataset.  Please choose one that interests you and start creating new visualizations !   It may be that just one visualization is sufficient, or you may wish to make several based on the dataset of your choice.   (Note: many of these challenges were taken up by Tableau users who typically make more complex 'dashboard' or 'infographic' style visualizations. Don't be discouraged by this. We are interested largely in creating simple, elegant charts similar to those we'd use for research output).

- Alternatively, you may wish to find your own data.  You could retrieve this from anywhere e.g. newspapers, fivethirtyeight's data - https://github.com/fivethirtyeight/data , or published research in open-access journal articles.  

If you need any advice on what to choose - please ask Dr Curley.  In week 4, students will present their visualization and design choices in class. Each person will give a quick 5-10 minute presentation on their choices.  To help you - here is a link to one makeover that I completed myself:  
https://raw.githubusercontent.com/jalapic/learnR/master/exercises/curley_makeover.R


<br/>


### Week 5. Learning R Packages -  plus extra work on joins, strings and tables

It's important to be able to self-learn when learning R  programming. This involves being able to work through blog posts, vignettes, help documentation.  Sometimes this can be very difficult and obscure, but the more we practice the easier we find learning new concepts.  We shall go over this especially when discussing the following topics:

Also this week, we will go over the following:

- joins in R:   how to join datasets using dplyr's join function.
- string manipulation:  A brief primer on working with character strings in R.
- tables:  making and exporting to word/pdf/RMarkdown tables - including output of models, raw data tables and summary statistics tables.

<br>


### Weeks 6-7. Group Data Carpentry & Visualization Project

The goals of these two weeks are to:

- increase your knowledge of working with large, messy datasets in R
- improve data carpentry skills
- develop the ability to discern key information and narratives from raw data
- generate publication quality data visualizations
- produce reproducible data analysis
- work with others in a group to share skills and tasks collaboratively

Before the first class:  Have a look at the datasets below and let me know which you would have a preference on working on - this will help with assigning groups.


In the first class, groups of 2-3 will be assigned.  The first step will be to explore the different datasets and become familiar with data issues.  
Secondly, begin to explore and generate potential research questiosns. This step usually involves producing exploratory visualizations.
You may also wish to bring in related data from other datasets to help with your analysis.

Throughout this class, you can ask me questions if you get stuck. This will provide an opportunity for me to identify which tasks/skills we need to discuss in more detail.

The second class will provide an opportunity to finalize visualizations and code.  This should be reproducible such that anybody can follow your analysis. 
Please post the finished work as a Gist.  You are encouraged to work on the project during the week too !


*Possible Datasets for Group Projects*

* American National Election Studies Datasets
   http://www.electionstudies.org/studypages/download/datacenter_all_NoData.php
   also see here for an example:  https://raw.githubusercontent.com/jalapic/learnR/master/datasets/makeover/anes.csv
   
* Federal Election Commission Data:  
    https://www.fec.gov
    https://www.fec.gov/data/
    http://classic.fec.gov/finance/disclosure/ftpdet.shtml
    http://classic.fec.gov/portal/download.shtml 
    see here for an example: https://raw.githubusercontent.com/jalapic/learnR/master/datasets/makeover/CandidateSummaryAction.csv

* Kaggle has many large datasets - https://www.kaggle.com/datasets  - we will view these

* One of your own choice (e.g. large research project from your lab).

<br>


### Weeks 8-9. Producing Reproducible Reports with RNotebooks, RMarkdown and Project Management

The aims of these two weeks are to:

- learn RMarkdown syntax
- understand how to make reproducible reports with RNotebooks & RMarkodwn
- learn how to customize report outputs in RMarkdown with CSS/HTML/chunk options
- recognize the significance of using R Projects for maintaing good workflow in our research
- know how to write a journal paper completely with script in RStudio
- learn how to make slides using RStudio

Exercise:  The exercise for this class will be due before week 9.   This exercise will require students to produce their own reproducible report using RNotebooks or RMarkdown.




<br/>



### Week 10: Reproducibility Exercise

In class each student will look up five research articles from Psychology journals in 2017.  For each, record whether data and/or code are provided along with the manuscript.  We will then attempt to reproduce the analyses of each paper.  We shall also discuss the merits of reproducibility and some of the ethical and practical issues surrounding open science.

<br>

### Week 11: Version Control using Git

In this class we shall discuss the merits and benefits of version control.  We will discuss how using Git and GitHub can facilitate open science research, and how we can manage our projects more effectively.

<br>

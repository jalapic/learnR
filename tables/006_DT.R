### Tables for Raw Data - DT package.


## DT tables

# The R package DT provides an R interface to the JavaScript library DataTables.

# It's just one function  datatable()  with some extensions...



# Advantages: 

  #  Excellent in RMarkdown documents for data exploration and presentation
  #  Works very  well with interactive Shiny documents.

# Can also use in plain RStudio for data exploration.


###

library(DT)
library(gapminder) # for the example data

head(gapminder)

datatable(gapminder)



## Styling tables with CSS  - see here: https://datatables.net/manual/styling/classes


# row striping, row highlighting on mouse over, row borders, highlighting ordered columns. 

datatable(head(gapminder), class = 'cell-border stripe') #note: this is just top 6 rows to show

datatable(gapminder, class = 'compact hover') 


# get rid of rwonames
datatable(head(gapminder), rownames = FALSE)  # no row names


# change column names
datatable(head(gapminder), colnames = c('Country', 'Cont.', 'Year', 'LifeExp', 'Population','GDPcap'))


# just one column name
datatable(head(gapminder), rownames = FALSE)
datatable(head(gapminder), colnames = c('Expectancy' = 'lifeExp'))
datatable(head(gapminder), colnames = c('Population' = 5, 'GDP' = 6),rownames = F) #need rownames=F


# Add a simple caption
datatable(
  head(gapminder),
  caption = 'Table 1: This is a simple caption for the table.'
)



### Filter by Column

datatable(gapminder, filter = 'top', options = list(
  pageLength = 7, autoWidth = TRUE
))          
# Notice that clicking the search boxes leads to different controls:
  


### Get Rid of all the stuff around the table
datatable(gapminder, options = list(dom = 't'))

### Just the top search boxes
datatable(gapminder, filter = 'top', options = list(dom = 't'))

### Just  the very top box 
datatable(gapminder, options = list(dom = 'ft'))

### Enable highlighting of searches
datatable(gapminder, options = list(searchHighlight = TRUE))


### Funky option for picking which columns to keep/remove on the fly            
# useful if have many columns and only want to explore some.
datatable(gapminder, rownames = FALSE,
          extensions = 'Buttons', options = list(dom = 'Bfrtip', buttons = I('colvis'))
            )



### If have very wide table and want to fix column 1 and last column so can scroll:


# example data:
m = as.data.frame(round(matrix(rnorm(100), 5), 5))
datatable(
  m, extensions = 'FixedColumns',
  options = list(
    dom = 't',
    scrollX = TRUE,
    fixedColumns = TRUE
  )
)

m

# fix some left 2 columns [row numbers and V1] and right 1 column
datatable(
  m, extensions = 'FixedColumns',
  options = list(
    dom = 't',
    scrollX = TRUE,
    fixedColumns = list(leftColumns = 2, rightColumns = 1)
  )
)


## Use the DT like excel (unlikely you want to but maybe a use e.g. checking values?)
datatable(gapminder, extensions = 'KeyTable', options = list(keys = TRUE))



            







### DT & formattable.

# Example data

products <- data.frame(id = 1:5, 
                       price = c(10, 15, 12, 8, 9),
                       rating = c(5, 4, 4, 3, 4),
                       market_share = c('0.1%', '0.12%', '0.05%', '0.03%', '0.14%'),
                       revenue = c(55000, 36400, 12000, -25000, 98100),
                       profit = c(25300, 11500, -8200, -46000, 65000))
products

sign_formatter <- formatter("span", 
                            style = x ~ style(color = ifelse(x > 0, "blue", 
                                                             ifelse(x < 0, "red", "black"))))

as.datatable(formattable(products, list(
  price = color_tile("transparent", "lightpink"),
  revenue = sign_formatter,
  profit = sign_formatter)))


# Can combine datatable() options inside as.datatable() function:
as.datatable(formattable(products, list(
  price = color_tile("transparent", "lightpink"),
  revenue = sign_formatter,
  profit = sign_formatter)),
  
   options = list(dom = 't'),
   caption = 'Table 1: Product Valuations and Ratings'
)

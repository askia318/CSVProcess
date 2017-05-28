# CSVProcess

The goal of CSVProcess is to process a CSV file into a tibble, take a deeper look by filter and plot a diagram. 

## Installation

You can install CSVProcess from github with:

```R
# install.packages("devtools")
devtools::install_github("CSVProcess/askia318")
```

## Example

It will read csv file "accident_2013.csv.bz2" and transfer it into a tibble.

```R
fars_read("accident_2013.csv.bz2")
```



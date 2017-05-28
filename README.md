# CSVProcess

The goal of CSVProcess is to process a CSV file into a tibble, take a deeper look by filter and plot a diagram. 

## Installation

You can install CSVProcess from github with:

```R
# install.packages("devtools")
devtools::install_github("CSVProcess/askia318")
```

## Example

* It will read csv file "accident_2013.csv.bz2" and transfer it into a tibble.

```R
fars_read("accident_2013.csv.bz2")
```

* It will transfer the inputted year into an integer and output a character "accident_'year'.csv.bz2"
```R
make_filename(2013)
```

* It will read files in the form "accident_'year'.csv.bz2" where 'year' is inputted by user, read the data as a tibble and then select columns 'MONTH' and 'year' as output.

```R
years <- list(2013,2014)
fars_read_years(years)
```

* This function calls fars_read_years to read files in "accident_'year'.csv.bz2" form and outputs a tibble with column 'MONTH' and 'year' first. Then it unlists (MONTH, year) pairs, groups them, and counts their numbers. Finally, it "reshapes" the output as a tibble with "MONTH", "years" form where "years" is the list in the input.

```R
years <- list(2013,2014)
fars_summarize_years(years)
```

* The function first transfers the input 'year' into a character as "accident_'year'.csv.bz2"
and read the file "accident_'year'.csv.bz2" as a tibble valued as 'data', then it also
transfers the input state.num' as an integer. Moreover, if the field 'data$STATE' does not
contain 'state.num', the function will stop and print a message.
If data$STATE contains state.num but has nothing to plot, the function will print
"no accidents to plot" and return invisible diagram; otherwise the function will plot
a diagram with LONGITUD in x-asix and LATITUDE in y-asix with points to indicate the
distrubution. You can input the year using \code{state.num,year} argument.

```R
fars_map_state(42,2013)
```

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_functions.R
\name{fars_map_state}
\alias{fars_map_state}
\title{Read CSV, Filter state.num and Plot its Point Diagram}
\usage{
fars_map_state(state.num, year)
}
\arguments{
\item{state.num}{the state number you want to filter in the data}

\item{year}{the you want to process}
}
\value{
a graph with polts to show distrubitions in (LONGITUD,LATITUDE)
}
\description{
The function first transfers the input 'year' into a character as "accident_'year'.csv.bz2"
and read the file "accident_'year'.csv.bz2" as a tibble valued as 'data', then it also
transfers the input state.num' as an integer. Moreover, if the field 'data$STATE' does not
contain 'state.num', the function will stop and print a message.
If data$STATE contains state.num but has nothing to plot, the function will print
"no accidents to plot" and return invisible diagram; otherwise the function will plot
a diagram with LONGITUD in x-asix and LATITUDE in y-asix with points to indicate the
distrubution. You can input the year using \code{state.num,year} argument.
}
\examples{
fars_map_state(42,2013)

}

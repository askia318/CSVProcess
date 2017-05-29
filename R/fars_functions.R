#' Read CSV file into a tibble
#'
#' This is a simple function which first reads 'filename' file in the working directory and
#' then outputs it as a tibble. You can input filename (using the \code{filename} argument).
#' It the file does not exist in the working directory, the function will stop and print an
#' error message; otherwise the function will call 'read_csv' function in "readr" package and
#' 'tbl_df' function in "dplyr" package to read and transform the file into a tibble.
#'
#' @param filename The name of the file you want to process
#'
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df
#'
#' @return The function returns the content of the file in a tibble
#'
#' @examples
#' \donotrun{
#' fars_read("accident_2013.csv.bz2")
#' }
#'
#' @export
fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}


#' Make a character as "accident_'year'.csv.bz2"
#'
#' The function will transfer the year you input into an integer and output as a character
#' named "accident_'year'.csv.bz2". You can input the year using \code{year} argument.
#'
#' @param year The year you want to process
#'
#' @return The function returns a character in the form "accident_'year'.csv.bz2"
#'
#' @examples
#' \donotrun{
#' make_filename(2013)
#' }
#'
#'
#' @export
make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("../data/accident_%d.csv.bz2", year)
}

#' Read CSV file and Filter data by Month and Year
#'
#' The function will read files in the form "accident_'year'.csv.bz2" where 'year' is inputted
#' by user, read the data as a tibble and then select columns 'MONTH' and 'year' as output.
#' If file "accident_'year'.csv.bz2" does not exist, it will print a warning message and return
#' NULL. You can input the year using \code{list(years)} argument.
#'
#' @param years The years in list you want to process
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom dplyr "%>%"
#'
#' @return a tibble with columns 'MONTH' and 'year'
#'
#' @examples
#' \donotrun{
#' years <- list(2013,2014)
#' fars_read_years(years)
#' }
#'
#' @export
fars_read_years <- function(years) {
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dplyr::mutate(dat, year = year) %>%
                                dplyr::select(MONTH, year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}


#' Read CSV, Filter data by MONTH and year, and Summarize its counts
#'
#' This function calls fars_read_years to read files in "accident_'year'.csv.bz2" form and
#' outputs a tibble with column 'MONTH' and 'year' first. Then it unlists (MONTH, year) pairs,
#' groups them, and counts their numbers. Finally, it "reshapes" the output as a tibble
#' with "MONTH", "years" form where "years" is the list in the input.
#' You can input the year using \code{list(years)} argument.
#'
#' @param years The years in list you want to process
#'
#' @importFrom dplyr bind_rows
#' @importFrom dplyr group_by
#' @importFrom dplyr summarize
#' @importFrom tidyr spread
#' @importFrom dplyr "%>%"
#'
#' @return a tibble with columns 'MONTH' and 'years'
#'
#' @examples
#' \donotrun{
#' years <- list(2013,2014)
#' fars_summarize_years(years)
#' }

#'
#' @export
fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by_(year, MONTH) %>%
                dplyr::summarize_(n = n()) %>%
                tidyr::spread(year, n)
}

#' Read CSV, Filter state.num and Plot its Point Diagram
#'
#' The function first transfers the input 'year' into a character as "accident_'year'.csv.bz2"
#' and read the file "accident_'year'.csv.bz2" as a tibble valued as 'data', then it also
#' transfers the input state.num' as an integer. Moreover, if the field 'data$STATE' does not
#' contain 'state.num', the function will stop and print a message.
#' If data$STATE contains state.num but has nothing to plot, the function will print
#' "no accidents to plot" and return invisible diagram; otherwise the function will plot
#' a diagram with LONGITUD in x-asix and LATITUDE in y-asix with points to indicate the
#' distrubution. You can input the year using \code{state.num,year} argument.
#'
#' @param state.num the state number you want to filter in the data
#' @param year the you want to process
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#' @return a graph with polts to show distrubitions in (LONGITUD,LATITUDE)
#'
#' @examples
#' \donotrun{
#' fars_map_state(42,2013)
#' }
#'
#' @export
fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}

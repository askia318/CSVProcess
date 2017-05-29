library(testthat)

test_that("character make", {
    accident_year <- make_filename(2013)
    expect_that(accident_year, is_identical_to("../data/accident_2013.csv.bz2"))
    expect_that(accident_year, is_a("character"))
})

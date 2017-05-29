context("CSVProcess")

test_that("if the type is correct", {

    accident<-make_filename(2013)
    expect_that(accident, is_identical_to("../data/accident_2013.csv.bz2"))
    expect_that(accident, is_a("character"))
})

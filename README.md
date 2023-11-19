
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rphido

The goal of `rphido` is to make it easier for Public Health Staff to use
`R` to:

- access and use data to improve public health
- and help with common string manipulation tasks.

## Data access functions

The `rphido` package includes functions to connect and extract data from
the custom reporting database of the Public Health Intelligence Branch,
`CEDAR`.

- `connect_cedar_odbc`: Connect to CEDAR using the `odbc` package and
  some initial setup.

- `extract_cedar`: Extract data from CEDAR using the supplied SQL using
  a connection object from the function `rphido::connect_cedar_odbc()`.

- `extract_cedar_linelist`: Extract a custom linelist of notifications
  data from CEDAR. An SQL statement is created by the function. The user
  can customise the SQL query by choosing parameters. The query is based
  on the View `nd.NotificationsView` and includes common fields by
  default.

- `show_cedar_names`: Show field names of notification in CEDAR. Return
  a vector of names of the fields of the main Notifications view in
  CEDAR. These field names can can be used in the custom sql command for
  the `extract_from_cedar` function, and in the `select_extra` parameter
  of the `extract_cedar_linelist` function.

## String splitter helper functions

### The common problem: returning a list not a vector.

The `str_split_one` function splits strings into character vectors
**not** lists.

A fairly common task when dealing with strings is the need to split a
single string into many parts.

This is what `base::strsplit()` and `stringr::str_split()` do.

``` r
(x <- "alfa,bravo,charlie,delta")
#> [1] "alfa,bravo,charlie,delta"
strsplit(x, split = ",")
#> [[1]]
#> [1] "alfa"    "bravo"   "charlie" "delta"
stringr::str_split(x, pattern = ",")
#> [[1]]
#> [1] "alfa"    "bravo"   "charlie" "delta"
```

Notice how the return value is a **list** of length one, where the first
element holds the character vector of parts. Often the shape of this
output is inconvenient, i.e. we want the un-listed version.

That’s exactly what `rphido::str_split_one()` does.

### `str_split_one`

The `str_split_one` function splits strings into character vectors
**not** lists.

``` r
library(rphido)

str_split_one(x, pattern = ",")
#> [1] "alfa"    "bravo"   "charlie" "delta"
```

Use `str_split_one()` when the input is known to be a **single string**.
For safety, it will error if its input is already a vector or list that
has length greater than one.

`str_split_one()` is built on `stringr::str_split()`, so you can use its
`n` argument and stringr’s general interface for describing the
`pattern` to be matched.

### `str_rip`

The second `rphido` string splitter helper function is `str_rip`.

`str_rip` will rip (split) a string `string` (or vector of strings) by a
simple separator.

The separator `pattern` is a simple string, **NOT a regular expression**
and **defaults to a comma**.

`str_rip` is a simple wrapper function for:
`stringr::str_split(string, stringr::fixed(pattern), simplify = TRUE)`

It returns a character matrix with columns for each split of the input
string and a row for each input string.

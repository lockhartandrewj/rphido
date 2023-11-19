
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rphido

The goal of `rphido` is to make it easier for Public Health Staff to
access and use data to improve public health and ahelp with common
string manipulation tasks

## Data access functions

## String splitter functions

### `str_split_one`

The first `rphido` string splitter function is `str_split_one`.

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

``` r
library(rphido)

str_split_one(x, pattern = ",")
#> [1] "alfa"    "bravo"   "charlie" "delta"
```

Use `str_split_one()` when the input is known to be a single string. For
safety, it will error if its input is already a vector or list that has
length greater than one.

`str_split_one()` is built on `stringr::str_split()`, so you can use its
`n` argument and stringr’s general interface for describing the
`pattern` to be matched.

``` r
str_split_one(x, pattern = ",", n = 2)
#> [1] "alfa"                "bravo,charlie,delta"

y <- "192.168.0.1"
str_split_one(y, pattern = stringr::fixed("."))
#> [1] "192" "168" "0"   "1"
```

### `str_rip`

The second `rphido` string splitter function is `str_rip`.

`str_rip` will rip (split) a string `string` (or vector of strings) by a
simple separator. The separator `pattern` is a simple string, NOT a
regular expression. This is a simple wrapper function for:
`stringr::str_split(string, stringr::fixed(pattern), simplify = TRUE)`

It returns a character matrix with columns for each split of the input
string and a row for each input string.

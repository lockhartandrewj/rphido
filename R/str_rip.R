#' Rip (split) a string into a vector by a simple string separator
#'
#' Split a string `string` (or vector of strings) by a simple separator.
#' The separator `pattern` is a simple string, NOT a regular expression.
#' This is a simple wrapper function for:
#'     `stringr::str_split(string, stringr::fixed(pattern), simplify = TRUE)`
#'
#' @param string A string to be split
#' @param pattern A separator pattern used to split the string.
#'                Note: this a simple string, NOT a regular expression
#' @export
#' @return a character matrix with columns for each split of the input string
#'         and a row for each input string
#' @examples
#' str_rip("x,y,z")  # defaults to comma as a separator pattern.
#'
#' test_chars <- tibble::tribble(
#'   ~pipe, ~comma, ~space, ~dash, ~slash, ~backslash, ~FRED, ~underscore,
#'   "a|b|c", "a,b,c", "a b c", "a-b-c", "a/b/c", "a\\b\\c", "aFREDbFREDc", "a_b_c",
#'   "d|e|f", "d,e,f", "d e f", "d-e-f", "d/e/f", "d\\e\\f", "dFREDeFREDf", "d_e_f"
#' )
#'
#' str_rip(test_chars$pipe, "|")
#' str_rip(test_chars$comma, ",")
#' str_rip(test_chars$comma)
#' str_rip(test_chars$space, " ")
#' str_rip(test_chars$dash, "-")
#' str_rip(test_chars$slash, "/")
#' str_rip(test_chars$backslash, "\\")
#' str_rip(test_chars$FRED, "FRED")
#' str_rip(test_chars$underscore, "_")
#' str_rip(test_chars$dash, "FAIL")




str_rip <- function(string, pattern = ",") {
  stringr::str_split(string, stringr::fixed(pattern), simplify = TRUE)
}

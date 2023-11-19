#' Show field names of notification in CEDAR.
#'
#' Return a vector of names of the fields of the main Notifications view
#'  `nd.NotificationsView` in CEDAR.
#' These field names can can be used in the custom sql command for the
#'  `extract_from_cedar` function,
#' `and in the `select_extra` parameter of `extract_cedar_linelist`.

#' @export
#' @return a character vector of the field names of notifications in CEDAR.
#'
#' @seealso [extract_cedar_linelist] and [extract_cedar]  and [connect_cedar_odbc] 
#' @examples
#' \dontrun{
#' show_cedar_names()
#' cedar_nv_names <- show_cedar_names()
#' }



show_cedar_names <- function() {
  CEDAR <- connect_cedar_odbc()
  nv_names <- DBI::dbListFields(CEDAR, "NotificationsView")
  DBI::dbDisconnect(CEDAR)
  
  nv_names
}
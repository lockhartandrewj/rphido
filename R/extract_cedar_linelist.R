#' Extract a line list of notifications data from CEDAR
#'
#' Extract a custom linelist of notifications data from CEDAR.
#' An SQL statement is created by the function. The user can customise the SQL query by choosing parameters.
#' The query is based on  the View `nd.NotificationsView` and includes common fields by default.
#'
#' - Choose the `disease` for the extract.
#'
#' - By default the current year is used as the date range, `ytd = TRUE`.
#' If `ytd = FALSE` then `start_date` and `end_date` are used as the date_range.
#'
#' - By default the extract is filtered by `OnsetDate`. To filter by `NotificationDate`, use `filter_onset = FALSE`.
#'
#' - Add more fields from `nd.NotificationsView` by using the `select_extra` parameter.
#'
#' - Add more filters by using the `filter_extra` parameter.
#'
#' #######- The function will output the custom SQL to the screen and extract the data with `qcider::extract_RD(sql)`.
#' - The function will output the custom SQL to the screen and extract the data with `rohido::extract_cedar(sql)`.
#' By choosing `sql_only = TRUE` the function will return a character string of the SQL command rather than the data.
#'
#' - If more flexibility is required then use `extract_from_RD` and supply your own SQL.
#'
#'
#' @param disease The disease to use for this query. Use the **exact spelling** from the Online Weekly Report. Defaults to `"Measles"`
#' @param ytd Use the current year as the data range for the query. Overrides `start_date` and `end_date`. Defaults to `TRUE`
#' @param start_date The start_date for the date_range for the query.
#' @param end_date The end_date for the date_range for the query. Defaults to `"2099-12-31"`.
#' @param filter_onset Use OnsetDate rather than NotificationDate for the date filter. Defaults to `TRUE`.
#' @param select_extra Additional fields to extract. For more than one field include a comma separated character string. Defaults to `""`.
#' @param filter_extra Additional filter to apply to the extract. Use valid SQL format such as `"SexName = 'Male'"`. The first ` AND` will be added automatically. For more than one filter include additional ` AND` in the character string.
#' @param sql_only return a character string of the custom SQL. The data is NOT extracted.
#'
#' @export
#' @return a tibble dataframe with the requested data or a character string of the custom sql if `sql_only = TRUE`
#'
#' @seealso [extract_cedar] [connect_cedar_odbc]
#' @examples
#' \dontrun{
#' # using all defaults: disease = "Measles" ytd = TRUE.
#' extract_cedar_linelist()
#'
#' # to choose disease is Influenza
#' extract_cedar_linelist(disease = "Influenza (lab confirmed)")
#'
#' # custom start_date and end_date
#'  extract_cedar_linelist(disease = "Syphilis (infectious)", start_date = "2017-01-01"
#'                     , end_date = "2018-06-30")
#'
#' # filter on NotificationDate for Tuberculosis
#'  extract_cedar_linelist(disease = "Tuberculosis", filter_onset = FALSE)
#'
#' # add an additional field: LGAName
#' extract_cedar_linelist(disease = "Dengue", select_extra = "LGAName")
#'
#' # add an addditional filter: males only
#'   # note use of the exact name from nd.NotificationsView `SexName` and single quotes around Male
#' extract_RD_linelist(disease = "Chlamydia (STI)", filter_extra = "SexName = 'Male'")
#'
#' # add two addditional filter: males only and age at onset over 20
#'   # note use of the exact name from nd.NotificationsView `SexName` and single quotes around Male
#'   # and additional AND clause in the character string for the filter
#' extract_RD_linelist(disease = "Chlamydia (STI)"
#'     , filter_extra = "SexName = 'Male' AND AgeAtOnsetYears > 20")
#' }



extract_cedar_linelist <- function(disease = "Measles", ytd = TRUE, start_date , end_date = "2099-12-31",
                                   filter_onset = TRUE, select_extra = "", filter_extra = "", sql_only = FALSE)
{
  
  select_fields<- "
SELECT SnapshotDate, NotificationId, OnsetDate  as EpisodeDate
     , SymptomOnsetDate  as OnsetDate, NotificationDate
     , SexName  as Sex, IndigGroupName as IndigGroup, AgeGroupCode  as AgeGroup, HHSName as HHS
     , DiseaseName as Disease,  Pathogen, Level1, Level2, Level3
"
  
  
  if(nchar(select_extra) > 1)  select_extra <- paste0(", ", select_extra)
  
  
  from_table <- "  FROM nd.NotificationsView n \n"
  
  
  disease_filter  <-paste0(" WHERE DiseaseName = '", disease, "'\n")
  
  
  date_field <- if(filter_onset)  "OnsetDate"  else "NotificationDate"
  
  
  if (ytd) {
    date_filter  <- paste0("  AND YEAR(", date_field, ") = YEAR(SnapshotDate)")
  } else if (nchar(start_date) > 1) {
    warning("ytd is FALSE and start_date not supplied")
    date_filter  <- paste0(" AND YEAR(", date_field, ") = YEAR(SnapshotDate)")
  }
  else {
    date_filter <- paste0(" AND ", date_field, " BETWEEN ", start_date, " AND ", end_date)
  }
  
  
  if(nchar(filter_extra) > 1)  filter_extra <- paste0("\n AND ", filter_extra)
  
  
  
  order_by <- paste0("\n ORDER BY ", date_field, ", NotificationId")
  
  
  sql <- paste0(select_fields, select_extra, from_table, disease_filter, date_filter, filter_extra, order_by)
  
  
  message (paste0("Using sql: ", sql))
  
  
  #if(sql_only) sql else qcider::extract_RD(sql)
  
  
  if(sql_only) sql else extract_cedar(sql)
}

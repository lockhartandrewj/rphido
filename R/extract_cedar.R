#' Extract data from CEDAR
#'
#' Extract data from CEDAR using the supplied SQL using package `odbc` 
#' and a connection object from the `rphido` function `connect_cedar_odbc()`
#'
#'
#' @param sql A valid SQL command to extract data from CEDAR
#' @return a tibble dataframe
#' @export
#' @seealso [extract_cedar_linelist] and [connect_cedar_odbc]
#' @examples
#' \dontrun{
#' sql <= "SELECT HHSName from nd.HHS where HHSName like 'Metro%'"
#' metro_hhs <- extract_cedar(sql)
#' }
#' # Uses the function `connect_cedar_odbc()` to create a connection to CEDAR
#' 

extract_cedar <- function(sql = "
SELECT   TOP 10   SnapshotDate, NotificationId, OnsetDate  as EpisodeDate
     , SymptomOnsetDate  as OnsetDate, NotificationDate
     , SexName  as Sex, IndigGroupName as IndigGroup, AgeGroupCode  as AgeGroup
     , HHSName as HHS
     , DiseaseName as Disease, Pathogen, Level1, Level2, Level3
  FROM nd.NotificationsView n 
 WHERE DiseaseName = 'Influenza (lab confirmed)'
  AND YEAR(OnsetDate) = YEAR(SnapshotDate)
 ORDER BY OnsetDate, NotificationId
                          ") {
  
  # make a connection object called CEDAR
  CEDAR <- connect_cedar_odbc()  
  
  # send the SQL to CEDAR and return the data as a tibble (dataframe) called `the_data`
  the_data <- tibble::as_tibble(DBI::dbGetQuery(CEDAR, sql))
  
  
  # Close the connection
  DBI::dbDisconnect(CEDAR)
  
  #return the_data
  the_data
  
}
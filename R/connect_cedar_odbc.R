#' Make a database connection to CEDAR
#'
#' Connect to CEDAR using the `odbc` package

#' Requires:
#'  - User configuration file: usr.dat.
#'  - package DBI   For basic database access
#'  - package odbc  For access to SQL Server databases

#' @param read_only Create a READ ONLY connection. Default = TRUE
#' @export
#' @return a valid SQL Server connection object to the Reporting database
#' @seealso [extract_cedar] and [extract_cedar_linelist]  
#' @examples
#' \dontrun{
#' CEDAR <- connect_cedar_odbc()
#' }
#' 

connect_cedar_odbc <- function(read_only = TRUE) {
  
  if(!file.exists("H:\\usr.dat")) {
    stop("Required file H:\\usr.dat is missing.")
  }
  
  user_data_raw <- readLines('H:\\usr.dat', n = 2)
  user_data <- stringr::str_split(user_data_raw[2], stringr::coll("|"), simplify = TRUE)
  
  user <- user_data[1]
  passw <- user_data[2]
  server_path <- user_data[3]
  #database <- "CDU_BI"
  #port <- user_data[4]
  
  
  ## Check that username and password are not missing
  if(length(user) < 1 || length(passw) < 1) {
    stop("Check login credentials data. One or both of username or password is missing.")
  }
  
  
  # Create a SQL Server connection object: `CEDAR` using the `odbc` package
  #    and `ODBC Driver 17 for SQL Server` driver
  CEDAR <- DBI::dbConnect(odbc::odbc(),
                          Driver   = "ODBC Driver 17 for SQL Server",
                          Server   = server_path,
                          Database = "CDU_BI",
                          UID      = user,
                          PWD      = passw,
                          Port     = 21433
  )
  
  
  # clean up user credentials
  user_data_raw <- NULL
  user_data <- NULL
  user <- NULL
  passw <- NULL
  server_path <- NULL
  
  
  # return the connection object
  CEDAR
}
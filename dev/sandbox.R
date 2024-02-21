library("DBI")
library(dplyr)

drv <- duckdb::duckdb(dbdir = here::here("duck.db"))
con <-  dbConnect(drv)

# Reading some data ----

dplyr::tbl(con, "lot_changes") %>% dplyr::collect() %>% View()

# Exporting the database ----

DBI::dbExecute(
  con,
  statement = glue::glue_sql(
    "EXPORT DATABASE '",
    here::here("exported"),
    "'"
  )
)

# Disconnecting ----
#DBI::dbDisconnect(con, shutdown = TRUE)

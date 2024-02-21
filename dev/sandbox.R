library("DBI")
library(dplyr)

drv <- duckdb::duckdb(dbdir = here::here("duck.db"))
con <-  dbConnect(drv)

# Reading some data ----

dplyr::tbl(con, "lot_changes") %>% dplyr::collect() %>% View()

DBI::dbListTables(con)

X <- dplyr::tbl(con, "supplier_lots") %>%
  dplyr::filter(lot == "19087") %>%
  dplyr::left_join(
    dplyr::tbl(con, "lot_changes"),
    dplyr::join_by(
      id_supplier == new_id_supplier,
      reference == new_reference,
      lot == new_lot
    )
  ) %>%
  dplyr::left_join(
    dplyr::tbl(con, "lot_changes")
  ) %>%
  collect()



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


library("DBI")
library(dplyr)
con <-  dbConnect(duckdb::duckdb(), ":memory:")

# CREATE Statements ----

DBI::dbSendStatement(con, "CREATE SEQUENCE id_sequence START 1")

DBI::dbSendStatement(
  con,
  "CREATE TABLE dict_units(
    id_unit INT DEFAULT nextval('id_sequence') PRIMARY KEY,
    unit TEXT
  )"
)

DBI::dbSendStatement(
  con,
  "CREATE TABLE sample_categories(
    id_category INT DEFAULT nextval('id_sequence') PRIMARY KEY,
    category TEXT
  )"
)

DBI::dbSendStatement(
  con,
  "CREATE TABLE samples(
    id_sample INT DEFAULT nextval('id_sequence') PRIMARY KEY,
    id_category INT REFERENCES sample_categories(id_category)
  )"
)

DBI::dbSendStatement(
  con,
  "CREATE TABLE suppliers(
    id_supplier INT DEFAULT nextval('id_sequence') PRIMARY KEY,
    supplier TEXT
  )"
)

DBI::dbSendStatement(
  con,
  "CREATE TABLE supplier_references(
    id_supplier INT REFERENCES suppliers(id_supplier),
    reference TEXT,
    description TEXT,
    PRIMARY KEY (id_supplier, reference)
  )"
)

DBI::dbSendStatement(
  con,
  "CREATE TABLE supplier_lots(
    id_sample INT PRIMARY KEY REFERENCES samples(id_sample),
    id_supplier INT,
    reference TEXT,
    lot TEXT,
    date_manufacture DATE,
    date_expiry DATE,
    UNIQUE (id_supplier, reference, lot),
    FOREIGN KEY (id_supplier, reference) REFERENCES supplier_references(id_supplier, reference)
  )"
)

DBI::dbSendStatement(
  con,
  "CREATE TABLE sample_mixtures(
    id_sample INT PRIMARY KEY REFERENCES samples(id_sample),
    date DATE
  )"
)

DBI::dbSendStatement(
  con,
  "CREATE TABLE mixture_components(
    id_sample INT REFERENCES sample_mixtures(id_sample),
    id_component INT REFERENCES sample_mixtures(id_sample),
    quantity REAL,
    id_unit INT REFERENCES dict_units(id_unit)

  )"
)

DBI::dbSendStatement(
  con,
  "CREATE TABLE sample_others(
    id_sample INT PRIMARY KEY REFERENCES samples(id_sample),
    description TEXT
  )"
)

duckdb::

# INSERT INTO Statements ----

DBI::dbSendQuery(con, "INSERT INTO suppliers VALUES (1, 'Randox')")
DBI::dbSendQuery(con, "INSERT INTO supplier_references VALUES (1, 'RandoxRef1', 'First Randox Reference')")

DBI::dbWithTransaction(
  con,
  {
    id_sample <- DBI::dbGetQuery(con, "INSERT INTO samples(sample_type) VALUES ('supplier') RETURNING id_sample")

    child_query <- glue::glue_sql(
      "INSERT INTO supplier_lots VALUES (",
      id_sample$id_sample,
      ", 1, 'RandoxRef1', 'RandoxRef1Lot1', '2021-01-01', '2024-01-31')"
    )
    DBI::dbSendQuery(con, child_query)
  })

DBI::dbWithTransaction(
  con,
  {
    id_sample <- DBI::dbGetQuery(con, "INSERT INTO samples(sample_type) VALUES ('supplier') RETURNING id_sample")

    child_query <- glue::glue_sql(
      "INSERT INTO supplier_lots VALUES (",
      id_sample$id_sample,
      ", 1, 'RandoxRef1', 'RandoxRef1Lot2', '2022-01-01', '2025-01-31')"
    )
    DBI::dbSendQuery(con, child_query)
  })

# Reading some data ----
dplyr::left_join(dplyr::tbl(con, "samples"), dplyr::tbl(con, "supplier_lots"))

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

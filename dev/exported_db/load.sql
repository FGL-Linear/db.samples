COPY samples FROM 'C:/Users/Francesc/Documents/R/DuckDB_test/exported_db\samples.csv' (FORMAT 'csv', quote '"', delimiter ',', header 1);
COPY suppliers FROM 'C:/Users/Francesc/Documents/R/DuckDB_test/exported_db\suppliers.csv' (FORMAT 'csv', quote '"', delimiter ',', header 1);
COPY supplier_references FROM 'C:/Users/Francesc/Documents/R/DuckDB_test/exported_db\supplier_references.csv' (FORMAT 'csv', quote '"', delimiter ',', header 1);
COPY supplier_lots FROM 'C:/Users/Francesc/Documents/R/DuckDB_test/exported_db\supplier_lots.csv' (FORMAT 'csv', quote '"', delimiter ',', header 1);

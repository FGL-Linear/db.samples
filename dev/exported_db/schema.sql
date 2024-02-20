

CREATE SEQUENCE id_sequence INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 3 NO CYCLE;

CREATE TABLE samples(id_sample INTEGER PRIMARY KEY DEFAULT(nextval('id_sequence')), sample_type VARCHAR);
CREATE TABLE suppliers(id_supplier INTEGER PRIMARY KEY, supplier VARCHAR);
CREATE TABLE supplier_references(id_supplier INTEGER, reference VARCHAR, description VARCHAR, FOREIGN KEY (id_supplier) REFERENCES suppliers(id_supplier), PRIMARY KEY(id_supplier, reference));
CREATE TABLE supplier_lots(id_sample INTEGER PRIMARY KEY, id_supplier INTEGER, reference VARCHAR, lot VARCHAR, date_manufacture DATE, date_expiry DATE, FOREIGN KEY (id_sample) REFERENCES samples(id_sample), UNIQUE(id_supplier, reference, lot), FOREIGN KEY (id_supplier, reference) REFERENCES supplier_references(id_supplier, reference));





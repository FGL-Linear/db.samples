

CREATE SEQUENCE id_sequence INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 NO CYCLE;

CREATE TABLE analytes(analyte VARCHAR PRIMARY KEY);
CREATE TABLE suppliers(id_supplier INTEGER PRIMARY KEY DEFAULT(nextval('id_sequence')), supplier VARCHAR NOT NULL UNIQUE);
CREATE TABLE sample_categories(id_category INTEGER PRIMARY KEY DEFAULT(nextval('id_sequence')), category VARCHAR NOT NULL UNIQUE);
CREATE TABLE dict_units(id_unit INTEGER PRIMARY KEY DEFAULT(nextval('id_sequence')), unit VARCHAR NOT NULL UNIQUE);
CREATE TABLE alt_temp(parameter VARCHAR PRIMARY KEY, f_t1_t2 FLOAT, f_t1_t3 FLOAT);
CREATE TABLE supplier_references(id_supplier INTEGER, reference VARCHAR, description VARCHAR, FOREIGN KEY (id_supplier) REFERENCES suppliers(id_supplier), PRIMARY KEY(id_supplier, reference));
CREATE TABLE samples(id_sample INTEGER PRIMARY KEY DEFAULT(nextval('id_sequence')), id_category INTEGER, FOREIGN KEY (id_category) REFERENCES sample_categories(id_category));
CREATE TABLE alt_units(analyte VARCHAR PRIMARY KEY, alt_units VARCHAR, f_alt_units FLOAT, FOREIGN KEY (analyte) REFERENCES analytes(analyte));
CREATE TABLE esp(analyte VARCHAR PRIMARY KEY, spanish VARCHAR, FOREIGN KEY (analyte) REFERENCES analytes(analyte));
CREATE TABLE methods(parameter VARCHAR PRIMARY KEY, analyte VARCHAR, "method" VARCHAR, f_sd_cn FLOAT NOT NULL, f_sd_ca FLOAT NOT NULL, units VARCHAR NOT NULL, FOREIGN KEY (analyte) REFERENCES analytes(analyte), FOREIGN KEY (analyte) REFERENCES analytes(analyte));
CREATE TABLE sample_versions(id_sample INTEGER, "version" INTEGER, date_version DATE, PRIMARY KEY(id_sample, "version"), FOREIGN KEY (id_sample) REFERENCES samples(id_sample));
CREATE TABLE sample_values(id_sample INTEGER, "version" INTEGER, parameter VARCHAR, "value" FLOAT, PRIMARY KEY(id_sample, "version", parameter), FOREIGN KEY (id_sample, "version") REFERENCES sample_versions(id_sample, "version"), FOREIGN KEY (parameter) REFERENCES methods(parameter));
CREATE TABLE sample_others(id_sample INTEGER PRIMARY KEY, description VARCHAR NOT NULL, FOREIGN KEY (id_sample) REFERENCES samples(id_sample));
CREATE TABLE sample_mixtures(id_sample INTEGER PRIMARY KEY, date DATE, FOREIGN KEY (id_sample) REFERENCES samples(id_sample));
CREATE TABLE supplier_lots(id_sample INTEGER PRIMARY KEY, id_supplier INTEGER, reference VARCHAR, lot VARCHAR, date_manufacture DATE, date_expiry DATE, FOREIGN KEY (id_sample) REFERENCES samples(id_sample), UNIQUE(id_supplier, reference, lot), FOREIGN KEY (id_supplier, reference) REFERENCES supplier_references(id_supplier, reference));
CREATE TABLE lot_changes(original_id_supplier INTEGER, original_reference VARCHAR, original_lot VARCHAR, new_id_supplier INTEGER, new_reference VARCHAR, new_lot VARCHAR, FOREIGN KEY (original_id_supplier, original_reference, original_lot) REFERENCES supplier_lots(id_supplier, reference, lot), FOREIGN KEY (new_id_supplier, new_reference, new_lot) REFERENCES supplier_lots(id_supplier, reference, lot));
CREATE TABLE mixture_components(id_sample INTEGER, id_component INTEGER, quantity FLOAT NOT NULL, id_unit INTEGER, FOREIGN KEY (id_sample) REFERENCES sample_mixtures(id_sample), FOREIGN KEY (id_component) REFERENCES samples(id_sample), FOREIGN KEY (id_unit) REFERENCES dict_units(id_unit));





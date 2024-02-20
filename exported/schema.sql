

CREATE SEQUENCE id_sequence INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 NO CYCLE;

CREATE TABLE dict_units(
  id_unit INTEGER PRIMARY KEY DEFAULT(nextval('id_sequence')),
  unit VARCHAR
  );

CREATE TABLE sample_categories(
  id_category INTEGER PRIMARY KEY DEFAULT(nextval('id_sequence')),
  category VARCHAR
);

CREATE TABLE suppliers(
  id_supplier INTEGER PRIMARY KEY DEFAULT(nextval('id_sequence')),
  supplier VARCHAR
);

CREATE TABLE samples(
  id_sample INTEGER PRIMARY KEY DEFAULT(nextval('id_sequence')),
  id_category INTEGER,
  FOREIGN KEY (id_category) REFERENCES sample_categories(id_category)
  );

CREATE TABLE supplier_references(
  id_supplier INTEGER,
  reference VARCHAR,
  description VARCHAR,
  FOREIGN KEY (id_supplier) REFERENCES suppliers(id_supplier),
  PRIMARY KEY(id_supplier, reference)
);

CREATE TABLE supplier_lots(
  id_sample INTEGER PRIMARY KEY,
  id_supplier INTEGER,
  reference VARCHAR,
  lot VARCHAR,
  date_manufacture DATE,
  date_expiry DATE,
  FOREIGN KEY (id_sample) REFERENCES samples(id_sample),
  UNIQUE(id_supplier, reference, lot),
  FOREIGN KEY (id_supplier, reference) REFERENCES supplier_references(id_supplier, reference)
);

CREATE TABLE sample_mixtures(
  id_sample INTEGER PRIMARY KEY,
  date DATE,
  FOREIGN KEY (id_sample) REFERENCES samples(id_sample)
);

CREATE TABLE mixture_components(
  id_sample INTEGER,
  id_component INTEGER,
  quantity FLOAT,
  id_unit INTEGER,
  FOREIGN KEY (id_sample) REFERENCES sample_mixtures(id_sample),
  FOREIGN KEY (id_component) REFERENCES samples(id_sample),
  FOREIGN KEY (id_unit) REFERENCES dict_units(id_unit)
);

CREATE TABLE sample_others(
  id_sample INTEGER PRIMARY KEY,
  description VARCHAR,
  FOREIGN KEY (id_sample) REFERENCES samples(id_sample)
);





import 'package:drift/drift.dart';

import '../database.dart'; // Replace with your database import

Future<void> migration2(Migrator m, AppDatabase db) async {
  print("Executing migration2");

  // Create the bib_tables_locations table
  await db.customStatement('''
    CREATE TABLE bib_tables_locations (
      id_table_location INTEGER PRIMARY KEY AUTOINCREMENT,
      table_desc TEXT,
      schema_name TEXT,
      table_name_label TEXT,
      pk_field TEXT,
      uuid_field_name TEXT
    );
  ''');

  await db.customStatement('''
  CREATE TABLE IF NOT EXISTS cor_module_dataset_table (
    id_module INTEGER NOT NULL,
    id_dataset INTEGER NOT NULL,
    PRIMARY KEY (id_module, id_dataset),
    FOREIGN KEY (id_module) REFERENCES t_modules (id_module),
    FOREIGN KEY (id_dataset) REFERENCES t_datasets (id_dataset)
    );
  ''');

  // Create the t_modules table
  await db.customStatement('''
    CREATE TABLE t_modules (
      id_module INTEGER PRIMARY KEY AUTOINCREMENT,
      module_code TEXT,
      module_label TEXT,
      module_picto TEXT,
      module_desc TEXT,
      module_group TEXT,
      module_path TEXT,
      module_external_url TEXT,
      module_target TEXT,
      module_comment TEXT,
      active_frontend BOOLEAN,
      active_backend BOOLEAN,
      module_doc_url TEXT,
      module_order INTEGER,
      ng_module TEXT,
      meta_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      meta_update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
  ''');

  await db.customStatement('''
    CREATE TABLE cor_site_module_table (
    id_base_site integer NOT NULL,
    id_module integer NOT NULL
    );
  ''');

  await db.customStatement('''
  CREATE TABLE IF NOT EXISTS t_objects (
    id_object INTEGER PRIMARY KEY AUTOINCREMENT,
    code_object TEXT UNIQUE,
    description_object TEXT
  );
  ''');

  await db.customStatement('''
  CREATE TABLE t_actions
  (
    id_action serial NOT NULL,
    code_action character varying(50) NOT NULL,
    description_action text
  );
  ''');

  await db.customStatement('''
  CREATE TABLE IF NOT EXISTS t_permissions_available (
    id_module INTEGER NOT NULL,
    id_object INTEGER NOT NULL,
    id_action INTEGER NOT NULL,
    label TEXT,
    scope_filter BOOLEAN DEFAULT FALSE,
    sensitivity_filter BOOLEAN DEFAULT FALSE NOT NULL,
    PRIMARY KEY (id_module, id_object, id_action),
    FOREIGN KEY (id_module) REFERENCES t_modules (id_module) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_object) REFERENCES t_objects (id_object) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_action) REFERENCES t_actions (id_action) ON DELETE CASCADE ON UPDATE CASCADE
  );
''');

  await db.customStatement('''
    CREATE TABLE IF NOT EXISTS bib_actions (
      id_action INTEGER PRIMARY KEY AUTOINCREMENT,
      code_action TEXT NOT NULL UNIQUE,
      description_action TEXT
    );
  ''');

  await db.customStatement('''
    CREATE TABLE IF NOT EXISTS t_permissions (
      id_permission INTEGER PRIMARY KEY AUTOINCREMENT,
      id_role INTEGER NOT NULL,
      id_action INTEGER NOT NULL,
      id_module INTEGER NOT NULL,
      id_object INTEGER NOT NULL,
      scope_value INTEGER,
      sensitivity_filter BOOLEAN DEFAULT FALSE NOT NULL,
      FOREIGN KEY (id_role) REFERENCES t_roles (id_role) ON DELETE CASCADE ON UPDATE CASCADE,
      FOREIGN KEY (id_action) REFERENCES bib_actions (id_action) ON DELETE CASCADE ON UPDATE CASCADE,
      FOREIGN KEY (id_module) REFERENCES t_modules (id_module) ON DELETE CASCADE ON UPDATE CASCADE,
      FOREIGN KEY (id_object) REFERENCES t_objects (id_object) ON DELETE CASCADE ON UPDATE CASCADE,
      FOREIGN KEY (id_module, id_object, id_action) REFERENCES t_permissions_available (id_module, id_object, id_action) ON DELETE CASCADE ON UPDATE CASCADE,
      FOREIGN KEY (scope_value) REFERENCES perm_scope (value) ON DELETE SET NULL ON UPDATE CASCADE
    );
  ''');

  await db.customStatement('''
  CREATE TABLE cor_object_module_table
(
    id_cor_object_module serial NOT NULL,
    id_object integer NOT NULL,
    id_module integer NOT NULL
);
  ''');

  // Insert initial static data into t_objects
  try {
    await db.customStatement('''
      INSERT INTO t_objects (code_object, description_object)
      VALUES
      ('GNM_SITES', 'Permissions sur les sites'),
      ('GNM_VISITES', 'Permissions sur les visites'),
      ('GNM_OBSERVATIONS', 'Permissions sur les observations'),
      ('GNM_GRP_SITES', 'Permissions sur les groupes de sites')
      ON CONFLICT (code_object) DO NOTHING;
    ''');
    print("Static data inserted into t_objects");
  } catch (e) {
    print("Error inserting static data into t_objects: $e");
    rethrow;
  }

  try {
    await db.customStatement('''
      CREATE TABLE t_base_sites (
        id_base_site INTEGER PRIMARY KEY AUTOINCREMENT,
        id_inventor INTEGER,
        id_digitiser INTEGER,
        base_site_name TEXT,
        base_site_description TEXT,
        base_site_code TEXT,
        first_use_date TEXT,
        geom TEXT, -- Stockage de la géométrie en format GeoJSON
        uuid_base_site TEXT,
        meta_create_date TEXT,
        meta_update_date TEXT,
        altitude_min INTEGER,
        altitude_max INTEGER,
        FOREIGN KEY (id_inventor) REFERENCES t_roles (id_role),
        FOREIGN KEY (id_digitiser) REFERENCES t_roles (id_role)
      );
    ''');
  } catch (e) {
    print("Error creating t_base_sites table: $e");
    rethrow;
  }

  // Create the t_nomenclatures table
  try {
    await db.customStatement('''
      CREATE TABLE t_nomenclatures (
        id_nomenclature INTEGER PRIMARY KEY AUTOINCREMENT,
        id_type INTEGER NOT NULL,
        cd_nomenclature TEXT NOT NULL,
        mnemonique TEXT,
        label_default TEXT,
        definition_default TEXT,
        label_fr TEXT,
        definition_fr TEXT,
        label_en TEXT,
        definition_en TEXT,
        label_es TEXT,
        definition_es TEXT,
        label_de TEXT,
        definition_de TEXT,
        label_it TEXT,
        definition_it TEXT,
        source TEXT,
        statut TEXT,
        id_broader INTEGER,
        hierarchy TEXT,
        active BOOLEAN DEFAULT TRUE,
        meta_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        meta_update_date TIMESTAMP
      );
    ''');
    print("t_nomenclatures table created successfully.");
  } catch (e) {
    print("Error creating t_nomenclatures table: $e");
    rethrow;
  }

  try {
    await db.customStatement('''
    CREATE TABLE t_datasets (
      id_dataset INTEGER PRIMARY KEY AUTOINCREMENT,
      unique_dataset_id TEXT NOT NULL, -- UUID stored as TEXT
      id_acquisition_framework INTEGER NOT NULL,
      dataset_name TEXT NOT NULL,
      dataset_shortname TEXT NOT NULL,
      dataset_desc TEXT NOT NULL,
      id_nomenclature_data_type INTEGER NOT NULL,
      keywords TEXT,
      marine_domain BOOLEAN NOT NULL,
      terrestrial_domain BOOLEAN NOT NULL,
      id_nomenclature_dataset_objectif INTEGER NOT NULL,
      bbox_west REAL,
      bbox_east REAL,
      bbox_south REAL,
      bbox_north REAL,
      id_nomenclature_collecting_method INTEGER NOT NULL,
      id_nomenclature_data_origin INTEGER NOT NULL,
      id_nomenclature_source_status INTEGER NOT NULL,
      id_nomenclature_resource_type INTEGER NOT NULL,
      active BOOLEAN DEFAULT TRUE,
      validable BOOLEAN DEFAULT TRUE,
      id_digitizer INTEGER,
      id_taxa_list INTEGER,
      meta_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      meta_update_date TIMESTAMP
    );
  ''');
    print("t_datasets table created successfully.");
  } catch (e) {
    print("Error creating t_datasets table: $e");
    rethrow;
  }

  print("Migration2 executed successfully");
}

import 'package:drift/drift.dart';

import '../database.dart';

/// Rend `t_datasets.id_nomenclature_dataset_objectif` nullable.
///
/// Depuis GeoNature 2.18 (#4103, plusieurs objectifs par JDD), la route
/// `/monitorings/util/dataset/{id}` ne renvoie plus ce champ. SQLite ne sait
/// pas retirer une contrainte NOT NULL : on reconstruit la table (les clés
/// étrangères ne sont pas activées dans l'app, le DROP ne cascade donc pas).
Future<void> migration30(Migrator m, AppDatabase db) async {
  print("Executing migration30: t_datasets.id_nomenclature_dataset_objectif nullable");

  try {
    await db.customStatement('''
    CREATE TABLE t_datasets_new (
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
      id_nomenclature_dataset_objectif INTEGER,
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

    await db.customStatement('''
    INSERT INTO t_datasets_new (
      id_dataset, unique_dataset_id, id_acquisition_framework, dataset_name,
      dataset_shortname, dataset_desc, id_nomenclature_data_type, keywords,
      marine_domain, terrestrial_domain, id_nomenclature_dataset_objectif,
      bbox_west, bbox_east, bbox_south, bbox_north,
      id_nomenclature_collecting_method, id_nomenclature_data_origin,
      id_nomenclature_source_status, id_nomenclature_resource_type,
      active, validable, id_digitizer, id_taxa_list,
      meta_create_date, meta_update_date
    )
    SELECT
      id_dataset, unique_dataset_id, id_acquisition_framework, dataset_name,
      dataset_shortname, dataset_desc, id_nomenclature_data_type, keywords,
      marine_domain, terrestrial_domain, id_nomenclature_dataset_objectif,
      bbox_west, bbox_east, bbox_south, bbox_north,
      id_nomenclature_collecting_method, id_nomenclature_data_origin,
      id_nomenclature_source_status, id_nomenclature_resource_type,
      active, validable, id_digitizer, id_taxa_list,
      meta_create_date, meta_update_date
    FROM t_datasets;
  ''');

    await db.customStatement('DROP TABLE t_datasets;');
    await db.customStatement('ALTER TABLE t_datasets_new RENAME TO t_datasets;');

    print("t_datasets rebuilt with nullable id_nomenclature_dataset_objectif");
  } catch (e) {
    print("Error rebuilding t_datasets: $e");
    rethrow;
  }
}

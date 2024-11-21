import 'package:drift/drift.dart';

import '../database.dart'; // Ensure the database class is imported

Future<void> migration1(Migrator m, AppDatabase db) async {
  print("Executing migration1");

  // Execute raw SQL statements using db.customStatement
  await db.customStatement('''
    CREATE TABLE t_module_complements (
      id_module INTEGER PRIMARY KEY AUTOINCREMENT,
      uuid_module_complement TEXT DEFAULT (randomblob(16)) UNIQUE,
      id_list_observer INTEGER,
      id_list_taxonomy INTEGER,
      b_synthese BOOLEAN DEFAULT 1,
      taxonomy_display_field_name TEXT DEFAULT 'nom_vern,lb_nom',
      b_draw_sites_group BOOLEAN,
      data TEXT
    );
  ''');

  await db.customStatement('''
    CREATE TABLE t_sites_groups (
      id_sites_group INTEGER PRIMARY KEY AUTOINCREMENT,
      id_module INTEGER,
      sites_group_name TEXT,
      sites_group_code TEXT,
      sites_group_description TEXT,
      uuid_sites_group TEXT DEFAULT (randomblob(16)) UNIQUE,
      comments TEXT,
      data TEXT,
      meta_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      meta_update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
  ''');

  await db.customStatement('''
    CREATE TABLE t_site_complements (
      id_base_site INTEGER PRIMARY KEY,
      id_module INTEGER,
      id_sites_group INTEGER,
      data TEXT
    );
  ''');

  await db.customStatement('''
    CREATE TABLE t_visit_complements (
      id_base_visit INTEGER PRIMARY KEY,
      data TEXT
    );
  ''');

  await db.customStatement('''
    CREATE TABLE t_observations (
      id_observation INTEGER PRIMARY KEY AUTOINCREMENT,
      id_base_visit INTEGER,
      cd_nom INTEGER,
      comments TEXT,
      uuid_observation TEXT DEFAULT (randomblob(16)) UNIQUE
    );
  ''');

  await db.customStatement('''
    CREATE TABLE t_observation_complements (
      id_observation INTEGER PRIMARY KEY,
      data TEXT
    );
  ''');

  await db.customStatement('''
    CREATE TABLE t_observation_details (
      id_observation_detail INTEGER PRIMARY KEY AUTOINCREMENT,
      id_observation INTEGER,
      data TEXT
    );
  ''');

  print("Migration1 executed successfully");
}

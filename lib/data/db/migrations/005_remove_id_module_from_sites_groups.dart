import 'package:drift/drift.dart';

Future<void> migration5(Migrator m, GeneratedDatabase db) async {
  print("Executing migration5");

  // Step 1: Create the new table `cor_sites_group_module`
  await db.customStatement('''
    CREATE TABLE cor_sites_group_module_table (
      id_sites_group INTEGER NOT NULL,
      id_module INTEGER NOT NULL,
      PRIMARY KEY (id_sites_group, id_module),
      FOREIGN KEY (id_sites_group) REFERENCES t_sites_groups (id_sites_group) ON DELETE CASCADE ON UPDATE CASCADE,
      FOREIGN KEY (id_module) REFERENCES modules (id_module) ON DELETE NO ACTION ON UPDATE CASCADE
    );
  ''');

  // Step 2: Transfer data from `t_sites_groups` to `cor_sites_group_module`
  await db.customStatement('''
    INSERT INTO cor_sites_group_module_table (id_sites_group, id_module)
    SELECT id_sites_group, id_module
    FROM t_sites_groups;
  ''');

  // Step 3: Remove the `id_module` column from `t_sites_groups`
  // Since Drift doesn't support column drops, recreate the table without the column
  await db.customStatement('''
    CREATE TABLE t_sites_groups_new (
      id_sites_group INTEGER PRIMARY KEY,
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
    INSERT INTO t_sites_groups_new (id_sites_group, sites_group_name, sites_group_code, sites_group_description, uuid_sites_group, comments, data, meta_create_date, meta_update_date)
    SELECT id_sites_group, sites_group_name, sites_group_code, sites_group_description, uuid_sites_group, comments, data, meta_create_date, meta_update_date
    FROM t_sites_groups;
  ''');

  await db.customStatement('DROP TABLE t_sites_groups;');
  await db.customStatement(
      'ALTER TABLE t_sites_groups_new RENAME TO t_sites_groups;');
}

// Downgrade Migration
Future<void> downgrade5(Migrator m, GeneratedDatabase db) async {
  print("Downgrading migration5");

  // Step 1: Add back the `id_module` column to `t_sites_groups`
  await db.customStatement('''
    CREATE TABLE t_sites_groups_new (
      id_sites_group INTEGER PRIMARY KEY,
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
    INSERT INTO t_sites_groups_new (id_sites_group, id_module, sites_group_name, sites_group_code, sites_group_description, uuid_sites_group, comments, data, meta_create_date, meta_update_date)
    WITH sgm AS (
      SELECT id_sites_group, MIN(id_module) AS first_id_module
      FROM cor_sites_group_module_table
      GROUP BY id_sites_group
    )
    SELECT tsg.id_sites_group, sgm.first_id_module, tsg.sites_group_name, tsg.sites_group_code, tsg.sites_group_description, tsg.uuid_sites_group, tsg.comments, tsg.data, tsg.meta_create_date, tsg.meta_update_date
    FROM t_sites_groups AS tsg
    LEFT JOIN sgm ON tsg.id_sites_group = sgm.id_sites_group;
  ''');

  await db.customStatement('DROP TABLE t_sites_groups;');
  await db.customStatement(
      'ALTER TABLE t_sites_groups_new RENAME TO t_sites_groups;');

  // Step 2: Drop the `cor_sites_group_module_table` table
  await db.customStatement('DROP TABLE cor_sites_group_module_table;');
}

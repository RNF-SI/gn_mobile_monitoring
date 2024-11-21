import 'package:drift/drift.dart';

Future<void> migration6(Migrator m, GeneratedDatabase db) async {
  print("Executing migration6");

  // Step 1: Drop the existing primary key on `t_observation_details`
  await db.customStatement('''
    CREATE TABLE t_observation_details_new (
      id_observation_detail INTEGER PRIMARY KEY,
      id_observation INTEGER NOT NULL,
      uuid_observation_detail TEXT DEFAULT (randomblob(16)) NOT NULL,
      data TEXT
    );
  ''');

  // Step 2: Transfer data to the new table
  await db.customStatement('''
    INSERT INTO t_observation_details_new (id_observation_detail, id_observation, data)
    SELECT id_observation_detail, id_observation, data
    FROM t_observation_details;
  ''');

  // Step 3: Replace the old table with the new one
  await db.customStatement('DROP TABLE t_observation_details;');
  await db.customStatement(
      'ALTER TABLE t_observation_details_new RENAME TO t_observation_details;');
}

// Downgrade Migration
Future<void> downgrade6(Migrator m, GeneratedDatabase db) async {
  print("Downgrading migration6");

  // Step 1: Recreate the table with the original primary key and without `uuid_observation_detail`
  await db.customStatement('''
    CREATE TABLE t_observation_details_new (
      id_observation_detail INTEGER,
      id_observation INTEGER NOT NULL,
      data TEXT,
      PRIMARY KEY (id_observation)
    );
  ''');

  // Step 2: Transfer data back
  await db.customStatement('''
    INSERT INTO t_observation_details_new (id_observation_detail, id_observation, data)
    SELECT id_observation_detail, id_observation, data
    FROM t_observation_details;
  ''');

  // Step 3: Drop the `uuid_observation_detail` column and replace the table
  await db.customStatement('DROP TABLE t_observation_details;');
  await db.customStatement(
      'ALTER TABLE t_observation_details_new RENAME TO t_observation_details;');
}

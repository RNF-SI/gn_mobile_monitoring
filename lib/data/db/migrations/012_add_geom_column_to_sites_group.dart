import 'package:drift/drift.dart';

Future<void> migration12(Migrator m, GeneratedDatabase db) async {
  print(
      "Executing migration12: Adding geom and related columns to 't_sites_groups'");

  try {
    // Step 1: Add the new columns one by one
    await db.customStatement('''
      ALTER TABLE t_sites_groups ADD COLUMN geom TEXT NULL;
    ''');
    print("Column 'geom' added to 't_sites_groups'");

    await db.customStatement('''
      ALTER TABLE t_sites_groups ADD COLUMN geom_local TEXT NULL;
    ''');
    print("Column 'geom_local' added to 't_sites_groups'");

    await db.customStatement('''
      ALTER TABLE t_sites_groups ADD COLUMN altitude_min INTEGER NULL;
    ''');
    print("Column 'altitude_min' added to 't_sites_groups'");

    await db.customStatement('''
      ALTER TABLE t_sites_groups ADD COLUMN altitude_max INTEGER NULL;
    ''');
    print("Column 'altitude_max' added to 't_sites_groups'");

    // Step 2: Add a CHECK constraint for SRID (Note: SQLite does not enforce geometry constraints, this is for illustration)
    await db.customStatement('''
      CREATE TRIGGER enforce_srid_geom
      BEFORE INSERT ON t_sites_groups
      WHEN instr(NEW.geom, 'SRID=4326;') <= 0
      BEGIN
        SELECT RAISE(ABORT, 'Invalid SRID for geom column');
      END;
    ''');
    print(
        "Constraint-like trigger 'enforce_srid_geom' added to 't_sites_groups'");

    // Step 3: Add index on the 'geom' column
    await db.customStatement('''
      CREATE INDEX idx_t_sites_groups_geom ON t_sites_groups (geom);
    ''');
    print(
        "Index 'idx_t_sites_groups_geom' created on 'geom' column of 't_sites_groups'");
  } catch (e) {
    print("Error during migration12: $e");
    rethrow;
  }
}

Future<void> downgrade12(Migrator m, GeneratedDatabase db) async {
  print(
      "Downgrading migration12: Removing geom and related columns from 't_sites_groups'");

  try {
    // Step 1: Drop the index
    await db.customStatement('''
      DROP INDEX IF EXISTS idx_t_sites_groups_geom;
    ''');
    print("Index 'idx_t_sites_groups_geom' dropped");

    // Step 2: Drop the triggers
    await db.customStatement('''
      DROP TRIGGER IF EXISTS enforce_srid_geom;
    ''');
    print("Trigger 'enforce_srid_geom' dropped");

    // Step 3: SQLite does not support dropping columns. Manual action required if a full downgrade is needed.
    print(
        "Note: SQLite does not support dropping columns. The table must be recreated manually if necessary.");
  } catch (e) {
    print("Error during downgrade12: $e");
    rethrow;
  }
}

import 'package:drift/drift.dart';

Future<void> migration11(Migrator m, GeneratedDatabase db) async {
  print("Executing migration11: Adding 'id_digitiser' to 't_sites_groups'");

  try {
    // Step 1: Add the new column `id_digitiser`
    await db.customStatement('''
      ALTER TABLE t_sites_groups
      ADD COLUMN id_digitiser INTEGER REFERENCES t_roles(id_role) ON UPDATE CASCADE;
    ''');

    print("Column 'id_digitiser' added to 't_sites_groups'");
  } catch (e) {
    print("Error during migration11: $e");
    rethrow;
  }
}

Future<void> downgrade11(Migrator m, GeneratedDatabase db) async {
  print(
      "Downgrading migration11: Removing 'id_digitiser' from 't_sites_groups'");

  try {
    // Step 1: Drop the foreign key constraint
    await db.customStatement('''
      ALTER TABLE t_sites_groups DROP COLUMN id_digitiser;
    ''');

    print("Column 'id_digitiser' removed from 't_sites_groups'");
  } catch (e) {
    print("Error during downgrade11: $e");
    rethrow;
  }
}

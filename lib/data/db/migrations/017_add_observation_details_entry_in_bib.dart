import 'package:drift/drift.dart';

Future<void> migration17(Migrator m, GeneratedDatabase db) async {
  print(
      "Executing migration17: Add observation details entry in bib_tables_location");

  try {
    // Ensure the unique constraint exists on `schema_name` and `table_name`
    await db.customStatement('''
      CREATE UNIQUE INDEX IF NOT EXISTS idx_bib_tables_location_schema_table
      ON bib_tables_location (schema_name, table_name);
    ''');

    // Insert into `bib_tables_location` table
    await db.customStatement('''
      INSERT INTO bib_tables_location (table_desc, schema_name, table_name, pk_field, uuid_field_name)
      VALUES
      (
        'Table centralisant les détails des observations réalisées lors d''une visite sur un site',
        'gn_monitoring',
        't_observation_details',
        'id_observation_detail',
        'uuid_observation_detail'
      )
      ON CONFLICT (schema_name, table_name) DO NOTHING;
    ''');
    print("Observation details entry added to bib_tables_location");
  } catch (e) {
    print("Error during migration17: $e");
    rethrow;
  }
}

Future<void> downgrade17(Migrator m, GeneratedDatabase db) async {
  print(
      "Downgrading migration17: Remove observation details entry from bib_tables_location");

  try {
    // Delete the specific entry from `bib_tables_location`
    await db.customStatement('''
      DELETE FROM bib_tables_location
      WHERE schema_name = 'gn_monitoring' AND table_name = 't_observation_details';
    ''');
    print("Observation details entry removed from bib_tables_location");
  } catch (e) {
    print("Error during downgrade17: $e");
    rethrow;
  }
}

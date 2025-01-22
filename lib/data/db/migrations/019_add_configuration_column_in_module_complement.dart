import 'package:drift/drift.dart';

/// Migration to add the "configuration" column to the "t_module_complements" table.
Future<void> migration19(Migrator m, GeneratedDatabase db) async {
  print(
      "Executing migration19: Add configuration column in t_module_complements table");

  try {
    // Add the new "configuration" column to the "t_module_complements" table
    await db.customStatement('''
      ALTER TABLE t_module_complements
      ADD COLUMN configuration TEXT;
    ''');
    print("Migration19 executed successfully.");
  } catch (e) {
    print("Error during migration19: $e");
    rethrow;
  }
}

/// Downgrade method for migration19 to revert the changes.
Future<void> downgrade19(Migrator m, GeneratedDatabase db) async {
  print(
      "Executing downgrade19: Remove configuration column from t_module_complements table");

  try {
    // Drift does not support dropping columns directly, so we log a note
    print("Note: Column removal is not directly supported in Drift.");
    print(
        "You will need to recreate the table if you intend to remove the column manually.");
  } catch (e) {
    print("Error during downgrade19: $e");
    rethrow;
  }
}

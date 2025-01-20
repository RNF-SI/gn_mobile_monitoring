import 'package:drift/drift.dart';

/// Migration to add the "downloaded" column to the "t_modules" table.
Future<void> migration18(Migrator m, GeneratedDatabase db) async {
  print("Executing migration18: Add downloaded column in t_modules table");

  try {
    // Add the new "downloaded" column to the "t_modules" table
    await db.customStatement('''
      ALTER TABLE t_modules
      ADD COLUMN downloaded BOOLEAN DEFAULT FALSE;
    ''');
    print("Migration18 executed successfully.");
  } catch (e) {
    print("Error during migration18: $e");
    rethrow;
  }
}

/// Downgrade method for migration18 to revert the changes.
Future<void> downgrade18(Migrator m, GeneratedDatabase db) async {
  print("Executing downgrade18: Remove downloaded column from t_modules table");

  try {
    // Drift does not support dropping columns directly, so we log a note
    print("Note: Column removal is not directly supported in Drift.");
    print(
        "You will need to recreate the table if you intend to remove the column manually.");
  } catch (e) {
    print("Error during downgrade18: $e");
    rethrow;
  }
}

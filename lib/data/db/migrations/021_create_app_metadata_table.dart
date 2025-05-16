import 'package:drift/drift.dart';

import '../database.dart';

Future<void> migration21(Migrator m, AppDatabase db) async {
  print("Executing migration21: Creating app_metadata table");
  
  try {
    // Création de la table app_metadata en SQL direct
    await db.customStatement('''
      CREATE TABLE app_metadata (
        key TEXT PRIMARY KEY,
        value TEXT
      );
    ''');
    
    print("app_metadata table created successfully");
  } catch (e) {
    print("Error creating app_metadata table: $e");
    rethrow;
  }
}

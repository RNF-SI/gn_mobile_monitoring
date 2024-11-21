import 'dart:io';

import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/global_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class GlobalDatabaseImpl implements GlobalDatabase {
  AppDatabase? _appDatabase;

  @override
  Future<void> initDatabase() async {
    try {
      print("Initializing database...");
      _appDatabase = await DB.instance.database;

      if (_appDatabase != null) {
        print("Database initialized successfully");

        // Force database to open and verify it is operational
        await _appDatabase!.customSelect('SELECT 1;').get();
        print("Database connection verified");
      } else {
        print("Database initialization failed");
      }
    } catch (e) {
      print("Error during database initialization: $e");
    }
  }

  Future<AppDatabase?> get database async {
    if (_appDatabase == null) {
      await initDatabase();
    }
    return _appDatabase;
  }

  @override
  Future<void> deleteDatabase() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'app.sqlite');
    final file = File(dbPath);

    if (await file.exists()) {
      await file.delete();
      print("Database deleted at: $dbPath");
    } else {
      print("Database file not found at: $dbPath");
    }

    _appDatabase = null; // Reset the database instance
  }
}

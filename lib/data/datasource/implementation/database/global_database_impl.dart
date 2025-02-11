import 'dart:io';

import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/global_database.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class GlobalDatabaseImpl implements GlobalDatabase {
  @override
  Future<void> initDatabase() async {
    print("Initializing database...");
    await DB.instance.database; // Initialize
    print("Database initialized successfully.");
  }

  @override
  Future<void> deleteDatabase() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'app.sqlite');
    final file = File(dbPath);

    // Reset database instance
    await DB.instance.resetDatabase();

    if (await file.exists()) {
      await file.delete();
      print("Database file deleted at: $dbPath");
    } else {
      print("Database file not found.");
    }
  }

  @override
  Future<void> resetDatabase() async {
    await DB.instance.resetDatabase();
  }
}

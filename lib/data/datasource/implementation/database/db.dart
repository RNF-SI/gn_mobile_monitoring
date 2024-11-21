import 'package:gn_mobile_monitoring/data/db/database.dart';

class DB {
  static final DB _instance = DB._internal();
  DB._internal();
  static DB get instance => _instance;

  AppDatabase? _database;

  Future<AppDatabase> get database async {
    if (_database == null) {
      print("Creating new AppDatabase instance...");
      _database = AppDatabase();
    } else {
      print("Reusing existing AppDatabase instance...");
      print("Database path: ${_database!}");
    }
    return _database!;
  }

  Future<void> resetDatabase() async {
    if (_database != null) {
      print("Closing database...");
      await _database!.close();
      print("Database closed");
    }
    _database = null;
  }
}

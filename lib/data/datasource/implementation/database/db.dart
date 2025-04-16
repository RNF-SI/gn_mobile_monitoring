import 'package:gn_mobile_monitoring/data/db/database.dart';

class DB {
  static DB _instance = DB._internal();
  DB._internal();
  static DB get instance => _instance;

  // Méthode d'aide pour les tests
  static void setInstance(DB db) {
    _instance = db;
  }

  Future<AppDatabase> get database async {
    return await AppDatabase.getInstance();
  }

  Future<void> resetDatabase() async {
    await AppDatabase.resetInstance();
  }
}
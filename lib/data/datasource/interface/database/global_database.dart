abstract class GlobalDatabase {
  Future<void> initDatabase();
  Future<void> deleteDatabase();
  Future<void> resetDatabase();
}

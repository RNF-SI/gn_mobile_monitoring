abstract class GlobalDatabaseRepository {
  Future<void> initDatabase();
  Future<void> deleteDatabase();
  Future<void> importCsv(String tableName, String filePath);
  Future<void> importAllCsv();
}

abstract class GlobalDatabaseRepository {
  Future<void> initDatabase();
  Future<void> deleteDatabase();
}

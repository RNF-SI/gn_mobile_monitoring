import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/global_database.dart';
import 'package:gn_mobile_monitoring/domain/repository/global_database_repository.dart';

class GlobalDatabaseRepositoryImpl implements GlobalDatabaseRepository {
  final GlobalDatabase database;
  final GlobalApi api;

  const GlobalDatabaseRepositoryImpl(this.database, this.api);

  @override
  Future<void> initDatabase() async {
    try {
      await database.initDatabase();
    } catch (e) {
      throw Exception('Failed to initialize database: $e');
    }
  }

  @override
  Future<void> deleteDatabase() async {
    try {
      await database.deleteDatabase();
    } catch (e) {
      throw Exception('Failed to delete database: $e');
    }
  }
}

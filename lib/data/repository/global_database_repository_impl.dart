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

  @override
  Future<void> importCsv(String tableName, String filePath) async {
    try {
      await database.importCsv(tableName, filePath);
    } catch (e) {
      throw Exception('Échec de l\'importation CSV : $e');
    }
  }

  @override
  Future<void> importAllCsv() async {
    final tableFiles = {
      'bib_tables_locations': 'assets/tables_csv/bib_tables_locations.csv',
      // 'cor_object_module':
      //     '/home/aschlegel/gn_mobile_monitoring/assets/tables_csv/cor_object_module.csv',
      // 'cor_site_module':
      //     '/home/aschlegel/gn_mobile_monitoring/assets/tables_csv/cor_site_module.csv',
      // 't_actions':
      //     '/home/aschlegel/gn_mobile_monitoring/assets/tables_csv/t_actions.csv',
      // 't_module_complements':
      //     '/home/aschlegel/gn_mobile_monitoring/assets/tables_csv/t_module_complements.csv',
      // 't_modules':
      //     '/home/aschlegel/gn_mobile_monitoring/assets/tables_csv/t_modules.csv',
      // 't_objects':
      //     '/home/aschlegel/gn_mobile_monitoring/assets/tables_csv/t_objects.csv',
      // 't_observation_details':
      //     '/home/aschlegel/gn_mobile_monitoring/assets/tables_csv/t_observation_details.csv',
      // 't_observations_complements':
      //     '/home/aschlegel/gn_mobile_monitoring/assets/tables_csv/t_observations_complements.csv',
      // 't_observations':
      //     '/home/aschlegel/gn_mobile_monitoring/assets/tables_csv/t_observations.csv',
      // 't_permissions_available':
      //     '/home/aschlegel/gn_mobile_monitoring/assets/tables_csv/t_permissions_available.csv',
      // 't_permissions':
      //     '/home/aschlegel/gn_mobile_monitoring/assets/tables_csv/t_permissions.csv',
      // 't_sites_complements':
      //     '/home/aschlegel/gn_mobile_monitoring/assets/tables_csv/t_sites_complements.csv',
      // 't_sites_groups':
      //     '/home/aschlegel/gn_mobile_monitoring/assets/tables_csv/t_sites_groups.csv',
      // 't_visit_complements':
      //     '/home/aschlegel/gn_mobile_monitoring/assets/tables_csv/t_visit_complements.csv',
    };

    for (final entry in tableFiles.entries) {
      final tableName = entry.key;
      final filePath = entry.value;

      try {
        print('Importing CSV for table: $tableName');
        await importCsv(tableName, filePath);
        print('Successfully imported CSV for table: $tableName');
      } catch (e) {
        print('Error importing CSV for table: $tableName. Error: $e');
      }
    }
  }
}

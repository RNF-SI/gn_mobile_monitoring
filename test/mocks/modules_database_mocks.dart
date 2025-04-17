import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/db/dao/modules_dao.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:mocktail/mocktail.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

class MockModulesDao extends Mock implements ModulesDao {}

class MockDB implements DB {
  final AppDatabase mockDatabase;

  MockDB(this.mockDatabase);

  @override
  Future<AppDatabase> get database async => mockDatabase;

  @override
  Future<void> resetDatabase() async {}
}

class MockQueryResult {
  final List<Map<String, dynamic>> data;

  MockQueryResult(this.data);

  Future<List<Map<String, dynamic>>> get get async => data;
}

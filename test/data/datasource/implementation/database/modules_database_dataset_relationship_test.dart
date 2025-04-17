import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/modules_database_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/modules_database_mocks.dart';

void main() {
  late ModuleDatabaseImpl moduleDatabase;
  late MockAppDatabase mockDatabase;
  late MockModulesDao mockModulesDao;

  setUp(() {
    mockDatabase = MockAppDatabase();
    mockModulesDao = MockModulesDao();
    when(() => mockDatabase.modulesDao).thenReturn(mockModulesDao);
    moduleDatabase = ModuleDatabaseImpl();
  });

  group('Module-Dataset relationship tests', () {
    test('Should associate a module with a dataset', () async {
      const moduleId = 1;
      const datasetId = 2;

      // Mock DB.instance to return our mock database
      final originalDB = DB.instance;
      DB.setInstance(MockDB(mockDatabase));

      // Setup mock for the DAO
      when(() => mockModulesDao.associateModuleWithDataset(moduleId, datasetId))
          .thenAnswer((_) async {});

      // Call method
      await moduleDatabase.associateModuleWithDataset(moduleId, datasetId);

      // Verify that we're using the ModulesDao
      verify(() => mockModulesDao.associateModuleWithDataset(moduleId, datasetId)).called(1);

      // Restore original DB instance
      DB.setInstance(originalDB);
    });

    test('Should get datasets for a module', () async {
      const moduleId = 1;
      final expectedDatasets = [1, 2, 3];

      // Mock DB.instance to return our mock database
      final originalDB = DB.instance;
      DB.setInstance(MockDB(mockDatabase));

      // Setup mock for the DAO
      when(() => mockModulesDao.getDatasetIdsForModule(moduleId))
          .thenAnswer((_) async => expectedDatasets);

      // Call method
      final result = await moduleDatabase.getDatasetIdsForModule(moduleId);

      // Verify result and DAO usage
      expect(result, equals(expectedDatasets));
      verify(() => mockModulesDao.getDatasetIdsForModule(moduleId)).called(1);

      // Restore original DB instance
      DB.setInstance(originalDB);
    });
  });
}
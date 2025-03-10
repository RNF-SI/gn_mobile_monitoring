import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/entity/module_complement_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/module_entity.dart';
import 'package:gn_mobile_monitoring/data/repository/modules_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late ModulesRepositoryImpl repository;
  late MockGlobalApi mockGlobalApi;
  late MockModulesApi mockModulesApi;
  late MockModulesDatabase mockModulesDatabase;
  late MockNomenclaturesDatabase mockNomenclaturesDatabase;
  late MockDatasetsDatabase mockDatasetsDatabase;

  setUp(() {
    mockGlobalApi = MockGlobalApi();
    mockModulesApi = MockModulesApi();
    mockModulesDatabase = MockModulesDatabase();
    mockNomenclaturesDatabase = MockNomenclaturesDatabase();
    mockDatasetsDatabase = MockDatasetsDatabase();

    repository = ModulesRepositoryImpl(
      mockGlobalApi,
      mockModulesApi,
      mockModulesDatabase,
      mockNomenclaturesDatabase,
      mockDatasetsDatabase,
    );
  });

  group('getModulesFromLocal', () {
    test('should return modules from local database', () async {
      // Arrange
      final mockModules = [
        Module(
          id: 1,
          moduleCode: 'code1',
          moduleLabel: 'Module 1',
          moduleDesc: 'Description 1',
          modulePath: 'path/to/module1',
          activeFrontend: true,
          moduleTarget: 'target1',
          modulePicto: 'picto1',
          moduleDocUrl: 'doc/url1',
          moduleGroup: 'group1',
          downloaded: true,
        ),
      ];

      when(() => mockModulesDatabase.getAllModules())
          .thenAnswer((_) async => mockModules);

      // Act
      final result = await repository.getModulesFromLocal();

      // Assert
      expect(result, equals(mockModules));
      verify(() => mockModulesDatabase.getAllModules()).called(1);
    });
  });

  group('fetchAndSyncModulesFromApi', () {
    test('should fetch modules from API and update local database', () async {
      // Arrange
      final mockToken = 'test_token';

      final moduleEntities = [
        ModuleEntity(
          idModule: 1,
          moduleCode: 'code1',
          moduleName: 'Module 1',
          moduleDesc: 'Description 1',
          modulePath: 'path/to/module1',
          modulePicto: 'picto1',
          downloaded: true,
        ),
      ];

      final moduleComplementEntities = [
        ModuleComplementEntity(
          idModule: 1,
          bSynthese: false,
          taxonomyDisplayFieldName: 'nom_vern,lb_nom',
        ),
      ];

      when(() => mockModulesApi.getModules(mockToken))
          .thenAnswer((_) async => (moduleEntities, moduleComplementEntities));

      when(() => mockModulesDatabase.clearAllData())
          .thenAnswer((_) async => {});

      when(() => mockModulesDatabase.insertModules(any()))
          .thenAnswer((_) async => {});

      when(() => mockModulesDatabase.insertModuleComplements(any()))
          .thenAnswer((_) async => {});

      // Act
      await repository.fetchAndSyncModulesFromApi(mockToken);

      // Assert
      verify(() => mockModulesApi.getModules(mockToken)).called(1);
      verify(() => mockModulesDatabase.clearAllData()).called(1);
      verify(() => mockModulesDatabase.insertModules(any())).called(1);
      verify(() => mockModulesDatabase.insertModuleComplements(any()))
          .called(1);
    });
  });

  // Les autres tests pour incrementalSyncModulesFromApi et downloadModuleData
  // suivront le même modèle
}

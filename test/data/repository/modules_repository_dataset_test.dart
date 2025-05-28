import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/modules_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/taxon_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/datasets_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/nomenclatures_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/taxon_database.dart';
import 'package:gn_mobile_monitoring/data/entity/dataset_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/nomenclature_entity.dart';
import 'package:gn_mobile_monitoring/data/repository/modules_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockGlobalApi extends Mock implements GlobalApi {}

class MockModulesApi extends Mock implements ModulesApi {}

class MockTaxonApi extends Mock implements TaxonApi {}

class MockModulesDatabase extends Mock implements ModulesDatabase {}

class MockNomenclaturesDatabase extends Mock implements NomenclaturesDatabase {}

class MockDatasetsDatabase extends Mock implements DatasetsDatabase {}

class MockTaxonDatabase extends Mock implements TaxonDatabase {}

class MockTaxonRepository extends Mock implements TaxonRepository {}

class MockSitesRepository extends Mock implements SitesRepository {}

void main() {
  late ModulesRepositoryImpl repository;
  late MockGlobalApi mockGlobalApi;
  late MockModulesApi mockModulesApi;
  late MockTaxonApi mockTaxonApi;
  late MockModulesDatabase mockModulesDatabase;
  late MockNomenclaturesDatabase mockNomenclaturesDatabase;
  late MockDatasetsDatabase mockDatasetsDatabase;
  late MockTaxonDatabase mockTaxonDatabase;
  late MockTaxonRepository mockTaxonRepository;
  late MockSitesRepository mockSitesRepository;

  setUp(() {
    mockGlobalApi = MockGlobalApi();
    mockModulesApi = MockModulesApi();
    mockTaxonApi = MockTaxonApi();
    mockModulesDatabase = MockModulesDatabase();
    mockNomenclaturesDatabase = MockNomenclaturesDatabase();
    mockDatasetsDatabase = MockDatasetsDatabase();
    mockTaxonDatabase = MockTaxonDatabase();
    mockTaxonRepository = MockTaxonRepository();
    mockSitesRepository = MockSitesRepository();

    repository = ModulesRepositoryImpl(
      mockGlobalApi,
      mockModulesApi,
      mockTaxonApi,
      mockModulesDatabase,
      mockNomenclaturesDatabase,
      mockDatasetsDatabase,
      mockTaxonDatabase,
      mockTaxonRepository,
      mockSitesRepository,
    );
  });

  group('ModulesRepositoryImpl', () {
    test('should initialize correctly', () {
      expect(repository, isNotNull);
    });
  });

  // Note: downloadModuleData method has been removed from ModulesRepositoryImpl
  // as part of the refactoring. Dataset-related functionality has been moved
  // to appropriate dedicated repositories and services.
}
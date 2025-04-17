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

  setUp(() {
    mockGlobalApi = MockGlobalApi();
    mockModulesApi = MockModulesApi();
    mockTaxonApi = MockTaxonApi();
    mockModulesDatabase = MockModulesDatabase();
    mockNomenclaturesDatabase = MockNomenclaturesDatabase();
    mockDatasetsDatabase = MockDatasetsDatabase();
    mockTaxonDatabase = MockTaxonDatabase();
    mockTaxonRepository = MockTaxonRepository();

    repository = ModulesRepositoryImpl(
      mockGlobalApi,
      mockModulesApi,
      mockTaxonApi,
      mockModulesDatabase,
      mockNomenclaturesDatabase,
      mockDatasetsDatabase,
      mockTaxonDatabase,
      mockTaxonRepository,
    );
  });

  group('downloadModuleData', () {
    const moduleId = 1;
    const moduleCode = 'MONITORING';

    final datasetsJson = [
      {
        'id_dataset': 1,
        'unique_dataset_id': 'uuid1',
        'id_acquisition_framework': 1,
        'dataset_name': 'Dataset 1',
        'dataset_shortname': 'DS1',
        'dataset_desc': 'Description 1',
        'id_nomenclature_data_type': 1,
        'keywords': 'keywords',
        'marine_domain': false,
        'terrestrial_domain': true,
        'id_nomenclature_dataset_objectif': 1,
        'id_nomenclature_collecting_method': 1,
        'id_nomenclature_data_origin': 1,
        'id_nomenclature_source_status': 1,
        'id_nomenclature_resource_type': 1,
      },
      {
        'id_dataset': 2,
        'unique_dataset_id': 'uuid2',
        'id_acquisition_framework': 2,
        'dataset_name': 'Dataset 2',
        'dataset_shortname': 'DS2',
        'dataset_desc': 'Description 2',
        'id_nomenclature_data_type': 2,
        'keywords': 'keywords',
        'marine_domain': true,
        'terrestrial_domain': false,
        'id_nomenclature_dataset_objectif': 2,
        'id_nomenclature_collecting_method': 2,
        'id_nomenclature_data_origin': 2,
        'id_nomenclature_source_status': 2,
        'id_nomenclature_resource_type': 2,
      },
    ];

    final nomenclatureEntities = [
      {
        'id_nomenclature': 1,
        'id_type': 1,
        'cd_nomenclature': 'CD1',
        'mnemonique': 'MNEM1',
        'label_default': 'Label 1',
        'definition_default': 'Def 1',
        'label_fr': 'Label FR 1',
        'definition_fr': 'Def FR 1',
        'id_broader': null,
        'hierarchy': 'HIER1',
        'active': true,
      },
      {
        'id_nomenclature': 2,
        'id_type': 1,
        'cd_nomenclature': 'CD2',
        'mnemonique': 'MNEM2',
        'label_default': 'Label 2',
        'definition_default': 'Def 2',
        'label_fr': 'Label FR 2',
        'definition_fr': 'Def FR 2',
        'id_broader': null,
        'hierarchy': 'HIER2',
        'active': true,
      },
    ];

    test('associates each dataset with the module during download', () async {
      // Setup
      when(() => mockModulesDatabase.getModuleCodeFromIdModule(moduleId))
          .thenAnswer((_) async => moduleCode);

      when(() => mockGlobalApi.getNomenclaturesAndDatasets(moduleCode))
          .thenAnswer((_) async => (
                nomenclatures: nomenclatureEntities
                    .map((e) => NomenclatureEntity.fromJson(e))
                    .toList(),
                nomenclatureTypes: <Map<String, dynamic>>[],
                datasets:
                    datasetsJson.map((e) => DatasetEntity.fromJson(e)).toList(),
              ));

      when(() => mockGlobalApi.getModuleConfiguration(moduleCode))
          .thenAnswer((_) async => <String, dynamic>{});

      when(() => mockGlobalApi.getSiteTypes())
          .thenAnswer((_) async => <Map<String, dynamic>>[]);

      when(() => mockDatasetsDatabase.insertDatasets(any()))
          .thenAnswer((_) async {});

      when(() => mockNomenclaturesDatabase.insertNomenclatures(any()))
          .thenAnswer((_) async {});

      when(() => mockNomenclaturesDatabase.insertNomenclatureTypes(any()))
          .thenAnswer((_) async {});

      when(() => mockModulesDatabase.updateModuleComplementConfiguration(
          any(), any())).thenAnswer((_) async {});

      when(() => mockModulesDatabase.markModuleAsDownloaded(any()))
          .thenAnswer((_) async {});

      when(() => mockModulesDatabase.associateModuleWithDataset(any(), any()))
          .thenAnswer((_) async {});

      // Execute
      await repository.downloadModuleData(moduleId);

      // Verify
      verify(() => mockDatasetsDatabase.insertDatasets(any())).called(1);

      // Verify each dataset was associated with the module
      verify(() => mockModulesDatabase.associateModuleWithDataset(moduleId, 1))
          .called(1);
      verify(() => mockModulesDatabase.associateModuleWithDataset(moduleId, 2))
          .called(1);
    });
  });
}

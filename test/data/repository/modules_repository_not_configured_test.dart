import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/repository/modules_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/entity/dataset_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/nomenclature_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late ModulesRepositoryImpl repository;
  late MockGlobalApi mockGlobalApi;
  late MockModulesApi mockModulesApi;
  late MockModulesDatabase mockModulesDatabase;
  late MockNomenclaturesDatabase mockNomenclaturesDatabase;
  late MockDatasetsDatabase mockDatasetsDatabase;
  late MockTaxonApi mockTaxonApi;
  late MockTaxonDatabase mockTaxonDatabase;
  late MockTaxonRepository mockTaxonRepository;
  late MockSitesRepository mockSitesRepository;
  late MockVersionApi mockVersionApi;

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
    mockVersionApi = MockVersionApi();

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
      mockVersionApi,
    );
  });

  test('module non configuré (#752) → refus avant toute écriture', () async {
    const token = 'jeton';
    when(() => mockVersionApi.fetchMonitoringVersion(token))
        .thenAnswer((_) async => '1.3.2');
    when(() => mockModulesDatabase.getModuleCodeFromIdModule(1))
        .thenAnswer((_) async => 'POPAmphibien');
    when(() => mockGlobalApi.getNomenclaturesAndDatasets(1, token: token))
        .thenAnswer((_) async => (
              nomenclatures: <NomenclatureEntity>[],
              datasets: <DatasetEntity>[],
              nomenclatureTypes: <Map<String, dynamic>>[],
              configuration: <String, dynamic>{
                'configured': false,
                'module': {'module_label': 'POP Amphibien'},
              },
            ));

    await expectLater(
      () => suppressOutput(() => repository.downloadCompleteModule(1, token)),
      throwsA(isA<Exception>().having((e) => e.toString(), 'message',
          contains("Le module POP Amphibien n'est pas encore configuré"))),
    );

    verifyNever(() => mockNomenclaturesDatabase.insertNomenclatures(any()));
    verifyNever(
        () => mockModulesDatabase.updateModuleComplementConfiguration(any(), any()));
  });

  test('ModuleConfiguration lit configured', () {
    expect(ModuleConfiguration.fromJson({'configured': false}).configured,
        false);
    expect(ModuleConfiguration.fromJson({}).configured, isNull);
  });
}

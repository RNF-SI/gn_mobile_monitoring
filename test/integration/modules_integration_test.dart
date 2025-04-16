import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/taxon_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/taxon_database.dart';
import 'package:gn_mobile_monitoring/data/repository/modules_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_modules_usecase_impl.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart'
    as custom_async_state;
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/mocks.dart';

class MockTaxonApi extends Mock implements TaxonApi {}
class MockTaxonDatabase extends Mock implements TaxonDatabase {}

/// Ce test d'intégration teste la chaîne complète depuis le repository jusqu'au viewmodel
/// pour s'assurer que les données circulent correctement à travers les couches.
void main() {
  late ProviderContainer container;
  late MockGlobalApi mockGlobalApi;
  late MockModulesApi mockModulesApi;
  late MockModulesDatabase mockModulesDatabase;
  late MockNomenclaturesDatabase mockNomenclaturesDatabase;
  late MockDatasetsDatabase mockDatasetsDatabase;
  late ModulesRepositoryImpl repository;
  late GetModulesUseCaseImpl useCase;
  late MockTaxonApi mockTaxonApi;
  late MockTaxonDatabase mockTaxonDatabase;

  setUp(() {
    mockGlobalApi = MockGlobalApi();
    mockModulesApi = MockModulesApi();
    mockTaxonApi = MockTaxonApi();
    mockModulesDatabase = MockModulesDatabase();
    mockNomenclaturesDatabase = MockNomenclaturesDatabase();
    mockDatasetsDatabase = MockDatasetsDatabase();
    mockTaxonDatabase = MockTaxonDatabase();

    // Mock for TaxonRepository
    final mockTaxonRepository = MockTaxonRepository();
    
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

    useCase = GetModulesUseCaseImpl(repository);

    // Override les providers pour utiliser nos instances mockées
    container = ProviderContainer(
      overrides: [
        modulesRepositoryProvider.overrideWithValue(repository),
        getModulesUseCaseProvider.overrideWithValue(useCase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('Integration test: Repository to ViewModel', () async {
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
      Module(
        id: 2,
        moduleCode: 'code2',
        moduleLabel: 'Module 2',
        moduleDesc: 'Description 2',
        modulePath: 'path/to/module2',
        activeFrontend: true,
        moduleTarget: 'target2',
        modulePicto: 'picto2',
        moduleDocUrl: 'doc/url2',
        moduleGroup: 'group2',
        downloaded: false,
      ),
    ];

    // Mock database response
    when(() => mockModulesDatabase.getAllModules())
        .thenAnswer((_) async => mockModules);

    // Act: Le ViewModel charge les modules lors de son initialisation
    final viewModel =
        container.read(userModuleListeViewModelStateNotifierProvider.notifier);

    // Force un rechargement explicite
    await viewModel.loadModules();

    // Assert: Vérifie que le state du ViewModel contient bien les modules
    final state = container.read(userModuleListeViewModelStateNotifierProvider);
    expect(state, isA<custom_async_state.State>());

    final moduleInfoListe = state.data!;
    expect(moduleInfoListe.values.length, equals(2));

    // Vérifie que le premier module est bien celui qui est marqué comme téléchargé
    expect(moduleInfoListe.values[0].module.id, equals(1));
    expect(moduleInfoListe.values[0].module.moduleLabel, equals('Module 1'));
    expect(moduleInfoListe.values[0].downloadStatus,
        equals(ModuleDownloadStatus.moduleDownloaded));

    // Vérifie que le second module est marqué comme non téléchargé
    expect(moduleInfoListe.values[1].module.id, equals(2));
    expect(moduleInfoListe.values[1].module.moduleLabel, equals('Module 2'));
    expect(moduleInfoListe.values[1].downloadStatus,
        equals(ModuleDownloadStatus.moduleNotDownloaded));

    // Vérifie les appels
    verify(() => mockModulesDatabase.getAllModules())
        .called(2); // Une fois lors de l'init, une fois lors du loadModules
  });
}

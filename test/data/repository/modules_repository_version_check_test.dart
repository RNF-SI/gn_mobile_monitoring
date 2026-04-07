import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/version_incompatible_exception.dart';
import 'package:gn_mobile_monitoring/data/repository/modules_repository_impl.dart';
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

  group('downloadCompleteModule - version check', () {
    const testToken = 'test_token';
    const testModuleId = 1;

    test('version OK (1.2.0) → le téléchargement continue', () async {
      // Arrange - version compatible
      when(() => mockVersionApi.fetchMonitoringVersion(testToken))
          .thenAnswer((_) async => '1.2.0');

      // Le reste du téléchargement a besoin de ces mocks pour continuer
      when(() => mockModulesDatabase.getModuleCodeFromIdModule(testModuleId))
          .thenAnswer((_) async => 'TEST_MODULE');
      when(() => mockGlobalApi.getNomenclaturesAndDatasets(testModuleId,
              token: testToken))
          .thenThrow(
              Exception('Stop ici - on vérifie juste que la version passe'));

      // Act & Assert - l'exception vient du mock getNomenclaturesAndDatasets,
      // pas du version check
      await expectLater(
        () => suppressOutput(
          () => repository.downloadCompleteModule(testModuleId, testToken),
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Stop ici'),
        )),
      );

      // Vérifie que le version check a été appelé
      verify(() => mockVersionApi.fetchMonitoringVersion(testToken)).called(1);
      // Vérifie que le code continue après le version check
      verify(() => mockModulesDatabase.getModuleCodeFromIdModule(testModuleId))
          .called(1);
    });

    test('version trop vieille (1.1.0) → throw VersionIncompatibleException',
        () async {
      when(() => mockVersionApi.fetchMonitoringVersion(testToken))
          .thenAnswer((_) async => '1.1.0');

      await expectLater(
        () => suppressOutput(
          () => repository.downloadCompleteModule(testModuleId, testToken),
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('version'),
        )),
      );

      // Aucun autre appel API ne doit être fait
      verifyNever(
          () => mockModulesDatabase.getModuleCodeFromIdModule(any()));
      verifyNever(() => mockGlobalApi.getNomenclaturesAndDatasets(any(),
          token: any(named: 'token')));
    });

    test('version null (module non trouvé) → throw VersionIncompatibleException',
        () async {
      when(() => mockVersionApi.fetchMonitoringVersion(testToken))
          .thenAnswer((_) async => null);

      await expectLater(
        () => suppressOutput(
          () => repository.downloadCompleteModule(testModuleId, testToken),
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('version'),
        )),
      );

      // Aucun autre appel API ne doit être fait
      verifyNever(
          () => mockModulesDatabase.getModuleCodeFromIdModule(any()));
    });

    test('version avec pre-release (1.2.0rc1) → throw car inférieure à 1.2.0',
        () async {
      when(() => mockVersionApi.fetchMonitoringVersion(testToken))
          .thenAnswer((_) async => '1.2.0rc1');

      await expectLater(
        () => suppressOutput(
          () => repository.downloadCompleteModule(testModuleId, testToken),
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('version'),
        )),
      );

      verifyNever(
          () => mockModulesDatabase.getModuleCodeFromIdModule(any()));
    });

    test('version supérieure (2.0.0) → le téléchargement continue', () async {
      when(() => mockVersionApi.fetchMonitoringVersion(testToken))
          .thenAnswer((_) async => '2.0.0');

      when(() => mockModulesDatabase.getModuleCodeFromIdModule(testModuleId))
          .thenAnswer((_) async => 'TEST_MODULE');
      when(() => mockGlobalApi.getNomenclaturesAndDatasets(testModuleId,
              token: testToken))
          .thenThrow(Exception('Stop ici'));

      await expectLater(
        () => suppressOutput(
          () => repository.downloadCompleteModule(testModuleId, testToken),
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Stop ici'),
        )),
      );

      verify(() => mockVersionApi.fetchMonitoringVersion(testToken)).called(1);
      verify(() => mockModulesDatabase.getModuleCodeFromIdModule(testModuleId))
          .called(1);
    });

    test('callbacks de progression sont appelés pendant le version check',
        () async {
      when(() => mockVersionApi.fetchMonitoringVersion(testToken))
          .thenAnswer((_) async => '1.0.0');

      final steps = <String>[];
      final progress = <double>[];

      try {
        await suppressOutput(
          () => repository.downloadCompleteModule(
            testModuleId,
            testToken,
            onProgressUpdate: (p) => progress.add(p),
            onStepUpdate: (s) => steps.add(s),
          ),
        );
      } catch (_) {}

      expect(steps, contains('Vérification de la version du serveur'));
      expect(progress, contains(0.05));
    });
  });
}

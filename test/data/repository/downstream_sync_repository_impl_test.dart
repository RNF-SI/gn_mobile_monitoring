import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/entity/nomenclature_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/dataset_entity.dart';
import 'package:gn_mobile_monitoring/data/repository/downstream_sync_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late DownstreamSyncRepositoryImpl repository;
  late MockGlobalApi mockGlobalApi;
  late MockTaxonApi mockTaxonApi;
  late MockGlobalDatabase mockGlobalDatabase;
  late MockNomenclaturesDatabase mockNomenclaturesDatabase;
  late MockDatasetsDatabase mockDatasetsDatabase;
  late MockTaxonDatabase mockTaxonDatabase;
  late MockModulesRepository mockModulesRepository;
  late MockSitesRepository mockSitesRepository;
  late MockVisitesDatabase mockVisitesDatabase;
  late MockObservationsDatabase mockObservationsDatabase;

  setUp(() {
    mockGlobalApi = MockGlobalApi();
    mockTaxonApi = MockTaxonApi();
    mockGlobalDatabase = MockGlobalDatabase();
    mockNomenclaturesDatabase = MockNomenclaturesDatabase();
    mockDatasetsDatabase = MockDatasetsDatabase();
    mockTaxonDatabase = MockTaxonDatabase();
    mockModulesRepository = MockModulesRepository();
    mockSitesRepository = MockSitesRepository();
    mockVisitesDatabase = MockVisitesDatabase();
    mockObservationsDatabase = MockObservationsDatabase();

    repository = DownstreamSyncRepositoryImpl(
      mockGlobalApi,
      mockTaxonApi,
      mockGlobalDatabase,
      mockNomenclaturesDatabase,
      mockDatasetsDatabase,
      mockTaxonDatabase,
      modulesRepository: mockModulesRepository,
      sitesRepository: mockSitesRepository,
      visitesDatabase: mockVisitesDatabase,
      observationsDatabase: mockObservationsDatabase,
    );
  });

  /// Suppress debugPrint output during tests
  Future<T> suppressOutput<T>(Future<T> Function() callback) async {
    return await runZoned(
      callback,
      zoneSpecification: ZoneSpecification(
        print: (Zone self, ZoneDelegate parent, Zone zone, String line) {},
      ),
    );
  }

  group('checkConnectivity', () {
    test('returns true when API is reachable', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);

      final result = await repository.checkConnectivity();

      expect(result, true);
      verify(() => mockGlobalApi.checkConnectivity()).called(1);
    });

    test('returns false when API throws exception', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenThrow(Exception('Network error'));

      final result =
          await suppressOutput(() => repository.checkConnectivity());

      expect(result, false);
    });
  });

  group('getLastSyncDate', () {
    test('returns date from database', () async {
      final date = DateTime(2024, 6, 1);
      when(() => mockGlobalDatabase.getLastSyncDate('modules'))
          .thenAnswer((_) async => date);

      final result = await repository.getLastSyncDate('modules');

      expect(result, date);
      verify(() => mockGlobalDatabase.getLastSyncDate('modules')).called(1);
    });

    test('returns null when database throws', () async {
      when(() => mockGlobalDatabase.getLastSyncDate('modules'))
          .thenThrow(Exception('DB error'));

      final result =
          await suppressOutput(() => repository.getLastSyncDate('modules'));

      expect(result, isNull);
    });
  });

  group('updateLastSyncDate', () {
    test('delegates to database', () async {
      final date = DateTime(2024, 6, 1);
      when(() => mockGlobalDatabase.updateLastSyncDate('modules', date))
          .thenAnswer((_) async {});

      await repository.updateLastSyncDate('modules', date);

      verify(() => mockGlobalDatabase.updateLastSyncDate('modules', date))
          .called(1);
    });

    test('rethrows exception on failure', () async {
      final date = DateTime(2024, 6, 1);
      when(() => mockGlobalDatabase.updateLastSyncDate('modules', date))
          .thenThrow(Exception('DB error'));

      expect(
        () => suppressOutput(
            () => repository.updateLastSyncDate('modules', date)),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('syncConfiguration', () {
    test('returns failure when not connected', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => false);

      final result =
          await suppressOutput(() => repository.syncConfiguration('token'));

      expect(result.success, false);
      expect(result.errorMessage, contains('Pas de connexion Internet'));
    });

    test('returns success with 0 items when no downloaded modules', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);
      when(() => mockModulesRepository.getModulesFromLocal())
          .thenAnswer((_) async => []);

      final result =
          await suppressOutput(() => repository.syncConfiguration('token'));

      expect(result.success, true);
      expect(result.itemsProcessed, 0);
    });

    test('returns success with 0 items when modules exist but none downloaded',
        () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);
      when(() => mockModulesRepository.getModulesFromLocal())
          .thenAnswer((_) async => [
                const Module(
                    id: 1,
                    moduleLabel: 'Test',
                    moduleCode: 'TEST',
                    downloaded: false),
              ]);

      final result =
          await suppressOutput(() => repository.syncConfiguration('token'));

      expect(result.success, true);
      expect(result.itemsProcessed, 0);
    });

    test('delegates to API when downloaded modules exist', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);
      when(() => mockModulesRepository.getModulesFromLocal())
          .thenAnswer((_) async => [
                const Module(
                    id: 1,
                    moduleLabel: 'Test',
                    moduleCode: 'MOD1',
                    downloaded: true),
              ]);

      final expectedResult = SyncResult.success(
        itemsProcessed: 5,
        itemsAdded: 3,
        itemsUpdated: 2,
        itemsSkipped: 0,
      );
      when(() => mockGlobalApi.syncConfiguration('token', ['MOD1']))
          .thenAnswer((_) async => expectedResult);
      when(() => mockGlobalDatabase.updateLastSyncDate(
              'configuration', any()))
          .thenAnswer((_) async {});

      final result =
          await suppressOutput(() => repository.syncConfiguration('token'));

      expect(result.success, true);
      verify(() => mockGlobalApi.syncConfiguration('token', ['MOD1']))
          .called(1);
    });

    test('returns failure with network error message on failed host lookup',
        () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);
      when(() => mockModulesRepository.getModulesFromLocal())
          .thenAnswer((_) async => [
                const Module(
                    id: 1,
                    moduleLabel: 'Test',
                    moduleCode: 'MOD1',
                    downloaded: true),
              ]);
      when(() => mockGlobalApi.syncConfiguration('token', ['MOD1']))
          .thenThrow(Exception('Failed host lookup'));

      final result =
          await suppressOutput(() => repository.syncConfiguration('token'));

      expect(result.success, false);
      expect(result.errorMessage, contains('Erreur réseau'));
    });
  });

  group('syncModules', () {
    test('returns failure when not connected', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => false);

      final result =
          await suppressOutput(() => repository.syncModules('token'));

      expect(result.success, false);
      expect(result.errorMessage, contains('Pas de connexion Internet'));
    });

    test('delegates to modulesRepository and returns success', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);
      when(() => mockModulesRepository.getModulesFromLocal())
          .thenAnswer((_) async => [
                const Module(
                    id: 1,
                    moduleLabel: 'M1',
                    moduleCode: 'M1',
                    downloaded: true),
              ]);
      when(() => mockModulesRepository.incrementalSyncModulesFromApi('token'))
          .thenAnswer((_) async {});
      when(() => mockGlobalDatabase.updateLastSyncDate('modules', any()))
          .thenAnswer((_) async {});

      final result =
          await suppressOutput(() => repository.syncModules('token'));

      expect(result.success, true);
      verify(() => mockModulesRepository.incrementalSyncModulesFromApi('token'))
          .called(1);
    });

    test('returns failure when sync throws', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);
      when(() => mockModulesRepository.getModulesFromLocal())
          .thenAnswer((_) async => []);
      when(() => mockModulesRepository.incrementalSyncModulesFromApi('token'))
          .thenThrow(Exception('Sync failed'));

      final result =
          await suppressOutput(() => repository.syncModules('token'));

      expect(result.success, false);
      expect(result.errorMessage, contains('synchronisation des modules'));
    });
  });

  group('syncSites', () {
    test('returns failure when not connected', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => false);

      final result =
          await suppressOutput(() => repository.syncSites('token'));

      expect(result.success, false);
    });

    test('delegates to sitesRepository', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);
      final expectedResult = SyncResult.success(
        itemsProcessed: 10,
        itemsAdded: 5,
        itemsUpdated: 5,
        itemsSkipped: 0,
      );
      when(() => mockSitesRepository
              .incrementalSyncSitesWithConflictHandling('token'))
          .thenAnswer((_) async => expectedResult);
      when(() => mockGlobalDatabase.updateLastSyncDate('sites', any()))
          .thenAnswer((_) async {});

      final result =
          await suppressOutput(() => repository.syncSites('token'));

      expect(result.success, true);
      verify(() => mockSitesRepository
              .incrementalSyncSitesWithConflictHandling('token'))
          .called(1);
    });
  });

  group('syncSiteGroups', () {
    test('returns failure when not connected', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => false);

      final result =
          await suppressOutput(() => repository.syncSiteGroups('token'));

      expect(result.success, false);
    });

    test('delegates to sitesRepository', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);
      final expectedResult = SyncResult.success(
        itemsProcessed: 3,
        itemsAdded: 1,
        itemsUpdated: 2,
        itemsSkipped: 0,
      );
      when(() => mockSitesRepository
              .incrementalSyncSiteGroupsWithConflictHandling('token'))
          .thenAnswer((_) async => expectedResult);
      when(() => mockGlobalDatabase.updateLastSyncDate('siteGroups', any()))
          .thenAnswer((_) async {});

      final result =
          await suppressOutput(() => repository.syncSiteGroups('token'));

      expect(result.success, true);
      verify(() => mockSitesRepository
              .incrementalSyncSiteGroupsWithConflictHandling('token'))
          .called(1);
    });
  });

  group('syncObservers', () {
    test('returns failure when not connected', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => false);

      final result =
          await suppressOutput(() => repository.syncObservers('token'));

      expect(result.success, false);
    });

    test('returns success (stub implementation)', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);
      when(() => mockGlobalDatabase.getLastSyncDate('observers'))
          .thenAnswer((_) async => null);
      when(() => mockGlobalDatabase.updateLastSyncDate('observers', any()))
          .thenAnswer((_) async {});

      final result =
          await suppressOutput(() => repository.syncObservers('token'));

      expect(result.success, true);
      expect(result.itemsProcessed, 0);
    });
  });

  group('syncNomenclatures', () {
    test('delegates to syncNomenclaturesAndDatasets', () async {
      // syncNomenclatures simply calls syncNomenclaturesAndDatasets
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => false);

      final result =
          await suppressOutput(() => repository.syncNomenclatures('token'));

      expect(result.success, false);
      expect(result.errorMessage, contains('Pas de connexion Internet'));
    });
  });

  group('syncTaxons', () {
    test('returns failure when not connected', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => false);

      final result =
          await suppressOutput(() => repository.syncTaxons('token'));

      expect(result.success, false);
      expect(result.errorMessage, contains('Pas de connexion Internet'));
    });

    test('returns success with 0 items when no downloaded modules', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);
      when(() => mockModulesRepository.getModulesFromLocal())
          .thenAnswer((_) async => []);

      final result =
          await suppressOutput(() => repository.syncTaxons('token'));

      expect(result.success, true);
      expect(result.itemsProcessed, 0);
    });
  });
}

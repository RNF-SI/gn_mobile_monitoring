import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/entity/base_visit_entity.dart';
import 'package:gn_mobile_monitoring/data/repository/upstream_sync_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

// Register fallback values for any() matchers
class FakeBaseVisitDomain extends Fake implements BaseVisit {}

class FakeObservation extends Fake implements Observation {}

class FakeObservationDetail extends Fake implements ObservationDetail {}

class FakeBaseSite extends Fake implements BaseSite {}

class FakeSiteGroup extends Fake implements SiteGroup {}

void main() {
  late UpstreamSyncRepositoryImpl repository;
  late MockGlobalApi mockGlobalApi;
  late MockGlobalDatabase mockGlobalDatabase;
  late MockModulesDatabase mockModulesDatabase;
  late MockVisitRepository mockVisitRepository;
  late MockObservationsRepository mockObservationsRepository;
  late MockObservationDetailsRepository mockObservationDetailsRepository;
  late MockSitesRepository mockSitesRepository;

  setUpAll(() {
    registerFallbackValue(FakeBaseVisitDomain());
    registerFallbackValue(FakeObservation());
    registerFallbackValue(FakeObservationDetail());
    registerFallbackValue(FakeBaseSite());
    registerFallbackValue(FakeSiteGroup());
  });

  setUp(() {
    mockGlobalApi = MockGlobalApi();
    mockGlobalDatabase = MockGlobalDatabase();
    mockModulesDatabase = MockModulesDatabase();
    mockVisitRepository = MockVisitRepository();
    mockObservationsRepository = MockObservationsRepository();
    mockObservationDetailsRepository = MockObservationDetailsRepository();
    mockSitesRepository = MockSitesRepository();

    repository = UpstreamSyncRepositoryImpl(
      mockGlobalApi,
      mockGlobalDatabase,
      mockModulesDatabase,
      visitRepository: mockVisitRepository,
      observationsRepository: mockObservationsRepository,
      observationDetailsRepository: mockObservationDetailsRepository,
      sitesRepository: mockSitesRepository,
    );
  });

  /// Suppress debugPrint/logger output during tests
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
    });

    test('returns false when API throws', () async {
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
      when(() => mockGlobalDatabase.getLastSyncDate('visitsToServer'))
          .thenAnswer((_) async => date);

      final result = await repository.getLastSyncDate('visitsToServer');

      expect(result, date);
    });

    test('returns null on error', () async {
      when(() => mockGlobalDatabase.getLastSyncDate('visitsToServer'))
          .thenThrow(Exception('DB error'));

      final result = await suppressOutput(
          () => repository.getLastSyncDate('visitsToServer'));

      expect(result, isNull);
    });
  });

  group('updateLastSyncDate', () {
    test('delegates to database', () async {
      final date = DateTime(2024, 6, 1);
      when(() => mockGlobalDatabase.updateLastSyncDate('visitsToServer', date))
          .thenAnswer((_) async {});

      await repository.updateLastSyncDate('visitsToServer', date);

      verify(() =>
              mockGlobalDatabase.updateLastSyncDate('visitsToServer', date))
          .called(1);
    });

    test('rethrows exception', () async {
      final date = DateTime(2024, 6, 1);
      when(() => mockGlobalDatabase.updateLastSyncDate('visitsToServer', date))
          .thenThrow(Exception('DB error'));

      expect(
        () => suppressOutput(
            () => repository.updateLastSyncDate('visitsToServer', date)),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('syncVisitsToServer', () {
    test('returns failure when not connected', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => false);

      final result = await suppressOutput(
          () => repository.syncVisitsToServer('token', 'MOD_TEST'));

      expect(result.success, false);
      expect(result.errorMessage, contains('Pas de connexion Internet'));
    });

    test('returns success with 0 items when no visits', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);
      when(() => mockVisitRepository.getVisitsByModuleCode('MOD_TEST'))
          .thenAnswer((_) async => []);
      when(() => mockGlobalDatabase.updateLastSyncDate(
              'visitsToServer', any()))
          .thenAnswer((_) async {});

      final result = await suppressOutput(
          () => repository.syncVisitsToServer('token', 'MOD_TEST'));

      expect(result.success, true);
      expect(result.itemsProcessed, 0);
      expect(result.itemsAdded, 0);
    });

    test('creates new visit via POST when serverVisitId is null', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);

      final visitEntity = BaseVisitEntity(
        idBaseVisit: 1,
        idBaseSite: 10,
        idDataset: 5,
        idModule: 3,
        visitDateMin: '2024-06-01',
        serverVisitId: null, // New visit
      );
      when(() => mockVisitRepository.getVisitsByModuleCode('MOD_TEST'))
          .thenAnswer((_) async => [visitEntity]);
      when(() => mockVisitRepository.getVisitWithFullDetails(1))
          .thenAnswer((_) async => visitEntity);
      when(() => mockModulesDatabase.getModuleCodeFromIdModule(3))
          .thenAnswer((_) async => 'MOD_TEST');
      when(() => mockSitesRepository.getSiteById(10))
          .thenAnswer((_) async => const BaseSite(
                idBaseSite: 10,
                baseSiteName: 'Site 10',
                isLocal: false,
              ));
      when(() => mockGlobalApi.sendVisit('token', 'MOD_TEST', any()))
          .thenAnswer((_) async => {'id': 100});
      when(() => mockVisitRepository.updateVisitServerId(1, 100))
          .thenAnswer((_) async {});

      // After POST success, observations are synced
      when(() => mockObservationsRepository.getObservationsByVisitId(1))
          .thenAnswer((_) async => []);
      when(() => mockVisitRepository.deleteVisit(1))
          .thenAnswer((_) async => true);
      when(() => mockGlobalDatabase.updateLastSyncDate(
              'visitsToServer', any()))
          .thenAnswer((_) async {});

      final result = await suppressOutput(
          () => repository.syncVisitsToServer('token', 'MOD_TEST'));

      expect(result.success, true);
      expect(result.itemsAdded, greaterThanOrEqualTo(1));
      verify(() => mockGlobalApi.sendVisit('token', 'MOD_TEST', any()))
          .called(1);
    });

    test('skips visit with missing idDataset', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);

      final visitEntity = BaseVisitEntity(
        idBaseVisit: 1,
        idBaseSite: 10,
        idDataset: 0, // Missing/invalid dataset
        idModule: 3,
        visitDateMin: '2024-06-01',
        serverVisitId: null,
      );
      when(() => mockVisitRepository.getVisitsByModuleCode('MOD_TEST'))
          .thenAnswer((_) async => [visitEntity]);
      when(() => mockVisitRepository.getVisitWithFullDetails(1))
          .thenAnswer((_) async => visitEntity);
      when(() => mockGlobalDatabase.updateLastSyncDate(
              'visitsToServer', any()))
          .thenAnswer((_) async {});

      final result = await suppressOutput(
          () => repository.syncVisitsToServer('token', 'MOD_TEST'));

      // Should fail because of the skipped visit error
      expect(result.itemsSkipped, greaterThanOrEqualTo(1));
      verifyNever(() => mockGlobalApi.sendVisit(any(), any(), any()));
    });
  });

  group('syncObservationsToServer', () {
    test('returns failure when not connected', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => false);

      final result = await suppressOutput(() =>
          repository.syncObservationsToServer('token', 'MOD_TEST', 1,
              serverVisitId: 100));

      expect(result.success, false);
      expect(result.errorMessage, contains('Pas de connexion Internet'));
    });

    test('returns success with 0 items when no observations', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);
      when(() => mockObservationsRepository.getObservationsByVisitId(1))
          .thenAnswer((_) async => []);

      final result = await suppressOutput(() =>
          repository.syncObservationsToServer('token', 'MOD_TEST', 1,
              serverVisitId: 100));

      expect(result.success, true);
      expect(result.itemsProcessed, 0);
    });

    test('creates new observation via POST', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);

      final observation = const Observation(
        idObservation: 1,
        idBaseVisit: 1,
        cdNom: 12345,
        comments: 'Test obs',
        serverObservationId: null, // New observation
      );
      when(() => mockObservationsRepository.getObservationsByVisitId(1))
          .thenAnswer((_) async => [observation]);
      when(() => mockGlobalApi.sendObservation('token', 'MOD_TEST', any()))
          .thenAnswer((_) async => {'id': 200});
      when(() => mockObservationsRepository.updateObservationServerId(1, 200))
          .thenAnswer((_) async => true);

      // After observation POST, details are synced
      when(() => mockObservationDetailsRepository
              .getObservationDetailsByObservationId(1))
          .thenAnswer((_) async => []);
      when(() => mockObservationsRepository.deleteObservation(1))
          .thenAnswer((_) async => true);

      final result = await suppressOutput(() =>
          repository.syncObservationsToServer('token', 'MOD_TEST', 1,
              serverVisitId: 100));

      expect(result.success, true);
      expect(result.itemsAdded, greaterThanOrEqualTo(1));
      verify(() => mockGlobalApi.sendObservation('token', 'MOD_TEST', any()))
          .called(1);
    });
  });

  group('syncObservationDetailsToServer', () {
    test('returns failure when not connected', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => false);

      final result = await suppressOutput(() =>
          repository.syncObservationDetailsToServer('token', 'MOD_TEST', 1,
              serverObservationId: 200));

      expect(result.success, false);
    });

    test('returns success with 0 items when no details', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);
      when(() => mockObservationDetailsRepository
              .getObservationDetailsByObservationId(1))
          .thenAnswer((_) async => []);

      final result = await suppressOutput(() =>
          repository.syncObservationDetailsToServer('token', 'MOD_TEST', 1,
              serverObservationId: 200));

      expect(result.success, true);
      expect(result.itemsProcessed, 0);
    });

    test('sends detail to server', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);

      final detail = const ObservationDetail(
        idObservationDetail: 1,
        idObservation: 1,
        data: {'denombrement': 5},
      );
      when(() => mockObservationDetailsRepository
              .getObservationDetailsByObservationId(1))
          .thenAnswer((_) async => [detail]);
      when(() =>
              mockGlobalApi.sendObservationDetail('token', 'MOD_TEST', any()))
          .thenAnswer((_) async => {'id': 300});
      when(() => mockObservationDetailsRepository.deleteObservationDetail(1))
          .thenAnswer((_) async => true);

      final result = await suppressOutput(() =>
          repository.syncObservationDetailsToServer('token', 'MOD_TEST', 1,
              serverObservationId: 200));

      expect(result.success, true);
      expect(result.itemsAdded, 1);
      verify(() =>
              mockGlobalApi.sendObservationDetail('token', 'MOD_TEST', any()))
          .called(1);
    });
  });

  group('syncSitesToServer', () {
    test('returns failure when not connected', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => false);

      final result = await suppressOutput(
          () => repository.syncSitesToServer('token', 'MOD_TEST'));

      expect(result.success, false);
      expect(result.errorMessage, contains('Pas de connexion Internet'));
    });

    test('returns success when no local sites', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);
      when(() => mockModulesDatabase.getModuleByCode('MOD_TEST'))
          .thenAnswer((_) async => const Module(
              id: 1, moduleLabel: 'Test', moduleCode: 'MOD_TEST'));
      when(() => mockSitesRepository.getLocalSitesByModuleCode('MOD_TEST'))
          .thenAnswer((_) async => []);
      when(() => mockGlobalDatabase.updateLastSyncDate(
              'sitesToServer', any()))
          .thenAnswer((_) async {});

      final result = await suppressOutput(
          () => repository.syncSitesToServer('token', 'MOD_TEST'));

      expect(result.success, true);
      expect(result.itemsProcessed, 0);
    });
  });

  group('syncSiteGroupsToServer', () {
    test('returns failure when not connected', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => false);

      final result = await suppressOutput(
          () => repository.syncSiteGroupsToServer('token', 'MOD_TEST'));

      expect(result.success, false);
      expect(result.errorMessage, contains('Pas de connexion Internet'));
    });

    test('returns success when no local site groups', () async {
      when(() => mockGlobalApi.checkConnectivity())
          .thenAnswer((_) async => true);
      when(() => mockModulesDatabase.getModuleByCode('MOD_TEST'))
          .thenAnswer((_) async => const Module(
              id: 1, moduleLabel: 'Test', moduleCode: 'MOD_TEST'));
      when(() =>
              mockSitesRepository.getLocalSiteGroupsByModuleCode('MOD_TEST'))
          .thenAnswer((_) async => []);
      when(() => mockGlobalDatabase.updateLastSyncDate(
              'siteGroupsToServer', any()))
          .thenAnswer((_) async {});

      final result = await suppressOutput(
          () => repository.syncSiteGroupsToServer('token', 'MOD_TEST'));

      expect(result.success, true);
      expect(result.itemsProcessed, 0);
    });
  });
}

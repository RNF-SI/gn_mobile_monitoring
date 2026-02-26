import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/repository/composite_sync_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late CompositeSyncRepositoryImpl repository;
  late MockDownstreamSyncRepository mockDownstream;
  late MockUpstreamSyncRepository mockUpstream;

  setUp(() {
    mockDownstream = MockDownstreamSyncRepository();
    mockUpstream = MockUpstreamSyncRepository();
    repository = CompositeSyncRepositoryImpl(
      downstreamRepo: mockDownstream,
      upstreamRepo: mockUpstream,
    );
  });

  SyncResult _successResult() => SyncResult.success(
        itemsProcessed: 10,
        itemsAdded: 5,
        itemsUpdated: 3,
        itemsSkipped: 2,
      );

  group('Downstream delegation', () {
    test('checkConnectivity delegates to downstream', () async {
      when(() => mockDownstream.checkConnectivity())
          .thenAnswer((_) async => true);

      final result = await repository.checkConnectivity();

      expect(result, true);
      verify(() => mockDownstream.checkConnectivity()).called(1);
    });

    test('getLastSyncDate delegates to downstream', () async {
      final date = DateTime(2024, 6, 1);
      when(() => mockDownstream.getLastSyncDate('modules'))
          .thenAnswer((_) async => date);

      final result = await repository.getLastSyncDate('modules');

      expect(result, date);
      verify(() => mockDownstream.getLastSyncDate('modules')).called(1);
    });

    test('updateLastSyncDate delegates to downstream', () async {
      final date = DateTime(2024, 6, 1);
      when(() => mockDownstream.updateLastSyncDate('modules', date))
          .thenAnswer((_) async {});

      await repository.updateLastSyncDate('modules', date);

      verify(() => mockDownstream.updateLastSyncDate('modules', date))
          .called(1);
    });

    test('syncConfiguration delegates to downstream', () async {
      final expected = _successResult();
      when(() => mockDownstream.syncConfiguration('token'))
          .thenAnswer((_) async => expected);

      final result = await repository.syncConfiguration('token');

      expect(result.success, true);
      verify(() => mockDownstream.syncConfiguration('token')).called(1);
    });

    test('syncNomenclatures delegates to downstream', () async {
      final expected = _successResult();
      when(() => mockDownstream.syncNomenclatures('token'))
          .thenAnswer((_) async => expected);

      final result = await repository.syncNomenclatures('token');

      expect(result.success, true);
      verify(() => mockDownstream.syncNomenclatures('token')).called(1);
    });

    test('syncNomenclaturesAndDatasets delegates to downstream', () async {
      final expected = _successResult();
      when(() => mockDownstream.syncNomenclaturesAndDatasets('token'))
          .thenAnswer((_) async => expected);

      final result = await repository.syncNomenclaturesAndDatasets('token');

      expect(result.success, true);
      verify(() => mockDownstream.syncNomenclaturesAndDatasets('token'))
          .called(1);
    });

    test('syncObservers delegates to downstream', () async {
      final expected = _successResult();
      when(() => mockDownstream.syncObservers('token'))
          .thenAnswer((_) async => expected);

      final result = await repository.syncObservers('token');

      expect(result.success, true);
      verify(() => mockDownstream.syncObservers('token')).called(1);
    });

    test('syncTaxons delegates to downstream', () async {
      final expected = _successResult();
      when(() => mockDownstream.syncTaxons('token'))
          .thenAnswer((_) async => expected);

      final result = await repository.syncTaxons('token');

      expect(result.success, true);
      verify(() => mockDownstream.syncTaxons('token')).called(1);
    });

    test('syncModules delegates to downstream', () async {
      final expected = _successResult();
      when(() => mockDownstream.syncModules('token'))
          .thenAnswer((_) async => expected);

      final result = await repository.syncModules('token');

      expect(result.success, true);
      verify(() => mockDownstream.syncModules('token')).called(1);
    });

    test('syncSites delegates to downstream', () async {
      final expected = _successResult();
      when(() => mockDownstream.syncSites('token'))
          .thenAnswer((_) async => expected);

      final result = await repository.syncSites('token');

      expect(result.success, true);
      verify(() => mockDownstream.syncSites('token')).called(1);
    });

    test('syncSiteGroups delegates to downstream', () async {
      final expected = _successResult();
      when(() => mockDownstream.syncSiteGroups('token'))
          .thenAnswer((_) async => expected);

      final result = await repository.syncSiteGroups('token');

      expect(result.success, true);
      verify(() => mockDownstream.syncSiteGroups('token')).called(1);
    });
  });

  group('Upstream delegation', () {
    test('syncVisitsToServer delegates to upstream', () async {
      final expected = _successResult();
      when(() => mockUpstream.syncVisitsToServer('token', 'MOD_TEST'))
          .thenAnswer((_) async => expected);

      final result =
          await repository.syncVisitsToServer('token', 'MOD_TEST');

      expect(result.success, true);
      verify(() => mockUpstream.syncVisitsToServer('token', 'MOD_TEST'))
          .called(1);
    });

    test('syncObservationsToServer delegates to upstream', () async {
      final expected = _successResult();
      when(() => mockUpstream.syncObservationsToServer(
              'token', 'MOD_TEST', 1,
              serverVisitId: 100))
          .thenAnswer((_) async => expected);

      final result = await repository.syncObservationsToServer(
          'token', 'MOD_TEST', 1,
          serverVisitId: 100);

      expect(result.success, true);
      verify(() => mockUpstream.syncObservationsToServer(
          'token', 'MOD_TEST', 1,
          serverVisitId: 100)).called(1);
    });

    test('syncObservationDetailsToServer delegates to upstream', () async {
      final expected = _successResult();
      when(() => mockUpstream.syncObservationDetailsToServer(
              'token', 'MOD_TEST', 1,
              serverObservationId: 200))
          .thenAnswer((_) async => expected);

      final result = await repository.syncObservationDetailsToServer(
          'token', 'MOD_TEST', 1,
          serverObservationId: 200);

      expect(result.success, true);
      verify(() => mockUpstream.syncObservationDetailsToServer(
          'token', 'MOD_TEST', 1,
          serverObservationId: 200)).called(1);
    });

    test('syncSitesToServer delegates to upstream', () async {
      final expected = _successResult();
      when(() => mockUpstream.syncSitesToServer('token', 'MOD_TEST'))
          .thenAnswer((_) async => expected);

      final result =
          await repository.syncSitesToServer('token', 'MOD_TEST');

      expect(result.success, true);
      verify(() => mockUpstream.syncSitesToServer('token', 'MOD_TEST'))
          .called(1);
    });

    test('syncSiteGroupsToServer delegates to upstream', () async {
      final expected = _successResult();
      when(() => mockUpstream.syncSiteGroupsToServer('token', 'MOD_TEST'))
          .thenAnswer((_) async => expected);

      final result =
          await repository.syncSiteGroupsToServer('token', 'MOD_TEST');

      expect(result.success, true);
      verify(() => mockUpstream.syncSiteGroupsToServer('token', 'MOD_TEST'))
          .called(1);
    });
  });

  group('No cross-delegation', () {
    test('downstream methods never call upstream', () async {
      when(() => mockDownstream.syncConfiguration('token'))
          .thenAnswer((_) async => _successResult());

      await repository.syncConfiguration('token');

      verifyNever(() => mockUpstream.syncVisitsToServer(any(), any()));
      verifyNever(() => mockUpstream.syncSitesToServer(any(), any()));
      verifyNever(() => mockUpstream.syncSiteGroupsToServer(any(), any()));
    });

    test('upstream methods never call downstream', () async {
      when(() => mockUpstream.syncVisitsToServer('token', 'MOD'))
          .thenAnswer((_) async => _successResult());

      await repository.syncVisitsToServer('token', 'MOD');

      verifyNever(() => mockDownstream.syncConfiguration(any()));
      verifyNever(() => mockDownstream.syncModules(any()));
      verifyNever(() => mockDownstream.syncSites(any()));
    });
  });
}

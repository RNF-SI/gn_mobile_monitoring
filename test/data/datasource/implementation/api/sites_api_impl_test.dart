import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/sites_api_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late SitesApiImpl sitesApi;
  late MockDio mockDio;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockDio = MockDio();
    mockConnectivity = MockConnectivity();
    sitesApi = SitesApiImpl(dio: mockDio, connectivity: mockConnectivity);
  });

  setUpAll(() {
    registerFallbackValue(Options());
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

  group('sendSite', () {
    test('throws NetworkException when no internet connection', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      final site = const BaseSite(
        idBaseSite: 1,
        baseSiteName: 'Test Site',
      );

      expect(
        () => suppressOutput(
            () => sitesApi.sendSite('token', 'MOD_TEST', site)),
        throwsA(isA<NetworkException>()),
      );
    });

    test('sends POST request and returns server response', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      final site = BaseSite(
        idBaseSite: 1,
        baseSiteName: 'Test Site',
        firstUseDate: DateTime(2024, 1, 1),
      );

      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: {'id': 100, 'base_site_name': 'Test Site'},
            statusCode: 201,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result = await suppressOutput(
          () => sitesApi.sendSite('token', 'MOD_TEST', site));

      expect(result['id'], 100);
      verify(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).called(1);
    });
  });

  group('updateSite', () {
    test('sends PATCH request and returns server response', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      final site = const BaseSite(
        idBaseSite: 1,
        baseSiteName: 'Updated Site',
      );

      when(() => mockDio.patch(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: {'id': 1, 'base_site_name': 'Updated Site'},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result = await suppressOutput(
          () => sitesApi.updateSite('token', 'MOD_TEST', 1, site));

      expect(result['base_site_name'], 'Updated Site');
      verify(() => mockDio.patch(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).called(1);
    });

    test('throws NetworkException on DioException', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      final site = const BaseSite(
        idBaseSite: 1,
        baseSiteName: 'Test',
      );

      when(() => mockDio.patch(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenThrow(DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: '/test'),
      ));

      expect(
        () => suppressOutput(
            () => sitesApi.updateSite('token', 'MOD_TEST', 1, site)),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('sendSiteGroup', () {
    test('throws NetworkException when no internet connection', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      final siteGroup = const SiteGroup(
        idSitesGroup: 1,
        sitesGroupName: 'Test Group',
      );

      expect(
        () => suppressOutput(
            () => sitesApi.sendSiteGroup('token', 'MOD_TEST', siteGroup)),
        throwsA(isA<NetworkException>()),
      );
    });

    test('sends POST request and returns server response', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      final siteGroup = const SiteGroup(
        idSitesGroup: 1,
        sitesGroupName: 'Test Group',
      );

      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: {'id': 200, 'sites_group_name': 'Test Group'},
            statusCode: 201,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result = await suppressOutput(
          () => sitesApi.sendSiteGroup('token', 'MOD_TEST', siteGroup));

      expect(result['id'], 200);
    });
  });

  group('fetchEnrichedSitesForModule', () {
    test('handles 204 No Content as valid empty response', () async {
      when(() => mockDio.get(
            '/monitorings/refacto/MOD_TEST/sites',
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: null,
            statusCode: 204,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result = await suppressOutput(
          () => sitesApi.fetchEnrichedSitesForModule('MOD_TEST', 'token'));

      expect(result['enriched_sites'], isEmpty);
      expect(result['site_complements'], isEmpty);
    });

    test('récupère tous les sites en un seul appel /refacto/', () async {
      // Enveloppe {count, items[], limit, page} renvoyée par /refacto/<code>/sites
      // Les items contiennent directement tous les champs (pas de wrapping
      // properties/geometry comme /object/).
      when(() => mockDio.get(
            '/monitorings/refacto/MOD_TEST/sites',
            queryParameters: {'limit': 100000},
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: {
              'count': 2,
              'limit': 100000,
              'page': 1,
              'items': [
                {
                  'id_base_site': 1,
                  'base_site_name': 'Site 1',
                  'base_site_code': 'S1',
                  'base_site_description': 'Description 1',
                  'altitude_min': 100,
                  'altitude_max': 200,
                  'first_use_date': '2024-01-01',
                  'uuid_base_site': 'uuid-1',
                  'geometry':
                      '{"type": "Point", "coordinates": [1.0, 2.0]}',
                  'id_sites_group': 42,
                },
                {
                  'id_base_site': 2,
                  'base_site_name': 'Site 2',
                  'base_site_code': 'S2',
                  'base_site_description': null,
                  'altitude_min': null,
                  'altitude_max': null,
                  'first_use_date': null,
                  'uuid_base_site': 'uuid-2',
                  'geometry': null,
                  // pas de id_sites_group : site hors groupe
                },
              ],
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result = await suppressOutput(
          () => sitesApi.fetchEnrichedSitesForModule('MOD_TEST', 'token'));

      final enrichedSites = result['enriched_sites'] as List;
      expect(enrichedSites.length, 2);

      final site1 = enrichedSites
          .cast<Map<String, dynamic>>()
          .firstWhere((s) => s['id_base_site'] == 1);
      expect(site1['base_site_code'], 'S1');
      expect(site1['altitude_min'], 100);
      expect(site1['geometry'], isNotNull);

      final complements = result['site_complements'] as List;
      expect(complements.length, 2);
      final site1Complement = complements.firstWhere(
        (c) => (c as dynamic).idBaseSite == 1,
      ) as dynamic;
      expect(site1Complement.idSitesGroup, 42);
      final site2Complement = complements.firstWhere(
        (c) => (c as dynamic).idBaseSite == 2,
      ) as dynamic;
      expect(site2Complement.idSitesGroup, isNull);
    });
  });
}

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
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: null,
            statusCode: 204,
            requestOptions: RequestOptions(path: '/test'),
          ));

      final result = await suppressOutput(
          () => sitesApi.fetchEnrichedSitesForModule('MOD_TEST', 'token'));

      expect(result['sites'], isEmpty);
      expect(result['site_complements'], isEmpty);
    });
  });
}

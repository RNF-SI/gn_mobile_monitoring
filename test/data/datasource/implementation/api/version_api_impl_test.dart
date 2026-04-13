import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/version_api_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late VersionApiImpl versionApi;

  setUpAll(() {
    registerFallbackValue(Options());
  });

  setUp(() {
    mockDio = MockDio();
    versionApi = VersionApiImpl(dio: mockDio);
  });

  group('fetchMonitoringVersion', () {
    test('retourne la version quand MONITORINGS est trouvé', () async {
      when(() => mockDio.get(
            '/gn_commons/modules',
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/gn_commons/modules'),
            statusCode: 200,
            data: [
              {'module_code': 'GEONATURE', 'version': '2.14.0'},
              {'module_code': 'MONITORINGS', 'version': '1.2.0'},
              {'module_code': 'OCCTAX', 'version': '2.8.0'},
            ],
          ));

      final result = await versionApi.fetchMonitoringVersion('test_token');
      expect(result, '1.2.0');
    });

    test('recherche case-insensitive du module_code', () async {
      when(() => mockDio.get(
            '/gn_commons/modules',
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/gn_commons/modules'),
            statusCode: 200,
            data: [
              {'module_code': 'monitorings', 'version': '1.3.0'},
            ],
          ));

      final result = await versionApi.fetchMonitoringVersion('test_token');
      expect(result, '1.3.0');
    });

    test('retourne null quand MONITORINGS absent de la liste', () async {
      when(() => mockDio.get(
            '/gn_commons/modules',
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/gn_commons/modules'),
            statusCode: 200,
            data: [
              {'module_code': 'GEONATURE', 'version': '2.14.0'},
              {'module_code': 'OCCTAX', 'version': '2.8.0'},
            ],
          ));

      final result = await versionApi.fetchMonitoringVersion('test_token');
      expect(result, isNull);
    });

    test('retourne null sur erreur 404 (vieux GeoNature)', () async {
      when(() => mockDio.get(
            '/gn_commons/modules',
            options: any(named: 'options'),
          )).thenThrow(DioException(
            requestOptions: RequestOptions(path: '/gn_commons/modules'),
            response: Response(
              requestOptions: RequestOptions(path: '/gn_commons/modules'),
              statusCode: 404,
            ),
            type: DioExceptionType.badResponse,
          ));

      final result = await versionApi.fetchMonitoringVersion('test_token');
      expect(result, isNull);
    });

    test('retourne null sur erreur réseau', () async {
      when(() => mockDio.get(
            '/gn_commons/modules',
            options: any(named: 'options'),
          )).thenThrow(DioException(
            requestOptions: RequestOptions(path: '/gn_commons/modules'),
            type: DioExceptionType.connectionTimeout,
          ));

      final result = await versionApi.fetchMonitoringVersion('test_token');
      expect(result, isNull);
    });

    test('retourne null quand la réponse n\'est pas une liste', () async {
      when(() => mockDio.get(
            '/gn_commons/modules',
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/gn_commons/modules'),
            statusCode: 200,
            data: {'error': 'unexpected format'},
          ));

      final result = await versionApi.fetchMonitoringVersion('test_token');
      expect(result, isNull);
    });

    test('retourne null quand module_version est absent', () async {
      when(() => mockDio.get(
            '/gn_commons/modules',
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/gn_commons/modules'),
            statusCode: 200,
            data: [
              {'module_code': 'MONITORINGS'},
            ],
          ));

      final result = await versionApi.fetchMonitoringVersion('test_token');
      expect(result, isNull);
    });
  });
}

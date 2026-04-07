import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/mobile_app_api_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late MobileAppApiImpl api;

  setUpAll(() {
    registerFallbackValue(Options());
  });

  setUp(() {
    mockDio = MockDio();
    api = MobileAppApiImpl(dio: mockDio);
  });

  group('fetchMobileApps', () {
    test('retourne la liste des apps quand la requête réussit', () async {
      when(() => mockDio.get(
            '/gn_commons/t_mobile_apps',
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/gn_commons/t_mobile_apps'),
            statusCode: 200,
            data: [
              {
                'id_mobile_app': 1,
                'app_code': 'MONITORING',
                'version_code': '2',
                'url_apk': 'https://example.com/monitoring.apk',
                'package': 'fr.geonature.monitoring',
              }
            ],
          ));

      final result = await api.fetchMobileApps('test_token', 'MONITORING');
      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result[0]['app_code'], 'MONITORING');
      expect(result[0]['version_code'], '2');
    });

    test('passe le bon app_code en query parameter', () async {
      when(() => mockDio.get(
            '/gn_commons/t_mobile_apps',
            queryParameters: {'app_code': 'MONITORING'},
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/gn_commons/t_mobile_apps'),
            statusCode: 200,
            data: [],
          ));

      await api.fetchMobileApps('test_token', 'MONITORING');

      verify(() => mockDio.get(
            '/gn_commons/t_mobile_apps',
            queryParameters: {'app_code': 'MONITORING'},
            options: any(named: 'options'),
          )).called(1);
    });

    test('retourne null sur erreur 404', () async {
      when(() => mockDio.get(
            '/gn_commons/t_mobile_apps',
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenThrow(DioException(
            requestOptions:
                RequestOptions(path: '/gn_commons/t_mobile_apps'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions:
                  RequestOptions(path: '/gn_commons/t_mobile_apps'),
              statusCode: 404,
            ),
          ));

      final result = await api.fetchMobileApps('test_token', 'MONITORING');
      expect(result, isNull);
    });

    test('retourne null sur erreur réseau', () async {
      when(() => mockDio.get(
            '/gn_commons/t_mobile_apps',
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenThrow(DioException(
            requestOptions:
                RequestOptions(path: '/gn_commons/t_mobile_apps'),
            type: DioExceptionType.connectionTimeout,
          ));

      final result = await api.fetchMobileApps('test_token', 'MONITORING');
      expect(result, isNull);
    });

    test('retourne null quand la réponse n\'est pas une liste', () async {
      when(() => mockDio.get(
            '/gn_commons/t_mobile_apps',
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/gn_commons/t_mobile_apps'),
            statusCode: 200,
            data: {'error': 'unexpected'},
          ));

      final result = await api.fetchMobileApps('test_token', 'MONITORING');
      expect(result, isNull);
    });

    test('retourne une liste vide quand aucune app trouvée', () async {
      when(() => mockDio.get(
            '/gn_commons/t_mobile_apps',
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/gn_commons/t_mobile_apps'),
            statusCode: 200,
            data: [],
          ));

      final result = await api.fetchMobileApps('test_token', 'MONITORING');
      expect(result, isNotNull);
      expect(result, isEmpty);
    });
  });
}

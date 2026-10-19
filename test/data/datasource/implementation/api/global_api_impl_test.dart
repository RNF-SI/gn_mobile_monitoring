import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/global_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/monitoring_routes.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/visits_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/observations_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/observation_details_api.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {
  @override
  BaseOptions get options => BaseOptions();
}
class MockConnectivity extends Mock implements Connectivity {}
class MockVisitsApi extends Mock implements VisitsApi {}
class MockObservationsApi extends Mock implements ObservationsApi {}
class MockObservationDetailsApi extends Mock implements ObservationDetailsApi {}
class MockResponse<T> extends Mock implements Response<T> {}

class _FixedModeResolver extends MonitoringApiModeResolver {
  const _FixedModeResolver(this.routes);
  final MonitoringApiRoutes routes;

  @override
  Future<MonitoringApiRoutes> resolve(
          Dio dio, String? token, String moduleCode) async =>
      routes;
}

void main() {
  late GlobalApiImpl globalApi;
  late MockDio mockDio;
  late MockConnectivity mockConnectivity;
  late MockVisitsApi mockVisitsApi;
  late MockObservationsApi mockObservationsApi;
  late MockObservationDetailsApi mockObservationDetailsApi;

  setUp(() {
    mockDio = MockDio();
    mockConnectivity = MockConnectivity();
    mockVisitsApi = MockVisitsApi();
    mockObservationsApi = MockObservationsApi();
    mockObservationDetailsApi = MockObservationDetailsApi();

    globalApi = GlobalApiImpl(
      dio: mockDio,
      connectivity: mockConnectivity,
      visitsApi: mockVisitsApi,
      observationsApi: mockObservationsApi,
      observationDetailsApi: mockObservationDetailsApi,
    );
  });

  setUpAll(() {
    registerFallbackValue(Options());
    registerFallbackValue(Uri());
    registerFallbackValue(BaseVisit(idBaseVisit: 0, idDataset: 1, idModule: 1, visitDateMin: ''));
    registerFallbackValue(Observation(idObservation: 0));
    registerFallbackValue(ObservationDetail(idObservationDetail: 0, data: {}));
  });

  group('GlobalApiImpl', () {
    const String token = 'test_token';

    group('getNomenclaturesAndDatasets', () {
      test('should return nomenclatures and datasets successfully', () async {
        const moduleId = 1;
        const moduleCode = 'TEST_MODULE';

        // Mock module response (depth=0, juste module_code)
        final mockModuleResponse = MockResponse<Map<String, dynamic>>();
        final moduleData = {
          'id_module': moduleId,
          'module_code': moduleCode,
        };

        when(() => mockModuleResponse.data).thenReturn(moduleData);
        when(() => mockModuleResponse.statusCode).thenReturn(200);

        when(() => mockDio.get(
          '/monitorings/module/$moduleId',
          queryParameters: {'depth': 0},
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockModuleResponse);

        // Mock object/module response (liste d'IDs datasets)
        final mockObjectResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockObjectResponse.data).thenReturn({
          'module_code': moduleCode,
          'properties': {
            'module_code': moduleCode,
            'datasets': [1],
          },
        });
        when(() => mockObjectResponse.statusCode).thenReturn(200);

        when(() => mockDio.get(
          '/monitorings/object/$moduleCode/module',
          queryParameters: {'depth': 0, 'field_name': 'module_code'},
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockObjectResponse);

        // Mock util/dataset response (dict TDatasets à plat)
        final mockDatasetResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockDatasetResponse.data).thenReturn({
          'id_dataset': 1,
          'unique_dataset_id': 'UUID-TEST-001',
          'id_acquisition_framework': 1,
          'dataset_name': 'Test Dataset',
          'dataset_shortname': 'TD',
          'dataset_desc': 'Test Description',
          'id_nomenclature_data_type': 1,
          'marine_domain': false,
          'terrestrial_domain': true,
          'id_nomenclature_dataset_objectif': 1,
          'id_nomenclature_collecting_method': 1,
          'id_nomenclature_data_origin': 1,
          'id_nomenclature_source_status': 1,
          'id_nomenclature_resource_type': 1,
          'active': true,
          'meta_create_date': '2023-01-01T00:00:00.000Z',
        });
        when(() => mockDatasetResponse.statusCode).thenReturn(200);

        when(() => mockDio.get(
          '/monitorings/util/dataset/1',
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockDatasetResponse);

        // Mock config response with nomenclature types (as list of strings)
        final mockConfigResponse = MockResponse<Map<String, dynamic>>();
        final configData = {
          'data': {
            'nomenclature': ['TYPE_MEDIA'],  // List of type codes as strings
          },
        };

        when(() => mockConfigResponse.data).thenReturn(configData);
        when(() => mockConfigResponse.statusCode).thenReturn(200);

        when(() => mockDio.get(
          '/monitorings/config/$moduleCode',
          options: any(named: 'options'),
        )).thenAnswer((_) async => mockConfigResponse);

        // Mock nomenclatures by type code response
        final mockNomenclatureResponse = MockResponse<Map<String, dynamic>>();
        final nomenclatureData = {
          'mnemonique': 'TYPE_MEDIA',
          'values': [
            {
              'id_nomenclature': 1,
              'cd_nomenclature': 'CODE1',
              'id_type': 117,
              'code_type': 'TYPE_MEDIA',
              'label_default': 'Test Label',
              'active': true,
              'meta_create_date': '2023-01-01T00:00:00.000Z',
            },
          ],
        };

        when(() => mockNomenclatureResponse.data).thenReturn(nomenclatureData);
        when(() => mockNomenclatureResponse.statusCode).thenReturn(200);

        when(() => mockDio.get('/nomenclatures/nomenclature/TYPE_MEDIA'))
            .thenAnswer((_) async => mockNomenclatureResponse);

        final result = await globalApi.getNomenclaturesAndDatasets(moduleId);

        expect(result.nomenclatures.length, equals(1));
        expect(result.datasets.length, equals(1));
        expect(result.nomenclatureTypes.length, equals(1));
        expect(result.configuration, equals(configData));
      });

      test(
          'utilise les datasets de /module/<id> sans appeler la route legacy '
          'object/module (refonte monitoring #513)', () async {
        const moduleId = 1;
        const moduleCode = 'TEST_MODULE';

        final mockModuleResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockModuleResponse.data).thenReturn({
          'id_module': moduleId,
          'module_code': moduleCode,
          'datasets': [1],
        });
        when(() => mockModuleResponse.statusCode).thenReturn(200);
        when(() => mockDio.get(
              '/monitorings/module/$moduleId',
              queryParameters: {'depth': 0},
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockModuleResponse);

        // JDD GeoNature 2.18 : sans id_nomenclature_dataset_objectif (#4103)
        final mockDatasetResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockDatasetResponse.data).thenReturn({
          'id_dataset': 1,
          'unique_dataset_id': 'UUID-TEST-001',
          'id_acquisition_framework': 1,
          'dataset_name': 'Test Dataset',
          'dataset_shortname': 'TD',
          'dataset_desc': 'Test Description',
          'id_nomenclature_data_type': 1,
          'marine_domain': false,
          'terrestrial_domain': true,
          'id_nomenclature_collecting_method': 1,
          'id_nomenclature_data_origin': 1,
          'id_nomenclature_source_status': 1,
          'id_nomenclature_resource_type': 1,
          'active': true,
          'meta_create_date': '2023-01-01T00:00:00.000Z',
        });
        when(() => mockDatasetResponse.statusCode).thenReturn(200);
        when(() => mockDio.get(
              '/monitorings/util/dataset/1',
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockDatasetResponse);

        final mockConfigResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockConfigResponse.data).thenReturn({'data': {}});
        when(() => mockConfigResponse.statusCode).thenReturn(200);
        when(() => mockDio.get(
              '/monitorings/config/$moduleCode',
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockConfigResponse);

        final result = await globalApi.getNomenclaturesAndDatasets(moduleId);

        expect(result.datasets.map((d) => d.idDataset), [1]);
        verifyNever(() => mockDio.get(
              '/monitorings/object/$moduleCode/module',
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            ));
      });

      test('should throw exception on API error', () async {
        const moduleId = 1;

        when(() => mockDio.get(
          '/monitorings/module/$moduleId',
          queryParameters: {'depth': 0},
          options: any(named: 'options'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
        ));

        expect(
          () async => await globalApi.getNomenclaturesAndDatasets(moduleId),
          throwsException,
        );
      });
    });

    group('checkConnectivity', () {
      test('should return false when no internet connection', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.none]);

        final result = await globalApi.checkConnectivity();

        expect(result, false);
      });

      test('should return true when server is accessible', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        final mockResponse = MockResponse<dynamic>();
        when(() => mockResponse.statusCode).thenReturn(200);

        when(() => mockDio.get(
              '/monitorings/sites/types',
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        final result = await globalApi.checkConnectivity();

        expect(result, true);
      });

      test('401 (routes authentifiées, #209) → serveur joignable', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);
        final mockResponse = MockResponse<dynamic>();
        when(() => mockResponse.statusCode).thenReturn(401);
        when(() => mockDio.get(
              '/monitorings/sites/types',
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        expect(await globalApi.checkConnectivity(), true);
      });

      test('500 → serveur non joignable', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);
        final mockResponse = MockResponse<dynamic>();
        when(() => mockResponse.statusCode).thenReturn(500);
        when(() => mockDio.get(
              '/monitorings/sites/types',
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        expect(await globalApi.checkConnectivity(), false);
      });

      test('should return false when server is not accessible', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        when(() => mockDio.get(
              '/monitorings/sites/types',
              options: any(named: 'options'),
            )).thenThrow(DioException(
              requestOptions: RequestOptions(path: '/monitorings/sites/types'),
              error: 'Network error',
              type: DioExceptionType.connectionError,
            ));

        final result = await globalApi.checkConnectivity();

        expect(result, false);
      });
    });

    group('delegation methods', () {
      test('sendVisit should delegate to VisitsApi', () async {
        const moduleCode = 'TEST_MODULE';
        final visit = BaseVisit(
          idBaseVisit: 0,
          idDataset: 1,
          idModule: 1,
          visitDateMin: '2024-01-01',
        );
        final expectedResponse = {'id': 123};

        when(() => mockVisitsApi.sendVisit(token, moduleCode, visit))
            .thenAnswer((_) async => expectedResponse);

        final result = await globalApi.sendVisit(token, moduleCode, visit);

        expect(result, equals(expectedResponse));
        verify(() => mockVisitsApi.sendVisit(token, moduleCode, visit)).called(1);
      });

      test('sendObservation should delegate to ObservationsApi', () async {
        const moduleCode = 'TEST_MODULE';
        final observation = Observation(
          idObservation: 0,
          idBaseVisit: 1,
          cdNom: 12345,
        );
        final expectedResponse = {'id': 456};

        when(() => mockObservationsApi.sendObservation(token, moduleCode, observation))
            .thenAnswer((_) async => expectedResponse);

        final result = await globalApi.sendObservation(token, moduleCode, observation);

        expect(result, equals(expectedResponse));
        verify(() => mockObservationsApi.sendObservation(token, moduleCode, observation)).called(1);
      });

      test('sendObservationDetail should delegate to ObservationDetailsApi', () async {
        const moduleCode = 'TEST_MODULE';
        final detail = ObservationDetail(
          idObservationDetail: 0,
          idObservation: 123,
          data: {'field': 'value'},
        );
        final expectedResponse = {'id': 789};

        when(() => mockObservationDetailsApi.sendObservationDetail(token, moduleCode, detail))
            .thenAnswer((_) async => expectedResponse);

        final result = await globalApi.sendObservationDetail(token, moduleCode, detail);

        expect(result, equals(expectedResponse));
        verify(() => mockObservationDetailsApi.sendObservationDetail(token, moduleCode, detail)).called(1);
      });
    });

    group('getModuleConfiguration', () {
      test('should return module configuration successfully', () async {
        const moduleCode = 'TEST_MODULE';
        final mockResponse = MockResponse<Map<String, dynamic>>();
        final configData = {
          'module': {
            'module_name': 'Test Module',
            'module_code': moduleCode,
          },
          'site': {
            'form_config': {
              'fields': []
            }
          }
        };

        when(() => mockResponse.data).thenReturn(configData);
        when(() => mockResponse.statusCode).thenReturn(200);

        when(() => mockDio.get('/monitorings/config/$moduleCode'))
            .thenAnswer((_) async => mockResponse);

        final result = await globalApi.getModuleConfiguration(moduleCode);

        expect(result, equals(configData));
      });
    });

    group('configuration via la nouvelle API (#210)', () {
      GlobalApiImpl api() => GlobalApiImpl(
            dio: mockDio,
            connectivity: mockConnectivity,
            modeResolver: const _FixedModeResolver(
                MonitoringApiRoutes(mode: MonitoringApiMode.current)),
          );

      test('lit <base>/<module>/config et la ramène au format historique',
          () async {
        when(() => mockDio.get('/monitorings/refacto/M/config',
                options: any(named: 'options')))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(),
                  statusCode: 200,
                  data: {
                    'visit': {
                      'fields': {
                        'visit_date_min': {'type_widget': 'date'},
                        'meteo': {'type_widget': 'text'},
                      },
                    },
                  },
                ));

        final config = await api().getModuleConfiguration('M');

        expect(config['visit']['generic'].keys, ['visit_date_min']);
        expect(config['visit']['specific'].keys, ['meteo']);
      });

      test('404 sur la nouvelle route → route legacy', () async {
        when(() => mockDio.get('/monitorings/refacto/M/config',
            options: any(named: 'options'))).thenThrow(DioException(
          requestOptions: RequestOptions(),
          response:
              Response(requestOptions: RequestOptions(), statusCode: 404),
          type: DioExceptionType.badResponse,
        ));
        when(() => mockDio.get('/monitorings/config/M',
                options: any(named: 'options')))
            .thenAnswer((_) async => Response(
                  requestOptions: RequestOptions(),
                  statusCode: 200,
                  data: {
                    'visit': {'generic': {}, 'specific': {}},
                  },
                ));

        final config = await api().getModuleConfiguration('M');

        expect(config['visit'], {'generic': {}, 'specific': {}});
      });
    });

    group('getSiteTypes', () {
      test('envoie le jeton quand il est fourni (#209)', () async {
        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn({'items': []});
        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockDio.get('/monitorings/sites/types',
                options: any(named: 'options')))
            .thenAnswer((_) async => mockResponse);

        await globalApi.getSiteTypes(token: 'jeton');

        final options = verify(() => mockDio.get('/monitorings/sites/types',
                options: captureAny(named: 'options')))
            .captured
            .single as Options;
        expect(options.headers?['Authorization'], 'Bearer jeton');
      });

      test('should return site types successfully', () async {
        final mockResponse = MockResponse<Map<String, dynamic>>();
        final responseData = {
          'items': [
            {'id': 1, 'name': 'Type 1'},
            {'id': 2, 'name': 'Type 2'},
          ]
        };

        when(() => mockResponse.data).thenReturn(responseData);
        when(() => mockResponse.statusCode).thenReturn(200);

        when(() => mockDio.get('/monitorings/sites/types'))
            .thenAnswer((_) async => mockResponse);

        final result = await globalApi.getSiteTypes();

        expect(result.length, equals(2));
        expect(result.first['name'], equals('Type 1'));
      });
    });

    group('syncNomenclaturesAndDatasets', () {
      test('should sync successfully with modules', () async {
        final moduleIds = [1, 2];

        // Mock checkConnectivity - return true (wifi + successful API call)
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        final mockConnResponse = MockResponse<dynamic>();
        when(() => mockConnResponse.statusCode).thenReturn(200);

        when(() => mockDio.get(
              '/monitorings/sites/types',
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockConnResponse);

        // Mock getNomenclaturesAndDatasets for each module
        for (final moduleId in moduleIds) {
          final moduleCode = 'TEST_MODULE_$moduleId';

          // Mock module response (depth=0, juste module_code)
          final mockModuleResponse = MockResponse<Map<String, dynamic>>();
          when(() => mockModuleResponse.data).thenReturn({
            'id_module': moduleId,
            'module_code': moduleCode,
          });
          when(() => mockModuleResponse.statusCode).thenReturn(200);

          when(() => mockDio.get(
            '/monitorings/module/$moduleId',
            queryParameters: {'depth': 0},
            options: any(named: 'options'),
          )).thenAnswer((_) async => mockModuleResponse);

          // Mock object/module response (liste d'IDs datasets)
          final mockObjectResponse = MockResponse<Map<String, dynamic>>();
          when(() => mockObjectResponse.data).thenReturn({
            'module_code': moduleCode,
            'properties': {
              'module_code': moduleCode,
              'datasets': [moduleId],
            },
          });
          when(() => mockObjectResponse.statusCode).thenReturn(200);

          when(() => mockDio.get(
            '/monitorings/object/$moduleCode/module',
            queryParameters: {'depth': 0, 'field_name': 'module_code'},
            options: any(named: 'options'),
          )).thenAnswer((_) async => mockObjectResponse);

          // Mock util/dataset response
          final mockDatasetResponse = MockResponse<Map<String, dynamic>>();
          when(() => mockDatasetResponse.data).thenReturn({
            'id_dataset': moduleId,
            'unique_dataset_id': 'UUID-TEST-00$moduleId',
            'id_acquisition_framework': 1,
            'dataset_name': 'Test Dataset $moduleId',
            'dataset_shortname': 'TD$moduleId',
            'dataset_desc': 'Test Description',
            'id_nomenclature_data_type': 1,
            'marine_domain': false,
            'terrestrial_domain': true,
            'id_nomenclature_dataset_objectif': 1,
            'id_nomenclature_collecting_method': 1,
            'id_nomenclature_data_origin': 1,
            'id_nomenclature_source_status': 1,
            'id_nomenclature_resource_type': 1,
            'active': true,
            'meta_create_date': '2023-01-01T00:00:00.000Z',
          });
          when(() => mockDatasetResponse.statusCode).thenReturn(200);

          when(() => mockDio.get(
            '/monitorings/util/dataset/$moduleId',
            options: any(named: 'options'),
          )).thenAnswer((_) async => mockDatasetResponse);

          // Mock config response
          final mockConfigResponse = MockResponse<Map<String, dynamic>>();
          when(() => mockConfigResponse.data).thenReturn({'data': {}});
          when(() => mockConfigResponse.statusCode).thenReturn(200);

          when(() => mockDio.get(
            '/monitorings/config/$moduleCode',
            options: any(named: 'options'),
          )).thenAnswer((_) async => mockConfigResponse);
        }

        final result = await globalApi.syncNomenclaturesAndDatasets(token, moduleIds);

        expect(result.success, true);
        expect(result.itemsProcessed, greaterThan(0));
      });

      test('should handle network exception', () async {
        final moduleIds = [1];

        // Mock no connectivity
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.none]);

        final result = await globalApi.syncNomenclaturesAndDatasets(token, moduleIds);

        expect(result.success, false);
        expect(result.errorMessage, contains('Aucune connexion réseau'));
      });
    });
  });
}
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/global_api_impl.dart';
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
    final String apiBase = Config.apiBase;

    group('getNomenclaturesAndDatasets', () {
      test('should return nomenclatures and datasets successfully', () async {
        const moduleName = 'TEST_MODULE';
        final mockResponse = MockResponse<Map<String, dynamic>>();
        final responseData = {
          'nomenclature': [
            {
              'id_nomenclature': 1,
              'cd_nomenclature': 'CODE1',
              'id_type': 117,
              'code_type': 'TYPE_MEDIA',
              'active': true,
              'meta_create_date': '2023-01-01T00:00:00.000Z',
            },
          ],
          'dataset': [
            {
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
            },
          ],
        };
        
        when(() => mockResponse.data).thenReturn(responseData);
        when(() => mockResponse.statusCode).thenReturn(200);
        
        when(() => mockDio.get('$apiBase/monitorings/util/init_data/$moduleName'))
            .thenAnswer((_) async => mockResponse);

        final result = await globalApi.getNomenclaturesAndDatasets(moduleName);

        expect(result.nomenclatures.length, equals(1));
        expect(result.datasets.length, equals(1));
        expect(result.nomenclatureTypes.length, equals(1));
        expect(result.nomenclatureTypes.first['mnemonique'], equals('TYPE_MEDIA'));
      });

      test('should throw exception on API error', () async {
        const moduleName = 'TEST_MODULE';
        
        when(() => mockDio.get('$apiBase/monitorings/util/init_data/$moduleName'))
            .thenThrow(DioException(
              requestOptions: RequestOptions(path: ''),
            ));

        expect(
          () async => await globalApi.getNomenclaturesAndDatasets(moduleName),
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
              '$apiBase/monitorings/sites/types',
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        final result = await globalApi.checkConnectivity();

        expect(result, true);
      });

      test('should return false when server is not accessible', () async {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        when(() => mockDio.get(
              '$apiBase/monitorings/sites/types',
              options: any(named: 'options'),
            )).thenThrow(DioException(
              requestOptions: RequestOptions(path: '$apiBase/monitorings/sites/types'),
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
        
        when(() => mockDio.get('$apiBase/monitorings/config/$moduleCode'))
            .thenAnswer((_) async => mockResponse);

        final result = await globalApi.getModuleConfiguration(moduleCode);

        expect(result, equals(configData));
      });
    });

    group('getSiteTypes', () {
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
        
        when(() => mockDio.get('$apiBase/monitorings/sites/types'))
            .thenAnswer((_) async => mockResponse);

        final result = await globalApi.getSiteTypes();

        expect(result.length, equals(2));
        expect(result.first['name'], equals('Type 1'));
      });
    });

    group('syncNomenclaturesAndDatasets', () {
      test('should sync successfully with modules', () async {
        final moduleCodes = ['MODULE_1', 'MODULE_2'];
        
        // Mock checkConnectivity
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);
        
        final mockConnResponse = MockResponse<dynamic>();
        when(() => mockConnResponse.statusCode).thenReturn(200);
        
        when(() => mockDio.get(
              '$apiBase/monitorings/sites/types',
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockConnResponse);

        // Mock sync responses
        for (final moduleCode in moduleCodes) {
          final moduleResponse = MockResponse<Map<String, dynamic>>();
          final moduleData = {
            'nomenclature': [
              {
                'id_nomenclature': 1,
                'cd_nomenclature': 'CODE1',
                'id_type': 117,
                'code_type': 'TYPE_MEDIA',
                'mnemonique': null,
                'label_default': 'Test Label',
                'label_fr': 'Test Label FR',
                'definition_default': null,
                'definition_fr': null,
                'label_en': null,
                'definition_en': null,
                'label_es': null,
                'definition_es': null,
                'label_de': null,
                'definition_de': null,
                'label_it': null,
                'definition_it': null,
                'source': null,
                'statut': null,
                'id_broader': null,
                'hierarchy': null,
                'active': true,
                'meta_create_date': '2023-01-01T00:00:00.000Z',
                'meta_update_date': '2023-01-01T00:00:00.000Z',
              },
            ],
            'dataset': [
              {
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
              },
            ],
          };
          
          when(() => moduleResponse.data).thenReturn(moduleData);
          when(() => moduleResponse.statusCode).thenReturn(200);
          
          when(() => mockDio.get(
                '$apiBase/monitorings/util/init_data/$moduleCode',
                options: any(named: 'options'),
              )).thenAnswer((_) async => moduleResponse);
        }

        final result = await globalApi.syncNomenclaturesAndDatasets(token, moduleCodes);

        expect(result.success, true);
        expect(result.itemsProcessed, greaterThan(0));
      });

      test('should handle network exception', () async {
        final moduleCodes = ['MODULE_1'];
        
        // Mock no connectivity
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.none]);

        final result = await globalApi.syncNomenclaturesAndDatasets(token, moduleCodes);

        expect(result.success, false);
        expect(result.errorMessage, contains('Aucune connexion réseau'));
      });
    });
  });
}
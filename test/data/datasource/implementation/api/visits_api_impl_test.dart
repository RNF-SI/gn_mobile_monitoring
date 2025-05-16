import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/visits_api_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/visit_observer.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}
class MockConnectivity extends Mock implements Connectivity {}
class MockResponse<T> extends Mock implements Response<T> {}

void main() {
  late VisitsApiImpl visitsApi;
  late MockDio mockDio;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockDio = MockDio();
    mockConnectivity = MockConnectivity();
    visitsApi = VisitsApiImpl(dio: mockDio, connectivity: mockConnectivity);
  });

  setUpAll(() {
    registerFallbackValue(Options());
    registerFallbackValue(Uri());
    registerFallbackValue([ConnectivityResult.none]);
  });

  group('VisitsApiImpl', () {
    const String token = 'test_token';
    const String moduleCode = 'TEST_MODULE';
    final String apiBase = Config.apiBase;

    group('sendVisit', () {
      test('should throw NetworkException when no internet connection', () async {
        // Configuration de l'état réseau sans connexion
        // La méthode checkConnectivity retourne une liste de ConnectivityResult
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.none]);

        // Visite de test
        final visit = BaseVisit(
          idBaseSite: 1,
          idDataset: 1,
          idModule: 1,
          visitDateMin: '2024-01-01',
          idBaseVisit: 0,
        );

        // Vérifier que la méthode lance une NetworkException sans atteindre le DioAdapter
        expect(
          () async => await visitsApi.sendVisit(token, moduleCode, visit),
          throwsA(isA<NetworkException>()),
        );

        // S'assurer que le post n'a jamais été appelé
        verifyNever(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ));
      });

      // Ignorer ce test car idDataset ne peut pas être null avec le modèle freezed
      // Il est marqué comme required, donc la création échouera avant d'atteindre l'API

      test('should throw ArgumentError when id_base_site is missing', () async {
        // Configuration de l'état réseau avec connexion
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // id_base_site est nullable, on peut le tester directement
        final visit = BaseVisit(
          idBaseSite: null,  // Explicitement null
          idDataset: 1,
          idModule: 1,
          visitDateMin: '2024-01-01',
          idBaseVisit: 0,
        );

        // Vérifier que la méthode lance une ArgumentError
        expect(
          () async => await visitsApi.sendVisit(token, moduleCode, visit),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should send visit successfully with required fields', () async {
        // Configuration de l'état réseau avec connexion
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // Visite complète avec tous les champs requis
        final visit = BaseVisit(
          idBaseSite: 1,
          idDataset: 1,
          idModule: 1,
          visitDateMin: '2024-01-01',
          idBaseVisit: 0,
        );

        // Mock de la réponse API
        const responseData = {
          'id': 123,
          'uuid': 'test-uuid',
          'status': 'success'
        };

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(responseData);
        when(() => mockResponse.statusCode).thenReturn(200);

        // Configuration du mock pour POST
        when(() => mockDio.post(
              '$apiBase/monitorings/object/$moduleCode/visit',
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        // Appel de la méthode
        final result = await visitsApi.sendVisit(token, moduleCode, visit);

        // Vérifications
        expect(result, equals(responseData));
        verify(() => mockDio.post(
              '$apiBase/monitorings/object/$moduleCode/visit',
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).called(1);
      });

      test('should send visit with additional data in properties', () async {
        // Configuration de l'état réseau avec connexion
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // Visite avec données supplémentaires
        final visit = BaseVisit(
          idBaseSite: 1,
          idDataset: 1,
          idModule: 10,
          visitDateMin: '2024-01-01',
          visitDateMax: '2024-01-02',
          comments: 'Test visit',
          idBaseVisit: 0,
          data: {
            'customField1': 'value1',
            'customField2': 42,
          },
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn({'id': 123});
        when(() => mockResponse.statusCode).thenReturn(200);

        // Capture des arguments pour vérifier le contenu
        final capturedData = <String, dynamic>{};
        
        when(() => mockDio.post(
              '$apiBase/monitorings/object/$moduleCode/visit',
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((invocation) async {
              capturedData.addAll(invocation.namedArguments[const Symbol('data')] as Map<String, dynamic>);
              return mockResponse;
            });

        // Appel de la méthode
        await visitsApi.sendVisit(token, moduleCode, visit);

        // Vérifier que les données supplémentaires sont dans properties
        expect(capturedData['properties']['customField1'], equals('value1'));
        expect(capturedData['properties']['customField2'], equals(42));
        expect(capturedData['module_code'], equals(moduleCode));
      });

      test('should handle server errors properly', () async {
        // Configuration de l'état réseau avec connexion
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // Visite valide
        final visit = BaseVisit(
          idBaseSite: 1,
          idDataset: 1,
          idModule: 1,
          visitDateMin: '2024-01-01',
          idBaseVisit: 0,
        );

        // Configuration du mock pour erreur serveur
        when(() => mockDio.post(
              '$apiBase/monitorings/object/$moduleCode/visit',
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenThrow(DioException(
              requestOptions: RequestOptions(path: ''),
              response: Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 500,
                data: {'error': 'Internal server error'},
              ),
            ));

        // L'API convertit les DioException en NetworkException
        expect(
          () async => await visitsApi.sendVisit(token, moduleCode, visit),
          throwsA(isA<NetworkException>()),
        );
      });

      test('should include observers in the request', () async {
        // Configuration de l'état réseau avec connexion
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // Visite avec observateurs
        final visit = BaseVisit(
          idBaseSite: 1,
          idDataset: 1,
          idModule: 1,
          visitDateMin: '2024-01-01',
          idBaseVisit: 0,
          observers: [1, 2], // Les observateurs sont une liste d'IDs dans BaseVisit
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn({'id': 123});
        when(() => mockResponse.statusCode).thenReturn(200);

        // Capture des arguments pour vérifier les observateurs
        final capturedData = <String, dynamic>{};
        
        when(() => mockDio.post(
              '$apiBase/monitorings/object/$moduleCode/visit',
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((invocation) async {
              capturedData.addAll(invocation.namedArguments[const Symbol('data')] as Map<String, dynamic>);
              return mockResponse;
            });

        // Appel de la méthode
        await visitsApi.sendVisit(token, moduleCode, visit);

        // Vérifier que les observateurs sont inclus
        expect(capturedData['properties']['observers'], equals([1, 2]));
      });
    });
  });
}
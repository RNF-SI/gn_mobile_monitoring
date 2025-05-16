import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/observations_api_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}
class MockConnectivity extends Mock implements Connectivity {}
class MockResponse<T> extends Mock implements Response<T> {}

void main() {
  late ObservationsApiImpl observationsApi;
  late MockDio mockDio;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockDio = MockDio();
    mockConnectivity = MockConnectivity();
    observationsApi = ObservationsApiImpl(dio: mockDio, connectivity: mockConnectivity);
  });

  setUpAll(() {
    registerFallbackValue(Options());
    registerFallbackValue(Uri());
    registerFallbackValue(ConnectivityResult.none);
  });

  group('ObservationsApiImpl', () {
    const String token = 'test_token';
    const String moduleCode = 'TEST_MODULE';
    final String apiBase = Config.apiBase;

    group('sendObservation', () {
      test('should throw NetworkException when no internet connection', () async {
        // Configuration de l'état réseau sans connexion
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.none]);

        // Observation de test
        final observation = Observation(
          idObservation: 0,
          idBaseVisit: 1,
          cdNom: 12345,
          comments: 'Test observation',
        );

        // Vérifier que la méthode lance une NetworkException
        expect(
          () async => await observationsApi.sendObservation(token, moduleCode, observation),
          throwsA(isA<NetworkException>()),
        );

        // S'assurer que le post n'a jamais été appelé
        verifyNever(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ));
      });

      test('should send observation successfully with required fields', () async {
        // Configuration de l'état réseau avec connexion
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // Observation complète avec tous les champs requis
        final observation = Observation(
          idObservation: 0,
          idBaseVisit: 1,
          cdNom: 12345,
          comments: 'Test observation',
          uuidObservation: 'test-uuid',
        );

        // Mock de la réponse API
        const responseData = {
          'id': 456,
          'uuid': 'test-uuid',
          'status': 'success'
        };

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(responseData);
        when(() => mockResponse.statusCode).thenReturn(200);

        // Configuration du mock pour POST avec skip_synthese
        when(() => mockDio.post(
              '$apiBase/monitorings/object/$moduleCode/observation?skip_synthese=true',
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        // Appel de la méthode
        final result = await observationsApi.sendObservation(token, moduleCode, observation);

        // Vérifications
        expect(result, equals(responseData));
        verify(() => mockDio.post(
              '$apiBase/monitorings/object/$moduleCode/observation?skip_synthese=true',
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).called(1);
      });

      test('should send observation with additional data in properties', () async {
        // Configuration de l'état réseau avec connexion
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // Observation avec données supplémentaires
        final observation = Observation(
          idObservation: 0,
          idBaseVisit: 1,
          cdNom: 12345,
          comments: 'Test observation',
          data: {
            'customField1': 'value1',
            'customField2': 42,
            'id_species': '789',  // Doit être converti en int
          },
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn({'id': 456});
        when(() => mockResponse.statusCode).thenReturn(200);

        // Capture des arguments pour vérifier le contenu
        final capturedData = <String, dynamic>{};
        
        when(() => mockDio.post(
              '$apiBase/monitorings/object/$moduleCode/observation?skip_synthese=true',
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((invocation) async {
              capturedData.addAll(invocation.namedArguments[const Symbol('data')] as Map<String, dynamic>);
              return mockResponse;
            });

        // Appel de la méthode
        await observationsApi.sendObservation(token, moduleCode, observation);

        // Vérifier que les données supplémentaires sont dans properties
        expect(capturedData['properties']['customField1'], equals('value1'));
        expect(capturedData['properties']['customField2'], equals(42));
        expect(capturedData['properties']['id_species'], equals(789)); // Converti en int
        expect(capturedData['module_code'], equals(moduleCode));
      });

      test('should handle server errors properly', () async {
        // Configuration de l'état réseau avec connexion
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // Observation valide
        final observation = Observation(
          idObservation: 0,
          idBaseVisit: 1,
          cdNom: 12345,
        );

        // Configuration du mock pour erreur serveur
        when(() => mockDio.post(
              '$apiBase/monitorings/object/$moduleCode/observation?skip_synthese=true',
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
          () async => await observationsApi.sendObservation(token, moduleCode, observation),
          throwsA(isA<NetworkException>()),
        );
      });

      test('should convert string cd_nom to integer in data field', () async {
        // Configuration de l'état réseau avec connexion
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // Observation avec cd_nom en string dans les données
        final observation = Observation(
          idObservation: 0,
          idBaseVisit: 1,
          data: {
            'cd_nom': '12345',  // String qui doit être converti en int
            'other_field': 'value',
          },
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn({'id': 456});
        when(() => mockResponse.statusCode).thenReturn(200);

        // Capture des arguments pour vérifier le contenu
        final capturedData = <String, dynamic>{};
        
        when(() => mockDio.post(
              '$apiBase/monitorings/object/$moduleCode/observation?skip_synthese=true',
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((invocation) async {
              capturedData.addAll(invocation.namedArguments[const Symbol('data')] as Map<String, dynamic>);
              return mockResponse;
            });

        // Appel de la méthode
        await observationsApi.sendObservation(token, moduleCode, observation);

        // Vérifier que cd_nom a été converti en int
        expect(capturedData['properties']['cd_nom'], equals(12345));
        expect(capturedData['properties']['other_field'], equals('value'));
      });

      test('should include uuid_observation at top level', () async {
        // Configuration de l'état réseau avec connexion
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // Observation avec UUID
        final observation = Observation(
          idObservation: 0,
          idBaseVisit: 1,
          uuidObservation: 'test-uuid-123',
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn({'id': 456});
        when(() => mockResponse.statusCode).thenReturn(200);

        // Capture des arguments pour vérifier le contenu
        final capturedData = <String, dynamic>{};
        
        when(() => mockDio.post(
              '$apiBase/monitorings/object/$moduleCode/observation?skip_synthese=true',
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((invocation) async {
              capturedData.addAll(invocation.namedArguments[const Symbol('data')] as Map<String, dynamic>);
              return mockResponse;
            });

        // Appel de la méthode
        await observationsApi.sendObservation(token, moduleCode, observation);

        // Vérifier que l'UUID est au niveau supérieur
        expect(capturedData['uuid_observation'], equals('test-uuid-123'));
      });
    });
  });
}

// ✓ Classe d'aide pour tester avec dépendances injectées
class ObservationsApiImplWithDeps extends ObservationsApiImpl {
  final Dio _mockDio;
  final Connectivity _mockConnectivity;

  ObservationsApiImplWithDeps(this._mockDio, this._mockConnectivity) : super();

  @override
  Dio get _dio => _mockDio;

  @override
  Connectivity get _connectivity => _mockConnectivity;
}
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/observation_details_api_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}
class MockConnectivity extends Mock implements Connectivity {}
class MockResponse<T> extends Mock implements Response<T> {}

void main() {
  late ObservationDetailsApiImpl observationDetailsApi;
  late MockDio mockDio;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockDio = MockDio();
    mockConnectivity = MockConnectivity();
    observationDetailsApi = ObservationDetailsApiImpl(dio: mockDio, connectivity: mockConnectivity);
  });

  setUpAll(() {
    registerFallbackValue(Options());
    registerFallbackValue(Uri());
    registerFallbackValue(ConnectivityResult.none);
  });

  group('ObservationDetailsApiImpl', () {
    const String token = 'test_token';
    const String moduleCode = 'TEST_MODULE';
    final String apiBase = Config.apiBase;

    group('sendObservationDetail', () {
      test('should throw NetworkException when no internet connection', () async {
        // Configuration de l'état réseau sans connexion
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.none]);

        // ObservationDetail de test
        final detail = ObservationDetail(
          idObservationDetail: 1,
          idObservation: 123,
          uuidObservationDetail: 'test-uuid',
          data: {},
        );

        // Vérifier que la méthode lance une NetworkException
        expect(
          () async => await observationDetailsApi.sendObservationDetail(token, moduleCode, detail),
          throwsA(isA<NetworkException>()),
        );

        // S'assurer que le post n'a jamais été appelé
        verifyNever(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ));
      });

      test('should throw ArgumentError when id_observation is missing', () async {
        // Configuration de l'état réseau avec connexion
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // ObservationDetail sans id_observation
        final detail = ObservationDetail(
          idObservationDetail: 1,
          idObservation: null,  // Explicitement null
          uuidObservationDetail: 'test-uuid',
          data: {},
        );

        // Vérifier que la méthode lance une ArgumentError
        expect(
          () async => await observationDetailsApi.sendObservationDetail(token, moduleCode, detail),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should send observation detail successfully with required fields', () async {
        // Configuration de l'état réseau avec connexion
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // ObservationDetail complète avec tous les champs requis
        final detail = ObservationDetail(
          idObservationDetail: 1,
          idObservation: 123,
          uuidObservationDetail: 'test-uuid',
          data: {
            'hauteur_strate': '10-20',
            'denombrement': 5,
          },
        );

        // Mock de la réponse API
        const responseData = {
          'id': 789,
          'uuid': 'test-uuid',
          'status': 'success'
        };

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn(responseData);
        when(() => mockResponse.statusCode).thenReturn(200);

        // Configuration du mock pour POST avec skip_synthese
        when(() => mockDio.post(
              '$apiBase/monitorings/object/$moduleCode/observation_detail?skip_synthese=true',
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        // Appel de la méthode
        final result = await observationDetailsApi.sendObservationDetail(token, moduleCode, detail);

        // Vérifications
        expect(result, equals(responseData));
        verify(() => mockDio.post(
              '$apiBase/monitorings/object/$moduleCode/observation_detail?skip_synthese=true',
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).called(1);
      });

      test('should convert numeric strings to integers in data fields', () async {
        // Configuration de l'état réseau avec connexion
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // ObservationDetail avec champs à convertir
        final detail = ObservationDetail(
          idObservationDetail: 1,
          idObservation: 123,
          data: {
            'id_nomenclature_strate': '456',  // String à convertir en int
            'hauteur_strate': '10-20',        // String à garder en string
            'denombrement': '5',              // String à convertir en int
            'cd_nom': '12345',                // String à convertir en int
          },
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn({'id': 789});
        when(() => mockResponse.statusCode).thenReturn(200);

        // Capture des arguments pour vérifier le contenu
        final capturedData = <String, dynamic>{};
        
        when(() => mockDio.post(
              '$apiBase/monitorings/object/$moduleCode/observation_detail?skip_synthese=true',
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((invocation) async {
              capturedData.addAll(invocation.namedArguments[const Symbol('data')] as Map<String, dynamic>);
              return mockResponse;
            });

        // Appel de la méthode
        await observationDetailsApi.sendObservationDetail(token, moduleCode, detail);

        // Vérifier la conversion des types
        expect(capturedData['properties']['id_nomenclature_strate'], equals(456));
        expect(capturedData['properties']['hauteur_strate'], equals('10-20'));
        expect(capturedData['properties']['denombrement'], equals('5')); // Non converti car ne commence pas par 'id_'
        expect(capturedData['properties']['cd_nom'], equals('12345')); // Non converti car ne commence pas par 'id_'
      });

      test('should handle List<int> UUID format', () async {
        // Configuration de l'état réseau avec connexion
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // ObservationDetail avec UUID en format String représentant une liste
        // Simuler "[192, 168, 1, 1]" qui devrait devenir "c0a80101"
        const uuidString = "[192, 168, 1, 1]";
        final detail = ObservationDetail(
          idObservationDetail: 1,
          idObservation: 123,
          uuidObservationDetail: uuidString,
          data: {},
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn({'id': 789});
        when(() => mockResponse.statusCode).thenReturn(200);

        // Capture des arguments pour vérifier le contenu
        final capturedData = <String, dynamic>{};
        
        when(() => mockDio.post(
              '$apiBase/monitorings/object/$moduleCode/observation_detail?skip_synthese=true',
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((invocation) async {
              capturedData.addAll(invocation.namedArguments[const Symbol('data')] as Map<String, dynamic>);
              return mockResponse;
            });

        // Appel de la méthode
        await observationDetailsApi.sendObservationDetail(token, moduleCode, detail);

        // Vérifier la conversion de l'UUID
        expect(capturedData['properties']['uuid_observation_detail'], equals('c0a80101'));
      });

      test('should handle server errors properly', () async {
        // Configuration de l'état réseau avec connexion
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // ObservationDetail valide
        final detail = ObservationDetail(
          idObservationDetail: 1,
          idObservation: 123,
          data: {},
        );

        // Configuration du mock pour erreur serveur
        when(() => mockDio.post(
              '$apiBase/monitorings/object/$moduleCode/observation_detail?skip_synthese=true',
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
          () async => await observationDetailsApi.sendObservationDetail(token, moduleCode, detail),
          throwsA(isA<NetworkException>()),
        );
      });

      test('should not duplicate id_observation field', () async {
        // Configuration de l'état réseau avec connexion
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // ObservationDetail avec id_observation en double
        final detail = ObservationDetail(
          idObservationDetail: 1,
          idObservation: 123,
          data: {
            'id_observation': '456',  // Doublon qui devrait être ignoré
            'other_field': 'value',
          },
        );

        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(() => mockResponse.data).thenReturn({'id': 789});
        when(() => mockResponse.statusCode).thenReturn(200);

        // Capture des arguments pour vérifier le contenu
        final capturedData = <String, dynamic>{};
        
        when(() => mockDio.post(
              '$apiBase/monitorings/object/$moduleCode/observation_detail?skip_synthese=true',
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((invocation) async {
              capturedData.addAll(invocation.namedArguments[const Symbol('data')] as Map<String, dynamic>);
              return mockResponse;
            });

        // Appel de la méthode
        await observationDetailsApi.sendObservationDetail(token, moduleCode, detail);

        // Vérifier que id_observation n'est pas dupliqué et a la bonne valeur
        expect(capturedData['properties']['id_observation'], equals(123));
        expect(capturedData['properties']['other_field'], equals('value'));
      });
    });
  });
}

// ✓ Extension pour faciliter les tests avec dépendances injectées
extension ObservationDetailsApiImplTestExtension on ObservationDetailsApiImpl {
  static ObservationDetailsApiImpl createWithDeps(Dio dio, Connectivity connectivity) {
    return ObservationDetailsApiImpl(dio: dio, connectivity: connectivity);
  }
}
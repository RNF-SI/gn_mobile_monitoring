import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/errors/login_error_formatter.dart';

DioException _dio({
  required DioExceptionType type,
  String? message,
  Response<dynamic>? response,
}) {
  return DioException(
    type: type,
    message: message,
    requestOptions: RequestOptions(path: 'https://demo.geonature.fr/geonature'),
    response: response,
  );
}

void main() {
  group('LoginErrorMessage.from', () {
    test('mappe les timeouts vers un message orienté connexion', () {
      final result = LoginErrorMessage.from(
          _dio(type: DioExceptionType.connectionTimeout));
      expect(result.message, contains('Délai dépassé'));
      expect(result.details['type'], 'connectionTimeout');
    });

    test('mappe une connexion impossible vers un message actionnable', () {
      final result = LoginErrorMessage.from(
          _dio(type: DioExceptionType.connectionError));
      expect(result.message, contains('Connexion impossible'));
    });

    test('mappe un certificat invalide vers un message HTTPS', () {
      final result = LoginErrorMessage.from(
          _dio(type: DioExceptionType.badCertificate));
      expect(result.message, contains('certificat HTTPS'));
    });

    test("traduit un 404 en pointe explicite vers l'URL", () {
      final result = LoginErrorMessage.from(_dio(
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          statusCode: 404,
          requestOptions: RequestOptions(path: '/'),
        ),
      ));
      expect(result.message, contains('404'));
      expect(result.message, contains('GeoNature'));
    });

    test('traduit un 5xx en suggestion de réessai', () {
      final result = LoginErrorMessage.from(_dio(
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          statusCode: 503,
          requestOptions: RequestOptions(path: '/'),
        ),
      ));
      expect(result.message, contains('503'));
      expect(result.message, contains('Réessayez'));
    });

    test('traduit un Failed host lookup en explication DNS', () {
      final result = LoginErrorMessage.from(_dio(
        type: DioExceptionType.unknown,
        message: 'SocketException: Failed host lookup: foo',
      ));
      expect(result.message, contains('nom de domaine'));
    });

    test("garde le message d'une Exception levée par l'API auth", () {
      // Pas de DioException : message déjà français lisible.
      final result = LoginErrorMessage.from(
        Exception('Le serveur redirige vers HTTPS. Modifiez l\'URL...'),
      );
      // Le préfixe "Exception: " est strippé.
      expect(result.message, startsWith('Le serveur redirige vers HTTPS'));
    });
  });
}

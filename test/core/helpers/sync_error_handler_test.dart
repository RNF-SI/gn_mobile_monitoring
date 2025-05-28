import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/sync_error_handler.dart';

void main() {
  group('SyncErrorHandler', () {
    group('extractDetailedError', () {
      test('should extract detailed error message', () {
        const error = 'timeout connection error';
        const entityType = 'visite';
        const entityId = 123;

        final result = SyncErrorHandler.extractDetailedError(error, entityType, entityId);

        expect(result, contains('Visite 123'));
        expect(result, contains('Timeout de connexion'));
      });

      test('should handle null error', () {
        const entityType = 'observation';
        const entityId = 456;

        final result = SyncErrorHandler.extractDetailedError(null, entityType, entityId);

        expect(result, contains('Observation 456'));
        expect(result, contains('null'));
      });

      test('should handle different entity types', () {
        const error = 'Validation failed';
        const entityId = 789;

        final visitResult = SyncErrorHandler.extractDetailedError(error, 'visite', entityId);
        final obsResult = SyncErrorHandler.extractDetailedError(error, 'observation', entityId);
        final detailResult = SyncErrorHandler.extractDetailedError(error, 'observation_detail', entityId);

        expect(visitResult, contains('Visite 789'));
        expect(obsResult, contains('Observation 789'));
        expect(detailResult, contains('Observation_detail 789'));
      });
    });

    group('isFatalError', () {
      test('should identify fatal database errors', () {
        const fatalError = 'constraint violation occurred';
        expect(SyncErrorHandler.isFatalError(fatalError), isTrue);
      });

      test('should identify fatal validation errors', () {
        const fatalError = 'FOREIGN KEY constraint failed';
        expect(SyncErrorHandler.isFatalError(fatalError), isTrue);
      });

      test('should not identify network errors as fatal', () {
        const networkError = 'Connection timeout';
        expect(SyncErrorHandler.isFatalError(networkError), isFalse);
      });

      test('should not identify temporary server errors as fatal', () {
        const serverError = '500 Internal Server Error';
        expect(SyncErrorHandler.isFatalError(serverError), isFalse);
      });

      test('should handle null error', () {
        expect(SyncErrorHandler.isFatalError(null), isFalse);
      });

      test('should handle different error types', () {
        expect(SyncErrorHandler.isFatalError(Exception('test')), isFalse);
        expect(SyncErrorHandler.isFatalError(ArgumentError('test')), isFalse);
      });
    });

    group('error formatting integration', () {
      test('should format constraint errors correctly', () {
        const error = 'unique constraint violation';
        const entityType = 'visite';
        const entityId = 123;

        final result = SyncErrorHandler.extractDetailedError(error, entityType, entityId);

        expect(result, contains('Visite 123'));
        expect(result, contains('Données en conflit'));
        expect(result, contains('existe déjà'));
      });

      test('should format server errors correctly', () {
        const error = '500 Internal Server Error with synthese';
        const entityType = 'observation';
        const entityId = 456;

        final result = SyncErrorHandler.extractDetailedError(error, entityType, entityId);

        expect(result, contains('Observation 456'));
        expect(result, contains('Erreur de synthèse'));
      });

      test('should format validation errors correctly', () {
        const error = '400 Bad Request - required field missing';
        const entityType = 'observation_detail';
        const entityId = 789;

        final result = SyncErrorHandler.extractDetailedError(error, entityType, entityId);

        expect(result, contains('Observation_detail 789'));
        expect(result, contains('Champs obligatoires'));
      });

      test('should format timeout errors correctly', () {
        const error = 'Connection timeout occurred';
        const entityType = 'visite';
        const entityId = 999;

        final result = SyncErrorHandler.extractDetailedError(error, entityType, entityId);

        expect(result, contains('Visite 999'));
        expect(result, contains('Timeout de connexion'));
      });

      test('should format network errors correctly', () {
        const error = 'NetworkException: 500 server error';
        const entityType = 'observation';
        const entityId = 111;

        final result = SyncErrorHandler.extractDetailedError(error, entityType, entityId);

        expect(result, contains('Observation 111'));
        expect(result, contains('Erreur interne du serveur'));
      });
    });
  });
}
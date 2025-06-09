import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/core/helpers/sync_error_handler.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';

void main() {
  group('SyncErrorHandler Enhanced with Server Details', () {
    test('should include server details in constraint error', () {
      // Simuler l'erreur PostgreSQL depuis les logs
      final jsonResponse = {
        'detail': 'ERREUR: la nouvelle ligne de la relation « synthese » viole la contrainte de vérification « check_synthese_count_max »\nDÉTAIL : Le nombre maximum (2) doit être supérieur au nombre minimum (3)'
      };

      final dioException = DioException(
        requestOptions: RequestOptions(path: '/monitoring/chiro/observation/36760'),
        response: Response(
          requestOptions: RequestOptions(path: '/monitoring/chiro/observation/36760'),
          data: jsonResponse,
          statusCode: 500,
        ),
      );

      final networkException = NetworkException(
        'Server error during sync',
        originalDioException: dioException,
      );

      final result = SyncErrorHandler.extractDetailedError(
        networkException,
        'Observation',
        36760,
      );

      // Vérifier la structure du message
      expect(result, startsWith('Observation 36760:'));
      expect(result, contains('Données en conflit'));
      expect(result, contains('nombre maximum doit être supérieur'));
      expect(result, contains('Détails serveur:'));
      expect(result, contains('ERREUR: la nouvelle ligne'));
      expect(result, contains('check_synthese_count_max'));
      expect(result, contains('nombre maximum (2)'));
      expect(result, contains('Détails techniques:'));
    });

    test('should include server details in nomenclature error', () {
      // Simuler l'erreur de nomenclature depuis les logs
      final jsonResponse = {
        'detail': 'Error : id_nomenclature --> (1376) and nomenclature --> (STADE_VIE) type didn\'t match. Use id_nomenclature in corresponding type (mnemonique field). See ref_nomenclatures.t_nomenclatures.id_type.'
      };

      final dioException = DioException(
        requestOptions: RequestOptions(path: '/monitoring/chiro/observation/36761'),
        response: Response(
          requestOptions: RequestOptions(path: '/monitoring/chiro/observation/36761'),
          data: jsonResponse,
          statusCode: 500,
        ),
      );

      final networkException = NetworkException(
        'Server error during sync',
        originalDioException: dioException,
      );

      final result = SyncErrorHandler.extractDetailedError(
        networkException,
        'Observation',
        36761,
      );

      // Vérifier la structure du message
      expect(result, startsWith('Observation 36761:'));
      expect(result, contains('Erreur interne du serveur'));
      expect(result, contains('Détails serveur:'));
      expect(result, contains('id_nomenclature --> (1376)'));
      expect(result, contains('STADE_VIE'));
      expect(result, contains('didn\'t match'));
      expect(result, contains('Détails techniques:'));
    });

    test('should handle HTML error response from server', () {
      // Simuler une page d'erreur HTML comme dans les logs
      const htmlResponse = '''
<html>
<head><title>GeoNatureError</title></head>
<body>
<div class="debugger">
<h1>GeoNatureError</h1>
<div class="detail">
  <p class="errormsg">geonature.utils.errors.GeoNatureError: MONITORING: create_or_update monitoringobject chiro, observation, 36761 : Error 500, Message:  Error while executing import_from_table with parameters</p>
</div>
</body>
</html>
      ''';

      final dioException = DioException(
        requestOptions: RequestOptions(path: '/monitoring/chiro/observation/36761'),
        response: Response(
          requestOptions: RequestOptions(path: '/monitoring/chiro/observation/36761'),
          data: htmlResponse,
          statusCode: 500,
        ),
      );

      final networkException = NetworkException(
        'Server error during sync',
        originalDioException: dioException,
      );

      final result = SyncErrorHandler.extractDetailedError(
        networkException,
        'Observation',
        36761,
      );

      // Vérifier la structure du message
      expect(result, startsWith('Observation 36761:'));
      expect(result, contains('Erreur interne du serveur'));
      expect(result, contains('Détails serveur:'));
      expect(result, contains('GeoNatureError'));
      expect(result, contains('import_from_table'));
    });

    test('should fallback to original behavior when no server details', () {
      // Erreur simple sans détails serveur
      final exception = Exception('Simple timeout error');

      final result = SyncErrorHandler.extractDetailedError(
        exception,
        'Visite',
        123,
      );

      expect(result, startsWith('Visite 123:'));
      expect(result, contains('Détails techniques:'));
      expect(result, isNot(contains('Détails serveur:')));
    });

    test('should avoid duplication when server details already in message', () {
      // Cas où les détails serveur sont déjà inclus dans le message d'erreur
      final errorWithDetails = '''
NetworkException: Server error
ERREUR: constraint violation
DÉTAIL : specific database error
      ''';

      final result = SyncErrorHandler.extractDetailedError(
        errorWithDetails,
        'Observation',
        999,
      );

      // Ne doit pas dupliquer les mêmes informations
      final occurrences = 'constraint violation'.allMatches(result).length;
      expect(occurrences, equals(1));
    });

    test('should handle complex nested error structures', () {
      // Structure complexe avec plusieurs niveaux d'erreur
      final complexError = {
        'error': 'Database operation failed',
        'detail': 'ERREUR: violates foreign key constraint "fk_observation_visit"',
        'context': {
          'sql': 'INSERT INTO observations...',
          'parameters': {'id_visit': 12345, 'id_observation': 67890}
        },
        'exception_type': 'IntegrityError'
      };

      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          data: complexError,
          statusCode: 500,
        ),
      );

      final result = SyncErrorHandler.extractDetailedError(
        dioException,
        'Observation',
        67890,
      );

      expect(result, contains('Détails serveur:'));
      expect(result, contains('foreign key constraint'));
      expect(result, contains('fk_observation_visit'));
    });

    group('Real-world error scenarios', () {
      test('should handle the exact error from logs - count_max violation', () {
        // Reproduire exactement l'erreur des logs
        const realError = '''
(psycopg2.errors.CheckViolation) ERREUR:  la nouvelle ligne de la relation « synthese » viole la contrainte de vérification « check_synthese_count_max »
DÉTAIL : La ligne en échec contient (2561408, 7efaec3c-8c70-403a-85f3-58a0cd32bbcd, e00b473e-4508-4283-b2bb-a40319a741f7, 80, 11547, 90, 175, 138, 53, 30, 158, 161, 81, 466, 144, 12, 169, 147, 93, null, 89, 176, 75, 127, 3, 2, 60295, Rhinolophus ferrumequinum (Schreber, 1774), Taxref V16.0, null, null, null, 1005, 1005, 0101000020E6100000C0B2D2A414F40C40261AA4E0291E4640, 0101000020E6100000C0B2D2A414F40C40261AA4E0291E4640, 01010000206A0800004505AE8320DF264151650D52E9375841, 2025-06-06 00:00:00, 2025-06-06 00:00:00, null, null, test test, null, null, 446, null, 2025-06-06 19:30:23.426149, 2025-06-06 19:30:23.426149, null, 24, null, null, null, null, null, null, 607, null, null, null, null, null, 179).
        ''';

        final result = SyncErrorHandler.extractDetailedError(
          realError,
          'Observation',
          36760,
        );

        expect(result, startsWith('Observation 36760:'));
        expect(result, contains('Données en conflit'));
        expect(result, contains('check_synthese_count_max'));
        expect(result, contains('DÉTAIL : La ligne en échec'));
        expect(result, contains('Rhinolophus ferrumequinum'));
      });

      test('should handle the exact error from logs - nomenclature mismatch', () {
        // Reproduire exactement l'erreur de nomenclature des logs
        const realError = '''
ERREUR:  Error : id_nomenclature --> (1376) and nomenclature --> (STADE_VIE) type didn't match. Use id_nomenclature in corresponding type (mnemonique field). See ref_nomenclatures.t_nomenclatures.id_type.
CONTEXTE : fonction PL/pgSQL ref_nomenclatures.check_nomenclature_type_by_mnemonique(integer,character varying), ligne 8 à RAISE
        ''';

        final result = SyncErrorHandler.extractDetailedError(
          realError,
          'Observation',
          36761,
        );

        expect(result, startsWith('Observation 36761:'));
        expect(result, contains('id_nomenclature --> (1376)'));
        expect(result, contains('STADE_VIE'));
        expect(result, contains('didn\'t match'));
        expect(result, contains('ref_nomenclatures.t_nomenclatures.id_type'));
      });
    });
  });
}
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/core/helpers/server_error_extractor.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';

void main() {
  group('ServerErrorExtractor', () {
    group('JSON Response Extraction', () {
      test('should extract detail from JSON response', () {
        final jsonResponse = {
          'detail': 'ERREUR: la nouvelle ligne de la relation « synthese » viole la contrainte de vérification « check_synthese_count_max »',
          'message': 'Database constraint violation',
          'code': 500
        };

        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            data: jsonResponse,
            statusCode: 500,
          ),
        );

        final result = ServerErrorExtractor.extractServerDetails(dioException);
        
        expect(result, contains('ERREUR: la nouvelle ligne'));
        expect(result, contains('detail:'));
      });

      test('should extract multiple JSON fields in priority order', () {
        final jsonResponse = {
          'error': 'General error',
          'detail': 'Specific database error',
          'message': 'User message',
        };

        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            data: jsonResponse,
            statusCode: 500,
          ),
        );

        final result = ServerErrorExtractor.extractServerDetails(dioException);
        
        // Should prioritize 'detail' over other fields
        expect(result, startsWith('detail:'));
        expect(result, contains('Specific database error'));
      });
    });

    group('HTML Response Extraction', () {
      test('should extract PostgreSQL errors from HTML', () {
        const htmlResponse = '''
<html>
<head><title>GeoNatureError</title></head>
<body>
<h1>GeoNatureError</h1>
<div class="detail">
  <p class="errormsg">MONITORING: create_or_update monitoringobject chiro, observation, 36760 : (psycopg2.errors.CheckViolation) ERREUR:  la nouvelle ligne de la relation « synthese » viole la contrainte de vérification « check_synthese_count_max »
DÉTAIL : Le nombre maximum (2) doit être supérieur au nombre minimum (3)</p>
</div>
</body>
</html>
        ''';

        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            data: htmlResponse,
            statusCode: 500,
          ),
        );

        final result = ServerErrorExtractor.extractServerDetails(dioException);
        
        expect(result, contains('ERREUR:'));
        expect(result, contains('contrainte de vérification'));
        expect(result, contains('DÉTAIL :'));
        expect(result, contains('nombre maximum'));
      });

      test('should extract error title and message from HTML', () {
        const htmlResponse = '''
<html>
<head><title>Server Error</title></head>
<body>
<h1>Internal Server Error</h1>
<p class="errormsg">Database connection failed</p>
</body>
</html>
        ''';

        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            data: htmlResponse,
            statusCode: 500,
          ),
        );

        final result = ServerErrorExtractor.extractServerDetails(dioException);
        
        expect(result, contains('Erreur: Internal Server Error'));
        expect(result, contains('Message: Database connection failed'));
      });
    });

    group('NetworkException Integration', () {
      test('should extract from NetworkException with DioException', () {
        final jsonResponse = {
          'detail': 'Error : id_nomenclature --> (1376) and nomenclature --> (STADE_VIE) type didn\'t match',
          'status': 500
        };

        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            data: jsonResponse,
            statusCode: 500,
          ),
        );

        final networkException = NetworkException(
          'Server error occurred',
          originalDioException: dioException,
        );

        final result = ServerErrorExtractor.extractServerDetails(networkException);
        
        expect(result, contains('id_nomenclature'));
        expect(result, contains('STADE_VIE'));
        expect(result, contains('didn\'t match'));
      });
    });

    group('String Response Extraction', () {
      test('should parse JSON string response', () {
        const jsonString = '{"detail": "ERREUR: constraint violation", "code": 500}';

        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            data: jsonString,
            statusCode: 500,
          ),
        );

        final result = ServerErrorExtractor.extractServerDetails(dioException);
        
        expect(result, contains('detail: ERREUR: constraint violation'));
      });

      test('should handle plain text response', () {
        const textResponse = 'Simple error message';

        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            data: textResponse,
            statusCode: 500,
          ),
        );

        final result = ServerErrorExtractor.extractServerDetails(dioException);
        
        expect(result, equals('Simple error message'));
      });
    });

    group('HTML Entity Decoding', () {
      test('should decode HTML entities', () {
        const htmlWithEntities = 'ERREUR: constraint &gt; value &amp; check &lt; failed';

        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            data: htmlWithEntities,
            statusCode: 500,
          ),
        );

        final result = ServerErrorExtractor.extractServerDetails(dioException);
        
        expect(result, contains('constraint > value & check < failed'));
      });
    });

    group('Edge Cases', () {
      test('should return null for null error', () {
        final result = ServerErrorExtractor.extractServerDetails(null);
        expect(result, isNull);
      });

      test('should return null for error without response data', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
        );

        final result = ServerErrorExtractor.extractServerDetails(dioException);
        expect(result, isNull);
      });

      test('should handle empty JSON response', () {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            data: {},
            statusCode: 500,
          ),
        );

        final result = ServerErrorExtractor.extractServerDetails(dioException);
        expect(result, equals('{}'));
      });
    });

    group('Utility Methods', () {
      test('hasServerDetails should return true for extractable errors', () {
        final jsonResponse = {'detail': 'Some error'};
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            data: jsonResponse,
            statusCode: 500,
          ),
        );

        expect(ServerErrorExtractor.hasServerDetails(dioException), isTrue);
        expect(ServerErrorExtractor.hasServerDetails(null), isFalse);
      });

      test('extractServerSummary should return first line', () {
        final jsonResponse = {
          'detail': 'Line 1: Main error\nLine 2: Additional details\nLine 3: More info'
        };
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            data: jsonResponse,
            statusCode: 500,
          ),
        );

        final summary = ServerErrorExtractor.extractServerSummary(dioException);
        expect(summary, contains('Line 1: Main error'));
        expect(summary, isNot(contains('Line 2:')));
      });

      test('extractServerSummary should truncate long first lines', () {
        final longMessage = 'A' * 150; // 150 characters
        final jsonResponse = {'detail': longMessage};
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            data: jsonResponse,
            statusCode: 500,
          ),
        );

        final summary = ServerErrorExtractor.extractServerSummary(dioException);
        expect(summary!.length, lessThanOrEqualTo(103)); // 100 + "..."
        expect(summary, endsWith('...'));
      });
    });
  });
}
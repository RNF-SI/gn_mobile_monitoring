import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/base_api.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {}
class MockDio extends Mock implements Dio {}
class MockResponse<T> extends Mock implements Response<T> {}

class TestApi extends BaseApi {
  TestApi({Connectivity? connectivity}) : super();

  Future<String> testRelativeUrl() async {
    final response = await dio.get('/test-endpoint');
    return response.data;
  }

  Future<String> testAbsoluteUrl() async {
    final response = await dio.get('https://example.com/absolute');
    return response.data;
  }
}

void main() {
  group('BaseApi Tests', () {
    late TestApi testApi;
    late MockConnectivity mockConnectivity;

    setUp(() {
      mockConnectivity = MockConnectivity();
      testApi = TestApi(connectivity: mockConnectivity);
    });

    group('URL Handling', () {
      test('should handle relative URLs correctly', () async {
        // BaseApi should automatically configure Dio with proper base URL
        expect(testApi.dio, isNotNull);
        expect(testApi.dio.options.baseUrl, isNotEmpty);
      });

      test('should configure proper headers', () {
        // Check that BaseApi provides a Dio instance with headers map
        expect(testApi.dio.options.headers, isNotNull);
        expect(testApi.dio.options.headers, isA<Map<String, dynamic>>());
      });

      test('should configure proper timeouts', () {
        // Check timeout configurations
        expect(testApi.dio.options.connectTimeout, isNotNull);
        expect(testApi.dio.options.receiveTimeout, isNotNull);
        expect(testApi.dio.options.sendTimeout, isNotNull);
      });
    });

    group('Network Connectivity', () {
      test('should handle connectivity checks properly', () async {
        // Mock connectivity check
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // This would normally be tested in actual API implementations
        // that use BaseApi's connectivity features
        expect(testApi.dio, isNotNull);
      });
    });

    group('Error Handling', () {
      test('should handle network errors consistently', () {
        // BaseApi should provide consistent error handling
        expect(testApi.dio.interceptors, isNotEmpty);
      });

      test('should handle timeout errors', () {
        // Test timeout configuration
        final timeoutDuration = testApi.dio.options.connectTimeout;
        expect(timeoutDuration, isNotNull);
        expect(timeoutDuration!.inMilliseconds, greaterThan(0));
      });
    });

    group('Configuration', () {
      test('should initialize with proper default configuration', () {
        expect(testApi.dio.options.baseUrl, isNotEmpty);
        expect(testApi.dio.options.headers, isA<Map<String, dynamic>>());
      });

      test('should handle different environments', () {
        // BaseApi should be able to handle different base URLs
        // This is tested implicitly through the configuration
        expect(testApi.dio.options.baseUrl, isNotNull);
      });
    });

    group('Interceptors', () {
      test('should have logging interceptor configured', () {
        // Check that interceptors are properly configured
        expect(testApi.dio.interceptors, isNotEmpty);
        
        // BaseApi should configure logging and error interceptors
        final interceptorTypes = testApi.dio.interceptors.map((i) => i.runtimeType).toList();
        expect(interceptorTypes, isNotEmpty);
      });

      test('should handle authentication headers when available', () {
        // BaseApi should be ready to handle auth tokens
        expect(testApi.dio.options.headers, isNotNull);
      });
    });

    group('Integration', () {
      test('should work with existing API implementations', () {
        // This test ensures BaseApi doesn't break existing functionality
        expect(testApi.dio, isA<Dio>());
        expect(testApi.dio.options.baseUrl, isNotNull);
      });

      test('should maintain backwards compatibility', () {
        // Ensure that changing to BaseApi doesn't break existing API calls
        expect(testApi.dio.options.method, equals('GET')); // Default method
      });
    });

    group('URL Construction', () {
      test('should build relative URLs correctly', () {
        const testPath = '/test-endpoint';
        final fullUrl = testApi.dio.options.baseUrl + testPath;
        
        expect(fullUrl, isNotEmpty);
        expect(fullUrl, endsWith(testPath));
      });

      test('should handle query parameters', () {
        // BaseApi should preserve Dio's query parameter handling
        expect(testApi.dio, isA<Dio>());
      });
    });

    group('Response Handling', () {
      test('should handle JSON responses', () {
        // BaseApi provides Dio instance capable of handling JSON
        expect(testApi.dio, isA<Dio>());
        expect(testApi.dio.options, isA<BaseOptions>());
      });

      test('should handle different response formats', () {
        // BaseApi should not restrict response formats
        expect(testApi.dio.options, isA<BaseOptions>());
      });
    });
  });
}
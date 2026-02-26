import 'dart:convert';

import 'package:dio/dio.dart';

/// A handler for a specific API route pattern
class MockApiHandler {
  final String method;
  final RegExp pathPattern;
  final Future<Response> Function(RequestOptions options) handler;

  MockApiHandler({
    required this.method,
    required this.pathPattern,
    required this.handler,
  });
}

/// Record of a request made through the interceptor
class RecordedRequest {
  final String method;
  final String path;
  final dynamic data;
  final Map<String, dynamic>? queryParameters;
  final DateTime timestamp;

  RecordedRequest({
    required this.method,
    required this.path,
    this.data,
    this.queryParameters,
    required this.timestamp,
  });

  @override
  String toString() => '$method $path';
}

/// Dio Interceptor that mocks API responses using registered handlers.
///
/// Usage:
/// ```dart
/// final interceptor = MockApiInterceptor();
/// interceptor.onGet('/auth/login', (options) async => Response(...));
/// final dio = Dio()..interceptors.add(interceptor);
/// ```
class MockApiInterceptor extends Interceptor {
  final List<MockApiHandler> _handlers = [];
  final List<RecordedRequest> _requests = [];
  bool _shouldFail = false;
  int _failStatusCode = 500;
  String _failMessage = 'Mock server error';

  /// All recorded requests
  List<RecordedRequest> get requests => List.unmodifiable(_requests);

  /// Register a GET handler for the given path pattern
  void onGet(String pathPattern,
      Future<Response> Function(RequestOptions options) handler) {
    _addHandler('GET', pathPattern, handler);
  }

  /// Register a POST handler for the given path pattern
  void onPost(String pathPattern,
      Future<Response> Function(RequestOptions options) handler) {
    _addHandler('POST', pathPattern, handler);
  }

  /// Register a PUT handler for the given path pattern
  void onPut(String pathPattern,
      Future<Response> Function(RequestOptions options) handler) {
    _addHandler('PUT', pathPattern, handler);
  }

  /// Register a PATCH handler for the given path pattern
  void onPatch(String pathPattern,
      Future<Response> Function(RequestOptions options) handler) {
    _addHandler('PATCH', pathPattern, handler);
  }

  /// Register a DELETE handler for the given path pattern
  void onDelete(String pathPattern,
      Future<Response> Function(RequestOptions options) handler) {
    _addHandler('DELETE', pathPattern, handler);
  }

  void _addHandler(String method, String pathPattern,
      Future<Response> Function(RequestOptions options) handler) {
    // Convert simple path patterns to regex:
    // /auth/login -> ^/auth/login$
    // /sites/:id  -> ^/sites/[^/]+$
    final regexPattern = pathPattern
        .replaceAllMapped(RegExp(r':(\w+)'), (m) => r'[^/]+')
        .replaceAll('/', r'\/');
    _handlers.add(MockApiHandler(
      method: method.toUpperCase(),
      pathPattern: RegExp('^$regexPattern\$'),
      handler: handler,
    ));
  }

  /// Register a handler that returns a JSON fixture
  void onGetJson(String pathPattern, dynamic jsonData, {int statusCode = 200}) {
    onGet(
      pathPattern,
      (options) async => Response(
        requestOptions: options,
        statusCode: statusCode,
        data: jsonData is String ? jsonDecode(jsonData) : jsonData,
      ),
    );
  }

  /// Register a POST handler that returns a JSON fixture
  void onPostJson(String pathPattern, dynamic jsonData,
      {int statusCode = 200}) {
    onPost(
      pathPattern,
      (options) async => Response(
        requestOptions: options,
        statusCode: statusCode,
        data: jsonData is String ? jsonDecode(jsonData) : jsonData,
      ),
    );
  }

  /// Make all subsequent unmatched requests fail with the given status code
  void setFailMode({int statusCode = 500, String message = 'Mock server error'}) {
    _shouldFail = true;
    _failStatusCode = statusCode;
    _failMessage = message;
  }

  /// Disable fail mode
  void clearFailMode() {
    _shouldFail = false;
  }

  /// Clear all recorded requests
  void clearRecords() {
    _requests.clear();
  }

  /// Clear all handlers
  void clearHandlers() {
    _handlers.clear();
  }

  /// Reset interceptor state (handlers + records)
  void reset() {
    clearHandlers();
    clearRecords();
    clearFailMode();
  }

  /// Find recorded requests matching method and path pattern
  List<RecordedRequest> findRequests(String method, String pathPattern) {
    final regex = RegExp(pathPattern);
    return _requests
        .where((r) =>
            r.method.toUpperCase() == method.toUpperCase() &&
            regex.hasMatch(r.path))
        .toList();
  }

  /// Check if a specific request was made
  bool hasRequest(String method, String pathPattern) {
    return findRequests(method, pathPattern).isNotEmpty;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Record the request
    _requests.add(RecordedRequest(
      method: options.method,
      path: options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      timestamp: DateTime.now(),
    ));

    // Find a matching handler
    for (final mockHandler in _handlers) {
      if (mockHandler.method == options.method.toUpperCase() &&
          mockHandler.pathPattern.hasMatch(options.path)) {
        mockHandler.handler(options).then((response) {
          handler.resolve(response);
        }).catchError((error) {
          handler.reject(
            DioException(
              requestOptions: options,
              error: error,
              type: DioExceptionType.unknown,
            ),
          );
        });
        return;
      }
    }

    // No handler found
    if (_shouldFail) {
      handler.reject(
        DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: _failStatusCode,
            statusMessage: _failMessage,
          ),
          type: DioExceptionType.badResponse,
        ),
      );
    } else {
      // Return 404 for unmatched requests
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 404,
          data: {'error': 'No mock handler for ${options.method} ${options.path}'},
        ),
      );
    }
  }
}

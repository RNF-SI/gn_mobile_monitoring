import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';

/// Base class for all API implementations that provides a Dio instance
/// with dynamic URL resolution from Config
abstract class BaseApi {
  /// Optional injected Dio instance for testing
  final Dio? _injectedDio;

  /// Constructor allowing optional Dio injection
  BaseApi({Dio? dio}) : _injectedDio = dio;

  /// Creates a new Dio instance with the current API base URL
  /// This ensures that URL changes are reflected immediately
  Dio createDio({Duration? connectTimeout, Duration? receiveTimeout, Duration? sendTimeout}) {
    // Use injected Dio if available (for testing)
    if (_injectedDio != null) {
      return _injectedDio!;
    }

    return Dio(BaseOptions(
      baseUrl: Config.apiBase,
      connectTimeout: connectTimeout ?? const Duration(seconds: 60),
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 120),
      sendTimeout: sendTimeout ?? const Duration(seconds: 60),
    ));
  }

  /// Getter for quick access to a standard Dio instance
  Dio get dio => createDio();

  /// Getter for the current API base URL
  String get apiBase => Config.apiBase;
}
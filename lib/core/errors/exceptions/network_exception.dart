import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;
  final DioException? originalDioException;

  NetworkException(this.message, {this.originalDioException});

  /// Accès direct à la réponse du serveur si disponible
  String? get responseData => originalDioException?.response?.data?.toString();

  @override
  String toString() {
    return 'NetworkException: $message';
  }
}

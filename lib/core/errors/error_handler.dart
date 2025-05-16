import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';

/// Gestionnaire d'erreurs global pour l'application.
/// S'occupe de l'interception des erreurs non capturées et leur journalisation.
class ErrorHandler {
  final AppLogger _logger;
  
  ErrorHandler() : _logger = AppLogger();
  
  /// Initialiser tous les gestionnaires d'erreurs
  Future<void> initialize() async {
    // Initialiser le logger
    await _logger.initialize();
    
    // Capturer les erreurs Flutter
    FlutterError.onError = _handleFlutterError;
    
    // Capturer les erreurs asynchrones
    PlatformDispatcher.instance.onError = _handlePlatformError;
    
    // Capturer les erreurs d'isolate en mode debug
    if (kDebugMode) {
      Isolate.current.addErrorListener(RawReceivePort((pair) {
        final List<dynamic> errorAndStacktrace = pair;
        final error = errorAndStacktrace[0];
        final stackTrace = StackTrace.fromString(errorAndStacktrace[1]);
        _logger.e(
          'Isolate Error',
          tag: 'ISOLATE',
          error: error,
          stackTrace: stackTrace,
        );
      }).sendPort);
    }
    
    _logger.i('ErrorHandler initialized', tag: 'APP');
  }

  /// Gérer les erreurs Flutter UI
  void _handleFlutterError(FlutterErrorDetails details) {
    // Log l'erreur
    _logger.e(
      'Unhandled Flutter Error: ${details.exception}',
      tag: 'FLUTTER',
      error: details.exception,
      stackTrace: details.stack,
    );
    
    // Permettre à Flutter de gérer l'erreur
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  }

  /// Gérer les erreurs de plateforme
  bool _handlePlatformError(Object error, StackTrace stack) {
    // Log l'erreur
    _logger.e(
      'Platform Error',
      tag: 'PLATFORM',
      error: error,
      stackTrace: stack,
    );
    
    // Retourner true indique que l'erreur a été gérée
    // false permettrait à l'application de planter
    return true;
  }

  /// Wrapper pour exécuter une méthode avec gestion d'erreur
  Future<T> runWithErrorHandling<T>(
    Future<T> Function() function, {
    required String tag,
    required String errorMessage,
    required T defaultValue,
  }) async {
    try {
      return await function();
    } catch (e, stackTrace) {
      _logger.e(
        errorMessage,
        tag: tag,
        error: e,
        stackTrace: stackTrace,
      );
      return defaultValue;
    }
  }
}
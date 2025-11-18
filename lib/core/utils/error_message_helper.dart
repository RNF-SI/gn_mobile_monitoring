import 'package:dio/dio.dart';

/// Helper class pour analyser et formater les messages d'erreur de manière plus spécifique
class ErrorMessageHelper {
  
  /// Formate un message d'erreur selon son type
  static String formatError(String operation, dynamic error, {String? moduleCode}) {
    final String modulePrefix = moduleCode != null ? 'Module $moduleCode: ' : '';
    final ErrorType errorType = _detectErrorType(error);
    
    switch (errorType) {
      case ErrorType.network:
        return '${modulePrefix}Erreur réseau lors de $operation: ${_getNetworkErrorMessage(error)}';
      
      case ErrorType.server:
        return '${modulePrefix}Erreur serveur lors de $operation: ${_getServerErrorMessage(error)}';
      
      case ErrorType.timeout:
        return '${modulePrefix}Timeout lors de $operation: Le serveur met trop de temps à répondre';
      
      case ErrorType.dns:
        return '${modulePrefix}Erreur DNS lors de $operation: ${_getDnsErrorMessage(error)}';
      
      case ErrorType.parsing:
        return '${modulePrefix}Erreur de données lors de $operation: ${_getParsingErrorMessage(error)}';
      
      case ErrorType.permission:
        return '${modulePrefix}Erreur d\'autorisation lors de $operation: ${_getPermissionErrorMessage(error)}';
      
      case ErrorType.unknown:
        return '${modulePrefix}Erreur lors de $operation: ${error.toString()}';
    }
  }
  
  /// Détecte le type d'erreur en analysant l'exception
  static ErrorType _detectErrorType(dynamic error) {
    final String errorString = error.toString().toLowerCase();
    
    // Erreurs DNS
    if (errorString.contains('failed host lookup') || 
        errorString.contains('nodename nor servname provided') ||
        errorString.contains('temporary failure in name resolution')) {
      return ErrorType.dns;
    }
    
    // Erreurs de timeout
    if (errorString.contains('timeout') || 
        errorString.contains('timed out') ||
        errorString.contains('deadline exceeded')) {
      return ErrorType.timeout;
    }
    
    // Erreurs de permission/authentification
    if (errorString.contains('401') || 
        errorString.contains('unauthorized') ||
        errorString.contains('403') ||
        errorString.contains('forbidden')) {
      return ErrorType.permission;
    }
    
    // Erreurs serveur
    if (errorString.contains('500') || 
        errorString.contains('502') ||
        errorString.contains('503') ||
        errorString.contains('504') ||
        errorString.contains('internal server error')) {
      return ErrorType.server;
    }
    
    // Erreurs de parsing JSON
    if (errorString.contains('json') || 
        errorString.contains('parsing') ||
        errorString.contains('invalid format') ||
        errorString.contains('unexpected character')) {
      return ErrorType.parsing;
    }
    
    // Erreurs réseau générales
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return ErrorType.timeout;
        case DioExceptionType.connectionError:
          return ErrorType.network;
        case DioExceptionType.badResponse:
          return ErrorType.server;
        default:
          return ErrorType.network;
      }
    }
    
    if (errorString.contains('network') || 
        errorString.contains('connection') ||
        errorString.contains('socket')) {
      return ErrorType.network;
    }
    
    return ErrorType.unknown;
  }
  
  static String _getNetworkErrorMessage(dynamic error) {
    if (error is DioException && error.message != null) {
      return 'Problème de connexion réseau (${error.message})';
    }
    return 'Problème de connexion réseau';
  }
  
  static String _getServerErrorMessage(dynamic error) {
    if (error is DioException && error.response?.statusCode != null) {
      final statusCode = error.response!.statusCode!;
      switch (statusCode) {
        case 500:
          return 'Erreur interne du serveur (500)';
        case 502:
          return 'Serveur indisponible (502)';
        case 503:
          return 'Service temporairement indisponible (503)';
        case 504:
          return 'Timeout du serveur (504)';
        default:
          return 'Erreur serveur ($statusCode)';
      }
    }
    return 'Erreur du serveur';
  }
  
  static String _getDnsErrorMessage(dynamic error) {
    final String errorString = error.toString();
    if (errorString.contains('failed host lookup')) {
      final match = RegExp(r"'([^']+)'").firstMatch(errorString);
      final hostname = match?.group(1) ?? 'serveur';
      return 'Impossible de résoudre l\'adresse du serveur ($hostname). Vérifiez votre connexion Internet.';
    }
    return 'Problème de résolution DNS. Vérifiez votre connexion Internet.';
  }
  
  static String _getParsingErrorMessage(dynamic error) {
    return 'Format de données invalide reçu du serveur';
  }
  
  static String _getPermissionErrorMessage(dynamic error) {
    if (error.toString().contains('401')) {
      return 'Token d\'authentification expiré ou invalide';
    }
    if (error.toString().contains('403')) {
      return 'Permissions insuffisantes pour cette opération';
    }
    return 'Problème d\'autorisation';
  }
  
  /// Suggère une action à effectuer selon le type d'erreur
  static String? getSuggestion(ErrorType errorType) {
    switch (errorType) {
      case ErrorType.dns:
        return 'Vérifiez votre connexion Internet et réessayez.';
      case ErrorType.network:
        return 'Vérifiez votre connexion réseau et réessayez.';
      case ErrorType.timeout:
        return 'Le serveur est lent. Réessayez dans quelques instants.';
      case ErrorType.server:
        return 'Problème côté serveur. Réessayez plus tard.';
      case ErrorType.permission:
        return 'Reconnectez-vous ou contactez l\'administrateur.';
      case ErrorType.parsing:
        return 'Problème avec les données reçues. Contactez le support.';
      case ErrorType.unknown:
        return 'Réessayez ou contactez le support si le problème persiste.';
    }
  }
}

enum ErrorType {
  network,
  server,
  timeout,
  dns,
  parsing,
  permission,
  unknown,
}
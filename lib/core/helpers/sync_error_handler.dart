import 'package:gn_mobile_monitoring/core/helpers/string_formatter.dart';

/// Helper pour la gestion et le formatage des erreurs de synchronisation
class SyncErrorHandler {
  /// Extrait des informations détaillées d'une erreur pour faciliter le débogage
  static String extractDetailedError(
      dynamic error, String entityType, int entityId) {
    String baseMessage = '${entityType.capitalize()} $entityId: ';
    String errorStr = error.toString();

    // Extraire les informations spécifiques selon le type d'erreur
    if (errorStr.contains('psycopg2.errors') ||
        errorStr.contains('CheckViolation') ||
        errorStr.contains('constraint') ||
        errorStr.contains('Constraint')) {
      return '$baseMessage${_formatConstraintError(errorStr)}';
    } else if (errorStr.contains('500')) {
      return '$baseMessage${_formatServerError(errorStr)}';
    } else if (errorStr.contains('400')) {
      return '$baseMessage${_formatValidationError(errorStr)}';
    } else if (errorStr.contains('timeout')) {
      return '$baseMessage${_formatTimeoutError()}';
    } else if (errorStr.contains('permission') || errorStr.contains('403')) {
      return '$baseMessage${_formatPermissionError()}';
    } else if (errorStr.contains('NetworkException')) {
      return '$baseMessage${_formatNetworkError(errorStr)}';
    } else {
      // Erreur générique, mais préserver les détails techniques PostgreSQL
      if (errorStr.contains('ERREUR:') ||
          errorStr.contains('DÉTAIL :') ||
          errorStr.contains('CONTEXTE :') ||
          errorStr.contains('sqlalchemy')) {
        return '$baseMessage$errorStr';
      }

      // Autres erreurs génériques
      String message = errorStr;
      if (message.length > 200) {
        message = '${message.substring(0, 200)}...';
      }
      return '$baseMessage$message';
    }
  }

  /// Formate une erreur de contrainte de base de données
  static String _formatConstraintError(String error) {
    if (error.contains('unique')) {
      return 'Données en conflit - Cet élément existe déjà sur le serveur.\nDétails techniques: $error';
    } else if (error.contains('foreign key') || error.contains('fkey')) {
      return 'Référence invalide - Un ID référencé n\'existe pas sur le serveur.\nDétails techniques: $error';
    } else {
      return 'Erreur de validation des données - Contrainte de base de données violée.\nDétails techniques: $error';
    }
  }

  /// Formate une erreur serveur 500
  static String _formatServerError(String error) {
    if (error.contains('synthese')) {
      return 'Erreur de synthèse - Problème lors de l\'intégration des données dans la synthèse.\nDétails techniques: $error';
    } else {
      return 'Erreur interne du serveur - Contactez l\'administrateur.\nDétails techniques: $error';
    }
  }

  /// Formate une erreur de validation 400
  static String _formatValidationError(String error) {
    if (error.contains('required') || error.contains('requis')) {
      return 'Champs obligatoires manquants - Vérifiez que toutes les données requises sont remplies.\nDétails techniques: $error';
    } else {
      return 'Données invalides - Vérifiez le format et le contenu des données.\nDétails techniques: $error';
    }
  }

  /// Formate une erreur de timeout
  static String _formatTimeoutError() {
    return 'Timeout de connexion - Vérifiez votre connexion Internet et réessayez.';
  }

  /// Formate une erreur de permissions
  static String _formatPermissionError() {
    return 'Permissions insuffisantes - Contactez votre administrateur pour obtenir les droits nécessaires.';
  }

  /// Formate une erreur réseau qui wrappe souvent d'autres erreurs
  static String _formatNetworkError(String error) {
    if (error.contains('500')) {
      return 'Erreur interne du serveur - Problème de traitement des données.';
    } else {
      return 'Erreur de communication avec le serveur - Vérifiez votre connexion.';
    }
  }

  /// Détermine si une erreur est fatale et nécessite la suppression locale de l'élément
  /// pour éviter les boucles infinies de synchronisation
  static bool isFatalError(dynamic error) {
    String errorString = error.toString().toLowerCase();

    // Si c'est une NetworkException, extraire le message interne
    if (error.toString().contains('NetworkException')) {
      errorString = error.toString().toLowerCase();
    }

    // Erreurs de contraintes de base de données qui ne peuvent pas être résolues par retry
    final fatalPatterns = [
      'checkviolation',
      'check violation',
      'constraint violation',
      'foreign key constraint',
      'unique constraint',
      'not null constraint',
      'duplicate key',
      'violates unique constraint',
      'violates foreign key constraint',
      'violates check constraint',
      'psycopg2.errors.checkviolation',
      'integrityerror',
      'integrity error',
    ];

    return fatalPatterns.any((pattern) => errorString.contains(pattern));
  }
}

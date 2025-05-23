import 'dart:math';

import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';

/// Types d'erreurs que nous pouvons simuler
enum ErrorType {
  none, // Aucune erreur
  missingCdNom, // ❌ Espèce manquante (champ requis)
  invalidVisitId, // ❌ ID de visite inexistant (99999)
  invalidDataTypes, // ❌ Types de données incorrects (string au lieu d'int)
  malformedJson, // ❌ JSON invalide
  permissionDenied, // ❌ Permissions insuffisantes (403)
  duplicateUuid, // ❌ UUID déjà existant (409)
  serverTimeout, // ❌ Timeout du serveur
  moduleInactive, // ❌ Module inexistant/inactif
}

/// Simulateur d'erreurs pour tester la synchronisation ascendante
/// Permet de simuler différents types d'erreurs de serveur
///
/// 🔧 Configuration rapide pour les tests :
/// - Changez _enableErrorSimulation à true/false
/// - Changez _currentErrorType pour le type d'erreur souhaité
/// - Ajustez _errorProbability pour la fréquence (0-100%)
class SyncErrorSimulator {
  // 🔧 CONFIGURATION DES TESTS - Modifiez ces valeurs pour tester
  static const bool _enableErrorSimulation =
      false; // ⚠️ ATTENTION: Activer seulement pour les tests
  static const ErrorType _currentErrorType =
      ErrorType.missingCdNom; // Type d'erreur à simuler
  static const int _errorProbability = 100; // Probabilité d'erreur (0-100%)

  /// Vérifie si une erreur doit être simulée
  static bool shouldSimulateError() {
    if (!_enableErrorSimulation || _currentErrorType == ErrorType.none) {
      return false;
    }

    final random = Random();
    return random.nextInt(100) < _errorProbability;
  }

  /// Modifie les données d'observation pour provoquer une erreur
  static Observation? corruptObservationData(Observation observation) {
    if (!shouldSimulateError()) return observation;

    switch (_currentErrorType) {
      case ErrorType.none:
        return observation;

      case ErrorType.missingCdNom:
        // Supprimer le cd_nom (espèce obligatoire)
        return observation.copyWith(
          cdNom: null,
        );

      case ErrorType.invalidVisitId:
        // Utiliser un ID de visite inexistant
        return observation.copyWith(
          idBaseVisit: 99999,
        );

      case ErrorType.invalidDataTypes:
        // Les types incorrects seront gérés dans corruptRequestBody
        return observation;

      case ErrorType.duplicateUuid:
        // Utiliser un UUID fixe pour provoquer un conflit
        return observation.copyWith(
          uuidObservation: 'duplicate-uuid-12345',
        );

      default:
        return observation;
    }
  }

  /// Modifie le corps de la requête pour provoquer une erreur
  static Map<String, dynamic> corruptRequestBody(
      Map<String, dynamic> requestBody) {
    if (!shouldSimulateError()) return requestBody;

    switch (_currentErrorType) {
      case ErrorType.none:
        return requestBody;

      case ErrorType.invalidDataTypes:
        // Corrompre les types de données
        final properties =
            Map<String, dynamic>.from(requestBody['properties'] ?? {});
        if (properties.containsKey('cd_nom')) {
          properties['cd_nom'] = 'texte_au_lieu_de_nombre';
        }
        if (properties.containsKey('id_base_visit')) {
          properties['id_base_visit'] = 'texte_au_lieu_de_nombre';
        }
        return {
          ...requestBody,
          'properties': properties,
        };

      case ErrorType.malformedJson:
        // Créer un JSON invalide (on simule en ajoutant un champ problématique)
        return {
          ...requestBody,
          'invalid_json': '"unclosed_string',
        };

      default:
        return requestBody;
    }
  }

  /// Lance une exception spécifique selon le type d'erreur
  static void throwSimulatedError() {
    if (!shouldSimulateError()) return;

    switch (_currentErrorType) {
      case ErrorType.none:
        return;

      case ErrorType.permissionDenied:
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 403,
            data: {
              'detail':
                  'Permissions insuffisantes: CRUVED "C" requis sur les observations'
            },
          ),
        );

      case ErrorType.serverTimeout:
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.receiveTimeout,
          message: 'Timeout lors de l\'envoi de l\'observation',
        );

      case ErrorType.moduleInactive:
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: {'detail': 'Module inexistant ou inactif'},
          ),
        );

      case ErrorType.missingCdNom:
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: {
              'detail': 'Champ requis manquant: cd_nom (espèce obligatoire)'
            },
          ),
        );

      case ErrorType.invalidVisitId:
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: {
              'detail':
                  'Clé étrangère invalide: id_base_visit=99999 n\'existe pas'
            },
          ),
        );

      case ErrorType.invalidDataTypes:
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: {
              'detail': 'Type de données incorrect: cd_nom doit être un entier'
            },
          ),
        );

      case ErrorType.malformedJson:
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: {'detail': 'JSON malformé: erreur de syntaxe'},
          ),
        );

      case ErrorType.duplicateUuid:
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 409,
            data: {'detail': 'Violation d\'unicité: UUID déjà existant'},
          ),
        );
    }
  }

  /// Retourne une description du type d'erreur actuel
  static String getErrorDescription() {
    switch (_currentErrorType) {
      case ErrorType.none:
        return 'Aucune erreur';
      case ErrorType.missingCdNom:
        return 'Champ cd_nom manquant (espèce obligatoire)';
      case ErrorType.invalidVisitId:
        return 'ID de visite inexistant (99999)';
      case ErrorType.invalidDataTypes:
        return 'Types de données incorrects (string au lieu d\'int)';
      case ErrorType.malformedJson:
        return 'JSON malformé avec syntaxe invalide';
      case ErrorType.permissionDenied:
        return 'Permissions insuffisantes (403)';
      case ErrorType.duplicateUuid:
        return 'UUID déjà existant (conflit)';
      case ErrorType.serverTimeout:
        return 'Timeout du serveur';
      case ErrorType.moduleInactive:
        return 'Module inexistant ou inactif';
    }
  }

  /// Retourne le type d'erreur actuellement actif
  static ErrorType get currentErrorType => _currentErrorType;

  /// Retourne la probabilité d'erreur actuelle
  static int get errorProbability => _errorProbability;

  /// Retourne si la simulation est activée
  static bool get isEnabled => _enableErrorSimulation;
}

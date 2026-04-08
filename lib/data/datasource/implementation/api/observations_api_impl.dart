import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/core/errors/sync_error_simulator.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/base_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/observations_api.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';

class ObservationsApiImpl extends BaseApi implements ObservationsApi {
  final Connectivity _connectivity;
  final Dio? _dio;

  ObservationsApiImpl({Connectivity? connectivity, Dio? dio})
        : _connectivity = connectivity ?? Connectivity(),
          _dio = dio;

  @override
  Dio get dio => _dio ?? super.dio;

  @override
  Future<Map<String, dynamic>> sendObservation(
      String token, String moduleCode, Observation observation) async {
    try {
      // Importer AppLogger et créer l'instance
      final logger = AppLogger();

      // 🧪 SIMULATION D'ERREURS POUR TESTS
      if (SyncErrorSimulator.isEnabled) {
        logger.i('[TEST] Simulation d\'erreurs activée: ${SyncErrorSimulator.getErrorDescription()}', tag: 'sync');
        
        // Vérifier si on doit simuler une erreur avant traitement
        SyncErrorSimulator.throwSimulatedError();
        
        // Corrompre l'observation si nécessaire
        final corruptedObservation = SyncErrorSimulator.corruptObservationData(observation);
        if (corruptedObservation != null) {
          observation = corruptedObservation;
          logger.w('[TEST] Données d\'observation corrompues pour simulation', tag: 'sync');
        }
      }

      // Vérifier la connectivité
      final connectivityResults = await _connectivity.checkConnectivity();
      if (connectivityResults.contains(ConnectivityResult.none) || connectivityResults.isEmpty) {
        logger.e('[API] ERREUR RÉSEAU: Aucune connexion Internet disponible',
            tag: 'sync');
        throw NetworkException('Aucune connexion réseau disponible');
      }


      // Préparer le corps de la requête selon le format attendu par l'API
      // Selon le backend: le format attendu est
      // {
      //    "properties": {
      //      "id_module": "...",  <-- Cette propriété est nécessaire
      //      ... autres propriétés
      //    }
      // }
      Map<String, dynamic> requestBody = {
        'properties': <String, dynamic>{
          // Assurer que id_base_visit est bien un entier
          'id_base_visit': observation.idBaseVisit != null
              ? int.parse(observation.idBaseVisit.toString())
              : null,
        },
      };

      // Ajouter l'UUID s'il est disponible (toujours inclure cette donnée importante pour tous les modules)
      // Mais gérer ce champ différemment car il semble causer des problèmes de type
      if (observation.uuidObservation != null) {
        // Au lieu d'ajouter directement à properties, l'ajouter au niveau supérieur du requestBody
        // pour éviter les conflits de type dans la section properties
        requestBody['uuid_observation'] = observation.uuidObservation;

        // Ajouter un log pour déboguer
        debugPrint(
            'UUID observation ajouté au niveau supérieur: ${observation.uuidObservation}');
      }

      // Ajouter le module_code dans un champ séparé du corps de la requête
      // Plutôt que comme une propriété directe qui cause un conflit de type
      debugPrint('Utilisation du moduleCode pour l\'observation: $moduleCode');
      // Ajouter module_code au niveau supérieur du corps de la requête
      requestBody['module_code'] = moduleCode;

      // Ajouter le cd_nom s'il est disponible
      if (observation.cdNom != null) {
        // S'assurer que cd_nom est bien un entier
        requestBody['properties']['cd_nom'] =
            int.parse(observation.cdNom.toString());
      }

      // Ajouter les commentaires s'ils sont disponibles
      if (observation.comments != null) {
        requestBody['properties']['comments'] = observation.comments;
      }

      // Ajouter l'id_digitiser s'il est disponible
      if (observation.idDigitiser != null) {
        requestBody['properties']['id_digitiser'] = observation.idDigitiser;
      }

      // Ajouter les données complémentaires si disponibles
      // En utilisant une approche itérative pour éviter les problèmes de type
      if (observation.data != null && observation.data!.isNotEmpty) {
        // Ajouter les données complémentaires directement dans properties
        // car c'est là que l'API GeoNature s'attend à les trouver
        final properties = requestBody['properties'] as Map<String, dynamic>;

        // Copier manuellement chaque entrée en convertissant les types si nécessaire
        observation.data!.forEach((key, value) {
          // Pour les champs qui commencent par 'id_' et qui peuvent être des entiers
          if (key.startsWith('id_') && value is String) {
            // Essayer de convertir en entier si c'est une chaîne numérique
            int? intValue = int.tryParse(value);
            if (intValue != null) {
              properties[key] = intValue;
              debugPrint(
                  'Conversion de $key: $value (String) -> $intValue (int)');
            } else {
              properties[key] = value;
            }
          } else if (key == 'cd_nom') {
            // Cas spécial pour cd_nom qui doit être un entier
            if (value is int) {
              properties[key] = value;
            } else if (value is String) {
              int? intValue = int.tryParse(value);
              if (intValue != null) {
                properties[key] = intValue;
                debugPrint(
                    'Conversion de cd_nom: $value (String) -> $intValue (int)');
              }
            } else if (value is Map<String, dynamic> &&
                value.containsKey('cd_nom')) {
              // Extraire cd_nom depuis un objet taxon complet
              final cdNom = value['cd_nom'];
              properties[key] = cdNom is int
                  ? cdNom
                  : int.tryParse(cdNom.toString());
              debugPrint(
                  'Extraction de cd_nom depuis Map: ${properties[key]}');
            }
          } else {
            // Conserver la valeur telle quelle pour les autres cas
            properties[key] = value;
          }
        });

        debugPrint('Données complémentaires ajoutées dans properties: $properties');
      }

      // 🧪 SIMULATION D'ERREURS POUR TESTS - Corrompre le body de la requête
      if (SyncErrorSimulator.isEnabled) {
        requestBody = SyncErrorSimulator.corruptRequestBody(requestBody);
        logger.w('[TEST] Corps de requête potentiellement corrompu pour simulation', tag: 'sync');
      }

      // Log détaillé pour le débogage
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln('[API] ENVOI OBSERVATION AU SERVEUR');
      if (SyncErrorSimulator.isEnabled) {
        logBuffer.writeln('[🧪 MODE TEST] ${SyncErrorSimulator.getErrorDescription()}');
      }
      logBuffer.writeln(
          '==================================================================');
      logBuffer
          .writeln('URL: $apiBase/monitorings/object/$moduleCode/observation');
      logBuffer.writeln('MÉTHODE: POST');

      // Afficher de façon sécurisée le token (juste les premiers caractères)
      if (token.length > 10) {
        logBuffer.writeln(
            'HEADERS: Authorization: Bearer ${token.substring(0, 10)}...[MASQUÉ]');
      } else {
        logBuffer.writeln('HEADERS: Authorization: Bearer [MASQUÉ]');
      }

      logBuffer.writeln('BODY:');
      logBuffer.writeln(
          '------------------------------------------------------------------');
      logBuffer.writeln(JsonEncoder.withIndent('  ').convert(requestBody));

      // Écrire dans le fichier log via AppLogger
      logger.i(logBuffer.toString(), tag: 'sync');

      String endpoint = '/monitorings/object/$moduleCode/observation';

      // Envoyer la requête
      final response = await dio.post(
        endpoint,
        data: requestBody,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          // Augmenter les timeouts pour éviter les erreurs ETIMEDOUT
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      // Log de la réponse
      logBuffer = StringBuffer();
      logBuffer.writeln('\n[API] RÉPONSE SERVEUR (${response.statusCode})');
      logBuffer.writeln(
          '------------------------------------------------------------------');
      if (response.data is Map || response.data is List) {
        logBuffer.writeln(JsonEncoder.withIndent('  ').convert(response.data));
      } else {
        logBuffer.writeln(response.data.toString());
      }
      logBuffer.writeln(
          '==================================================================');

      // Écrire dans le fichier log via AppLogger
      logger.i(logBuffer.toString(), tag: 'sync');

      if (response.statusCode == 201 || response.statusCode == 200) {
        logger.i('Observation envoyée avec succès: ${response.data}',
            tag: 'sync');
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
            'Erreur lors de l\'envoi de l\'observation. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Importer AppLogger et créer l'instance
      final logger = AppLogger();

      // Log détaillé pour le débogage Dio
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln('[API] ERREUR DIO LORS DE L\'ENVOI DE L\'OBSERVATION');
      logBuffer.writeln(
          '==================================================================');
      logBuffer.writeln('Type: ${e.type}');
      logBuffer.writeln('Message: ${e.message}');
      logBuffer.writeln('URL: ${e.requestOptions.uri}');
      logBuffer.writeln('Méthode: ${e.requestOptions.method}');

      if (e.response != null) {
        logBuffer.writeln('\nRÉPONSE ERREUR:');
        logBuffer.writeln('Status code: ${e.response?.statusCode}');
        if (e.response?.data != null) {
          if (e.response?.data is Map || e.response?.data is List) {
            logBuffer.writeln(
                const JsonEncoder.withIndent('  ').convert(e.response?.data));
          } else {
            logBuffer.writeln(e.response?.data.toString());
          }
        }
      }

      logBuffer.writeln('\nREQUEST OPTIONS:');
      logBuffer.writeln('Connect timeout: ${e.requestOptions.connectTimeout}');
      logBuffer.writeln('Receive timeout: ${e.requestOptions.receiveTimeout}');
      logBuffer.writeln('Send timeout: ${e.requestOptions.sendTimeout}');
      logBuffer.writeln(
          '==================================================================');

      // Écrire dans le fichier log via AppLogger
      logger.e(logBuffer.toString(), tag: 'sync', error: e);

      throw NetworkException(
          'Erreur réseau lors de l\'envoi de l\'observation: ${e.message}',
          originalDioException: e);
    } catch (e, stackTrace) {
      // Importer AppLogger et créer l'instance
      final logger = AppLogger();

      // Log détaillé pour le débogage général
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer
          .writeln('[API] ERREUR GÉNÉRALE LORS DE L\'ENVOI DE L\'OBSERVATION');
      logBuffer.writeln(
          '==================================================================');
      logBuffer.writeln('Type: ${e.runtimeType}');
      logBuffer.writeln('Message: $e');
      logBuffer.writeln('\nSTACK TRACE:');
      logBuffer.writeln(stackTrace);
      logBuffer.writeln(
          '==================================================================');

      // Écrire dans le fichier log via AppLogger
      logger.e(logBuffer.toString(),
          tag: 'sync', error: e, stackTrace: stackTrace);

      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateObservation(
      String token, String moduleCode, int observationId, Observation observation) async {
    try {
      // Importer AppLogger et créer l'instance
      final logger = AppLogger();

      // 🧪 SIMULATION D'ERREURS POUR TESTS
      if (SyncErrorSimulator.isEnabled) {
        logger.i('[TEST] Simulation d\'erreurs activée: ${SyncErrorSimulator.getErrorDescription()}', tag: 'sync');
        
        // Vérifier si on doit simuler une erreur avant traitement
        SyncErrorSimulator.throwSimulatedError();
        
        // Corrompre l'observation si nécessaire
        final corruptedObservation = SyncErrorSimulator.corruptObservationData(observation);
        if (corruptedObservation != null) {
          observation = corruptedObservation;
          logger.w('[TEST] Données d\'observation corrompues pour simulation', tag: 'sync');
        }
      }

      // Vérifier la connectivité
      final connectivityResults = await _connectivity.checkConnectivity();
      if (connectivityResults.contains(ConnectivityResult.none) || connectivityResults.isEmpty) {
        logger.e('[API] ERREUR RÉSEAU: Aucune connexion Internet disponible',
            tag: 'sync');
        throw NetworkException('Aucune connexion réseau disponible');
      }

      // Préparer le corps de la requête comme pour sendObservation
      Map<String, dynamic> requestBody = {
        'properties': <String, dynamic>{
          'id_base_visit': observation.idBaseVisit != null
              ? int.parse(observation.idBaseVisit.toString())
              : null,
        },
      };

      if (observation.uuidObservation != null) {
        requestBody['uuid_observation'] = observation.uuidObservation;
      }

      requestBody['module_code'] = moduleCode;

      if (observation.cdNom != null) {
        requestBody['properties']['cd_nom'] =
            int.parse(observation.cdNom.toString());
      }

      if (observation.comments != null) {
        requestBody['properties']['comments'] = observation.comments;
      }

      // Ajouter l'id_digitiser s'il est disponible
      if (observation.idDigitiser != null) {
        requestBody['properties']['id_digitiser'] = observation.idDigitiser;
      }

      if (observation.data != null && observation.data!.isNotEmpty) {
        final properties = requestBody['properties'] as Map<String, dynamic>;

        observation.data!.forEach((key, value) {
          if (key.startsWith('id_') && value is String) {
            int? intValue = int.tryParse(value);
            if (intValue != null) {
              properties[key] = intValue;
            } else {
              properties[key] = value;
            }
          } else if (key == 'cd_nom') {
            // Cas spécial pour cd_nom qui doit être un entier
            if (value is int) {
              properties[key] = value;
            } else if (value is String) {
              int? intValue = int.tryParse(value);
              if (intValue != null) {
                properties[key] = intValue;
              }
            } else if (value is Map<String, dynamic> &&
                value.containsKey('cd_nom')) {
              final cdNom = value['cd_nom'];
              properties[key] = cdNom is int
                  ? cdNom
                  : int.tryParse(cdNom.toString());
            }
          } else {
            properties[key] = value;
          }
        });
      }

      // 🧪 SIMULATION D'ERREURS POUR TESTS
      if (SyncErrorSimulator.isEnabled) {
        requestBody = SyncErrorSimulator.corruptRequestBody(requestBody);
        logger.w('[TEST] Corps de requête potentiellement corrompu pour simulation', tag: 'sync');
      }

      // Log détaillé pour le débogage
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln('\n==================================================================');
      logBuffer.writeln('[API] MISE À JOUR OBSERVATION SUR LE SERVEUR (PATCH)');
      if (SyncErrorSimulator.isEnabled) {
        logBuffer.writeln('[🧪 MODE TEST] ${SyncErrorSimulator.getErrorDescription()}');
      }
      logBuffer.writeln('==================================================================');
      logBuffer.writeln('URL: $apiBase/monitorings/object/$moduleCode/observation/$observationId');
      logBuffer.writeln('MÉTHODE: PATCH');

      if (token.length > 10) {
        logBuffer.writeln('HEADERS: Authorization: Bearer ${token.substring(0, 10)}...[MASQUÉ]');
      } else {
        logBuffer.writeln('HEADERS: Authorization: Bearer [MASQUÉ]');
      }

      logBuffer.writeln('BODY:');
      logBuffer.writeln('------------------------------------------------------------------');
      logBuffer.writeln(JsonEncoder.withIndent('  ').convert(requestBody));

      logger.i(logBuffer.toString(), tag: 'sync');

      String endpoint = '/monitorings/object/$moduleCode/observation/$observationId';

      // Envoyer la requête PATCH
      final response = await dio.patch(
        endpoint,
        data: requestBody,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      // Log de la réponse
      logBuffer = StringBuffer();
      logBuffer.writeln('\n[API] RÉPONSE SERVEUR (${response.statusCode})');
      logBuffer.writeln('------------------------------------------------------------------');
      if (response.data is Map || response.data is List) {
        logBuffer.writeln(JsonEncoder.withIndent('  ').convert(response.data));
      } else {
        logBuffer.writeln(response.data.toString());
      }
      logBuffer.writeln('==================================================================');

      logger.i(logBuffer.toString(), tag: 'sync');

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i('Observation mise à jour avec succès: ${response.data}', tag: 'sync');
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Erreur lors de la mise à jour de l\'observation. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final logger = AppLogger();

      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln('\n==================================================================');
      logBuffer.writeln('[API] ERREUR DIO LORS DE LA MISE À JOUR DE L\'OBSERVATION');
      logBuffer.writeln('==================================================================');
      logBuffer.writeln('Type: ${e.type}');
      logBuffer.writeln('Message: ${e.message}');
      logBuffer.writeln('URL: ${e.requestOptions.uri}');
      logBuffer.writeln('Méthode: ${e.requestOptions.method}');

      if (e.response != null) {
        logBuffer.writeln('\nRÉPONSE ERREUR:');
        logBuffer.writeln('Status code: ${e.response?.statusCode}');
        if (e.response?.data != null) {
          if (e.response?.data is Map || e.response?.data is List) {
            logBuffer.writeln(const JsonEncoder.withIndent('  ').convert(e.response?.data));
          } else {
            logBuffer.writeln(e.response?.data.toString());
          }
        }
      }

      logBuffer.writeln('\nREQUEST OPTIONS:');
      logBuffer.writeln('Connect timeout: ${e.requestOptions.connectTimeout}');
      logBuffer.writeln('Receive timeout: ${e.requestOptions.receiveTimeout}');
      logBuffer.writeln('Send timeout: ${e.requestOptions.sendTimeout}');
      logBuffer.writeln('==================================================================');

      logger.e(logBuffer.toString(), tag: 'sync', error: e);

      throw NetworkException('Erreur réseau lors de la mise à jour de l\'observation: ${e.message}', originalDioException: e);
    } catch (e, stackTrace) {
      final logger = AppLogger();

      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln('\n==================================================================');
      logBuffer.writeln('[API] ERREUR GÉNÉRALE LORS DE LA MISE À JOUR DE L\'OBSERVATION');
      logBuffer.writeln('==================================================================');
      logBuffer.writeln('Type: ${e.runtimeType}');
      logBuffer.writeln('Message: $e');
      logBuffer.writeln('\nSTACK TRACE:');
      logBuffer.writeln(stackTrace);
      logBuffer.writeln('==================================================================');

      logger.e(logBuffer.toString(), tag: 'sync', error: e, stackTrace: stackTrace);

      rethrow;
    }
  }
}
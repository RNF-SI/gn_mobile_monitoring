import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/observation_details_api.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';

class ObservationDetailsApiImpl implements ObservationDetailsApi {
  final Dio _dio;
  final String apiBase = Config.apiBase;
  final Connectivity _connectivity;

  ObservationDetailsApiImpl({Dio? dio, Connectivity? connectivity})
      : _dio = dio ?? Dio(BaseOptions(
          baseUrl: Config.apiBase,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 180), // 3 minutes
          sendTimeout: const Duration(seconds: 60),
        )),
        _connectivity = connectivity ?? Connectivity();

  @override
  Future<Map<String, dynamic>> sendObservationDetail(
      String token, String moduleCode, ObservationDetail detail) async {
    try {
      // Importer AppLogger et créer l'instance
      final logger = AppLogger();

      // Vérifier la connectivité
      final connectivityResults = await _connectivity.checkConnectivity();
      if (connectivityResults.contains(ConnectivityResult.none) || connectivityResults.isEmpty) {
        logger.e('[API] ERREUR RÉSEAU: Aucune connexion Internet disponible',
            tag: 'sync');
        throw NetworkException('Aucune connexion réseau disponible');
      }

      // Vérifier que l'ID de l'observation est présent
      if (detail.idObservation == null) {
        logger.e(
            '[API] ERREUR: id_observation manquant pour le détail d\'observation',
            tag: 'sync');
        throw ArgumentError(
            'L\'ID de l\'observation est requis pour envoyer un détail d\'observation');
      }

      // Préparer le corps de la requête selon le format attendu par l'API
      // D'après l'analyse de la réponse serveur, les données devraient être dans properties
      // {
      //    "properties": {
      //      "id_observation": "...",
      //      "hauteur_strate": "...",
      //      "denombrement": "...",
      //      ... autres propriétés
      //    }
      // }

      // Imprimer le type d'idObservation pour le diagnostic
      logger.i('Type de idObservation: ${detail.idObservation.runtimeType}',
          tag: 'sync');

      // Créer un nouveau Map avec les bonnes contraintes de type
      final Map<String, dynamic> properties = {};
      // Ajouter l'ID d'observation manuellement
      properties['id_observation'] = detail.idObservation;

      // Créer la structure complète du requestBody
      final Map<String, dynamic> requestBody = {
        'properties': properties,
        'module_code': moduleCode,
      };

      // Log détaillé pour examiner l'objet detail
      logger.i('Examen de l\'objet ObservationDetail:', tag: 'sync');
      logger.i('  - idObservationDetail: ${detail.idObservationDetail}',
          tag: 'sync');
      logger.i('  - idObservation: ${detail.idObservation}', tag: 'sync');
      logger.i('  - idModule: ${detail.idModule}', tag: 'sync');
      logger.i('  - uuidObservationDetail: ${detail.uuidObservationDetail}',
          tag: 'sync');
      logger.i('  - Nombre de champs dans data: ${detail.data.length}',
          tag: 'sync');

      // Examen détaillé de tous les champs de données pour le débogage
      logger.i('Examen détaillé de tous les champs de données:', tag: 'sync');
      detail.data.forEach((key, value) {
        logger.i('  - Champ "$key": $value (${value?.runtimeType})',
            tag: 'sync');
      });

      // Ajouter l'UUID s'il est disponible - VERSION CORRIGÉE
      if (detail.uuidObservationDetail != null) {
        try {
          logger.i(
              'UUID original: ${detail.uuidObservationDetail} (${detail.uuidObservationDetail.runtimeType})',
              tag: 'sync');

          // Convertir l'UUID en chaîne hexadécimale si c'est une liste d'entiers
          String uuidValue;
          if (detail.uuidObservationDetail is List<int>) {
            // Convertir la liste d'entiers en chaîne hexadécimale
            uuidValue = (detail.uuidObservationDetail as List<int>)
                .map((b) => b.toRadixString(16).padLeft(2, '0'))
                .join('');
            logger.i('UUID converti de List<int> à String: $uuidValue',
                tag: 'sync');
          } else if (detail.uuidObservationDetail is String) {
            // Si c'est une chaîne qui ressemble à une liste
            if (detail.uuidObservationDetail.toString().startsWith('[') &&
                detail.uuidObservationDetail.toString().endsWith(']')) {
              try {
                // Extraire les nombres de la chaîne
                final String listString =
                    detail.uuidObservationDetail.toString();
                final String numbersOnly =
                    listString.substring(1, listString.length - 1);
                final List<String> parts = numbersOnly.split(', ');
                final List<int> bytes = parts.map((p) => int.parse(p)).toList();

                // Convertir en format hexadécimal
                uuidValue = bytes
                    .map((b) => b.toRadixString(16).padLeft(2, '0'))
                    .join('');
                logger.i(
                    'UUID converti de String "[n1, n2, ...]" à format hex: $uuidValue',
                    tag: 'sync');
              } catch (e) {
                // Si échec, utiliser directement la chaîne
                uuidValue = detail.uuidObservationDetail.toString();
                logger.i(
                    'Échec de conversion de liste, utilisation de la chaîne brute: $uuidValue',
                    tag: 'sync');
              }
            } else {
              // Utiliser directement la chaîne si elle n'a pas l'air d'être une liste
              uuidValue = detail.uuidObservationDetail as String;
              logger.i('UUID déjà en String: $uuidValue', tag: 'sync');
            }
          } else {
            // Convertir en chaîne pour tous les autres types
            uuidValue = detail.uuidObservationDetail.toString();
            logger.w(
                'UUID de type inattendu (${detail.uuidObservationDetail.runtimeType}), converti en chaîne: $uuidValue',
                tag: 'sync');
          }

          // Ajouter l'UUID au format chaîne dans les propriétés
          final properties = requestBody['properties'] as Map<String, dynamic>;
          properties['uuid_observation_detail'] = uuidValue;
          logger.i('UUID détail observation ajouté avec succès: $uuidValue',
              tag: 'sync');
        } catch (e, stackTrace) {
          // Capturer explicitement l'erreur pour plus de détails
          logger.e('ERREUR lors de l\'ajout de l\'UUID: $e',
              tag: 'sync', error: e, stackTrace: stackTrace);

          // Continuer sans ajouter l'UUID plutôt que de faire échouer toute la requête
          logger.w('Continuation sans l\'UUID pour éviter l\'échec complet',
              tag: 'sync');
        }
      }

      // Traiter les données complémentaires avec gestion sécurisée des types
      if (detail.data.isNotEmpty) {
        logger.i(
            'Traitement de ${detail.data.length} champs de données complémentaires',
            tag: 'sync');

        try {
          // Utiliser directement notre map de propriétés qui est déjà du bon type
          final Map<String, dynamic> properties =
              requestBody['properties'] as Map<String, dynamic>;
          logger.i('Type de properties: ${properties.runtimeType}',
              tag: 'sync');

          // Copier les champs directement dans properties, car c'est là que le serveur les attend
          for (final entry in detail.data.entries) {
            final key = entry.key;
            final value = entry.value;

            try {
              // Ne pas dupliquer id_observation qui est déjà défini
              if (key == 'id_observation') {
                logger.i(
                    'Ignorer le champ $key car déjà défini dans properties',
                    tag: 'sync');
                continue; // Skip this field
              }

              logger.i(
                  'Traitement du champ $key: $value (${value?.runtimeType})',
                  tag: 'sync');

              // Cas 1: Pour les champs qui commencent par 'id_' (nomenclatures et ID) - convertir en int
              if (key.startsWith('id_') && value is String) {
                int? intValue = int.tryParse(value);
                if (intValue != null) {
                  properties[key] = intValue;
                  logger.i(
                      'Conversion de $key: $value (String) -> $intValue (int)',
                      tag: 'sync');
                } else {
                  properties[key] = value;
                }
              }
              // Cas 2: Traiter les objets/listes en vérifiant si c'est du JSON sérialisé
              else if (value is String &&
                  value.trim().startsWith('{') &&
                  value.trim().endsWith('}')) {
                try {
                  // Tenter de parser comme JSON
                  final jsonValue = jsonDecode(value);
                  properties[key] = jsonValue;
                  logger.i('Conversion de $key: JSON String -> Objet',
                      tag: 'sync');
                } catch (_) {
                  // En cas d'échec, conserver la valeur d'origine
                  properties[key] = value;
                }
              }
              // Cas 3: Traiter les valeurs booléennes
              else if (value is String &&
                  (value.toLowerCase() == 'true' ||
                      value.toLowerCase() == 'false')) {
                final boolValue = value.toLowerCase() == 'true';
                properties[key] = boolValue;
                logger.i(
                    'Conversion de $key: $value (String) -> $boolValue (bool)',
                    tag: 'sync');
              }
              // Cas 4: Valeur null
              else if (value == null) {
                properties[key] = null;
                logger.i('Champ $key est null', tag: 'sync');
              }
              // Cas par défaut: conserver la valeur telle quelle (String, int, double, etc.)
              else {
                properties[key] = value;
                logger.i(
                    'Valeur conservée telle quelle pour $key: $value (${value.runtimeType})',
                    tag: 'sync');
              }
            } catch (e) {
              logger.e('Erreur lors du traitement du champ $key: $e',
                  tag: 'sync', error: e);
              // Continuer avec les autres champs pour ne pas bloquer toute la synchronisation
            }
          }

          // Vérifier que toutes les valeurs sont de types compatibles avec JSON
          logger.i('Vérification des types dans properties avant envoi:',
              tag: 'sync');
          properties.forEach((key, value) {
            logger.i('  - $key: $value (${value?.runtimeType})', tag: 'sync');
          });
        } catch (e, stackTrace) {
          logger.e('Erreur lors du traitement des données complémentaires: $e',
              tag: 'sync', error: e, stackTrace: stackTrace);
        }
      }

      // Log final du corps de la requête
      try {
        logger.i('Corps final de la requête:', tag: 'sync');
        logger.i(JsonEncoder.withIndent('  ').convert(requestBody),
            tag: 'sync');
      } catch (e) {
        logger.e('Erreur lors de l\'encodage JSON du corps de la requête: $e',
            tag: 'sync', error: e);
      }

      // Créer un champ data vide pour la compatibilité avec certaines API (au cas où)
      requestBody['data'] = {};

      // Log détaillé pour le débogage
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln('[API] ENVOI DÉTAIL D\'OBSERVATION AU SERVEUR');
      logBuffer.writeln(
          '==================================================================');
      logBuffer.writeln(
          'URL: $apiBase/monitorings/object/$moduleCode/observation_detail');
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

      String endpoint = '$apiBase/monitorings/object/$moduleCode/observation_detail';

      // Envoyer la requête
      final response = await _dio.post(
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
        logger.i('Détail d\'observation envoyé avec succès: ${response.data}',
            tag: 'sync');

        // Analyse détaillée de la réponse du serveur
        final serverResponse = response.data as Map<String, dynamic>;

        logger.i('Analyse détaillée de la réponse du serveur:', tag: 'sync');

        // Log des informations essentielles
        if (serverResponse.containsKey('id') ||
            serverResponse.containsKey('ID')) {
          final id = serverResponse['id'] ?? serverResponse['ID'];
          logger.i('ID dans la réponse: $id', tag: 'sync');
        } else {
          logger.w('Aucun ID trouvé dans la réponse', tag: 'sync');
        }

        // Vérifier les propriétés
        if (serverResponse.containsKey('properties')) {
          final properties = serverResponse['properties'];
          if (properties is Map) {
            logger.i('Propriétés trouvées dans la réponse: $properties',
                tag: 'sync');
          }
        } else {
          logger.w('Pas de champ "properties" dans la réponse', tag: 'sync');
        }

        // Vérifier tous les champs pour trouver où pourraient être les données
        logger.i('Liste de tous les champs de premier niveau dans la réponse:',
            tag: 'sync');
        serverResponse.keys.forEach((key) {
          logger.i(
              '- Champ "$key": ${serverResponse[key]} (${serverResponse[key]?.runtimeType})',
              tag: 'sync');
        });

        return serverResponse;
      } else {
        throw Exception(
            'Erreur lors de l\'envoi du détail d\'observation. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Importer AppLogger et créer l'instance
      final logger = AppLogger();

      // Log détaillé pour le débogage Dio
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln(
          '[API] ERREUR DIO LORS DE L\'ENVOI DU DÉTAIL D\'OBSERVATION');
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
          'Erreur réseau lors de l\'envoi du détail d\'observation: ${e.message}',
          originalDioException: e);
    } catch (e, stackTrace) {
      // Importer AppLogger et créer l'instance
      final logger = AppLogger();

      // Log détaillé pour le débogage général
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln(
          '[API] ERREUR GÉNÉRALE LORS DE L\'ENVOI DU DÉTAIL D\'OBSERVATION');
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
}
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/observations_api.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';

class ObservationsApiImpl implements ObservationsApi {
  final Dio _dio;
  final String apiBase = Config.apiBase;
  final Connectivity _connectivity = Connectivity();

  ObservationsApiImpl()
      : _dio = Dio(BaseOptions(
          baseUrl: Config.apiBase,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 180), // 3 minutes
          sendTimeout: const Duration(seconds: 60),
        ));

  @override
  Future<Map<String, dynamic>> sendObservation(
      String token, String moduleCode, Observation observation) async {
    try {
      // Importer AppLogger et créer l'instance
      final logger = AppLogger();

      // Vérifier la connectivité
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
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
      final Map<String, dynamic> requestBody = {
        'properties': {
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
          } else if (key == 'cd_nom' && value is String) {
            // Cas spécial pour cd_nom qui doit être un entier
            int? intValue = int.tryParse(value);
            if (intValue != null) {
              properties[key] = intValue;
              debugPrint(
                  'Conversion de cd_nom: $value (String) -> $intValue (int)');
            } else {
              properties[key] = value;
            }
          } else {
            // Conserver la valeur telle quelle pour les autres cas
            properties[key] = value;
          }
        });

        debugPrint('Données complémentaires ajoutées dans properties: $properties');
      }

      // Log détaillé pour le débogage
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln('[API] ENVOI OBSERVATION AU SERVEUR');
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

      // Ajouter skip_synthese=true comme paramètre global pour tous les modules
      // Cette approche permet d'éviter les erreurs de synchronisation avec la synthèse
      String endpoint =
          '$apiBase/monitorings/object/$moduleCode/observation?skip_synthese=true';
      logger.i(
          '[API] Utilisation du paramètre skip_synthese=true pour éviter les erreurs de synchronisation',
          tag: 'sync');

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
          'Erreur réseau lors de l\'envoi de l\'observation: ${e.message}');
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
}
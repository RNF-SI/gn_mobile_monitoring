import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/visits_api.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';

class VisitsApiImpl implements VisitsApi {
  final Dio _dio;
  final String apiBase = Config.apiBase;
  final Connectivity _connectivity;

  VisitsApiImpl({Dio? dio, Connectivity? connectivity})
      : _dio = dio ?? Dio(BaseOptions(
          baseUrl: Config.apiBase,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 180), // 3 minutes
          sendTimeout: const Duration(seconds: 60),
        )),
        _connectivity = connectivity ?? Connectivity();

  @override
  Future<Map<String, dynamic>> sendVisit(
      String token, String moduleCode, BaseVisit visit) async {
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

      // Vérification des champs obligatoires
      if (visit.idDataset == null) {
        logger.e('[API] ERREUR: id_dataset manquant pour la visite',
            tag: 'sync');
        throw ArgumentError(
            'Le champ id_dataset est requis pour envoyer une visite');
      }

      if (visit.idBaseSite == null) {
        logger.e('[API] ERREUR: id_base_site manquant pour la visite',
            tag: 'sync');
        throw ArgumentError(
            'Le champ id_base_site est requis pour envoyer une visite');
      }

      // Préparer le corps de la requête selon le format attendu par l'API
      // Selon le backend: le format attendu est
      // {
      //    "properties": {
      //      "id_module": "...",  <-- Cette propriété est nécessaire
      //      "id_dataset": "...", <-- Cette propriété est également nécessaire
      //      ... autres propriétés
      //    }
      // }
      final Map<String, dynamic> requestBody = {
        'properties': {
          'id_base_site': visit.idBaseSite,
          'visit_date_min': visit.visitDateMin,
          'observers': visit.observers ?? [],
          'id_dataset':
              visit.idDataset, // Ajout de l'id_dataset requis par le backend
        },
      };

      // Ajouter l'ID du module s'il est disponible dans le modèle
      if (visit.idModule != null) {
        requestBody['properties']['id_module'] = visit.idModule;
      }

      // Ajouter module_code au niveau supérieur du corps de la requête
      // pour éviter les conflits de type avec les propriétés
      debugPrint('Ajout du moduleCode pour la visite: $moduleCode');
      requestBody['module_code'] = moduleCode;

      // Ajouter les données complémentaires si disponibles
      // Les placer directement dans properties, pas dans un champ data séparé
      if (visit.data != null && visit.data!.isNotEmpty) {
        final properties = requestBody['properties'] as Map<String, dynamic>;
        
        // Copier manuellement chaque entrée pour éviter les incompatibilités de type
        visit.data!.forEach((key, value) {
          properties[key] = value;
        });

        debugPrint(
            'Données complémentaires ajoutées aux properties de la visite: ${visit.data}');
      }

      // Ajouter d'autres propriétés selon nécessité
      if (visit.visitDateMax != null) {
        requestBody['properties']['visit_date_max'] = visit.visitDateMax;
      }
      if (visit.comments != null) {
        requestBody['properties']['comments'] = visit.comments;
      }
      if (visit.idNomenclatureTechCollectCampanule != null) {
        requestBody['properties']['id_nomenclature_tech_collect_campanule'] =
            visit.idNomenclatureTechCollectCampanule;
      }
      if (visit.idNomenclatureGrpTyp != null) {
        requestBody['properties']['id_nomenclature_grp_typ'] =
            visit.idNomenclatureGrpTyp;
      }

      // Les vérifications des champs obligatoires ont été déplacées en début de méthode

      // Log détaillé pour le débogage
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln('[API] ENVOI VISITE AU SERVEUR');
      logBuffer.writeln(
          '==================================================================');
      logBuffer.writeln('URL: $apiBase/monitorings/object/$moduleCode/visit');
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

      // Envoyer la requête
      // Utiliser l'URL correcte selon les spécifications du backend: /monitorings/object/<module_code>/visit
      final response = await _dio.post(
        '$apiBase/monitorings/object/$moduleCode/visit',
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
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
            'Erreur lors de l\'envoi de la visite. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Importer AppLogger et créer l'instance
      final logger = AppLogger();

      // Log détaillé pour le débogage Dio
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln('[API] ERREUR DIO LORS DE L\'ENVOI DE LA VISITE');
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

      // Construire un message d'erreur complet avec tous les détails disponibles
      String completeErrorMessage = 'Erreur réseau lors de l\'envoi de la visite: ${e.message}';
      
      // Ajouter les détails de la réponse si disponibles
      if (e.response?.data != null) {
        String responseData = e.response!.data.toString();
        if (responseData.isNotEmpty) {
          completeErrorMessage += '\n\nDétails du serveur:\n$responseData';
        }
      }
      
      throw NetworkException(completeErrorMessage, originalDioException: e);
    } catch (e, stackTrace) {
      // Importer AppLogger et créer l'instance
      final logger = AppLogger();

      // Log détaillé pour le débogage général
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln('[API] ERREUR GÉNÉRALE LORS DE L\'ENVOI DE LA VISITE');
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
  Future<Map<String, dynamic>> updateVisit(
      String token, String moduleCode, int visitId, BaseVisit visit) async {
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

      // Préparer le corps de la requête selon le format attendu par l'API
      final Map<String, dynamic> requestBody = {
        'properties': {
          'id_base_site': visit.idBaseSite,
          'visit_date_min': visit.visitDateMin,
          'observers': visit.observers ?? [],
          'id_dataset': visit.idDataset,
        },
      };

      // Ajouter l'ID du module s'il est disponible dans le modèle
      if (visit.idModule != null) {
        requestBody['properties']['id_module'] = visit.idModule;
      }

      // Ajouter module_code au niveau supérieur du corps de la requête
      requestBody['module_code'] = moduleCode;

      // Ajouter les données complémentaires si disponibles
      if (visit.data != null && visit.data!.isNotEmpty) {
        final properties = requestBody['properties'] as Map<String, dynamic>;
        
        // Copier manuellement chaque entrée pour éviter les incompatibilités de type
        visit.data!.forEach((key, value) {
          properties[key] = value;
        });

        debugPrint(
            'Données complémentaires ajoutées aux properties de la visite: ${visit.data}');
      }

      // Ajouter d'autres propriétés selon nécessité
      if (visit.visitDateMax != null) {
        requestBody['properties']['visit_date_max'] = visit.visitDateMax;
      }
      if (visit.comments != null) {
        requestBody['properties']['comments'] = visit.comments;
      }
      if (visit.idNomenclatureTechCollectCampanule != null) {
        requestBody['properties']['id_nomenclature_tech_collect_campanule'] =
            visit.idNomenclatureTechCollectCampanule;
      }
      if (visit.idNomenclatureGrpTyp != null) {
        requestBody['properties']['id_nomenclature_grp_typ'] =
            visit.idNomenclatureGrpTyp;
      }

      // Log détaillé pour le débogage
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln('[API] MISE À JOUR VISITE AU SERVEUR');
      logBuffer.writeln(
          '==================================================================');
      logBuffer.writeln('URL: $apiBase/monitorings/object/$moduleCode/visit/$visitId');
      logBuffer.writeln('MÉTHODE: PATCH');

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

      // Envoyer la requête PATCH avec l'ID dans l'URL
      final response = await _dio.patch(
        '$apiBase/monitorings/object/$moduleCode/visit/$visitId',
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
            'Erreur lors de la mise à jour de la visite. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Importer AppLogger et créer l'instance
      final logger = AppLogger();

      // Log détaillé pour le débogage Dio
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln('[API] ERREUR DIO LORS DE LA MISE À JOUR DE LA VISITE');
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

      // Construire un message d'erreur complet avec tous les détails disponibles
      String completeErrorMessage = 'Erreur réseau lors de la mise à jour de la visite: ${e.message}';
      
      // Ajouter les détails de la réponse si disponibles
      if (e.response?.data != null) {
        String responseData = e.response!.data.toString();
        if (responseData.isNotEmpty) {
          completeErrorMessage += '\n\nDétails du serveur:\n$responseData';
        }
      }
      
      throw NetworkException(completeErrorMessage, originalDioException: e);
    } catch (e, stackTrace) {
      // Importer AppLogger et créer l'instance
      final logger = AppLogger();

      // Log détaillé pour le débogage général
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln('[API] ERREUR GÉNÉRALE LORS DE LA MISE À JOUR DE LA VISITE');
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
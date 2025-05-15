import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/entity/dataset_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/nomenclature_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';

class GlobalApiImpl implements GlobalApi {
  final Dio _dio;
  final String apiBase = Config.apiBase;
  final Connectivity _connectivity = Connectivity();

  GlobalApiImpl()
      : _dio = Dio(BaseOptions(
          baseUrl: Config.apiBase,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 180), // 3 minutes
          sendTimeout: const Duration(seconds: 60),
        ));

  @override
  Future<
      ({
        List<NomenclatureEntity> nomenclatures,
        List<DatasetEntity> datasets,
        List<Map<String, dynamic>> nomenclatureTypes
      })> getNomenclaturesAndDatasets(String moduleName) async {
    try {
      // Use the moduleName parameter in the API URL
      final response =
          await _dio.get('$apiBase/monitorings/util/init_data/$moduleName');

      if (response.statusCode == 200) {
        // Log the response for debugging
        print('Response from $apiBase/monitorings/util/init_data/$moduleName:');
        print(
            'Nomenclature count: ${(response.data['nomenclature'] as List<dynamic>).length}');

        final nomenclatures = (response.data['nomenclature'] as List<dynamic>)
            .map((json) => NomenclatureEntity.fromJson(json))
            .toList();

        // Extract unique nomenclature types from nomenclatures
        final Map<int, Map<String, dynamic>> uniqueTypeData = {};

        for (var nomenclature in nomenclatures) {
          final idType = nomenclature.idType;
          // Only process types that haven't been seen yet
          if (!uniqueTypeData.containsKey(idType)) {
            // Utiliser le codeType de la nomenclature s'il est disponible
            final mnemonique =
                nomenclature.codeType ?? _getMnemoniqueFallback(idType);
            uniqueTypeData[idType] = {
              'idType': idType,
              'mnemonique': mnemonique,
            };
          }
        }

        final datasets = (response.data['dataset'] as List<dynamic>)
            .map((json) => DatasetEntity.fromJson(json))
            .toList();

        return (
          nomenclatures: nomenclatures,
          datasets: datasets,
          nomenclatureTypes: uniqueTypeData.values.toList(),
        );
      } else {
        throw Exception(
            'Failed to fetch data for module $moduleName. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data for module $moduleName: $e');
    }
  }

  // Helper method to provide a default mnemonique for known type IDs
  String _getMnemoniqueFallback(int idType) {
    // Map of known type IDs to their mnemoniques
    final knownTypes = {
      117: 'TYPE_MEDIA',
      116: 'TYPE_SITE',
      118: 'TYPE_OBSERVATION',
      119: 'TYPE_VISIT',
      120: 'TYPE_PERMISSION',
    };

    return knownTypes[idType] ?? 'TYPE_$idType';
  }

  @override
  Future<Map<String, dynamic>> getModuleConfiguration(String moduleCode) async {
    try {
      final response =
          await _dio.get('$apiBase/monitorings/config/$moduleCode');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to fetch configuration for module $moduleCode. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Error fetching configuration for module $moduleCode: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getSiteTypes() async {
    try {
      final response = await _dio.get('$apiBase/monitorings/sites/types');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final items = data['items'] as List<dynamic>;
        return items.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception(
            'Failed to fetch site types. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching site types: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getSiteTypeById(
      int idNomenclatureTypeSite) async {
    try {
      final response = await _dio
          .get('$apiBase/monitorings/sites/types/$idNomenclatureTypeSite');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to fetch site type with ID $idNomenclatureTypeSite. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Error fetching site type with ID $idNomenclatureTypeSite: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getSiteTypeByLabel(String label) async {
    try {
      final response = await _dio.get('$apiBase/monitorings/sites/types/label',
          queryParameters: {'label_fr': label});

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to fetch site type with label $label. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching site type with label $label: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getNomenclatureTypes() async {
    try {
      final response =
          await _dio.get('$apiBase/nomenclatures/nomenclature_types');

      if (response.statusCode == 200) {
        final items = response.data as List<dynamic>;
        return items.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception(
            'Failed to fetch nomenclature types. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching nomenclature types: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getNomenclatureTypeByMnemonique(
      String mnemonique) async {
    try {
      final response = await _dio
          .get('$apiBase/nomenclatures/nomenclature_types/$mnemonique');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to fetch nomenclature type with mnemonique $mnemonique. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Error fetching nomenclature type with mnemonique $mnemonique: $e');
    }
  }

  @override
  Future<bool> checkConnectivity() async {
    try {
      // Vérifier la connectivité réseau
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      // Utiliser l'endpoint des types de sites pour vérifier si le serveur est accessible
      final response = await _dio.get(
        '$apiBase/monitorings/sites/types',
        options: Options(
          validateStatus: (status) => true,
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      // En cas d'erreur, on considère que le serveur n'est pas accessible
      return false;
    }
  }

  @override
  Future<SyncResult> syncNomenclaturesAndDatasets(
    String token,
    List<String> moduleCodes, {
    DateTime? lastSync,
  }) async {
    try {
      // Vérifier la connectivité
      if (!await checkConnectivity()) {
        throw NetworkException('Aucune connexion réseau disponible');
      }

      int itemsProcessed = 0;
      int itemsAdded = 0;
      int itemsUpdated = 0;
      int itemsSkipped = 0;
      List<String> errors = [];
      final Map<int, Map<String, dynamic>> allUniqueTypeData = {};

      // Synchroniser les nomenclatures et datasets pour chaque module
      for (final moduleCode in moduleCodes) {
        try {
          final response = await _dio.get(
            '$apiBase/monitorings/util/init_data/$moduleCode',
            options: Options(
              headers: {'Authorization': 'Bearer $token'},
            ),
          );

          if (response.statusCode == 200) {
            // Traiter les nomenclatures
            final nomenclatures =
                (response.data['nomenclature'] as List<dynamic>)
                    .map((json) => NomenclatureEntity.fromJson(json))
                    .toList();

            // Extraire les types de nomenclature uniques
            for (var nomenclature in nomenclatures) {
              final idType = nomenclature.idType;
              if (!allUniqueTypeData.containsKey(idType)) {
                final mnemonique =
                    nomenclature.codeType ?? _getMnemoniqueFallback(idType);
                allUniqueTypeData[idType] = {
                  'idType': idType,
                  'mnemonique': mnemonique,
                };
              }
            }

            // Compter les nomenclatures
            itemsProcessed += nomenclatures.length;
            if (lastSync == null) {
              itemsAdded += nomenclatures.length;
            } else {
              itemsUpdated += nomenclatures.length;
            }

            // Traiter les datasets
            final datasets = (response.data['dataset'] as List<dynamic>)
                .map((json) => DatasetEntity.fromJson(json))
                .toList();

            // Compter les datasets
            itemsProcessed += datasets.length;
            // Les datasets sont considérés comme des mises à jour
            // car ils sont liés aux modules déjà téléchargés
            itemsUpdated += datasets.length;
          } else {
            itemsSkipped++;
            errors
                .add('Module $moduleCode: Status code ${response.statusCode}');
          }
        } catch (e) {
          itemsSkipped++;
          errors.add('Module $moduleCode: ${e.toString()}');
        }
      }

      // Ajouter les types uniques au compte total
      itemsProcessed += allUniqueTypeData.length;
      if (lastSync == null) {
        itemsAdded += allUniqueTypeData.length;
      } else {
        itemsUpdated += allUniqueTypeData.length;
      }

      if (errors.isNotEmpty) {
        return SyncResult.failure(
          errorMessage:
              'Erreurs lors de la synchronisation:\n${errors.join('\n')}',
          itemsProcessed: itemsProcessed,
          itemsAdded: itemsAdded,
          itemsUpdated: itemsUpdated,
          itemsSkipped: itemsSkipped,
        );
      }

      return SyncResult.success(
        itemsProcessed: itemsProcessed,
        itemsAdded: itemsAdded,
        itemsUpdated: itemsUpdated,
        itemsSkipped: itemsSkipped,
      );
    } on DioException catch (e) {
      return SyncResult.failure(
        errorMessage: 'Erreur réseau: ${e.message}',
      );
    } catch (e) {
      return SyncResult.failure(
        errorMessage:
            'Erreur lors de la synchronisation des nomenclatures et datasets: $e',
      );
    }
  }

  @override
  @Deprecated('Use syncNomenclaturesAndDatasets instead')
  Future<SyncResult> syncNomenclatures(
    String token,
    List<String> moduleCodes, {
    DateTime? lastSync,
  }) async {
    return syncNomenclaturesAndDatasets(token, moduleCodes, lastSync: lastSync);
  }

  @override
  @Deprecated('Use syncNomenclaturesAndDatasets instead')
  Future<SyncResult> syncDatasets(
      String token, List<String> moduleCodes) async {
    return syncNomenclaturesAndDatasets(token, moduleCodes);
  }

  @override
  Future<SyncResult> syncConfiguration(
      String token, List<String> moduleCodes) async {
    try {
      // Vérifier la connectivité
      if (!await checkConnectivity()) {
        throw NetworkException('Aucune connexion réseau disponible');
      }

      int itemsProcessed = 0;
      int itemsAdded = 0;
      int itemsUpdated = 0;
      int itemsSkipped = 0;
      List<String> errors = [];

      // Synchroniser la configuration pour chaque module
      for (final moduleCode in moduleCodes) {
        try {
          final response = await _dio.get(
            '$apiBase/monitorings/config/$moduleCode',
            options: Options(
              headers: {'Authorization': 'Bearer $token'},
            ),
          );

          if (response.statusCode == 200) {
            itemsProcessed++;
            // On considère que c'est une mise à jour puisque le module était déjà téléchargé
            itemsUpdated++;
          } else {
            itemsSkipped++;
            errors
                .add('Module $moduleCode: Status code ${response.statusCode}');
          }
        } catch (e) {
          itemsSkipped++;
          errors.add('Module $moduleCode: ${e.toString()}');
        }
      }

      if (errors.isNotEmpty) {
        return SyncResult.failure(
          errorMessage:
              'Erreurs lors de la synchronisation:\n${errors.join('\n')}',
          itemsProcessed: itemsProcessed,
          itemsUpdated: itemsUpdated,
          itemsSkipped: itemsSkipped,
        );
      }

      return SyncResult.success(
        itemsProcessed: itemsProcessed,
        itemsAdded: itemsAdded,
        itemsUpdated: itemsUpdated,
        itemsSkipped: itemsSkipped,
      );
    } on DioException catch (e) {
      return SyncResult.failure(
        errorMessage: 'Erreur réseau: ${e.message}',
      );
    } catch (e) {
      return SyncResult.failure(
        errorMessage:
            'Erreur lors de la synchronisation de la configuration: $e',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> sendVisit(
      String token, String moduleCode, BaseVisit visit) async {
    try {
      // Importer AppLogger et créer l'instance 
      final logger = AppLogger();
      
      // Vérifier la connectivité
      if (!await checkConnectivity()) {
        logger.e('[API] ERREUR RÉSEAU: Aucune connexion Internet disponible', tag: 'sync');
        throw NetworkException('Aucune connexion réseau disponible');
      }

      // Vérification des champs obligatoires
      if (visit.idDataset == null) {
        logger.e('[API] ERREUR: id_dataset manquant pour la visite', tag: 'sync');
        throw ArgumentError('Le champ id_dataset est requis pour envoyer une visite');
      }
      
      if (visit.idBaseSite == null) {
        logger.e('[API] ERREUR: id_base_site manquant pour la visite', tag: 'sync');
        throw ArgumentError('Le champ id_base_site est requis pour envoyer une visite');
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
          'id_dataset': visit.idDataset, // Ajout de l'id_dataset requis par le backend
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
      // En utilisant une approche itérative pour éviter les problèmes de type
      if (visit.data != null && visit.data!.isNotEmpty) {
        // Créer un nouveau champ 'data' séparé pour stocker les données complémentaires
        requestBody['data'] = {};
        
        // Copier manuellement chaque entrée pour éviter les incompatibilités de type
        visit.data!.forEach((key, value) {
          requestBody['data'][key] = value;
        });
        
        debugPrint('Données complémentaires ajoutées à la visite: ${requestBody['data']}');
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
      logBuffer.writeln('\n==================================================================');
      logBuffer.writeln('[API] ENVOI VISITE AU SERVEUR');
      logBuffer.writeln('==================================================================');
      logBuffer.writeln('URL: $apiBase/monitorings/object/$moduleCode/visit');
      logBuffer.writeln('MÉTHODE: POST');
      
      // Afficher de façon sécurisée le token (juste les premiers caractères)
      if (token.length > 10) {
        logBuffer.writeln('HEADERS: Authorization: Bearer ${token.substring(0, 10)}...[MASQUÉ]');
      } else {
        logBuffer.writeln('HEADERS: Authorization: Bearer [MASQUÉ]');
      }
      
      logBuffer.writeln('BODY:');
      logBuffer.writeln('------------------------------------------------------------------');
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
      logBuffer.writeln('------------------------------------------------------------------');
      if (response.data is Map || response.data is List) {
        logBuffer.writeln(JsonEncoder.withIndent('  ').convert(response.data));
      } else {
        logBuffer.writeln(response.data.toString());
      }
      logBuffer.writeln('==================================================================');
      
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
      logBuffer.writeln('\n==================================================================');
      logBuffer.writeln('[API] ERREUR DIO LORS DE L\'ENVOI DE LA VISITE');
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

      // Écrire dans le fichier log via AppLogger
      logger.e(logBuffer.toString(), tag: 'sync', error: e);

      throw NetworkException(
          'Erreur réseau lors de l\'envoi de la visite: ${e.message}');
    } catch (e, stackTrace) {
      // Importer AppLogger et créer l'instance
      final logger = AppLogger();
      
      // Log détaillé pour le débogage général
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln('\n==================================================================');
      logBuffer.writeln('[API] ERREUR GÉNÉRALE LORS DE L\'ENVOI DE LA VISITE');
      logBuffer.writeln('==================================================================');
      logBuffer.writeln('Type: ${e.runtimeType}');
      logBuffer.writeln('Message: $e');
      logBuffer.writeln('\nSTACK TRACE:');
      logBuffer.writeln(stackTrace);
      logBuffer.writeln('==================================================================');

      // Écrire dans le fichier log via AppLogger
      logger.e(logBuffer.toString(), tag: 'sync', error: e, stackTrace: stackTrace);

      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> sendObservation(
      String token, String moduleCode, Observation observation) async {
    try {
      // Importer AppLogger et créer l'instance 
      final logger = AppLogger();
      
      // Vérifier la connectivité
      if (!await checkConnectivity()) {
        logger.e('[API] ERREUR RÉSEAU: Aucune connexion Internet disponible', tag: 'sync');
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
          'id_base_visit': observation.idBaseVisit,
        },
      };
      
      // Ajouter l'UUID s'il est disponible (toujours inclure cette donnée importante pour tous les modules)
      if (observation.uuidObservation != null) {
        requestBody['properties']['uuid_observation'] = observation.uuidObservation;
      }
      
      // Ajouter le module_code dans un champ séparé du corps de la requête
      // Plutôt que comme une propriété directe qui cause un conflit de type
      debugPrint('Utilisation du moduleCode pour l\'observation: $moduleCode');
      // Ajouter module_code au niveau supérieur du corps de la requête
      requestBody['module_code'] = moduleCode;

      // Ajouter le cd_nom s'il est disponible
      if (observation.cdNom != null) {
        requestBody['properties']['cd_nom'] = observation.cdNom;
      }

      // Ajouter les commentaires s'ils sont disponibles
      if (observation.comments != null) {
        requestBody['properties']['comments'] = observation.comments;
      }

      // Ajouter les données complémentaires si disponibles
      // En utilisant une approche itérative pour éviter les problèmes de type
      if (observation.data != null && observation.data!.isNotEmpty) {
        // Créer un nouveau champ 'data' séparé pour stocker les données complémentaires
        // au lieu de les ajouter directement aux propriétés
        requestBody['data'] = {};
        
        // Copier manuellement chaque entrée pour éviter les incompatibilités de type
        observation.data!.forEach((key, value) {
          requestBody['data'][key] = value;
        });
        
        debugPrint('Données complémentaires ajoutées: ${requestBody['data']}');
      }

      // Log détaillé pour le débogage
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln('\n==================================================================');
      logBuffer.writeln('[API] ENVOI OBSERVATION AU SERVEUR');
      logBuffer.writeln('==================================================================');
      logBuffer.writeln('URL: $apiBase/monitorings/object/$moduleCode/observation');
      logBuffer.writeln('MÉTHODE: POST');
      
      // Afficher de façon sécurisée le token (juste les premiers caractères)
      if (token.length > 10) {
        logBuffer.writeln('HEADERS: Authorization: Bearer ${token.substring(0, 10)}...[MASQUÉ]');
      } else {
        logBuffer.writeln('HEADERS: Authorization: Bearer [MASQUÉ]');
      }
      
      logBuffer.writeln('BODY:');
      logBuffer.writeln('------------------------------------------------------------------');
      logBuffer.writeln(JsonEncoder.withIndent('  ').convert(requestBody));
      
      // Écrire dans le fichier log via AppLogger
      logger.i(logBuffer.toString(), tag: 'sync');

      // Ajouter skip_synthese=true comme paramètre global pour tous les modules
      // Cette approche permet d'éviter les erreurs de synchronisation avec la synthèse
      String endpoint = '$apiBase/monitorings/object/$moduleCode/observation?skip_synthese=true';
      logger.i('[API] Utilisation du paramètre skip_synthese=true pour éviter les erreurs de synchronisation', tag: 'sync');
      
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
      logBuffer.writeln('------------------------------------------------------------------');
      if (response.data is Map || response.data is List) {
        logBuffer.writeln(JsonEncoder.withIndent('  ').convert(response.data));
      } else {
        logBuffer.writeln(response.data.toString());
      }
      logBuffer.writeln('==================================================================');
      
      // Écrire dans le fichier log via AppLogger
      logger.i(logBuffer.toString(), tag: 'sync');

      if (response.statusCode == 201 || response.statusCode == 200) {
        logger.i('Observation envoyée avec succès: ${response.data}', tag: 'sync');
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
      logBuffer.writeln('\n==================================================================');
      logBuffer.writeln('[API] ERREUR DIO LORS DE L\'ENVOI DE L\'OBSERVATION');
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

      // Écrire dans le fichier log via AppLogger
      logger.e(logBuffer.toString(), tag: 'sync', error: e);
      
      throw NetworkException(
          'Erreur réseau lors de l\'envoi de l\'observation: ${e.message}');
    } catch (e, stackTrace) {
      // Importer AppLogger et créer l'instance
      final logger = AppLogger();
      
      // Log détaillé pour le débogage général
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln('\n==================================================================');
      logBuffer.writeln('[API] ERREUR GÉNÉRALE LORS DE L\'ENVOI DE L\'OBSERVATION');
      logBuffer.writeln('==================================================================');
      logBuffer.writeln('Type: ${e.runtimeType}');
      logBuffer.writeln('Message: $e');
      logBuffer.writeln('\nSTACK TRACE:');
      logBuffer.writeln(stackTrace);
      logBuffer.writeln('==================================================================');

      // Écrire dans le fichier log via AppLogger
      logger.e(logBuffer.toString(), tag: 'sync', error: e, stackTrace: stackTrace);
      
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> sendObservationDetail(
      String token, String moduleCode, ObservationDetail detail) async {
    try {
      // Vérifier la connectivité
      if (!await checkConnectivity()) {
        throw NetworkException('Aucune connexion réseau disponible');
      }

      // Vérifier que l'ID de l'observation est présent
      if (detail.idObservation == null) {
        throw ArgumentError(
            'L\'ID de l\'observation est requis pour envoyer un détail d\'observation');
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
          'id_observation': detail.idObservation,
        },
      };
      
      // Ajouter le module_code dans un champ séparé du corps de la requête
      // Plutôt que comme une propriété directe qui cause un conflit de type
      debugPrint('Utilisation du moduleCode pour le détail d\'observation: $moduleCode');
      // Ajouter module_code au niveau supérieur du corps de la requête
      requestBody['module_code'] = moduleCode;

      // Ajouter les données complémentaires en utilisant une approche itérative
      // pour éviter les problèmes de type
      if (detail.data.isNotEmpty) {
        // Créer un nouveau champ 'data' séparé pour stocker les données complémentaires
        requestBody['data'] = {};
        
        // Copier manuellement chaque entrée pour éviter les incompatibilités de type
        detail.data.forEach((key, value) {
          requestBody['data'][key] = value;
        });
        
        debugPrint('Données complémentaires ajoutées au détail: ${requestBody['data']}');
      }

      debugPrint('Envoi du détail d\'observation au serveur: $requestBody');

      // Envoyer la requête
      // Utiliser l'URL correcte selon les spécifications du backend: /monitorings/object/<module_code>/observation_detail
      final response = await _dio.post(
        '$apiBase/monitorings/object/$moduleCode/observation_detail',
        data: requestBody,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint(
            'Détail d\'observation envoyé avec succès: ${response.data}');
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
            'Erreur lors de l\'envoi du détail d\'observation. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint(
          'Erreur DIO lors de l\'envoi du détail d\'observation: ${e.message}');
      if (e.response != null) {
        debugPrint('Réponse d\'erreur: ${e.response?.data}');
      }
      throw NetworkException(
          'Erreur réseau lors de l\'envoi du détail d\'observation: ${e.message}');
    } catch (e) {
      debugPrint(
          'Erreur générale lors de l\'envoi du détail d\'observation: $e');
      rethrow;
    }
  }
}

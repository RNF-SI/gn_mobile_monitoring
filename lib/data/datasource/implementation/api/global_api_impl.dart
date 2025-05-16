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

      throw NetworkException(
          'Erreur réseau lors de l\'envoi de la visite: ${e.message}');
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
  Future<Map<String, dynamic>> sendObservation(
      String token, String moduleCode, Observation observation) async {
    try {
      // Importer AppLogger et créer l'instance
      final logger = AppLogger();

      // Vérifier la connectivité
      if (!await checkConnectivity()) {
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

  @override
  Future<Map<String, dynamic>> sendObservationDetail(
      String token, String moduleCode, ObservationDetail detail) async {
    try {
      // Importer AppLogger et créer l'instance
      final logger = AppLogger();

      // Vérifier la connectivité
      if (!await checkConnectivity()) {
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

      // // Ajouter un champ additional_data à properties pour éviter les problèmes de compatibilité
      // try {
      //   final properties = requestBody['properties'] as Map;
      //   if (!properties.containsKey('additional_data')) {
      //     properties['additional_data'] = {};
      //     logger.i('Ajout du champ "additional_data" vide pour compatibilité', tag: 'sync');
      //   }
      // } catch (e) {
      //   logger.e('Erreur lors de l\'ajout de additional_data: $e', tag: 'sync', error: e);
      // }

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

      // Envoyer la requête
      // Utiliser l'URL correcte selon les spécifications du backend: /monitorings/object/<module_code>/observation_detail
      final response = await _dio.post(
        '$apiBase/monitorings/object/$moduleCode/observation_detail',
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
          'Erreur réseau lors de l\'envoi du détail d\'observation: ${e.message}');
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

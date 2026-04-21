import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/core/utils/error_message_helper.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/base_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/observation_details_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/observations_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/sites_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/visits_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/observation_details_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/observations_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/sites_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/visits_api.dart';
import 'package:gn_mobile_monitoring/data/entity/dataset_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/nomenclature_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';

class GlobalApiImpl extends BaseApi implements GlobalApi {
  final Connectivity _connectivity;
  final VisitsApi _visitsApi;
  final ObservationsApi _observationsApi;
  final ObservationDetailsApi _observationDetailsApi;
  final SitesApi _sitesApi;

  GlobalApiImpl({
    super.dio,
    Connectivity? connectivity,
    VisitsApi? visitsApi,
    ObservationsApi? observationsApi,
    ObservationDetailsApi? observationDetailsApi,
    SitesApi? sitesApi,
  })  : _connectivity = connectivity ?? Connectivity(),
        _visitsApi = visitsApi ?? VisitsApiImpl(),
        _observationsApi = observationsApi ?? ObservationsApiImpl(),
        _observationDetailsApi =
            observationDetailsApi ?? ObservationDetailsApiImpl(),
        _sitesApi = sitesApi ?? SitesApiImpl();

  @override
  Future<
      ({
        List<NomenclatureEntity> nomenclatures,
        List<DatasetEntity> datasets,
        List<Map<String, dynamic>> nomenclatureTypes,
        Map<String, dynamic> configuration,
      })> getNomenclaturesAndDatasets(int moduleId, {String? token}) async {
    try {
      final logger = AppLogger();
      
      // Préparer les headers si un token est fourni
      final headers = token != null ? {'Authorization': 'Bearer $token'} : null;
      
      // Requêtes légères : une instance Dio avec timeout raisonnable suffit
      final dioInstance = createDio(receiveTimeout: const Duration(seconds: 30));

      // Étape 1a : récupérer module_code (payload minimal, pas de relations sérialisées)
      // Le token doit être fourni pour éviter une redirection 302 vers la page de login
      final moduleResponse = await dioInstance.get(
        '/monitorings/module/$moduleId',
        queryParameters: {'depth': 0},
        options: headers != null ? Options(headers: headers) : null,
      );

      // 204 (No Content) signifie qu'il n'y a pas de données disponibles,
      // mais c'est un cas valide (pas une erreur)
      if (moduleResponse.statusCode == 204) {
        logger.i(
          'Module $moduleId: réponse 204 (No Content) - aucune nomenclature ou dataset disponible. '
          'Le module peut être téléchargé normalement.',
          tag: 'sync',
        );
        // Même avec 204, on peut récupérer la configuration
        final moduleData = moduleResponse.data as Map<String, dynamic>?;
        final moduleCode = moduleData?['module_code'] as String?;

        // Essayer de récupérer quand même la configuration
        Map<String, dynamic> config = {};
        if (moduleCode != null) {
          try {
            final configResponse = await dio.get(
              '/monitorings/config/$moduleCode',
              options: headers != null ? Options(headers: headers) : null,
            );
            if (configResponse.statusCode == 200) {
              config = configResponse.data as Map<String, dynamic>;
            }
          } catch (e) {
            logger.w('Impossible de récupérer la configuration pour $moduleCode: $e', tag: 'sync');
          }
        }

        return (
          nomenclatures: <NomenclatureEntity>[],
          datasets: <DatasetEntity>[],
          nomenclatureTypes: <Map<String, dynamic>>[],
          configuration: config,
        );
      }

      if (moduleResponse.statusCode != 200) {
        throw Exception(
            'Failed to fetch module $moduleId. Status code: ${moduleResponse.statusCode}');
      }

      final moduleData = moduleResponse.data as Map<String, dynamic>;
      final moduleCode = moduleData['module_code'] as String?;
      if (moduleCode == null) {
        throw Exception('Module code not found in module data for module $moduleId');
      }

      // Étape 1b : récupérer la liste d'IDs des datasets via l'endpoint "object"
      // (pattern utilisé par l'UI web GeoNature, scalable sur backend à sérialisation lente
      // car `field_name=module_code` empêche l'expansion des relations côté SQLAlchemy)
      final List<int> datasetIds = [];
      try {
        final objectResponse = await dioInstance.get(
          '/monitorings/object/$moduleCode/module',
          queryParameters: {'depth': 0, 'field_name': 'module_code'},
          options: headers != null ? Options(headers: headers) : null,
        );
        if (objectResponse.statusCode == 200 && objectResponse.data != null) {
          final data = objectResponse.data as Map<String, dynamic>;
          // Les IDs sont sous `properties.datasets` (fallback racine par précaution)
          final props = (data['properties'] is Map<String, dynamic>)
              ? data['properties'] as Map<String, dynamic>
              : data;
          final rawIds = props['datasets'];
          if (rawIds is List) {
            for (final id in rawIds) {
              if (id is int) {
                datasetIds.add(id);
              } else if (id is String) {
                final parsed = int.tryParse(id);
                if (parsed != null) datasetIds.add(parsed);
              }
            }
          }
        }
      } catch (e) {
        logger.w(
          'Impossible de récupérer la liste des datasets pour $moduleCode: $e',
          tag: 'sync',
        );
      }

      // Étape 1c : fetch de chaque dataset en parallèle, avec concurrence limitée
      // pour éviter de saturer le connection pool HTTP et le serveur.
      final List<DatasetEntity> datasets = [];
      const int chunkSize = 10;
      for (var i = 0; i < datasetIds.length; i += chunkSize) {
        final chunk = datasetIds.sublist(
          i,
          (i + chunkSize < datasetIds.length) ? i + chunkSize : datasetIds.length,
        );
        await Future.wait(chunk.map((id) async {
          try {
            final resp = await dioInstance.get(
              '/monitorings/util/dataset/$id',
              options: headers != null ? Options(headers: headers) : null,
            );
            if (resp.statusCode == 200 && resp.data is Map<String, dynamic>) {
              datasets.add(
                DatasetEntity.fromJson(resp.data as Map<String, dynamic>),
              );
            } else {
              logger.w('Dataset $id: statut ${resp.statusCode}, ignoré', tag: 'sync');
            }
          } catch (e) {
            logger.w('Erreur fetch dataset $id: $e', tag: 'sync');
          }
        }));
      }

      // Étape 2 : Récupérer la configuration du module pour obtenir les types de nomenclatures
      // Cette configuration sera également retournée pour éviter un appel redondant
      final configResponse = await dio.get(
        '/monitorings/config/$moduleCode',
        options: headers != null ? Options(headers: headers) : null,
      );
      
      final Map<String, dynamic> config;
      if (configResponse.statusCode == 200) {
        config = configResponse.data as Map<String, dynamic>;
      } else {
        logger.w(
          'Module $moduleCode: Impossible de récupérer la configuration (status: ${configResponse.statusCode}). '
          'Les nomenclatures ne pourront pas être récupérées.',
          tag: 'sync',
        );
        // Retourner les datasets sans nomenclatures mais avec une config vide
        return (
          nomenclatures: <NomenclatureEntity>[],
          datasets: datasets,
          nomenclatureTypes: <Map<String, dynamic>>[],
          configuration: <String, dynamic>{},
        );
      }
      
      // Extraire les types de nomenclatures depuis config.data.nomenclature
      final List<String> nomenclatureTypeCodes = [];
      if (config.containsKey('data') && 
          config['data'] is Map &&
          (config['data'] as Map).containsKey('nomenclature') &&
          (config['data'] as Map)['nomenclature'] is List) {
        final data = config['data'] as Map<String, dynamic>;
        final nomenclatureList = data['nomenclature'] as List<dynamic>;
        nomenclatureTypeCodes.addAll(
          nomenclatureList.whereType<String>(),
        );
      }

      // Étape 3 : Récupérer les nomenclatures pour chaque type
      final List<NomenclatureEntity> allNomenclatures = [];
      final Map<int, Map<String, dynamic>> uniqueTypeData = {};

      // Récupérer les nomenclatures en parallèle pour optimiser les performances
      // Note: Les nomenclatures GeoNature sont généralement publiques et n'ont pas besoin du token
      await Future.wait(
        nomenclatureTypeCodes.map((typeCode) async {
          try {
            final nomenclatureResponse = await dio.get(
              '/nomenclatures/nomenclature/$typeCode',
              // Optionnel: ajouter le token si nécessaire pour certaines instances
              // options: headers != null ? Options(headers: headers) : null,
            );

            if (nomenclatureResponse.statusCode == 200) {
              final nomenclatureData = nomenclatureResponse.data as Map<String, dynamic>;
              
              // Extraire les valeurs (values) de la réponse
              if (nomenclatureData.containsKey('values') && 
                  nomenclatureData['values'] is List) {
                final values = nomenclatureData['values'] as List<dynamic>;
                
                for (var valueJson in values) {
                  try {
                    final nomenclature = NomenclatureEntity.fromJson(
                      valueJson as Map<String, dynamic>,
                    );
                    allNomenclatures.add(nomenclature);

                    // Ajouter le type de nomenclature si pas déjà vu
                    if (!uniqueTypeData.containsKey(nomenclature.idType)) {
                      uniqueTypeData[nomenclature.idType] = {
                        'idType': nomenclature.idType,
                        'mnemonique': nomenclature.codeType ?? 
                                     nomenclatureData['mnemonique'] ?? 
                                     typeCode,
                      };
                    }
                  } catch (e) {
                    logger.w(
                      'Erreur lors du parsing d\'une nomenclature pour le type $typeCode: $e',
                      tag: 'sync',
                    );
                  }
                }
              }
            } else {
              logger.w(
                'Module $moduleCode: Impossible de récupérer les nomenclatures pour le type $typeCode '
                '(status: ${nomenclatureResponse.statusCode})',
                tag: 'sync',
              );
            }
          } catch (e) {
            logger.w(
              'Erreur lors de la récupération des nomenclatures pour le type $typeCode: $e',
              tag: 'sync',
            );
            // Continuer avec les autres types
          }
        }),
      );

      logger.i(
        'Module $moduleCode (ID: $moduleId): ${datasets.length} datasets et '
        '${allNomenclatures.length} nomenclatures récupérés depuis ${nomenclatureTypeCodes.length} types. '
        'Configuration également récupérée.',
        tag: 'sync',
      );

      return (
        nomenclatures: allNomenclatures,
        datasets: datasets,
        nomenclatureTypes: uniqueTypeData.values.toList(),
        configuration: config,
      );
    } catch (e) {
      throw Exception(
          'Error fetching data for module $moduleId: ${e.toString()}');
    }
  }

  // Helper method to provide a default mnemonique for known type IDs
  // Conservée pour une utilisation future lors de la récupération des nomenclatures
  // ignore: unused_element
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
          await dio.get('/monitorings/config/$moduleCode');

      // 204 (No Content) signifie qu'il n'y a pas de configuration disponible,
      // mais c'est un cas valide - retourner une configuration minimale valide
      if (response.statusCode == 204) {
        final logger = AppLogger();
        logger.i(
          'Module $moduleCode: réponse 204 (No Content) pour la configuration. '
          'Retour d\'une configuration minimale valide.',
          tag: 'sync',
        );
        // Retourner une configuration minimale mais valide pour éviter les erreurs de parsing
        return {
          'module': {'children_types': [], 'label': 'Module'},
          'site': {'label': 'Site', 'label_list': 'Sites'},
          'sites_group': {'label': 'Groupe de sites', 'label_list': 'Groupes de sites'},
        };
      }

      if (response.statusCode == 200) {
        final data = response.data;
        if (data == null || (data is Map && data.isEmpty)) {
          // Si les données sont null ou vides, retourner une config minimale
          return {
            'module': {'children_types': [], 'label': 'Module'},
            'site': {'label': 'Site', 'label_list': 'Sites'},
            'sites_group': {'label': 'Groupe de sites', 'label_list': 'Groupes de sites'},
          };
        }
        return data as Map<String, dynamic>;
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
      final response = await dio.get('/monitorings/sites/types');

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
      final response = await dio
          .get('/monitorings/sites/types/$idNomenclatureTypeSite');

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
      final response = await dio.get('/monitorings/sites/types/label',
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
          await dio.get('/nomenclatures/nomenclature_types');

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
      final response = await dio
          .get('/nomenclatures/nomenclature_types/$mnemonique');

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
      final connectivityResults = await _connectivity.checkConnectivity();
      if (connectivityResults.contains(ConnectivityResult.none) ||
          connectivityResults.isEmpty) {
        return false;
      }

      // Utiliser l'endpoint des types de sites pour vérifier si le serveur est accessible
      final response = await dio.get(
        '/monitorings/sites/types',
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
    List<int> moduleIds, {
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
      // On réutilise la méthode getNomenclaturesAndDatasets qui implémente correctement
      // le nouveau flux avec récupération de la configuration et des nomenclatures
      for (final moduleId in moduleIds) {
        try {
          // Utiliser getNomenclaturesAndDatasets qui gère tout le flux
          // Passer le token pour les requêtes authentifiées
          final data = await getNomenclaturesAndDatasets(moduleId, token: token);

          // Compter les nomenclatures
          itemsProcessed += data.nomenclatures.length;
          if (lastSync == null) {
            itemsAdded += data.nomenclatures.length;
          } else {
            itemsUpdated += data.nomenclatures.length;
          }

          // Ajouter les types de nomenclatures uniques
          for (var typeData in data.nomenclatureTypes) {
            final idType = typeData['idType'] as int;
            if (!allUniqueTypeData.containsKey(idType)) {
              allUniqueTypeData[idType] = typeData;
            }
          }

          // Compter les datasets
          itemsProcessed += data.datasets.length;
          // Les datasets sont considérés comme des mises à jour
          // car ils sont liés aux modules déjà téléchargés
          itemsUpdated += data.datasets.length;
        } catch (e) {
          itemsSkipped++;
          errors.add('Module $moduleId: ${e.toString()}');
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
    // Cette méthode est dépréciée, elle ne peut plus fonctionner avec le nouvel endpoint
    // qui nécessite des moduleIds. Retourner une erreur explicite.
    return SyncResult.failure(
      errorMessage: 'syncNomenclatures est dépréciée. Utilisez syncNomenclaturesAndDatasets avec des moduleIds.',
    );
  }

  @override
  @Deprecated('Use syncNomenclaturesAndDatasets instead')
  Future<SyncResult> syncDatasets(
      String token, List<String> moduleCodes) async {
    // Cette méthode est dépréciée, elle ne peut plus fonctionner avec le nouvel endpoint
    // qui nécessite des moduleIds. Retourner une erreur explicite.
    return SyncResult.failure(
      errorMessage: 'syncDatasets est dépréciée. Utilisez syncNomenclaturesAndDatasets avec des moduleIds.',
    );
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

      // Log des modules à synchroniser
      debugPrint('Synchronisation de la configuration pour ${moduleCodes.length} modules: ${moduleCodes.join(', ')}');
      
      // Synchroniser la configuration pour chaque module
      for (final moduleCode in moduleCodes) {
        debugPrint('Synchronisation configuration du module: $moduleCode');
        try {
          final response = await dio.get(
            '/monitorings/config/$moduleCode',
            options: Options(
              headers: {'Authorization': 'Bearer $token'},
            ),
          );

          if (response.statusCode == 200) {
            itemsProcessed++;
            // On considère que c'est une mise à jour puisque le module était déjà téléchargé
            itemsUpdated++;
            debugPrint('Configuration synchronisée avec succès pour le module: $moduleCode');
          } else {
            itemsSkipped++;
            final errorMsg = 'Module $moduleCode: Erreur serveur lors de la synchronisation de la configuration (code ${response.statusCode})';
            errors.add(errorMsg);
            debugPrint('Erreur de synchronisation configuration: $errorMsg');
          }
        } catch (e) {
          itemsSkipped++;
          final errorMessage = ErrorMessageHelper.formatError(
            'la synchronisation de la configuration', 
            e, 
            moduleCode: moduleCode
          );
          errors.add(errorMessage);
          // Log détaillé pour le debugging
          debugPrint('Erreur de synchronisation configuration pour module $moduleCode: $e');
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
    return _visitsApi.sendVisit(token, moduleCode, visit);
  }

  @override
  Future<Map<String, dynamic>> updateVisit(
      String token, String moduleCode, int visitId, BaseVisit visit) async {
    return _visitsApi.updateVisit(token, moduleCode, visitId, visit);
  }

  @override
  Future<Map<String, dynamic>> sendObservation(
      String token, String moduleCode, Observation observation) async {
    return _observationsApi.sendObservation(token, moduleCode, observation);
  }

  @override
  Future<Map<String, dynamic>> updateObservation(
      String token, String moduleCode, int observationId, Observation observation) async {
    return _observationsApi.updateObservation(token, moduleCode, observationId, observation);
  }

  @override
  Future<Map<String, dynamic>> sendObservationDetail(
      String token, String moduleCode, ObservationDetail detail) async {
    return _observationDetailsApi.sendObservationDetail(
        token, moduleCode, detail);
  }

  @override
  Future<Map<String, dynamic>> sendSite(
      String token, String moduleCode, BaseSite site, {int? moduleId}) async {
    return _sitesApi.sendSite(token, moduleCode, site, moduleId: moduleId);
  }

  @override
  Future<Map<String, dynamic>> updateSite(
      String token, String moduleCode, int siteId, BaseSite site) async {
    return _sitesApi.updateSite(token, moduleCode, siteId, site);
  }

  @override
  Future<Map<String, dynamic>> sendSiteGroup(
      String token, String moduleCode, SiteGroup siteGroup, {int? moduleId}) async {
    return _sitesApi.sendSiteGroup(token, moduleCode, siteGroup, moduleId: moduleId);
  }
}

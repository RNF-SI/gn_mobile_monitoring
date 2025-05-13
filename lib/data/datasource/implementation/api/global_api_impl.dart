import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/entity/dataset_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/nomenclature_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';

class GlobalApiImpl implements GlobalApi {
  final Dio _dio;
  final String apiBase = Config.apiBase;
  final Connectivity _connectivity = Connectivity();

  GlobalApiImpl()
      : _dio = Dio(BaseOptions(
          baseUrl: Config.apiBase,
          connectTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 3000),
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
        print('Nomenclature count: ${(response.data['nomenclature'] as List<dynamic>).length}');
        
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
}

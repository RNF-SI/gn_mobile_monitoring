import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/entity/bib_type_site_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/dataset_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/nomenclature_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/nomenclature_type_entity.dart';

class GlobalApiImpl implements GlobalApi {
  final Dio _dio;
  final String apiBase = Config.apiBase;

  GlobalApiImpl()
      : _dio = Dio(BaseOptions(
          baseUrl: Config.apiBase,
          connectTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 3000),
        ));

  @override
  Future<Map<String, dynamic>> getNomenclaturesAndDatasets(
      String moduleName) async {
    try {
      // Use the moduleName parameter in the API URL
      final response =
          await _dio.get('$apiBase/monitorings/util/init_data/$moduleName');

      if (response.statusCode == 200) {
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
            final mnemonique = nomenclature.codeType ?? _getMnemoniqueFallback(idType);
            uniqueTypeData[idType] = {
              'idType': idType,
              'mnemonique': mnemonique,
            };
          }
        }

        final datasets = (response.data['dataset'] as List<dynamic>)
            .map((json) => DatasetEntity.fromJson(json))
            .toList();

        return {
          'nomenclatures': nomenclatures,
          'datasets': datasets,
          'nomenclatureTypes': uniqueTypeData.values.toList(),
        };
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
        throw Exception('Failed to fetch site types. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching site types: $e');
    }
  }
  
  @override
  Future<Map<String, dynamic>> getSiteTypeById(int idNomenclatureTypeSite) async {
    try {
      final response = await _dio.get('$apiBase/monitorings/sites/types/$idNomenclatureTypeSite');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch site type with ID $idNomenclatureTypeSite. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching site type with ID $idNomenclatureTypeSite: $e');
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
        throw Exception('Failed to fetch site type with label $label. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching site type with label $label: $e');
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> getNomenclatureTypes() async {
    try {
      final response = await _dio.get('$apiBase/nomenclatures/nomenclature_types');
      
      if (response.statusCode == 200) {
        final items = response.data as List<dynamic>;
        return items.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to fetch nomenclature types. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching nomenclature types: $e');
    }
  }
  
  @override
  Future<Map<String, dynamic>> getNomenclatureTypeByMnemonique(String mnemonique) async {
    try {
      final response = await _dio.get('$apiBase/nomenclatures/nomenclature_types/$mnemonique');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch nomenclature type with mnemonique $mnemonique. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching nomenclature type with mnemonique $mnemonique: $e');
    }
  }
}

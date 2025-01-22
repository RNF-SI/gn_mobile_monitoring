import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/entity/dataset_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/nomenclature_entity.dart';

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

        final datasets = (response.data['dataset'] as List<dynamic>)
            .map((json) => DatasetEntity.fromJson(json))
            .toList();

        return {
          'nomenclatures': nomenclatures,
          'datasets': datasets,
        };
      } else {
        throw Exception(
            'Failed to fetch data for module $moduleName. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data for module $moduleName: $e');
    }
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
}

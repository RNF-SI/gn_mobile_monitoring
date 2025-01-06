import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/modules_api.dart';
import 'package:gn_mobile_monitoring/data/entity/module_entity.dart';

class ModulesApiImpl implements ModulesApi {
  final Dio _dio;

  ModulesApiImpl()
      : _dio = Dio(BaseOptions(
          baseUrl: Config.apiBase,
          connectTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 3000),
        ));

  @override
  Future<List<ModuleEntity>> getModules() async {
    try {
      final response = await _dio.get('/monitorings/modules');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data
              .map(
                  (json) => ModuleEntity.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Unexpected response format: not a List');
        }
      } else {
        throw Exception(
            'Failed to load modules with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Gestion des erreurs réseau
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      // Gestion des autres types d'erreurs
      throw Exception('Error fetching modules: $e');
    }
  }
}

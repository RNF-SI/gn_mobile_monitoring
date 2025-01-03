import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/modules_api.dart';
import 'package:gn_mobile_monitoring/data/entity/module_entity.dart';

class ModulesApiImpl implements ModulesApi {
  var apiBase = Config.apiBase;

  @override
  Future<List<ModuleEntity>> getModules() async {
    try {
      final response = await Dio().get('$apiBase/modules');
      if (response.statusCode == 200) {
        final List<dynamic> modulesJson = response.data as List<dynamic>;
        return modulesJson
            .map((json) => ModuleEntity.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Failed to load modules with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching modules: $e');
    }
  }
}

import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/modules_api.dart';
import 'package:gn_mobile_monitoring/data/entity/cor_site_module_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/module_complement_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/module_entity.dart';

class ModulesApiImpl implements ModulesApi {
  final Dio _dio;

  ModulesApiImpl()
      : _dio = Dio(BaseOptions(
          baseUrl: Config.apiBase,
          connectTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 3000),
        ));

  /// Checks if a module has sufficient CRUVED permissions
  /// Returns true if any of the CRUVED values is greater than 0
  bool _hasModulePermissions(Map<String, dynamic> cruved) {
    if (cruved == null) return false;

    // Check if any of the CRUVED values is greater than 0
    return cruved.values.any((value) => value is num && value > 0);
  }

  @override
  Future<(List<ModuleEntity>, List<ModuleComplementEntity>)> getModules(
      String token) async {
    try {
      final response = await _dio.get(
        '/monitorings/modules',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          final modules = <ModuleEntity>[];
          final moduleComplements = <ModuleComplementEntity>[];

          for (var item in data) {
            final json = item as Map<String, dynamic>;

            // Check CRUVED permissions
            final cruved = json['cruved'] as Map<String, dynamic>?;
            if (!_hasModulePermissions(cruved ?? {})) {
              continue; // Skip this module if no permissions
            }

            // Extract module data
            final moduleJson = {
              'id_module': json['id_module'],
              'module_code': json['module_code'],
              'module_label': json['module_label'],
              'module_picto': json['module_picto'],
              'module_desc': json['module_desc'],
              'module_group': json['module_group'],
              'module_path': json['module_path'],
              'module_external_url': json['module_external_url'],
              'module_target': json['module_target'],
              'module_comment': json['module_comment'],
              'active_frontend': json['active_frontend'],
              'active_backend': json['active_backend'],
              'module_doc_url': json['module_doc_url'],
              'module_order': json['module_order'],
              'ng_module': json['ng_module'],
              'meta_create_date': json['meta_create_date'],
              'meta_update_date': json['meta_update_date'],
              'cruved': json['cruved'],
            };
            modules.add(ModuleEntity.fromJson(moduleJson));

            // Extract module complement data
            final complementJson = {
              'id_module': json['id_module'],
              'uuid_module_complement': json['uuid_module_complement'],
              'id_list_observer': json['id_list_observer'],
              'id_list_taxonomy': json['id_list_taxonomy'],
              'b_synthese': json['b_synthese'],
              'taxonomy_display_field_name':
                  json['taxonomy_display_field_name'],
              'b_draw_sites_group': json['b_draw_sites_group'],
              'data': json['data'],
              'configuration': json['configuration'],
            };
            moduleComplements
                .add(ModuleComplementEntity.fromJson(complementJson));
          }

          return (modules, moduleComplements);
        } else {
          throw Exception('Unexpected response format: not a List');
        }
      } else {
        throw Exception(
            'Failed to load modules with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching modules: $e');
    }
  }

  @override
  Future<List<CorSiteModuleEntity>> getCorSiteModules(
      String token, String moduleCode) async {
    try {
      final response = await _dio.get(
        '/monitorings/list/$moduleCode/site',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CorSiteModuleEntity.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load module sites with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching module sites: $e');
    }
  }
}

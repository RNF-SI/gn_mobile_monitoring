import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/api_exception.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/sites_api.dart';
import 'package:gn_mobile_monitoring/data/entity/base_site_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/module_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/site_group_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/site_groups_with_modules.dart';

class SitesApiImpl implements SitesApi {
  final Dio _dio;

  SitesApiImpl()
      : _dio = Dio(BaseOptions(
          baseUrl: Config.apiBase,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ));

  /// Fetches all monitoring modules from the API
  Future<List<Map<String, dynamic>>> _fetchMonitoringModules(
      String token) async {
    try {
      final response = await _dio.get(
        '/gn_commons/modules',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> modules = response.data;
        return modules
            .where((module) => module['type'] == 'monitoring_module')
            .cast<Map<String, dynamic>>()
            .toList();
      } else {
        throw ApiException(
          'Failed to fetch modules',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
          'Network error while fetching modules: ${e.message}');
    } catch (e) {
      throw ApiException('Unexpected error while fetching modules: $e');
    }
  }

  @override
  Future<List<BaseSiteEntity>> fetchSitesForModule(
      String moduleCode, String token) async {
    try {
      final response = await _dio.get(
        '/monitorings/list/$moduleCode/site',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> sites = response.data;
        return sites.map((site) => BaseSiteEntity.fromJson(site)).toList();
      }

      throw ApiException(
        'Failed to fetch sites for module $moduleCode',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw NetworkException(
          'Network error while fetching sites: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to fetch sites: $e');
    }
  }

  @override
  Future<List<SiteGroupsWithModulesLabel>> fetchSiteGroupsForModule(
      String moduleCode, String token) async {
    try {
      final response = await _dio.get(
        '/monitorings/list/$moduleCode/sites_group',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> siteGroups = response.data;

        return siteGroups.map((siteGroup) {
          // Convert the site group to the format our app expects
          final Map<String, dynamic> groupData = {
            'id_sites_group': siteGroup['id_sites_group'],
            'sites_group_name': siteGroup['sites_group_name'] ?? '',
            'sites_group_code': siteGroup['sites_group_code'] ?? '',
            'comments': siteGroup['comments'],
            'nb_sites': siteGroup['nb_sites'],
            'nb_visits': siteGroup['nb_visits'],
            // Add any other fields needed by SiteGroupEntity
            'modules': [
              moduleCode
            ], // We know this site group belongs to this module
          };

          return SiteGroupsWithModulesLabel(
            siteGroup: SiteGroupEntity.fromJson(groupData),
            moduleLabelList: [
              moduleCode
            ], // We know this site group belongs to this module
          );
        }).toList();
      }

      throw ApiException(
        'Failed to fetch site groups for module $moduleCode',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw NetworkException(
          'Network error while fetching site groups: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to fetch site groups: $e');
    }
  }

  @override
  Future<List<ModuleEntity>> fetchModulesFromIdSite(
      int idSite, String token) async {
    final response = await _dio.get(
      '/monitorings/sites/$idSite/modules',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = response.data;
      return jsonData.map((item) => ModuleEntity.fromJson(item)).toList();
    }
    throw ApiException('Failed to fetch modules from API',
        statusCode: response.statusCode);
  }
}

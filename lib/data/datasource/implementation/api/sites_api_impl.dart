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


  @override
  Future<List<BaseSiteEntity>> fetchSitesForModule(
      String moduleCode, String token) async {
    try {
      final response = await _dio.get(
        '/monitorings/object/$moduleCode/module',
        queryParameters: {
          'depth': 1,
          'field_name': 'module_code',
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final result = <BaseSiteEntity>[];
        
        // Process sites from the children
        if (data['children'] != null && data['children']['site'] != null) {
          final sitesList = data['children']['site'] as List;
          for (var site in sitesList) {
            final siteData = site as Map<String, dynamic>;
            final properties = siteData['properties'] as Map<String, dynamic>;
            
            // Extract site data from the properties
            final siteJson = {
              'id_base_site': properties['id_base_site'] ?? siteData['id'],
              'base_site_name': properties['base_site_name'],
              'base_site_code': properties['initial_code'],
              // Add other fields as needed
            };
            
            result.add(BaseSiteEntity.fromJson(siteJson));
          }
        }
        
        return result;
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
        '/monitorings/object/$moduleCode/module',
        queryParameters: {
          'depth': 1,
          'field_name': 'module_code',
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final result = <SiteGroupsWithModulesLabel>[];
        
        // Process site groups from the children
        if (data['children'] != null && data['children']['sites_group'] != null) {
          final siteGroupsList = data['children']['sites_group'] as List;
          for (var group in siteGroupsList) {
            final groupData = group as Map<String, dynamic>;
            final properties = groupData['properties'] as Map<String, dynamic>;
            
            // Extract site group data from the properties
            final Map<String, dynamic> formattedGroupData = {
              'id_sites_group': properties['id_sites_group'] ?? groupData['id'],
              'sites_group_name': properties['sites_group_name'] ?? '',
              'sites_group_code': properties['sites_group_code'] ?? '',
              'comments': properties['comments'],
              'nb_sites': properties['nb_sites'],
              'nb_visits': properties['nb_visits'],
              'modules': [
                moduleCode
              ], // We know this site group belongs to this module
            };
            
            result.add(SiteGroupsWithModulesLabel(
              siteGroup: SiteGroupEntity.fromJson(formattedGroupData),
              moduleLabelList: [
                moduleCode
              ], // We know this site group belongs to this module
            ));
          }
        }
        
        return result;
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

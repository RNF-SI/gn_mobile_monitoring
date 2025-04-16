import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/api_exception.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/sites_api.dart';
import 'package:gn_mobile_monitoring/data/entity/base_site_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/module_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/site_complement_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/site_group_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/site_groups_with_modules.dart';
import 'package:gn_mobile_monitoring/data/mapper/site_complement_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';

class SitesApiImpl implements SitesApi {
  final Dio _dio;

  SitesApiImpl()
      : _dio = Dio(BaseOptions(
          baseUrl: Config.apiBase,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
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
  Future<List<Map<String, dynamic>>> fetchDetailedSitesData(
      String token) async {
    try {
      final response = await _dio.get(
        '/monitorings/list/apollons/site',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        return jsonData.cast<Map<String, dynamic>>();
      }

      throw ApiException(
        'Failed to fetch detailed sites data',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw NetworkException(
          'Network error while fetching detailed sites data: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to fetch detailed sites data: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> fetchEnrichedSitesForModule(
      String moduleCode, String token) async {
    try {
      // 1. Fetch sites for the module (to get the list of IDs that we care about)
      final moduleResponse = await _dio.get(
        '/monitorings/object/$moduleCode/module',
        queryParameters: {
          'depth': 1,
          'field_name': 'module_code',
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (moduleResponse.statusCode != 200) {
        throw ApiException(
          'Failed to fetch sites for module $moduleCode',
          statusCode: moduleResponse.statusCode,
        );
      }

      final moduleData = moduleResponse.data as Map<String, dynamic>;
      final Set<int> moduleSiteIds = {};
      final List<BaseSiteEntity> moduleSites = [];

      // Extract site IDs from the module response
      if (moduleData['children'] != null &&
          moduleData['children']['site'] != null) {
        final sitesList = moduleData['children']['site'] as List;
        for (var site in sitesList) {
          final siteData = site as Map<String, dynamic>;
          final properties = siteData['properties'] as Map<String, dynamic>;
          final siteId = properties['id_base_site'] ?? siteData['id'];

          if (siteId != null) {
            moduleSiteIds.add(siteId as int);

            // Create basic site entity with data we have
            final siteJson = {
              'id_base_site': siteId,
              'base_site_name': properties['base_site_name'],
              'base_site_code': properties['initial_code'],
            };

            moduleSites.add(BaseSiteEntity.fromJson(siteJson));
          }
        }
      }

      // 2. Fetch detailed data for all sites
      final detailedResponse = await _dio.get(
        '/monitorings/list/apollons/site',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (detailedResponse.statusCode != 200) {
        throw ApiException(
          'Failed to fetch detailed sites data',
          statusCode: detailedResponse.statusCode,
        );
      }

      final List<dynamic> allSitesData = detailedResponse.data;
      final Map<int, Map<String, dynamic>> detailedSitesMap = {};
      final List<Map<String, dynamic>> enrichedSites = [];
      final List<SiteComplement> siteComplements = [];

      // First, build a map of all detailed site data keyed by site ID
      for (var siteData in allSitesData) {
        final Map<String, dynamic> site = siteData as Map<String, dynamic>;
        final int siteId = site['id_base_site'] as int;
        detailedSitesMap[siteId] = site;
      }

      // Now process only the sites that are in the module
      for (var site in moduleSites) {
        if (detailedSitesMap.containsKey(site.idBaseSite)) {
          final detailedData = detailedSitesMap[site.idBaseSite]!;

          // Create enriched site data
          final Map<String, dynamic> enrichedSite = {
            'id_base_site': site.idBaseSite,
            'base_site_name':
                detailedData['base_site_name'] ?? site.baseSiteName,
            'base_site_code':
                detailedData['base_site_code'] ?? site.baseSiteCode,
            'base_site_description': detailedData['base_site_description'],
            'altitude_min': detailedData['altitude_min'],
            'altitude_max': detailedData['altitude_max'],
            'first_use_date': detailedData['first_use_date'],
            'uuid_base_site': detailedData['uuid_base_site'],
          };

          enrichedSites.add(enrichedSite);

          // Create site complement data for storage
          final int? idSitesGroup = detailedData['id_sites_group'] as int?;
          final Map<String, dynamic>? siteData =
              detailedData['data'] as Map<String, dynamic>?;

          // Create entity first, then convert to domain model
          final complementEntity = SiteComplementEntity(
            idBaseSite: site.idBaseSite,
            idSitesGroup: idSitesGroup,
            data: siteData != null ? jsonEncode(siteData) : null,
          );

          siteComplements.add(complementEntity.toDomain());
        } else {
          // Site doesn't have detailed data, use basic data
          enrichedSites.add({
            'id_base_site': site.idBaseSite,
            'base_site_name': site.baseSiteName,
            'base_site_code': site.baseSiteCode,
          });
        }
      }

      return {
        'enriched_sites': enrichedSites,
        'site_complements': siteComplements,
      };
    } on DioException catch (e) {
      throw NetworkException(
          'Network error while fetching enriched sites: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to fetch enriched sites: $e');
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
        if (data['children'] != null &&
            data['children']['sites_group'] != null) {
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

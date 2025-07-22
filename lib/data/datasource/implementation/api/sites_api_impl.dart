import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/api_exception.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/base_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/sites_api.dart';
import 'package:gn_mobile_monitoring/data/entity/site_complement_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/site_group_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/site_groups_with_modules.dart';
import 'package:gn_mobile_monitoring/data/mapper/site_complement_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';

class SitesApiImpl extends BaseApi implements SitesApi {
  SitesApiImpl();

  @override
  Dio get dio => createDio(
    receiveTimeout: const Duration(seconds: 300), // 5 minutes pour les grosses quantités de données
    sendTimeout: const Duration(seconds: 120),
  );

  @override
  Future<Map<String, dynamic>> fetchEnrichedSitesForModule(
      String moduleCode, String token) async {
    try {
      // Fetch sites for the module using the secure endpoint with depth=2
      final moduleResponse = await dio.get(
        '/monitorings/object/$moduleCode/module',
        queryParameters: {
          'depth': 2,
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
      final List<Map<String, dynamic>> enrichedSites = [];
      final List<SiteComplement> siteComplements = [];

      // 1. PRIORITY: Récupérer d'abord les sites dans les groupes de sites (avec depth=2)
      if (moduleData['children'] != null &&
          moduleData['children']['sites_group'] != null) {
        final siteGroupsList = moduleData['children']['sites_group'] as List;
        
        for (var group in siteGroupsList) {
          final groupData = group as Map<String, dynamic>;
          final groupProperties = groupData['properties'] as Map<String, dynamic>;
          final groupId = groupProperties['id_sites_group'] as int;
          
          // Check if the group has sites
          if (groupData['children'] != null &&
              groupData['children']['site'] != null) {
            final sitesList = groupData['children']['site'] as List;
            
            for (var site in sitesList) {
              final siteData = site as Map<String, dynamic>;
              final properties = siteData['properties'] as Map<String, dynamic>;
              final siteId = properties['id_base_site'] ?? siteData['id'];

              if (siteId != null && !moduleSiteIds.contains(siteId)) {
                moduleSiteIds.add(siteId);

                // Create enriched site data directly from the secure endpoint
                final Map<String, dynamic> enrichedSite = {
                  'id_base_site': siteId,
                  'base_site_name': properties['base_site_name'],
                  'base_site_code': null, // Will be fetched with individual requests
                  'base_site_description': null, // Will be fetched with individual requests
                  'altitude_min': null, // Will be fetched with individual requests
                  'altitude_max': null, // Will be fetched with individual requests
                  'first_use_date': null, // Will be fetched with individual requests
                  'uuid_base_site': null, // Will be fetched with individual requests
                };

                enrichedSites.add(enrichedSite);

                // Create site complement data for storage
                // Use the group ID from the parent group, not from site properties
                
                // Extract module-specific data from site properties (excluding base site fields)
                final Map<String, dynamic> siteSpecificData = Map.from(properties);
                // Remove base site fields that are stored in the main site table
                siteSpecificData.remove('id_base_site');
                siteSpecificData.remove('base_site_name');
                siteSpecificData.remove('base_site_code');
                siteSpecificData.remove('base_site_description');
                siteSpecificData.remove('additional_data_keys');
                
                final complementEntity = SiteComplementEntity(
                  idBaseSite: siteId,
                  idSitesGroup: groupId,
                  data: siteSpecificData.isNotEmpty ? jsonEncode(siteSpecificData) : null,
                );

                siteComplements.add(complementEntity.toDomain());
              }
            }
          }
        }
      }

      // 2. Récupérer les sites directement liés au module (hors groupes) qui ne sont pas déjà traités
      if (moduleData['children'] != null &&
          moduleData['children']['site'] != null) {
        final sitesList = moduleData['children']['site'] as List;
        
        for (var site in sitesList) {
          final siteData = site as Map<String, dynamic>;
          final properties = siteData['properties'] as Map<String, dynamic>;
          final siteId = properties['id_base_site'] ?? siteData['id'];

          if (siteId != null && !moduleSiteIds.contains(siteId)) {
            moduleSiteIds.add(siteId);

            // Create enriched site data directly from the secure endpoint
            final Map<String, dynamic> enrichedSite = {
              'id_base_site': siteId,
              'base_site_name': properties['base_site_name'],
              'base_site_code': null, // Will be fetched with individual requests
              'base_site_description': null, // Will be fetched with individual requests
              'altitude_min': null, // Will be fetched with individual requests
              'altitude_max': null, // Will be fetched with individual requests
              'first_use_date': null, // Will be fetched with individual requests
              'uuid_base_site': null, // Will be fetched with individual requests
            };

            enrichedSites.add(enrichedSite);

            // Create site complement data for storage
            final int? idSitesGroup = properties['id_sites_group'] as int?;
            
            // Extract module-specific data from site properties (excluding base site fields)
            final Map<String, dynamic> siteSpecificData = Map.from(properties);
            // Remove base site fields that are stored in the main site table
            siteSpecificData.remove('id_base_site');
            siteSpecificData.remove('base_site_name');
            siteSpecificData.remove('base_site_code');
            siteSpecificData.remove('base_site_description');
            siteSpecificData.remove('additional_data_keys');
            
            final complementEntity = SiteComplementEntity(
              idBaseSite: siteId,
              idSitesGroup: idSitesGroup,
              data: siteSpecificData.isNotEmpty ? jsonEncode(siteSpecificData) : null,
            );

            siteComplements.add(complementEntity.toDomain());
          }
        }
      }

      // Fetch additional details for each site using individual requests
      await _fetchAdditionalSiteDetails(enrichedSites, moduleCode, token);

      return {
        'enriched_sites': enrichedSites,
        'site_complements': siteComplements,
      };
    } on DioException catch (e) {
      throw NetworkException(
          'Network error while fetching enriched sites: ${e.message}',
          originalDioException: e);
    } catch (e) {
      throw ApiException('Failed to fetch enriched sites: $e');
    }
  }

  /// Fetch additional site details using individual secure requests with depth=0
  Future<void> _fetchAdditionalSiteDetails(
      List<Map<String, dynamic>> enrichedSites, String moduleCode, String token) async {
    for (var site in enrichedSites) {
      try {
        final siteId = site['id_base_site'] as int;
        final response = await dio.get(
          '/monitorings/object/$moduleCode/site/$siteId',
          queryParameters: {
            'depth': 0, // We don't need visits data
          },
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );

        if (response.statusCode == 200) {
          final siteData = response.data as Map<String, dynamic>;
          final properties = siteData['properties'] as Map<String, dynamic>;

          // Update the site with additional details from the secure endpoint
          site['base_site_code'] = properties['base_site_code'];
          site['base_site_description'] = properties['base_site_description'];
          site['altitude_min'] = properties['altitude_min'];
          site['altitude_max'] = properties['altitude_max'];
          site['first_use_date'] = properties['first_use_date'];
          site['uuid_base_site'] = properties['uuid_base_site'];
          
          // Also update geometry if available
          if (siteData['geometry'] != null) {
            site['geometry'] = siteData['geometry'];
          }
        }
      } catch (e) {
        // Keep null values for missing data
      }
    }
  }

  @override
  Future<List<SiteGroupsWithModulesLabel>> fetchSiteGroupsForModule(
      String moduleCode, String token) async {
    try {
      final response = await dio.get(
        '/monitorings/object/$moduleCode/module',
        queryParameters: {
          'depth': 2,
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
          'Network error while fetching site groups: ${e.message}',
          originalDioException: e);
    } catch (e) {
      throw ApiException('Failed to fetch site groups: $e');
    }
  }
}

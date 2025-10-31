import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
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

      // 204 (No Content) signifie qu'il n'y a pas de sites disponibles,
      // mais c'est un cas valide - continuer avec des données vides
      if (moduleResponse.statusCode == 204) {
        final logger = AppLogger();
        logger.i(
          'Module $moduleCode: réponse 204 (No Content) pour les sites. '
          'Aucun site disponible pour ce module.',
          tag: 'sync',
        );
        return {
          'sites': <Map<String, dynamic>>[],
          'site_complements': <Map<String, dynamic>>[],
        };
      }

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
      List<dynamic>? siteGroupsList;
      
      // Try to find site groups in different possible locations
      if (moduleData['children'] != null &&
          moduleData['children']['sites_group'] != null) {
        // Original structure: data.children.sites_group
        siteGroupsList = moduleData['children']['sites_group'] as List;
      } else if (moduleData['sites_group'] != null) {
        // Alternative structure: data.sites_group directly
        siteGroupsList = moduleData['sites_group'] as List;
      } else if (moduleData['properties'] != null && 
                 moduleData['properties']['sites_group'] != null) {
        // Another possible structure: data.properties.sites_group
        siteGroupsList = moduleData['properties']['sites_group'] as List;
      }
      
      if (siteGroupsList != null) {
        
        for (var group in siteGroupsList) {
          final groupData = group as Map<String, dynamic>;
          
          // Extract group properties - handle different structures
          Map<String, dynamic> groupProperties;
          if (groupData['properties'] != null) {
            groupProperties = groupData['properties'] as Map<String, dynamic>;
          } else {
            // If no properties field, use the group data itself
            groupProperties = groupData;
          }
          
          final groupId = groupProperties['id_sites_group'] as int? ??
                         groupData['id_sites_group'] as int? ??
                         groupData['id'] as int? ??
                         0;
          
          // Check if the group has sites - handle different structures
          List<dynamic>? sitesList;
          
          if (groupData['children'] != null &&
              groupData['children']['site'] != null) {
            sitesList = groupData['children']['site'] as List;
          } else if (groupData['site'] != null) {
            sitesList = groupData['site'] as List;
          } else if (groupData['sites'] != null) {
            sitesList = groupData['sites'] as List;
          }
          
          if (sitesList != null) {
            
            for (var site in sitesList) {
              final siteData = site as Map<String, dynamic>;
              
              // Extract site properties - handle different structures
              Map<String, dynamic> properties;
              if (siteData['properties'] != null) {
                properties = siteData['properties'] as Map<String, dynamic>;
              } else {
                // If no properties field, use the site data itself
                properties = siteData;
              }
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
      List<dynamic>? directSitesList;
      
      // Try to find sites in different possible locations
      if (moduleData['children'] != null &&
          moduleData['children']['site'] != null) {
        directSitesList = moduleData['children']['site'] as List;
      } else if (moduleData['site'] != null) {
        directSitesList = moduleData['site'] as List;
      } else if (moduleData['sites'] != null) {
        directSitesList = moduleData['sites'] as List;
      }
      
      if (directSitesList != null) {
        
        for (var site in directSitesList) {
          final siteData = site as Map<String, dynamic>;
          
          // Extract site properties - handle different structures
          Map<String, dynamic> properties;
          if (siteData['properties'] != null) {
            properties = siteData['properties'] as Map<String, dynamic>;
          } else {
            // If no properties field, use the site data itself
            properties = siteData;
          }
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
          
          // Extract site properties - handle different structures
          Map<String, dynamic> properties;
          if (siteData['properties'] != null) {
            properties = siteData['properties'] as Map<String, dynamic>;
          } else {
            // If no properties field, use the site data itself
            properties = siteData;
          }

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

      // 204 (No Content) signifie qu'il n'y a pas de groupes de sites disponibles,
      // mais c'est un cas valide - retourner une liste vide
      if (response.statusCode == 204) {
        final logger = AppLogger();
        logger.i(
          'Module $moduleCode: réponse 204 (No Content) pour les groupes de sites. '
          'Aucun groupe de sites disponible pour ce module.',
          tag: 'sync',
        );
        return <SiteGroupsWithModulesLabel>[];
      }

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final result = <SiteGroupsWithModulesLabel>[];

        // Debug print to understand the response structure
        print('API Response structure for module $moduleCode: ${data.keys.toList()}');
        
        // Handle different API response structures
        List<dynamic>? siteGroupsList;
        
        // Try to find site groups in different possible locations
        if (data['children'] != null &&
            data['children']['sites_group'] != null) {
          // Original structure: data.children.sites_group
          siteGroupsList = data['children']['sites_group'] as List;
          print('Found site groups in children.sites_group: ${siteGroupsList.length} groups');
        } else if (data['sites_group'] != null) {
          // Alternative structure: data.sites_group directly
          siteGroupsList = data['sites_group'] as List;
          print('Found site groups directly in sites_group: ${siteGroupsList.length} groups');
        } else if (data['properties'] != null && 
                   data['properties']['sites_group'] != null) {
          // Another possible structure: data.properties.sites_group
          siteGroupsList = data['properties']['sites_group'] as List;
          print('Found site groups in properties.sites_group: ${siteGroupsList.length} groups');
        } else {
          // No site groups found - this might be normal for modules without site groups
          print('No site groups found for module $moduleCode. Response keys: ${data.keys.toList()}');
          if (data['children'] != null) {
            print('Children keys: ${(data['children'] as Map<String, dynamic>).keys.toList()}');
          }
          if (data['properties'] != null) {
            print('Properties keys: ${(data['properties'] as Map<String, dynamic>).keys.toList()}');
          }
        }
        
        // Process site groups if found
        if (siteGroupsList != null) {
          for (var group in siteGroupsList) {
            try {
              final groupData = group as Map<String, dynamic>;
              
              // Extract properties - handle different structures
              Map<String, dynamic>? properties;
              if (groupData['properties'] != null) {
                properties = groupData['properties'] as Map<String, dynamic>;
              } else {
                // If no properties field, use the group data itself
                properties = groupData;
              }

              // Extract site group data from the properties
              final Map<String, dynamic> formattedGroupData = {
                'id_sites_group': properties['id_sites_group'] ?? 
                                 groupData['id_sites_group'] ?? 
                                 groupData['id'] ??
                                 groupData['id_group'],
                'sites_group_name': properties['sites_group_name'] ?? 
                                   groupData['sites_group_name'] ?? 
                                   groupData['name'] ?? 
                                   '',
                'sites_group_code': properties['sites_group_code'] ?? 
                                   groupData['sites_group_code'] ?? 
                                   groupData['code'] ?? 
                                   '',
                'comments': properties['comments'] ?? groupData['comments'],
                'nb_sites': properties['nb_sites'] ?? groupData['nb_sites'],
                'nb_visits': properties['nb_visits'] ?? groupData['nb_visits'],
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
            } catch (e) {
              print('Error processing site group: $e');
              print('Group data: $group');
            }
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

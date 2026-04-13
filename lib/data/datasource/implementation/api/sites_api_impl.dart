import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/api_exception.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/base_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/sites_api.dart';
import 'package:gn_mobile_monitoring/data/entity/site_complement_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/site_group_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/site_groups_with_modules.dart';
import 'package:gn_mobile_monitoring/data/mapper/site_complement_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

class SitesApiImpl extends BaseApi implements SitesApi {
  final Connectivity _connectivity;

  SitesApiImpl({Connectivity? connectivity, Dio? dio})
      : _connectivity = connectivity ?? Connectivity(),
        super(dio: dio);

  @override
  Dio get dio => createDio(
        receiveTimeout: const Duration(
            seconds: 300), // 5 minutes pour les grosses quantités de données
        sendTimeout: const Duration(seconds: 120),
      );

  @override
  Future<Map<String, dynamic>> fetchEnrichedSitesForModule(
      String moduleCode, String token) async {
    try {
      // @since monitoring 0.1.0
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
                  'base_site_code':
                      null, // Will be fetched with individual requests
                  'base_site_description':
                      null, // Will be fetched with individual requests
                  'altitude_min':
                      null, // Will be fetched with individual requests
                  'altitude_max':
                      null, // Will be fetched with individual requests
                  'first_use_date':
                      null, // Will be fetched with individual requests
                  'uuid_base_site':
                      null, // Will be fetched with individual requests
                  'geometry': null,
                };

                enrichedSites.add(enrichedSite);

                // Create site complement data for storage
                // Use the group ID from the parent group, not from site properties

                // Extract module-specific data from site properties (excluding base site fields)
                final Map<String, dynamic> siteSpecificData =
                    Map.from(properties);
                // Remove base site fields that are stored in the main site table
                siteSpecificData.remove('id_base_site');
                siteSpecificData.remove('base_site_name');
                siteSpecificData.remove('base_site_code');
                siteSpecificData.remove('base_site_description');
                siteSpecificData.remove('additional_data_keys');

                final complementEntity = SiteComplementEntity(
                  idBaseSite: siteId,
                  idSitesGroup: groupId,
                  data: siteSpecificData.isNotEmpty
                      ? jsonEncode(siteSpecificData)
                      : null,
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
              'base_site_code':
                  null, // Will be fetched with individual requests
              'base_site_description':
                  null, // Will be fetched with individual requests
              'altitude_min': null, // Will be fetched with individual requests
              'altitude_max': null, // Will be fetched with individual requests
              'first_use_date':
                  null, // Will be fetched with individual requests
              'uuid_base_site':
                  null, // Will be fetched with individual requests
              'geometry': null,
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
              data: siteSpecificData.isNotEmpty
                  ? jsonEncode(siteSpecificData)
                  : null,
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
      List<Map<String, dynamic>> enrichedSites,
      String moduleCode,
      String token) async {
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

          // Also update geometry if available (convert from Map to JSON string)
          if (siteData['geometry'] != null) {
            final geometryData = siteData['geometry'];
            if (geometryData is Map<String, dynamic>) {
              site['geom'] = jsonEncode(geometryData);
            } else if (geometryData is String) {
              site['geom'] = geometryData;
            }
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
      // @since monitoring 1.2.0
      final response = await dio.get(
        '/monitorings/refacto/$moduleCode/sites_groups',
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

        print(
            'API Response for site groups module $moduleCode: ${data.keys.toList()}');

        // Extract site groups from the items array
        final items = data['items'] as List?;
        if (items != null) {
          print('Found ${items.length} site groups for module $moduleCode');

          for (var item in items) {
            try {
              final groupData = item as Map<String, dynamic>;
              final groupId = groupData['id_sites_group'];

              // Fetch individual site group to get complete data including 'data' field
              final detailedGroupData = await _fetchDetailedSiteGroup(
                moduleCode,
                groupId,
                token,
              );

              if (detailedGroupData != null) {
                result.add(SiteGroupsWithModulesLabel(
                  siteGroup: SiteGroupEntity.fromJson(detailedGroupData),
                  moduleLabelList: [moduleCode],
                ));
              }
            } catch (e) {
              print('Error processing site group: $e');
              print('Group data: $item');
            }
          }
        } else {
          print(
              'No items found in site groups response for module $moduleCode');
        }

        return result;
      }

      throw ApiException(
        'Failed to fetch site groups for module $moduleCode',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      // 403 = le module ne supporte pas les groupes de sites
      if (e.response?.statusCode == 403) {
        final logger = AppLogger();
        logger.i(
          'Module $moduleCode: 403 pour les groupes de sites. '
          'Ce module ne supporte probablement pas les groupes de sites.',
          tag: 'sync',
        );
        return <SiteGroupsWithModulesLabel>[];
      }
      throw NetworkException(
          'Network error while fetching site groups: ${e.message}',
          originalDioException: e);
    } catch (e) {
      throw ApiException('Failed to fetch site groups: $e');
    }
  }

  /// Fetch detailed site group data including 'data' field
  Future<Map<String, dynamic>?> _fetchDetailedSiteGroup(
      String moduleCode, int groupId, String token) async {
    try {
      // @since monitoring 1.2.0
      final response = await dio.get(
        '/monitorings/sites_groups/$moduleCode/$groupId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final groupData = response.data as Map<String, dynamic>;

        // Convert the complete API response to our format
        final Map<String, dynamic> formattedGroupData = {
          'id_sites_group': groupData['id_sites_group'],
          'sites_group_name': groupData['sites_group_name'],
          'sites_group_code': groupData['sites_group_code'],
          'sites_group_description': groupData['sites_group_description'],
          'uuid_sites_group': groupData['uuid_sites_group'],
          'comments': groupData['comments'],
          'id_digitiser': groupData['id_digitiser'],
          'altitude_min': groupData['altitude_min'],
          'altitude_max': groupData['altitude_max'],
          // Handle geometry with SRID prefix for site groups
          'geom': groupData['geometry'] != null
              ? (groupData['geometry'] is Map<String, dynamic>
                  ? jsonEncode(groupData['geometry'])
                  : groupData['geometry'].toString())
              : null,
          // Use the 'data' field from the detailed response
          'data': groupData['data'] ?? {},
        };

        print(
            'Creating detailed SiteGroupEntity from: ${formattedGroupData.keys.toList()}');

        return formattedGroupData;
      }
    } catch (e) {
      print('Error fetching detailed site group $groupId: $e');
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> sendSite(
      String token, String moduleCode, BaseSite site, {int? moduleId}) async {
    try {
      final logger = AppLogger();

      // Vérifier la connectivité
      final connectivityResults = await _connectivity.checkConnectivity();
      if (connectivityResults.contains(ConnectivityResult.none) ||
          connectivityResults.isEmpty) {
        logger.e('[API] ERREUR RÉSEAU: Aucune connexion Internet disponible',
            tag: 'sync');
        throw NetworkException('Aucune connexion réseau disponible');
      }

      // Préparer le corps de la requête au format GeoJSON Feature attendu par l'API
      final Map<String, dynamic> requestBody = {
        'type': 'Feature',
        'properties': {
          'base_site_name': site.baseSiteName,
          'base_site_code': site.baseSiteCode,
          'base_site_description': site.baseSiteDescription,
          'altitude_min': site.altitudeMin,
          'altitude_max': site.altitudeMax,
          'first_use_date': site.firstUseDate?.toIso8601String(),
          if (site.idInventor != null) 'id_inventor': site.idInventor,
          if (site.idDigitiser != null) 'id_digitiser': site.idDigitiser,
        },
      };

      // Ajouter module_code au niveau supérieur
      requestBody['module_code'] = moduleCode;

      // Associer le site au module via cor_site_module
      if (moduleId != null) {
        (requestBody['properties'] as Map<String, dynamic>)['modules'] = [moduleId];
      }

      // Ajouter la géométrie (toujours inclure la clé, même null, car le serveur
      // fait post_data["geometry"] au lieu de post_data.get("geometry"))
      if (site.geom != null && site.geom!.isNotEmpty) {
        try {
          final geomMap = jsonDecode(site.geom!);
          requestBody['geometry'] = geomMap;
        } catch (e) {
          logger.w('[API] Géométrie invalide ignorée: ${site.geom}', tag: 'sync');
          requestBody['geometry'] = null;
        }
      } else {
        requestBody['geometry'] = null;
      }

      // Ajouter les données complémentaires si disponibles
      if (site.data != null && site.data!.isNotEmpty) {
        final properties = requestBody['properties'] as Map<String, dynamic>;
        site.data!.forEach((key, value) {
          if (value == null) return; // Ignorer les valeurs nulles
          // Si c'est un objet nomenclature (Map avec un champ 'id'), extraire l'ID
          if (value is Map<String, dynamic> && value.containsKey('id')) {
            properties[key] = value['id'];
          } else {
            properties[key] = value;
          }
        });
      }

      // Log détaillé pour le débogage
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln('[API] ENVOI SITE AU SERVEUR');
      logBuffer.writeln(
          '==================================================================');
      logBuffer.writeln('URL: $apiBase/monitorings/object/$moduleCode/site');
      logBuffer.writeln('MÉTHODE: POST');

      if (token.length > 10) {
        logBuffer.writeln(
            'HEADERS: Authorization: Bearer ${token.substring(0, 10)}...[MASQUÉ]');
      } else {
        logBuffer.writeln('HEADERS: Authorization: Bearer [MASQUÉ]');
      }

      logBuffer.writeln('BODY:');
      logBuffer.writeln(
          '------------------------------------------------------------------');
      logBuffer.writeln(const JsonEncoder.withIndent('  ').convert(requestBody));

      logger.i(logBuffer.toString(), tag: 'sync');

      // Envoyer la requête
      final response = await dio.post(
        '/monitorings/object/$moduleCode/site',
        data: requestBody,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      // Log de la réponse
      logBuffer = StringBuffer();
      logBuffer.writeln('\n[API] RÉPONSE SERVEUR (${response.statusCode})');
      logBuffer.writeln(
          '------------------------------------------------------------------');
      if (response.data is Map || response.data is List) {
        logBuffer
            .writeln(const JsonEncoder.withIndent('  ').convert(response.data));
      } else {
        logBuffer.writeln(response.data.toString());
      }
      logBuffer.writeln(
          '==================================================================');

      logger.i(logBuffer.toString(), tag: 'sync');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
            'Erreur lors de l\'envoi du site. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final logger = AppLogger();

      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln('[API] ERREUR DIO LORS DE L\'ENVOI DU SITE');
      logBuffer.writeln(
          '==================================================================');
      logBuffer.writeln('Type: ${e.type}');
      logBuffer.writeln('Message: ${e.message}');
      logBuffer.writeln('URL: ${e.requestOptions.uri}');
      logBuffer.writeln('Méthode: ${e.requestOptions.method}');

      if (e.response != null) {
        logBuffer.writeln('\nRÉPONSE ERREUR:');
        logBuffer.writeln('Status code: ${e.response?.statusCode}');
        if (e.response?.data != null) {
          if (e.response?.data is Map || e.response?.data is List) {
            logBuffer.writeln(
                const JsonEncoder.withIndent('  ').convert(e.response?.data));
          } else {
            logBuffer.writeln(e.response?.data.toString());
          }
        }
      }

      logBuffer.writeln(
          '==================================================================');

      logger.e(logBuffer.toString(), tag: 'sync', error: e);

      String completeErrorMessage =
          'Erreur réseau lors de l\'envoi du site: ${e.message}';

      if (e.response?.data != null) {
        String responseData = e.response!.data.toString();
        if (responseData.isNotEmpty) {
          completeErrorMessage += '\n\nDétails du serveur:\n$responseData';
        }
      }

      throw NetworkException(completeErrorMessage, originalDioException: e);
    } catch (e, stackTrace) {
      final logger = AppLogger();

      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln('[API] ERREUR GÉNÉRALE LORS DE L\'ENVOI DU SITE');
      logBuffer.writeln(
          '==================================================================');
      logBuffer.writeln('Type: ${e.runtimeType}');
      logBuffer.writeln('Message: $e');
      logBuffer.writeln('\nSTACK TRACE:');
      logBuffer.writeln(stackTrace);
      logBuffer.writeln(
          '==================================================================');

      logger.e(logBuffer.toString(),
          tag: 'sync', error: e, stackTrace: stackTrace);

      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateSite(
      String token, String moduleCode, int siteId, BaseSite site) async {
    try {
      final logger = AppLogger();

      // Vérifier la connectivité
      final connectivityResults = await _connectivity.checkConnectivity();
      if (connectivityResults.contains(ConnectivityResult.none) ||
          connectivityResults.isEmpty) {
        logger.e('[API] ERREUR RÉSEAU: Aucune connexion Internet disponible',
            tag: 'sync');
        throw NetworkException('Aucune connexion réseau disponible');
      }

      // Préparer le corps de la requête au format GeoJSON Feature attendu par l'API
      final Map<String, dynamic> requestBody = {
        'type': 'Feature',
        'properties': {
          'base_site_name': site.baseSiteName,
          'base_site_code': site.baseSiteCode,
          'base_site_description': site.baseSiteDescription,
          'altitude_min': site.altitudeMin,
          'altitude_max': site.altitudeMax,
          'first_use_date': site.firstUseDate?.toIso8601String(),
          if (site.idInventor != null) 'id_inventor': site.idInventor,
          if (site.idDigitiser != null) 'id_digitiser': site.idDigitiser,
        },
      };

      // Ajouter module_code au niveau supérieur
      requestBody['module_code'] = moduleCode;

      // Ajouter la géométrie si disponible
      if (site.geom != null && site.geom!.isNotEmpty) {
        try {
          final geomMap = jsonDecode(site.geom!);
          requestBody['geometry'] = geomMap;
        } catch (e) {
          logger.w('[API] Géométrie invalide ignorée: ${site.geom}', tag: 'sync');
        }
      }

      // Ajouter les données complémentaires si disponibles
      if (site.data != null && site.data!.isNotEmpty) {
        final properties = requestBody['properties'] as Map<String, dynamic>;
        site.data!.forEach((key, value) {
          if (value == null) return; // Ignorer les valeurs nulles
          // Si c'est un objet nomenclature (Map avec un champ 'id'), extraire l'ID
          if (value is Map<String, dynamic> && value.containsKey('id')) {
            properties[key] = value['id'];
          } else {
            properties[key] = value;
          }
        });
      }

      // Log détaillé pour le débogage
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln('[API] MISE À JOUR SITE AU SERVEUR');
      logBuffer.writeln(
          '==================================================================');
      logBuffer
          .writeln('URL: $apiBase/monitorings/object/$moduleCode/site/$siteId');
      logBuffer.writeln('MÉTHODE: PATCH');

      if (token.length > 10) {
        logBuffer.writeln(
            'HEADERS: Authorization: Bearer ${token.substring(0, 10)}...[MASQUÉ]');
      } else {
        logBuffer.writeln('HEADERS: Authorization: Bearer [MASQUÉ]');
      }

      logBuffer.writeln('BODY:');
      logBuffer.writeln(
          '------------------------------------------------------------------');
      logBuffer.writeln(const JsonEncoder.withIndent('  ').convert(requestBody));

      logger.i(logBuffer.toString(), tag: 'sync');

      // Envoyer la requête PATCH
      final response = await dio.patch(
        '/monitorings/object/$moduleCode/site/$siteId',
        data: requestBody,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      // Log de la réponse
      logBuffer = StringBuffer();
      logBuffer.writeln('\n[API] RÉPONSE SERVEUR (${response.statusCode})');
      logBuffer.writeln(
          '------------------------------------------------------------------');
      if (response.data is Map || response.data is List) {
        logBuffer
            .writeln(const JsonEncoder.withIndent('  ').convert(response.data));
      } else {
        logBuffer.writeln(response.data.toString());
      }
      logBuffer.writeln(
          '==================================================================');

      logger.i(logBuffer.toString(), tag: 'sync');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
            'Erreur lors de la mise à jour du site. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final logger = AppLogger();

      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln('[API] ERREUR DIO LORS DE LA MISE À JOUR DU SITE');
      logBuffer.writeln(
          '==================================================================');
      logBuffer.writeln('Type: ${e.type}');
      logBuffer.writeln('Message: ${e.message}');
      logBuffer.writeln('URL: ${e.requestOptions.uri}');
      logBuffer.writeln('Méthode: ${e.requestOptions.method}');

      if (e.response != null) {
        logBuffer.writeln('\nRÉPONSE ERREUR:');
        logBuffer.writeln('Status code: ${e.response?.statusCode}');
        if (e.response?.data != null) {
          if (e.response?.data is Map || e.response?.data is List) {
            logBuffer.writeln(
                const JsonEncoder.withIndent('  ').convert(e.response?.data));
          } else {
            logBuffer.writeln(e.response?.data.toString());
          }
        }
      }

      logBuffer.writeln(
          '==================================================================');

      logger.e(logBuffer.toString(), tag: 'sync', error: e);

      String completeErrorMessage =
          'Erreur réseau lors de la mise à jour du site: ${e.message}';

      if (e.response?.data != null) {
        String responseData = e.response!.data.toString();
        if (responseData.isNotEmpty) {
          completeErrorMessage += '\n\nDétails du serveur:\n$responseData';
        }
      }

      throw NetworkException(completeErrorMessage, originalDioException: e);
    } catch (e, stackTrace) {
      final logger = AppLogger();

      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln('[API] ERREUR GÉNÉRALE LORS DE LA MISE À JOUR DU SITE');
      logBuffer.writeln(
          '==================================================================');
      logBuffer.writeln('Type: ${e.runtimeType}');
      logBuffer.writeln('Message: $e');
      logBuffer.writeln('\nSTACK TRACE:');
      logBuffer.writeln(stackTrace);
      logBuffer.writeln(
          '==================================================================');

      logger.e(logBuffer.toString(),
          tag: 'sync', error: e, stackTrace: stackTrace);

      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> sendSiteGroup(
      String token, String moduleCode, SiteGroup siteGroup, {int? moduleId}) async {
    try {
      final logger = AppLogger();

      // Vérifier la connectivité
      final connectivityResults = await _connectivity.checkConnectivity();
      if (connectivityResults.contains(ConnectivityResult.none) ||
          connectivityResults.isEmpty) {
        logger.e('[API] ERREUR RÉSEAU: Aucune connexion Internet disponible',
            tag: 'sync');
        throw NetworkException('Aucune connexion réseau disponible');
      }

      // Préparer le corps de la requête au format GeoJSON Feature
      final Map<String, dynamic> requestBody = {
        'type': 'Feature',
        'properties': {
          'sites_group_name': siteGroup.sitesGroupName,
          'sites_group_code': siteGroup.sitesGroupCode,
          'sites_group_description': siteGroup.sitesGroupDescription,
          'comments': siteGroup.comments,
          'altitude_min': siteGroup.altitudeMin,
          'altitude_max': siteGroup.altitudeMax,
        },
      };

      // Ajouter module_code au niveau supérieur (requis par l'API)
      requestBody['module_code'] = moduleCode;

      // Associer le groupe au module via cor_sites_group_module
      if (moduleId != null) {
        (requestBody['properties'] as Map<String, dynamic>)['modules'] = [moduleId];
      }

      // Ajouter la géométrie (toujours inclure la clé, même null, car le serveur
      // fait post_data["geometry"] au lieu de post_data.get("geometry"))
      if (siteGroup.geom != null && siteGroup.geom!.isNotEmpty) {
        try {
          final geomMap = jsonDecode(siteGroup.geom!);
          requestBody['geometry'] = geomMap;
        } catch (e) {
          logger.w('[API] Géométrie invalide ignorée: ${siteGroup.geom}',
              tag: 'sync');
          requestBody['geometry'] = null;
        }
      } else {
        requestBody['geometry'] = null;
      }

      // Ajouter les données complémentaires si disponibles
      if (siteGroup.data != null && siteGroup.data!.isNotEmpty) {
        try {
          final dataMap = jsonDecode(siteGroup.data!) as Map<String, dynamic>;
          final properties = requestBody['properties'] as Map<String, dynamic>;
          dataMap.forEach((key, value) {
            if (value == null) return;
            if (value is Map<String, dynamic> && value.containsKey('id')) {
              properties[key] = value['id'];
            } else {
              properties[key] = value;
            }
          });
        } catch (e) {
          logger.w('[API] Données complémentaires invalides ignorées: ${siteGroup.data}',
              tag: 'sync');
        }
      }

      // Log détaillé pour le débogage
      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln('[API] ENVOI GROUPE DE SITES AU SERVEUR');
      logBuffer.writeln(
          '==================================================================');
      logBuffer.writeln(
          'URL: $apiBase/monitorings/object/$moduleCode/sites_group');
      logBuffer.writeln('MÉTHODE: POST');

      if (token.length > 10) {
        logBuffer.writeln(
            'HEADERS: Authorization: Bearer ${token.substring(0, 10)}...[MASQUÉ]');
      } else {
        logBuffer.writeln('HEADERS: Authorization: Bearer [MASQUÉ]');
      }

      logBuffer.writeln('BODY:');
      logBuffer.writeln(
          '------------------------------------------------------------------');
      logBuffer.writeln(
          const JsonEncoder.withIndent('  ').convert(requestBody));

      logger.i(logBuffer.toString(), tag: 'sync');

      // Envoyer la requête
      final response = await dio.post(
        '/monitorings/object/$moduleCode/sites_group',
        data: requestBody,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      // Log de la réponse
      logBuffer = StringBuffer();
      logBuffer.writeln('\n[API] RÉPONSE SERVEUR (${response.statusCode})');
      logBuffer.writeln(
          '------------------------------------------------------------------');
      if (response.data is Map || response.data is List) {
        logBuffer.writeln(
            const JsonEncoder.withIndent('  ').convert(response.data));
      } else {
        logBuffer.writeln(response.data.toString());
      }
      logBuffer.writeln(
          '==================================================================');

      logger.i(logBuffer.toString(), tag: 'sync');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
            'Erreur lors de l\'envoi du groupe de sites. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final logger = AppLogger();

      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln('[API] ERREUR DIO LORS DE L\'ENVOI DU GROUPE DE SITES');
      logBuffer.writeln(
          '==================================================================');
      logBuffer.writeln('Type: ${e.type}');
      logBuffer.writeln('Message: ${e.message}');
      logBuffer.writeln('URL: ${e.requestOptions.uri}');
      logBuffer.writeln('Méthode: ${e.requestOptions.method}');

      if (e.response != null) {
        logBuffer.writeln('\nRÉPONSE ERREUR:');
        logBuffer.writeln('Status code: ${e.response?.statusCode}');
        if (e.response?.data != null) {
          if (e.response?.data is Map || e.response?.data is List) {
            logBuffer.writeln(
                const JsonEncoder.withIndent('  ').convert(e.response?.data));
          } else {
            logBuffer.writeln(e.response?.data.toString());
          }
        }
      }

      logBuffer.writeln(
          '==================================================================');

      logger.e(logBuffer.toString(), tag: 'sync', error: e);

      String completeErrorMessage =
          'Erreur réseau lors de l\'envoi du groupe de sites: ${e.message}';

      if (e.response?.data != null) {
        String responseData = e.response!.data.toString();
        if (responseData.isNotEmpty) {
          completeErrorMessage += '\n\nDétails du serveur:\n$responseData';
        }
      }

      throw NetworkException(completeErrorMessage, originalDioException: e);
    } catch (e, stackTrace) {
      final logger = AppLogger();

      StringBuffer logBuffer = StringBuffer();
      logBuffer.writeln(
          '\n==================================================================');
      logBuffer.writeln(
          '[API] ERREUR GÉNÉRALE LORS DE L\'ENVOI DU GROUPE DE SITES');
      logBuffer.writeln(
          '==================================================================');
      logBuffer.writeln('Type: ${e.runtimeType}');
      logBuffer.writeln('Message: $e');
      logBuffer.writeln('\nSTACK TRACE:');
      logBuffer.writeln(stackTrace);
      logBuffer.writeln(
          '==================================================================');

      logger.e(logBuffer.toString(),
          tag: 'sync', error: e, stackTrace: stackTrace);

      rethrow;
    }
  }
}

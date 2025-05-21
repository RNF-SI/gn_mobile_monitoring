import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/api_exception.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/sites_api.dart';
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
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(
              seconds: 300), // 5 minutes pour les grosses quantités de données
          sendTimeout: const Duration(seconds: 120),
        ));

  @override
  Future<Map<String, dynamic>> fetchEnrichedSitesForModule(
      String moduleCode, String token) async {
    try {
      // Récupérer d'abord l'ID du module à partir de son code
      final moduleResponse = await _dio.get(
        '/monitorings/object/$moduleCode/module',
        queryParameters: {
          'depth': 0,
          'field_name': 'module_code',
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (moduleResponse.statusCode != 200) {
        throw ApiException(
          'Failed to fetch module info for $moduleCode',
          statusCode: moduleResponse.statusCode,
        );
      }

      final moduleData = moduleResponse.data as Map<String, dynamic>;
      final int? moduleId =
          moduleData['properties']?['id_module'] ?? moduleData['id'];

      if (moduleId == null) {
        throw ApiException(
            'Could not extract module ID from response for module $moduleCode');
      }

      print('Found module ID $moduleId for module code $moduleCode');

      // Utiliser la nouvelle requête avec pagination pour récupérer TOUS les sites
      final List<dynamic> allSitesData = [];
      int currentPage = 1;
      int totalCount = 0;
      const int pageSize = 100; // Taille de page optimisée
      
      // Boucle de pagination pour récupérer tous les sites
      do {
        print('Fetching page $currentPage for module $moduleCode...');
        
        final sitesResponse = await _dio.get(
          '/monitorings/sites',
          queryParameters: {
            'modules': moduleId.toString(),
            'page': currentPage,
            'limit': pageSize,
            'sort': 'id_base_site', // Tri consistant pour la pagination
            'sort_dir': 'asc',
          },
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );

        if (sitesResponse.statusCode != 200) {
          throw ApiException(
            'Failed to fetch sites page $currentPage for module $moduleCode',
            statusCode: sitesResponse.statusCode,
          );
        }

        final Map<String, dynamic> responseData = sitesResponse.data;
        final List<dynamic> pageItems = responseData['items'] ?? [];
        totalCount = responseData['count'] ?? 0;
        final int currentLimit = responseData['limit'] ?? pageSize;
        final int currentPageNum = responseData['page'] ?? currentPage;
        
        print('Page $currentPageNum: ${pageItems.length} sites retrieved (limit: $currentLimit)');
        
        // Ajouter les sites de cette page à la liste totale
        allSitesData.addAll(pageItems);
        
        // Passer à la page suivante
        currentPage++;
        
        // Continuer tant qu'on a récupéré une page complète
        // Si la page contient moins d'éléments que la limite, c'est la dernière page
        if (pageItems.length < pageSize) {
          print('Last page reached (${pageItems.length} < $pageSize items)');
          break;
        }
        
      } while (true);

      print('Pagination completed: $totalCount sites total, ${allSitesData.length} sites retrieved for module $moduleCode');

      final List<Map<String, dynamic>> enrichedSites = [];
      final List<SiteComplement> siteComplements = [];
      int sitesWithCreatePermission = 0;

      // Traiter tous les sites et filtrer ceux avec permission "C" (création de visites)
      for (var siteData in allSitesData) {
        final Map<String, dynamic> site = siteData as Map<String, dynamic>;
        final Map<String, dynamic>? cruved =
            site['cruved'] as Map<String, dynamic>?;

        // Vérifier si l'utilisateur a le droit de créer des visites sur ce site
        final bool canCreateVisits = cruved?['C'] == true;

        if (canCreateVisits) {
          sitesWithCreatePermission++;

          // Créer les données enrichies du site
          final Map<String, dynamic> enrichedSite = {
            'id_base_site': site['id_base_site'],
            'base_site_name': site['base_site_name'],
            'base_site_code': site['base_site_code'],
            'base_site_description': site['base_site_description'],
            'altitude_min': site['altitude_min'],
            'altitude_max': site['altitude_max'],
            'first_use_date': site['first_use_date'],
            'uuid_base_site': site['uuid_base_site'],
            // 'geometry': site['geometry'], // Inclure la géométrie si disponible
          };

          enrichedSites.add(enrichedSite);

          // Créer les données de complément de site
          final int siteId = site['id_base_site'] as int;
          final int? idSitesGroup = site['id_sites_group'] as int?;
          final Map<String, dynamic>? siteDataField =
              site['data'] as Map<String, dynamic>?;

          // Créer l'entité puis la convertir en modèle de domaine
          final complementEntity = SiteComplementEntity(
            idBaseSite: siteId,
            idSitesGroup: idSitesGroup,
            data: siteDataField != null ? jsonEncode(siteDataField) : null,
          );

          siteComplements.add(complementEntity.toDomain());
        }
      }

      print(
          'Filtered to $sitesWithCreatePermission sites with create permission out of ${allSitesData.length} total sites');

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

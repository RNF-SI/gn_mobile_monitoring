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
      final logger = AppLogger();
      final dioInstance = createDio(receiveTimeout: const Duration(seconds: 60));
      final headers = {'Authorization': 'Bearer $token'};

      // Un seul appel : /refacto/<code>/sites renvoie déjà tous les champs par
      // site (base_site_*, altitudes, geometry, id_sites_group, meta_*, etc.)
      // dans une enveloppe {count, items[], limit, page}.
      // limit=100000 contourne le limit par défaut (50) côté backend.
      final response = await dioInstance.get(
        '/monitorings/refacto/$moduleCode/sites',
        queryParameters: {'limit': 100000},
        options: Options(headers: headers),
      );

      if (response.statusCode == 204) {
        logger.i(
          'Module $moduleCode: réponse 204 (No Content) pour les sites. '
          'Aucun site disponible pour ce module.',
          tag: 'sync',
        );
        return {
          'enriched_sites': <Map<String, dynamic>>[],
          'site_complements': <SiteComplement>[],
        };
      }

      if (response.statusCode != 200) {
        throw ApiException(
          'Failed to fetch sites for module $moduleCode',
          statusCode: response.statusCode,
        );
      }

      final data = response.data as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>?) ?? const [];
      final serverCount = data['count'] as int?;

      // Détecte une troncature silencieuse : le serveur indique avoir plus de
      // sites qu'il n'en renvoie (limit trop basse).
      if (serverCount != null && serverCount > items.length) {
        logger.w(
          'Module $moduleCode: $serverCount sites côté serveur, '
          'seulement ${items.length} reçus. Vérifier le paramètre limit.',
          tag: 'sync',
        );
      }

      final List<Map<String, dynamic>> enrichedSites = [];
      final List<SiteComplement> siteComplements = [];

      for (final item in items.whereType<Map<String, dynamic>>()) {
        final siteId = item['id_base_site'] as int?;
        if (siteId == null) continue;

        // BaseSiteEntity.fromJson accepte `geometry` (Map ou String) ou `geom`
        enrichedSites.add({
          'id_base_site': siteId,
          'base_site_name': item['base_site_name'],
          'base_site_code': item['base_site_code'],
          'base_site_description': item['base_site_description'],
          'altitude_min': item['altitude_min'],
          'altitude_max': item['altitude_max'],
          'first_use_date': item['first_use_date'],
          'uuid_base_site': item['uuid_base_site'],
          'geometry': item['geometry'],
        });

        final idSitesGroup = item['id_sites_group'] as int?;
        final siteSpecificData = Map<String, dynamic>.from(item);
        siteSpecificData.remove('id_base_site');
        siteSpecificData.remove('base_site_name');
        siteSpecificData.remove('base_site_code');
        siteSpecificData.remove('base_site_description');
        siteSpecificData.remove('additional_data_keys');

        siteComplements.add(SiteComplementEntity(
          idBaseSite: siteId,
          idSitesGroup: idSitesGroup,
          data: siteSpecificData.isNotEmpty
              ? jsonEncode(siteSpecificData)
              : null,
        ).toDomain());
      }

      logger.i(
        'Module $moduleCode: ${enrichedSites.length} sites récupérés.',
        tag: 'sync',
      );

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

  /// Clés « standards » du modèle TMonitoringSitesGroups côté backend.
  /// Toute clé top-level de la réponse /refacto/ qui ne figure pas ici est
  /// considérée comme un attribut spécifique du module (aplati par
  /// add_specific_attributes côté backend) et ré-injectée dans `data`.
  static const _standardSiteGroupKeys = <String>{
    'id_sites_group',
    'sites_group_name',
    'sites_group_code',
    'sites_group_description',
    'uuid_sites_group',
    'comments',
    'id_digitiser',
    'altitude_min',
    'altitude_max',
    'geometry',
    'meta_create_date',
    'meta_update_date',
    // Métadonnées de la réponse (pas des colonnes du modèle)
    'pk',
    'cruved',
    'is_geom_from_child',
    'medias',
    'modules',
    'nb_sites',
    'nb_visits',
  };

  @override
  Future<List<SiteGroupsWithModulesLabel>> fetchSiteGroupsForModule(
      String moduleCode, String token) async {
    // /refacto/<code>/sites_groups renvoie `{count, items, limit, page}` avec
    // toutes les colonnes standard + les attributs spécifiques du module
    // aplatis au top-level. On reconstitue le champ `data` côté Dart et on
    // n'a plus besoin du fetch unitaire N+1 qui saturait le serveur de Gil.
    const pageSize = 100;
    final logger = AppLogger();
    final result = <SiteGroupsWithModulesLabel>[];

    try {
      var page = 1;
      int? serverCount;

      while (true) {
        final response = await dio.get(
          '/monitorings/refacto/$moduleCode/sites_groups',
          queryParameters: {'limit': pageSize, 'page': page},
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );

        if (response.statusCode == 204) {
          logger.i(
            'Module $moduleCode: réponse 204 pour les groupes de sites.',
            tag: 'sync',
          );
          return <SiteGroupsWithModulesLabel>[];
        }

        if (response.statusCode != 200) {
          throw ApiException(
            'Failed to fetch site groups for module $moduleCode',
            statusCode: response.statusCode,
          );
        }

        final data = response.data as Map<String, dynamic>;
        serverCount ??= data['count'] as int?;
        final items = (data['items'] as List?) ?? const [];

        for (final item in items.whereType<Map<String, dynamic>>()) {
          final built = _buildSiteGroupFromRefactoItem(item, moduleCode);
          if (built != null) result.add(built);
        }

        // Sortie : page vide (fin) ou compte total atteint
        if (items.isEmpty) break;
        if (serverCount != null && result.length >= serverCount) break;
        // Garde-fou : une page incomplète signale la fin (certains backends
        // n'ont pas de `count` fiable).
        if (items.length < pageSize) break;

        page++;
        if (page > 1000) {
          logger.w(
            'Module $moduleCode: pagination interrompue après 1000 pages '
            '(sécurité). Groupes récupérés: ${result.length}.',
            tag: 'sync',
          );
          break;
        }
      }

      logger.i(
        'Module $moduleCode: ${result.length} groupes de sites récupérés '
        '${serverCount != null ? "(serveur: $serverCount)" : ""}.',
        tag: 'sync',
      );
      return result;
    } on DioException catch (e) {
      // 403 = le module ne supporte pas les groupes de sites
      if (e.response?.statusCode == 403) {
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

  /// Construit un SiteGroupsWithModulesLabel à partir d'un item de /refacto/.
  /// Les clés non-standards (attributs spécifiques du module, aplatis par le
  /// backend) sont recollées dans un Map `data` pour compatibilité avec
  /// SiteGroupEntity.fromJson.
  SiteGroupsWithModulesLabel? _buildSiteGroupFromRefactoItem(
      Map<String, dynamic> item, String moduleCode) {
    try {
      final dynamicData = <String, dynamic>{};
      for (final entry in item.entries) {
        if (!_standardSiteGroupKeys.contains(entry.key)) {
          dynamicData[entry.key] = entry.value;
        }
      }

      final formattedGroupData = <String, dynamic>{
        'id_sites_group': item['id_sites_group'],
        'sites_group_name': item['sites_group_name'],
        'sites_group_code': item['sites_group_code'],
        'sites_group_description': item['sites_group_description'],
        'uuid_sites_group': item['uuid_sites_group'],
        'comments': item['comments'],
        'id_digitiser': item['id_digitiser'],
        'altitude_min': item['altitude_min'],
        'altitude_max': item['altitude_max'],
        // SiteGroupEntity.fromJson accepte `geometry` (Map ou String) ou `geom`
        'geometry': item['geometry'],
        'data': dynamicData,
      };

      return SiteGroupsWithModulesLabel(
        siteGroup: SiteGroupEntity.fromJson(formattedGroupData),
        moduleLabelList: [moduleCode],
      );
    } catch (e) {
      AppLogger().w(
        'Module $moduleCode: échec parsing d\'un groupe depuis /refacto/: $e',
        tag: 'sync',
      );
      return null;
    }
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
            // `modules` est géré explicitement plus haut (properties.modules =
            // [moduleId]) et on a vu en prod que la valeur stockée en DB
            // locale peut être corrompue ("{id_module: 58}" string). On ignore
            // donc toute valeur issue du data JSON pour cette clé — notre
            // assignation via moduleId fait foi.
            if (key == 'modules') return;
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

      // Sanitization finale de properties.modules : garantir que c'est bien
      // une liste d'entiers, peu importe l'état de la DB locale. Gère les
      // cas historiques où la valeur est stringifiée ("{id_module: 58}") ou
      // encapsulée dans une Map.
      final rawModules = (requestBody['properties']
          as Map<String, dynamic>)['modules'];
      if (rawModules is List) {
        final sanitized = <int>[];
        for (final item in rawModules) {
          if (item is int) {
            sanitized.add(item);
          } else if (item is String) {
            final parsed = int.tryParse(item);
            if (parsed != null) {
              sanitized.add(parsed);
            } else {
              // Essayer d'extraire l'entier d'une string "{id_module: 58}".
              final match = RegExp(r'(\d+)').firstMatch(item);
              if (match != null) sanitized.add(int.parse(match.group(1)!));
            }
          } else if (item is Map) {
            final id = item['id_module'] ?? item['id'];
            if (id is int) {
              sanitized.add(id);
            } else if (id is String) {
              final parsed = int.tryParse(id);
              if (parsed != null) sanitized.add(parsed);
            }
          }
        }
        (requestBody['properties'] as Map<String, dynamic>)['modules'] =
            sanitized;
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

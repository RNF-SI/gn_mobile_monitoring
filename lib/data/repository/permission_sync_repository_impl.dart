import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/core/constants/permission_constants.dart';
import 'package:gn_mobile_monitoring/domain/model/cruved_response.dart';
import 'package:gn_mobile_monitoring/domain/model/permission.dart';
import 'package:gn_mobile_monitoring/domain/model/user_role.dart';
import 'package:gn_mobile_monitoring/domain/repository/permission_sync_repository.dart';

class PermissionSyncException implements Exception {
  final String message;
  final int? statusCode;

  PermissionSyncException(this.message, [this.statusCode]);

  @override
  String toString() => 'PermissionSyncException: $message (Status: $statusCode)';
}

class PermissionSyncRepositoryImpl implements PermissionSyncRepository {
  final Dio _dio;

  PermissionSyncRepositoryImpl(this._dio);

  @override
  Future<List<Permission>> syncModulePermissions(
      String baseUrl, String authToken) async {
    try {
      _configureAuth(authToken);
      
      final response = await _dio.get('$baseUrl/monitorings/modules');

      if (response.statusCode == 200) {
        final modules = (response.data as List)
            .map<ModuleResponse>((json) => ModuleResponse.fromJson(json))
            .toList();

        final permissions = <Permission>[];

        for (final module in modules) {
          // TODO: Récupérer l'ID utilisateur depuis le token/session
          const userId = 1; // Temporaire
          
          final modulePermissions = convertCruvedToPermissions(
            module.cruved,
            userId,
            module.id,
            PermissionConstants.monitoringModules,
          );
          permissions.addAll(modulePermissions);
        }

        return permissions;
      } else {
        throw PermissionSyncException(
          'Échec de la synchronisation des modules',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw PermissionSyncException(
        'Erreur réseau: ${e.response?.data ?? e.message}',
        e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<Permission>> syncModuleSpecificPermissions(
    String baseUrl,
    String moduleCode,
    String authToken,
  ) async {
    try {
      _configureAuth(authToken);
      
      final permissions = <Permission>[];
      const userId = 1; // TODO: Récupérer depuis session
      final moduleId = _getModuleIdFromCode(moduleCode);

      // Synchroniser les différents types d'objets en parallèle
      await Future.wait([
        _syncSites(baseUrl, moduleCode, userId, moduleId, permissions),
        _syncSiteGroups(baseUrl, moduleCode, userId, moduleId, permissions),
        _syncVisits(baseUrl, moduleCode, userId, moduleId, permissions),
        _syncIndividuals(baseUrl, moduleCode, userId, moduleId, permissions),
      ]);

      return permissions;
    } catch (e) {
      throw PermissionSyncException(
        'Erreur lors de la synchronisation du module $moduleCode: $e',
      );
    }
  }

  @override
  Future<CruvedResponse> getObjectPermissions(
    String baseUrl,
    String moduleCode,
    String objectType,
    int? objectId,
    String authToken,
  ) async {
    try {
      _configureAuth(authToken);
      
      final url = objectId != null
          ? '$baseUrl/monitorings/object/$moduleCode/$objectType/$objectId'
          : '$baseUrl/monitorings/object/$moduleCode/$objectType';

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['cruved'] != null) {
          return CruvedResponse.fromJson(data['cruved']);
        }
      }

      return const CruvedResponse(); // Permissions vides par défaut
    } catch (e) {
      throw PermissionSyncException(
        'Erreur lors de la récupération des permissions pour $objectType: $e',
      );
    }
  }

  @override
  Future<UserRole?> getUserInfo(String baseUrl, String authToken) async {
    try {
      _configureAuth(authToken);
      
      // TODO: Endpoint à définir pour récupérer les infos utilisateur
      final response = await _dio.get('$baseUrl/auth/user');

      if (response.statusCode == 200) {
        return UserRole.fromJson(response.data);
      }

      return null;
    } catch (e) {
      throw PermissionSyncException(
        'Erreur lors de la récupération des infos utilisateur: $e',
      );
    }
  }

  @override
  List<Permission> convertCruvedToPermissions(
    CruvedResponse cruved,
    int userId,
    int moduleId,
    String objectCode,
  ) {
    final permissions = <Permission>[];

    final cruvedMap = {
      PermissionConstants.actionCreate: cruved.create,
      PermissionConstants.actionRead: cruved.read,
      PermissionConstants.actionUpdate: cruved.update,
      PermissionConstants.actionValidate: cruved.validate,
      PermissionConstants.actionExport: cruved.export,
      PermissionConstants.actionDelete: cruved.delete,
    };

    int permissionId = DateTime.now().millisecondsSinceEpoch; // ID temporaire unique

    for (final entry in cruvedMap.entries) {
      if (entry.value) {
        permissions.add(Permission(
          idPermission: permissionId++,
          idRole: userId,
          idAction: _getActionId(entry.key),
          idModule: moduleId,
          idObject: _getObjectId(objectCode),
          scopeValue: 3, // Par défaut, scope maximal pour les permissions true
          sensitivityFilter: false,
        ));
      }
    }

    return permissions;
  }

  // === Méthodes privées ===

  void _configureAuth(String authToken) {
    _dio.options.headers = {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    };
  }

  Future<void> _syncSites(String baseUrl, String moduleCode, int userId,
      int moduleId, List<Permission> permissions) async {
    try {
      final response = await _dio.get('$baseUrl/monitorings/sites/$moduleCode');

      if (response.statusCode == 200) {
        final sites = (response.data as List)
            .map<SiteResponse>((json) => SiteResponse.fromJson(json))
            .toList();

        if (sites.isNotEmpty) {
          final sitePermissions = convertCruvedToPermissions(
            sites.first.cruved,
            userId,
            moduleId,
            PermissionConstants.monitoringSites,
          );
          permissions.addAll(sitePermissions);
        }
      }
    } catch (e) {
      // Log mais ne pas faire échouer la synchronisation complète
      print('Avertissement: Impossible de synchroniser les sites: $e');
    }
  }

  Future<void> _syncSiteGroups(String baseUrl, String moduleCode, int userId,
      int moduleId, List<Permission> permissions) async {
    try {
      final response =
          await _dio.get('$baseUrl/monitorings/sites_groups/$moduleCode');

      if (response.statusCode == 200) {
        final siteGroups = (response.data as List)
            .map<SiteGroupResponse>((json) => SiteGroupResponse.fromJson(json))
            .toList();

        if (siteGroups.isNotEmpty) {
          final groupPermissions = convertCruvedToPermissions(
            siteGroups.first.cruved,
            userId,
            moduleId,
            PermissionConstants.monitoringGrpSites,
          );
          permissions.addAll(groupPermissions);
        }
      }
    } catch (e) {
      print('Avertissement: Impossible de synchroniser les groupes de sites: $e');
    }
  }

  Future<void> _syncVisits(String baseUrl, String moduleCode, int userId,
      int moduleId, List<Permission> permissions) async {
    try {
      final response = await _dio.get('$baseUrl/monitorings/visits/$moduleCode');

      if (response.statusCode == 200) {
        final visits = (response.data as List)
            .map<VisitResponse>((json) => VisitResponse.fromJson(json))
            .toList();

        if (visits.isNotEmpty) {
          final visitPermissions = convertCruvedToPermissions(
            visits.first.cruved,
            userId,
            moduleId,
            PermissionConstants.monitoringVisites,
          );
          permissions.addAll(visitPermissions);
        }
      }
    } catch (e) {
      print('Avertissement: Impossible de synchroniser les visites: $e');
    }
  }

  Future<void> _syncIndividuals(String baseUrl, String moduleCode, int userId,
      int moduleId, List<Permission> permissions) async {
    try {
      final response = await _dio.get('$baseUrl/monitorings/individuals');

      if (response.statusCode == 200) {
        // Format à adapter selon l'API réelle
        // TODO: Implémenter selon la structure de réponse
      }
    } catch (e) {
      print('Avertissement: Impossible de synchroniser les individus: $e');
    }
  }

  int _getActionId(String actionCode) {
    switch (actionCode) {
      case PermissionConstants.actionCreate:
        return 1;
      case PermissionConstants.actionRead:
        return 2;
      case PermissionConstants.actionUpdate:
        return 3;
      case PermissionConstants.actionValidate:
        return 4;
      case PermissionConstants.actionExport:
        return 5;
      case PermissionConstants.actionDelete:
        return 6;
      default:
        return 0;
    }
  }

  int _getObjectId(String objectCode) {
    switch (objectCode) {
      case PermissionConstants.monitoringModules:
        return 1;
      case PermissionConstants.monitoringSites:
        return 2;
      case PermissionConstants.monitoringGrpSites:
        return 3;
      case PermissionConstants.monitoringVisites:
        return 4;
      case PermissionConstants.monitoringIndividuals:
        return 5;
      case PermissionConstants.monitoringMarkings:
        return 6;
      default:
        return 0;
    }
  }

  int _getModuleIdFromCode(String moduleCode) {
    // TODO: Implémenter un mapping ou récupérer depuis la base
    return 1; // Valeur par défaut
  }
}
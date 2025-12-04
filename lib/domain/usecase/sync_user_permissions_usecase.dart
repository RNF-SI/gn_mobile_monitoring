import 'package:gn_mobile_monitoring/domain/model/user_permissions.dart';
import 'package:gn_mobile_monitoring/domain/model/cruved_response.dart';
import 'package:gn_mobile_monitoring/domain/repository/permission_sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/permission_repository.dart';
import 'package:gn_mobile_monitoring/core/constants/permission_constants.dart';

class SyncUserPermissionsUseCase {
  final PermissionSyncRepository _syncRepository;
  final PermissionRepository _permissionRepository;

  SyncUserPermissionsUseCase(this._syncRepository, this._permissionRepository);
  
  /// Synchronise les permissions de l'utilisateur depuis l'API
  /// À appeler lors du login ou du changement d'utilisateur
  Future<UserPermissions?> execute({
    required String baseUrl,
    required String authToken,
    required int idRole,
    required String username,
    int? idOrganisme,
  }) async {
    try {
      
      // Récupérer les permissions pour chaque objet du monitoring
      // Basé sur les patterns du monitoring web
      final futures = await Future.wait([
        _getPermissionsForObject(_syncRepository, baseUrl, authToken, 'MONITORINGS_MODULES'),
        _getPermissionsForObject(_syncRepository, baseUrl, authToken, 'MONITORINGS_SITES'),
        _getPermissionsForObject(_syncRepository, baseUrl, authToken, 'MONITORINGS_GRP_SITES'),
        _getPermissionsForObject(_syncRepository, baseUrl, authToken, 'MONITORINGS_VISITES'),
        _getPermissionsForObject(_syncRepository, baseUrl, authToken, 'MONITORINGS_INDIVIDUALS'),
        _getPermissionsForObject(_syncRepository, baseUrl, authToken, 'MONITORINGS_MARKINGS'),
      ]);
      
      final userPermissions = UserPermissions(
        idRole: idRole,
        username: username,
        idOrganisme: idOrganisme,
        monitoringModules: futures[0],
        monitoringSites: futures[1],
        monitoringGrpSites: futures[2],
        monitoringVisites: futures[3],
        monitoringIndividuals: futures[4],
        monitoringMarkings: futures[5],
        isConnected: true,
      );
      
      // Optionnel : sauvegarder en base locale pour utilisation hors ligne
      // await permissionRepo.saveUserPermissions(userPermissions);
      
      return userPermissions;
    } catch (e) {
      print('Erreur lors de la synchronisation des permissions: $e');
      return null;
    }
  }
  
  /// Récupère les permissions pour un type d'objet spécifique
  Future<CruvedResponse> _getPermissionsForObject(
    PermissionSyncRepository syncRepo,
    String baseUrl,
    String authToken,
    String objectType,
  ) async {
    try {
      // Pour l'instant, récupérer depuis l'API générique des modules
      // Dans le futur, on pourra utiliser des endpoints spécifiques
      final permissions = await syncRepo.syncModulePermissions(baseUrl, authToken);
      
      // Trouver les permissions pour cet objet
      final objectPermissions = permissions.where((p) => 
        _getObjectCodeFromConstant(objectType) == _getObjectCodeFromPermission(p)
      );
      
      if (objectPermissions.isEmpty) {
        return const CruvedResponse();
      }
      
      // Convertir en CruvedResponse
      final perms = objectPermissions.first;
      return CruvedResponse(
        create: _hasAction(objectPermissions, PermissionConstants.actionCreate),
        read: _hasAction(objectPermissions, PermissionConstants.actionRead),
        update: _hasAction(objectPermissions, PermissionConstants.actionUpdate),
        validate: _hasAction(objectPermissions, PermissionConstants.actionValidate),
        export: _hasAction(objectPermissions, PermissionConstants.actionExport),
        delete: _hasAction(objectPermissions, PermissionConstants.actionDelete),
      );
    } catch (e) {
      print('Erreur lors de la récupération des permissions pour $objectType: $e');
      return const CruvedResponse();
    }
  }
  
  bool _hasAction(Iterable permissions, String actionCode) {
    return permissions.any((p) => 
      _getActionCodeFromPermission(p) == actionCode && 
      (p.scopeValue ?? 0) > 0
    );
  }
  
  String _getObjectCodeFromConstant(String constantName) {
    switch (constantName) {
      case 'MONITORINGS_MODULES':
        return PermissionConstants.monitoringModules;
      case 'MONITORINGS_SITES':
        return PermissionConstants.monitoringSites;
      case 'MONITORINGS_GRP_SITES':
        return PermissionConstants.monitoringGrpSites;
      case 'MONITORINGS_VISITES':
        return PermissionConstants.monitoringVisites;
      case 'MONITORINGS_INDIVIDUALS':
        return PermissionConstants.monitoringIndividuals;
      case 'MONITORINGS_MARKINGS':
        return PermissionConstants.monitoringMarkings;
      default:
        return '';
    }
  }
  
  String _getObjectCodeFromPermission(dynamic permission) {
    // À implémenter selon la structure de Permission
    return '';
  }
  
  String _getActionCodeFromPermission(dynamic permission) {
    // À implémenter selon la structure de Permission
    return '';
  }
}
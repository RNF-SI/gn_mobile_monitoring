import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gn_mobile_monitoring/domain/model/cruved_response.dart';

part 'user_permissions.freezed.dart';
part 'user_permissions.g.dart';

/// Permissions globales de l'utilisateur connecté pour l'application mobile
/// Basé sur les patterns du monitoring web, simplifié pour un utilisateur unique
@freezed
class UserPermissions with _$UserPermissions {
  const factory UserPermissions({
    required int idRole,
    required String username,
    required int? idOrganisme,
    
    // Permissions CRUVED par objet du monitoring - correspond aux patterns web
    required CruvedResponse monitoringModules,    // MONITORINGS_MODULES
    required CruvedResponse monitoringSites,      // MONITORINGS_SITES  
    required CruvedResponse monitoringGrpSites,   // MONITORINGS_GRP_SITES
    required CruvedResponse monitoringVisites,    // MONITORINGS_VISITES
    required CruvedResponse monitoringIndividuals,// MONITORINGS_INDIVIDUALS
    required CruvedResponse monitoringMarkings,   // MONITORINGS_MARKINGS
    
    @Default(false) bool isConnected,
  }) = _UserPermissions;

  factory UserPermissions.fromJson(Map<String, dynamic> json) =>
      _$UserPermissionsFromJson(json);
}

/// Extension pour faciliter l'accès aux permissions comme dans le monitoring web
extension UserPermissionsHelpers on UserPermissions {
  
  /// Vérifie si l'utilisateur peut créer un objet d'un type donné
  bool canCreate(String objectType) {
    return _getCruvedForObject(objectType).create;
  }
  
  /// Vérifie si l'utilisateur peut lire un objet d'un type donné
  bool canRead(String objectType) {
    return _getCruvedForObject(objectType).read;
  }
  
  /// Vérifie si l'utilisateur peut modifier un objet d'un type donné  
  bool canUpdate(String objectType) {
    return _getCruvedForObject(objectType).update;
  }
  
  /// Vérifie si l'utilisateur peut supprimer un objet d'un type donné
  bool canDelete(String objectType) {
    return _getCruvedForObject(objectType).delete;
  }
  
  /// Vérifie si l'utilisateur peut valider un objet d'un type donné
  bool canValidate(String objectType) {
    return _getCruvedForObject(objectType).validate;
  }
  
  /// Vérifie si l'utilisateur peut exporter un objet d'un type donné
  bool canExport(String objectType) {
    return _getCruvedForObject(objectType).export;
  }
  
  /// Retourne les permissions CRUVED pour un type d'objet donné
  CruvedResponse _getCruvedForObject(String objectType) {
    switch (objectType) {
      case 'module':
      case 'MONITORINGS_MODULES':
        return monitoringModules;
      case 'site':
      case 'MONITORINGS_SITES':
        return monitoringSites;
      case 'sites_group':
      case 'MONITORINGS_GRP_SITES':
        return monitoringGrpSites;
      case 'visit':
      case 'observation':
      case 'observation_detail':
      case 'MONITORINGS_VISITES':
        return monitoringVisites;
      case 'individual':
      case 'MONITORINGS_INDIVIDUALS':
        return monitoringIndividuals;
      case 'marking':
      case 'MONITORINGS_MARKINGS':
        return monitoringMarkings;
      default:
        // Par défaut, pas de permissions
        return const CruvedResponse(
          create: false,
          read: false, 
          update: false,
          delete: false,
          validate: false,
          export: false,
        );
    }
  }
  
  /// Retourne toutes les permissions sous forme de Map pour debug/logging
  Map<String, CruvedResponse> getAllPermissions() {
    return {
      'MONITORINGS_MODULES': monitoringModules,
      'MONITORINGS_SITES': monitoringSites,
      'MONITORINGS_GRP_SITES': monitoringGrpSites,
      'MONITORINGS_VISITES': monitoringVisites,
      'MONITORINGS_INDIVIDUALS': monitoringIndividuals,
      'MONITORINGS_MARKINGS': monitoringMarkings,
    };
  }
}

/// Permissions vides pour initialisation ou déconnexion
class UserPermissions_Empty {
  static const UserPermissions empty = UserPermissions(
    idRole: 0,
    username: '',
    idOrganisme: null,
    monitoringModules: CruvedResponse(),
    monitoringSites: CruvedResponse(),
    monitoringGrpSites: CruvedResponse(),
    monitoringVisites: CruvedResponse(),
    monitoringIndividuals: CruvedResponse(),
    monitoringMarkings: CruvedResponse(),
    isConnected: false,
  );
}
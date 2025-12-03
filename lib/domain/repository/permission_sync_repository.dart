import 'package:gn_mobile_monitoring/domain/model/cruved_response.dart';
import 'package:gn_mobile_monitoring/domain/model/permission.dart';
import 'package:gn_mobile_monitoring/domain/model/user_role.dart';

/// Repository interface pour la synchronisation des permissions avec l'API GeoNature
abstract class PermissionSyncRepository {
  /// Synchronise les permissions globales des modules depuis l'API
  Future<List<Permission>> syncModulePermissions(String baseUrl, String authToken);
  
  /// Synchronise les permissions spécifiques d'un module
  Future<List<Permission>> syncModuleSpecificPermissions(
    String baseUrl, 
    String moduleCode, 
    String authToken
  );
  
  /// Récupère les permissions CRUVED d'un objet spécifique
  Future<CruvedResponse> getObjectPermissions(
    String baseUrl,
    String moduleCode,
    String objectType,
    int? objectId,
    String authToken,
  );
  
  /// Récupère les informations utilisateur depuis l'API
  Future<UserRole?> getUserInfo(String baseUrl, String authToken);
  
  /// Convertit une réponse CRUVED en permissions locales
  List<Permission> convertCruvedToPermissions(
    CruvedResponse cruved,
    int userId,
    int moduleId,
    String objectCode,
  );
}
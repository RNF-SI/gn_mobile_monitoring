import 'package:gn_mobile_monitoring/domain/model/user_permissions.dart';
import 'package:gn_mobile_monitoring/domain/repository/permission_repository.dart';

/// Use case pour récupérer les permissions de l'utilisateur connecté
/// Simplifié pour l'application mobile avec un seul utilisateur
class GetUserPermissionsUseCase {
  final PermissionRepository _permissionRepository;

  GetUserPermissionsUseCase(this._permissionRepository);

  Future<UserPermissions?> execute() async {
    // Récupérer l'utilisateur actuel
    final currentUser = await _permissionRepository.getCurrentUser();
    if (currentUser == null) {
      return null;
    }
    
    // Pour l'instant, retourner des permissions vides
    // TODO: Récupérer depuis la base locale ou synchroniser depuis l'API
    return UserPermissions_Empty.empty.copyWith(
      idRole: currentUser.idRole,
      username: currentUser.identifiant,
      idOrganisme: currentUser.idOrganisme,
      isConnected: true,
    );
  }
}
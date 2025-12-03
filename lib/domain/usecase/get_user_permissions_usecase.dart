import 'package:gn_mobile_monitoring/domain/model/user_permissions.dart';
import 'package:gn_mobile_monitoring/domain/repository/permission_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';

part 'get_user_permissions_usecase.g.dart';

/// Use case pour récupérer les permissions de l'utilisateur connecté
/// Simplifié pour l'application mobile avec un seul utilisateur
@riverpod
class GetUserPermissionsUseCase extends _$GetUserPermissionsUseCase {
  @override
  Future<UserPermissions?> build() async {
    final permissionRepo = ref.read(permissionRepositoryProvider);
    
    // Récupérer l'utilisateur actuel
    final currentUser = await permissionRepo.getCurrentUser();
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
  
  /// Force le rechargement des permissions
  void refresh() {
    ref.invalidateSelf();
  }
}
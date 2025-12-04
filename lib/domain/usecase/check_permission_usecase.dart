import 'package:gn_mobile_monitoring/domain/repository/permission_repository.dart';

class CheckPermissionUseCase {
  final PermissionRepository _permissionRepository;

  CheckPermissionUseCase(this._permissionRepository);

  Future<bool> execute({
    required int idModule,
    required String objectCode,
    required String actionCode,
  }) async {
    // Récupérer l'utilisateur actuel
    final currentUser = await _permissionRepository.getCurrentUser();
    if (currentUser == null) return false;
    
    return _permissionRepository.hasPermission(
      currentUser.idRole,
      idModule,
      objectCode,
      actionCode,
    );
  }
}


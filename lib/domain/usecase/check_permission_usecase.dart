import 'package:gn_mobile_monitoring/domain/repository/permission_repository.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_permission_usecase.g.dart';

@riverpod
class CheckPermissionUseCase extends _$CheckPermissionUseCase {
  @override
  Future<bool> build(
    int idModule,
    String objectCode,
    String actionCode,
  ) async {
    final permissionRepo = ref.read(permissionRepositoryProvider);
    
    // Récupérer l'utilisateur actuel
    final currentUser = await permissionRepo.getCurrentUser();
    if (currentUser == null) return false;
    
    return permissionRepo.hasPermission(
      currentUser.idRole,
      idModule,
      objectCode,
      actionCode,
    );
  }
}


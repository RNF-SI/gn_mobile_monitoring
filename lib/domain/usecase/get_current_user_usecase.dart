import 'package:gn_mobile_monitoring/domain/model/user_role.dart';
import 'package:gn_mobile_monitoring/domain/repository/permission_repository.dart';

class GetCurrentUserUseCase {
  final PermissionRepository _permissionRepository;

  GetCurrentUserUseCase(this._permissionRepository);

  Future<UserRole?> execute() {
    return _permissionRepository.getCurrentUser();
  }
}
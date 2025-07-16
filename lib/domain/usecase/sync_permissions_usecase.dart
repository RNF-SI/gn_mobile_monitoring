import '../repository/permission_repository.dart';

class SyncPermissionsUseCase {
  final PermissionRepository permissionRepository;

  SyncPermissionsUseCase({required this.permissionRepository});

  Future<void> syncPermissions(String moduleCode) async {
    await permissionRepository.syncPermissions(moduleCode);
  }

  Future<void> syncAllPermissions(List<String> moduleCodes) async {
    for (final moduleCode in moduleCodes) {
      try {
        await permissionRepository.syncPermissions(moduleCode);
      } catch (e) {
        // Continue with other modules if one fails
        continue;
      }
    }
  }

  Future<void> clearPermissions() async {
    await permissionRepository.clearPermissions();
  }
}
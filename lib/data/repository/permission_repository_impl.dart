import '../../core/network/network_info.dart';
import '../../domain/model/permission.dart';
import '../../domain/model/user.dart';
import '../../domain/repository/permission_repository.dart';
import '../../domain/repository/user_repository.dart';
import '../datasource/interface/permission_api_datasource.dart';
import '../datasource/interface/permission_db_datasource.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  final PermissionApiDataSource apiDataSource;
  final PermissionDbDataSource dbDataSource;
  final NetworkInfo networkInfo;
  final UserRepository userRepository;

  PermissionRepositoryImpl({
    required this.apiDataSource,
    required this.dbDataSource,
    required this.networkInfo,
    required this.userRepository,
  });

  @override
  Future<Permission?> getPermission(String moduleCode) async {
    // Essayer d'abord le cache local
    final cachedPermission = await dbDataSource.getPermissionByModuleCode(moduleCode);
    
    if (cachedPermission != null) {
      return cachedPermission;
    }

    // Si pas de cache et connecté, synchroniser
    if (await networkInfo.isConnected) {
      await syncPermissions(moduleCode);
      return await dbDataSource.getPermissionByModuleCode(moduleCode);
    }

    return null;
  }

  @override
  Future<void> syncPermissions(String moduleCode) async {
    if (await networkInfo.isConnected) {
      try {
        final permission = await apiDataSource.getPermissions(moduleCode);
        await dbDataSource.savePermission(permission);
      } catch (e) {
        // En cas d'erreur, on ne fait rien pour ne pas casser l'app
        // Les permissions en cache (si elles existent) seront utilisées
        rethrow;
      }
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    return await userRepository.getCurrentUser();
  }

  @override
  Future<void> clearPermissions() async {
    await dbDataSource.deleteAllPermissions();
  }

  @override
  Future<List<Permission>> getAllPermissions() async {
    return await dbDataSource.getAllPermissions();
  }
}
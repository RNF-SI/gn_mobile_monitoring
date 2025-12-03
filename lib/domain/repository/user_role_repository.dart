import 'package:gn_mobile_monitoring/domain/model/user_role.dart';

abstract class UserRoleRepository {
  Future<UserRole?> getCurrentUser();
  Future<UserRole?> getUserById(int idRole);
  Future<UserRole?> getUserByIdentifiant(String identifiant);
  Future<void> setCurrentUser(UserRole userRole);
  Future<void> clearCurrentUser();
}
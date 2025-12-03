import 'package:gn_mobile_monitoring/data/db/dao/user_role_dao.dart';
import 'package:gn_mobile_monitoring/domain/model/user_role.dart';
import 'package:gn_mobile_monitoring/domain/repository/user_role_repository.dart';

class UserRoleRepositoryImpl implements UserRoleRepository {
  final UserRoleDao _userRoleDao;

  UserRoleRepositoryImpl(this._userRoleDao);

  @override
  Future<UserRole?> getCurrentUser() {
    return _userRoleDao.getCurrentUser();
  }

  @override
  Future<UserRole?> getUserById(int idRole) {
    return _userRoleDao.getUserById(idRole);
  }

  @override
  Future<UserRole?> getUserByIdentifiant(String identifiant) {
    return _userRoleDao.getUserByIdentifiant(identifiant);
  }

  @override
  Future<void> setCurrentUser(UserRole userRole) {
    return _userRoleDao.setCurrentUser(userRole);
  }

  @override
  Future<void> clearCurrentUser() {
    return _userRoleDao.clearCurrentUser();
  }
}
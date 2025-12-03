import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/user_role_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_user_roles.dart';
import 'package:gn_mobile_monitoring/data/entity/user_role_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/user_role.dart';

part 'user_role_dao.g.dart';

@DriftAccessor(tables: [TUserRoles])
class UserRoleDao extends DatabaseAccessor<AppDatabase>
    with _$UserRoleDaoMixin {
  UserRoleDao(AppDatabase attachedDatabase) : super(attachedDatabase);

  Future<UserRole?> getCurrentUser() async {
    final query = select(tUserRoles)
      ..where((u) => u.active.equals(true))
      ..limit(1);
    
    final userRole = await query.getSingleOrNull();
    return userRole != null
        ? UserRoleMapper.toModel(UserRoleEntity.fromTUserRole(userRole))
        : null;
  }

  Future<UserRole?> getUserById(int idRole) async {
    final query = select(tUserRoles)
      ..where((u) => u.idRole.equals(idRole));
    
    final userRole = await query.getSingleOrNull();
    return userRole != null
        ? UserRoleMapper.toModel(UserRoleEntity.fromTUserRole(userRole))
        : null;
  }

  Future<UserRole?> getUserByIdentifiant(String identifiant) async {
    final query = select(tUserRoles)
      ..where((u) => u.identifiant.equals(identifiant));
    
    final userRole = await query.getSingleOrNull();
    return userRole != null
        ? UserRoleMapper.toModel(UserRoleEntity.fromTUserRole(userRole))
        : null;
  }

  Future<void> insertUserRole(UserRole userRole) async {
    await into(tUserRoles).insert(TUserRolesCompanion(
      idRole: Value(userRole.idRole),
      identifiant: Value(userRole.identifiant),
      nomRole: Value(userRole.nomRole),
      prenomRole: Value(userRole.prenomRole),
      idOrganisme: Value(userRole.idOrganisme),
      active: Value(userRole.active),
    ));
  }

  Future<void> updateCurrentUser(UserRole userRole) async {
    await (update(tUserRoles)..where((u) => u.active.equals(true)))
        .write(TUserRolesCompanion(
      identifiant: Value(userRole.identifiant),
      nomRole: Value(userRole.nomRole),
      prenomRole: Value(userRole.prenomRole),
      idOrganisme: Value(userRole.idOrganisme),
      active: Value(userRole.active),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> setCurrentUser(UserRole userRole) async {
    await transaction(() async {
      await (update(tUserRoles)..where((u) => u.active.equals(true)))
          .write(const TUserRolesCompanion(active: Value(false)));

      await insertUserRole(userRole);
    });
  }

  Future<void> clearCurrentUser() async {
    await (update(tUserRoles)..where((u) => u.active.equals(true)))
        .write(const TUserRolesCompanion(active: Value(false)));
  }
}
import 'package:gn_mobile_monitoring/data/entity/user_role_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/user_role.dart';

class UserRoleMapper {
  static UserRole toModel(UserRoleEntity entity) {
    return UserRole(
      idRole: entity.idRole,
      identifiant: entity.identifiant,
      nomRole: entity.nomRole,
      prenomRole: entity.prenomRole,
      idOrganisme: entity.idOrganisme,
      active: entity.active,
    );
  }

  static UserRoleEntity fromModel(UserRole model) {
    return UserRoleEntity(
      idRole: model.idRole,
      identifiant: model.identifiant,
      nomRole: model.nomRole,
      prenomRole: model.prenomRole,
      idOrganisme: model.idOrganisme,
      active: model.active,
      createdAt: DateTime.now(),
    );
  }
}
import 'package:gn_mobile_monitoring/data/db/database.dart';

class UserRoleEntity {
  final int idRole;
  final String identifiant;
  final String nomRole;
  final String prenomRole;
  final int? idOrganisme;
  final bool active;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserRoleEntity({
    required this.idRole,
    required this.identifiant,
    required this.nomRole,
    required this.prenomRole,
    this.idOrganisme,
    required this.active,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserRoleEntity.fromTUserRole(TUserRole userRole) {
    return UserRoleEntity(
      idRole: userRole.idRole,
      identifiant: userRole.identifiant,
      nomRole: userRole.nomRole,
      prenomRole: userRole.prenomRole,
      idOrganisme: userRole.idOrganisme,
      active: userRole.active,
      createdAt: userRole.createdAt,
      updatedAt: userRole.updatedAt,
    );
  }
}
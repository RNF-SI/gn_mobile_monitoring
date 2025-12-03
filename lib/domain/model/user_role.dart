import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_role.freezed.dart';
part 'user_role.g.dart';

@freezed
class UserRole with _$UserRole {
  const factory UserRole({
    required int idRole,
    required String identifiant,
    required String nomRole,
    required String prenomRole,
    int? idOrganisme,
    @Default(true) bool active,
  }) = _UserRole;

  factory UserRole.fromJson(Map<String, dynamic> json) =>
      _$UserRoleFromJson(json);
}
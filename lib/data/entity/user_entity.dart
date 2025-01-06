class UserEntity {
  final bool active;
  final String dateInsert;
  final String dateUpdate;
  final String? descRole;
  final String? email;
  final bool groupe;
  final int idOrganisme;
  final int idRole; // Correct unique identifier
  final String identifiant;
  final int maxLevelProfil;
  final String nomComplet;
  final String nomRole;
  final String prenomRole;
  final String token;

  UserEntity({
    required this.active,
    required this.dateInsert,
    required this.dateUpdate,
    this.descRole,
    this.email,
    required this.groupe,
    required this.idOrganisme,
    required this.idRole,
    required this.identifiant,
    required this.maxLevelProfil,
    required this.nomComplet,
    required this.nomRole,
    required this.prenomRole,
    required this.token,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;
    final token = json['token'] as String? ?? '';
    return UserEntity(
      active: userJson['active'] as bool? ?? false,
      dateInsert: userJson['date_insert'] as String? ?? '',
      dateUpdate: userJson['date_update'] as String? ?? '',
      descRole: userJson['desc_role'] as String?,
      email: userJson['email'] as String?,
      groupe: userJson['groupe'] as bool? ?? false,
      idOrganisme: userJson['id_organisme'] as int? ?? -1,
      idRole: userJson['id_role'] as int? ?? 0, // Correct unique identifier
      identifiant: userJson['identifiant'] as String? ?? '',
      maxLevelProfil: userJson['max_level_profil'] as int? ?? 0,
      nomComplet: userJson['nom_complet'] as String? ?? '',
      nomRole: userJson['nom_role'] as String? ?? '',
      prenomRole: userJson['prenom_role'] as String? ?? '',
      token: token as String? ?? '',
    );
  }
}

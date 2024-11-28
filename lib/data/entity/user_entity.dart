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
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      active: json['active'] as bool? ?? false,
      dateInsert: json['date_insert'] as String? ?? '',
      dateUpdate: json['date_update'] as String? ?? '',
      descRole: json['desc_role'] as String?,
      email: json['email'] as String?,
      groupe: json['groupe'] as bool? ?? false,
      idOrganisme: json['id_organisme'] as int? ?? -1,
      idRole: json['id_role'] as int? ?? 0, // Correct unique identifier
      identifiant: json['identifiant'] as String? ?? '',
      maxLevelProfil: json['max_level_profil'] as int? ?? 0,
      nomComplet: json['nom_complet'] as String? ?? '',
      nomRole: json['nom_role'] as String? ?? '',
      prenomRole: json['prenom_role'] as String? ?? '',
    );
  }
}

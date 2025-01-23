class CorSitesGroupModuleEntity {
  final int idModule;
  final int idSitesGroup;

  CorSitesGroupModuleEntity({
    required this.idModule,
    required this.idSitesGroup,
  });

  factory CorSitesGroupModuleEntity.fromJson(Map<String, dynamic> json) {
    try {
      final idModule = json['id_module'];
      final idSitesGroup = json['id_sites_group'];

      if (idModule == null) {
        throw Exception("Missing or null `id_module` in JSON: $json");
      }
      if (idSitesGroup == null) {
        throw Exception("Missing or null `id_sites_group` in JSON: $json");
      }

      if (idModule is! int) {
        throw Exception(
            "Invalid type for `id_module`. Expected int, got ${idModule.runtimeType}");
      }
      if (idSitesGroup is! int) {
        throw Exception(
            "Invalid type for `id_sites_group`. Expected int, got ${idSitesGroup.runtimeType}");
      }

      return CorSitesGroupModuleEntity(
        idModule: idModule,
        idSitesGroup: idSitesGroup,
      );
    } catch (e) {
      throw Exception(
          "Error parsing CorSitesGroupModuleEntity: $e\nJSON data: $json");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id_module': idModule,
      'id_sites_group': idSitesGroup,
    };
  }
}

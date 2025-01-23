class CorSiteModuleEntity {
  final int idModule;
  final int idBaseSite;

  CorSiteModuleEntity({
    required this.idModule,
    required this.idBaseSite,
  });

  factory CorSiteModuleEntity.fromJson(Map<String, dynamic> json) {
    try {
      final idModule = json['id_module'];
      final idBaseSite = json['id_base_site'];

      if (idModule == null) {
        throw Exception("Missing or null `id_module` in JSON: $json");
      }
      if (idBaseSite == null) {
        throw Exception("Missing or null `id_base_site` in JSON: $json");
      }

      if (idModule is! int) {
        throw Exception(
            "Invalid type for `id_module`. Expected int, got ${idModule.runtimeType}");
      }
      if (idBaseSite is! int) {
        throw Exception(
            "Invalid type for `id_base_site`. Expected int, got ${idBaseSite.runtimeType}");
      }

      return CorSiteModuleEntity(
        idModule: idModule,
        idBaseSite: idBaseSite,
      );
    } catch (e) {
      throw Exception(
          "Error parsing CorSiteModuleEntity: $e\nJSON data: $json");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id_module': idModule,
      'id_base_site': idBaseSite,
    };
  }
}

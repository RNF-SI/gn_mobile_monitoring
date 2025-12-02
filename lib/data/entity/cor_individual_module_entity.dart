class CorIndividualModuleEntity {
  final int idModule;
  final int idIndividual;

  CorIndividualModuleEntity({
    required this.idModule,
    required this.idIndividual,
  });

  factory CorIndividualModuleEntity.fromJson(Map<String, dynamic> json) {
    try {
      final idModule = json['id_module'];
      final idIndividual = json['id_individual'];

      if (idModule == null) {
        throw Exception("Missing or null `id_module` in JSON: $json");
      }
      if (idIndividual == null) {
        throw Exception("Missing or null `id_individual` in JSON: $json");
      }

      if (idModule is! int) {
        throw Exception(
            "Invalid type for `id_module`. Expected int, got ${idModule.runtimeType}");
      }
      if (idIndividual is! int) {
        throw Exception(
            "Invalid type for `id_individual`. Expected int, got ${idIndividual.runtimeType}");
      }

      return CorIndividualModuleEntity(
        idModule: idModule,
        idIndividual: idIndividual,
      );
    } catch (e) {
      throw Exception(
          "Error parsing CorIndividualModuleEntity: $e\nJSON data: $json");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id_module': idModule,
      'id_individual': idIndividual,
    };
  }
}

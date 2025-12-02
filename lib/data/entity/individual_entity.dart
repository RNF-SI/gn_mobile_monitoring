class IndividualEntity {
  final int idIndividual;
  final int? idDigitiser;
  final int? cdNom;
  final String? comment;
  final String? individualName;
  final int? idNomenclatureSex;
  final bool? activeIndividual;
  final String? uuidIndividual;
  final int? serverIndividualId;
  final DateTime? metaCreateDate;
  final DateTime? metaUpdateDate;

  IndividualEntity({
    required this.idIndividual,
    this.idDigitiser,
    this.cdNom,
    this.comment,
    this.individualName,
    this.idNomenclatureSex,
    this.activeIndividual,
    this.uuidIndividual,
    this.serverIndividualId,
    this.metaCreateDate,
    this.metaUpdateDate,
  });

  // Factory method to convert JSON to entity
  factory IndividualEntity.fromJson(Map<String, dynamic> json) {
    return IndividualEntity(
      idIndividual: json['id_individual'] as int,
      idDigitiser: json['id_digitiser'] as int?,
      cdNom: json['cd_nom'] as int?,
      comment: json['comment'] as String?,
      individualName: json['individual_name'] as String?,
      idNomenclatureSex: json['id_nomenclature_sex'] as int?,
      activeIndividual: json['active_individual'] as bool?,
      uuidIndividual: json['uuid_individual'] as String?,
      metaCreateDate: json['meta_create_date'] != null
          ? DateTime.parse(json['meta_create_date'])
          : null,
      metaUpdateDate: json['meta_update_date'] != null
          ? DateTime.parse(json['meta_update_date'])
          : null,
    );
  }

  // Method to convert entity to JSON
  Map<String, dynamic> toJson() {
    return {
      'id_individual': idIndividual,
      'id_digitiser': idDigitiser,
      'cd_nom': cdNom,
      'comment': comment,
      'individual_name': individualName,
      'id_nomenclature_sex': idNomenclatureSex,
      'active_individual': activeIndividual,
      'uuid_individual': uuidIndividual,
      'meta_create_date': metaCreateDate?.toIso8601String(),
      'meta_update_date': metaUpdateDate?.toIso8601String(),
    };
  }
}

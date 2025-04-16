class CorSiteTypeEntity {
  final int idBaseSite;
  final int idNomenclatureTypeSite;
  
  CorSiteTypeEntity({
    required this.idBaseSite,
    required this.idNomenclatureTypeSite,
  });
  
  factory CorSiteTypeEntity.fromJson(Map<String, dynamic> json) {
    return CorSiteTypeEntity(
      idBaseSite: json['id_base_site'],
      idNomenclatureTypeSite: json['id_nomenclature_type_site'],
    );
  }
  
  Map<String, dynamic> toDb() {
    return {
      'id_base_site': idBaseSite,
      'id_nomenclature_type_site': idNomenclatureTypeSite,
    };
  }
  
  factory CorSiteTypeEntity.fromDb(Map<String, dynamic> db) {
    return CorSiteTypeEntity(
      idBaseSite: db['id_base_site'],
      idNomenclatureTypeSite: db['id_nomenclature_type_site'],
    );
  }
}
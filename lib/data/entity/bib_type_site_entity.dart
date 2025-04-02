import 'dart:convert';

class BibTypeSiteEntity {
  final int idNomenclatureTypeSite;
  final String? config;
  
  BibTypeSiteEntity({
    required this.idNomenclatureTypeSite,
    this.config,
  });
  
  factory BibTypeSiteEntity.fromJson(Map<String, dynamic> json) {
    return BibTypeSiteEntity(
      idNomenclatureTypeSite: json['id_nomenclature_type_site'],
      config: json['config'] != null 
        ? json['config'] is String 
          ? json['config'] 
          : jsonEncode(json['config'])
        : null,
    );
  }
  
  Map<String, dynamic> toDb() {
    return {
      'id_nomenclature_type_site': idNomenclatureTypeSite,
      'config': config,
    };
  }
  
  factory BibTypeSiteEntity.fromDb(Map<String, dynamic> db) {
    return BibTypeSiteEntity(
      idNomenclatureTypeSite: db['id_nomenclature_type_site'],
      config: db['config'],
    );
  }
  
  Map<String, dynamic>? getConfigAsJson() {
    if (config == null) return null;
    try {
      return json.decode(config!) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}
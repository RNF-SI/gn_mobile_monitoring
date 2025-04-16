class NomenclatureEntity {
  final int idNomenclature;
  final int idType;
  final String cdNomenclature;
  final String? mnemonique;
  final String? codeType; // Ajout du champ code_type
  final String? labelDefault;
  final String? definitionDefault;
  final String? labelFr;
  final String? definitionFr;
  final String? labelEn;
  final String? definitionEn;
  final String? labelEs;
  final String? definitionEs;
  final String? labelDe;
  final String? definitionDe;
  final String? labelIt;
  final String? definitionIt;
  final String? source;
  final String? statut;
  final int? idBroader;
  final String? hierarchy;
  final bool active;
  final DateTime? metaCreateDate;
  final DateTime? metaUpdateDate;

  NomenclatureEntity({
    required this.idNomenclature,
    required this.idType,
    required this.cdNomenclature,
    this.mnemonique,
    this.codeType,
    this.labelDefault,
    this.definitionDefault,
    this.labelFr,
    this.definitionFr,
    this.labelEn,
    this.definitionEn,
    this.labelEs,
    this.definitionEs,
    this.labelDe,
    this.definitionDe,
    this.labelIt,
    this.definitionIt,
    this.source,
    this.statut,
    this.idBroader,
    this.hierarchy,
    required this.active,
    required this.metaCreateDate,
    this.metaUpdateDate,
  });

  factory NomenclatureEntity.fromJson(Map<String, dynamic> json) {
    return NomenclatureEntity(
      idNomenclature: json['id_nomenclature'],
      idType: json['id_type'],
      cdNomenclature: json['cd_nomenclature'],
      mnemonique: json['mnemonique'],
      codeType: json['code_type'],  // Ajout du champ code_type
      labelDefault: json['label_default'],
      definitionDefault: json['definition_default'],
      labelFr: json['label_fr'],
      definitionFr: json['definition_fr'],
      labelEn: json['label_en'],
      definitionEn: json['definition_en'],
      labelEs: json['label_es'],
      definitionEs: json['definition_es'],
      labelDe: json['label_de'],
      definitionDe: json['definition_de'],
      labelIt: json['label_it'],
      definitionIt: json['definition_it'],
      source: json['source'],
      statut: json['statut'],
      idBroader: json['id_broader'],
      hierarchy: json['hierarchy'],
      active: json['active'] ?? true,
      metaCreateDate: json['meta_create_date'] != null
          ? DateTime.parse(json['meta_create_date'])
          : null,
      metaUpdateDate: json['meta_update_date'] != null
          ? DateTime.parse(json['meta_update_date'])
          : null,
    );
  }

  Map<String, dynamic> toDb() {
    return {
      'id_nomenclature': idNomenclature,
      'id_type': idType,
      'cd_nomenclature': cdNomenclature,
      'mnemonique': mnemonique,
      'code_type': codeType,  // Ajout du champ code_type
      'label_default': labelDefault,
      'definition_default': definitionDefault,
      'label_fr': labelFr,
      'definition_fr': definitionFr,
      'label_en': labelEn,
      'definition_en': definitionEn,
      'label_es': labelEs,
      'definition_es': definitionEs,
      'label_de': labelDe,
      'definition_de': definitionDe,
      'label_it': labelIt,
      'definition_it': definitionIt,
      'source': source,
      'statut': statut,
      'id_broader': idBroader,
      'hierarchy': hierarchy,
      'active': active,
      'meta_create_date': metaCreateDate?.toIso8601String(),
      'meta_update_date': metaUpdateDate?.toIso8601String(),
    };
  }

  factory NomenclatureEntity.fromDb(Map<String, dynamic> db) {
    return NomenclatureEntity(
      idNomenclature: db['id_nomenclature'],
      idType: db['id_type'],
      cdNomenclature: db['cd_nomenclature'],
      mnemonique: db['mnemonique'],
      codeType: db['code_type'],  // Ajout du champ code_type
      labelDefault: db['label_default'],
      definitionDefault: db['definition_default'],
      labelFr: db['label_fr'],
      definitionFr: db['definition_fr'],
      labelEn: db['label_en'],
      definitionEn: db['definition_en'],
      labelEs: db['label_es'],
      definitionEs: db['definition_es'],
      labelDe: db['label_de'],
      definitionDe: db['definition_de'],
      labelIt: db['label_it'],
      definitionIt: db['definition_it'],
      source: db['source'],
      statut: db['statut'],
      idBroader: db['id_broader'],
      hierarchy: db['hierarchy'],
      active: db['active'] == 1,
      metaCreateDate: DateTime.parse(db['meta_create_date']),
      metaUpdateDate: db['meta_update_date'] != null
          ? DateTime.parse(db['meta_update_date'])
          : null,
    );
  }
}

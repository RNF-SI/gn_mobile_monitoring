class NomenclatureTypeEntity {
  final int idType;
  final String? mnemonique;
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
  final DateTime? metaCreateDate;
  final DateTime? metaUpdateDate;

  NomenclatureTypeEntity({
    required this.idType,
    this.mnemonique,
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
    this.metaCreateDate,
    this.metaUpdateDate,
  });

  factory NomenclatureTypeEntity.fromJson(Map<String, dynamic> json) {
    return NomenclatureTypeEntity(
      idType: json['id_type'],
      mnemonique: json['mnemonique'],
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
      'id_type': idType,
      'mnemonique': mnemonique,
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
      'meta_create_date': metaCreateDate?.toIso8601String(),
      'meta_update_date': metaUpdateDate?.toIso8601String(),
    };
  }

  factory NomenclatureTypeEntity.fromDb(Map<String, dynamic> db) {
    return NomenclatureTypeEntity(
      idType: db['id_type'],
      mnemonique: db['mnemonique'],
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
      metaCreateDate: db['meta_create_date'] != null
          ? DateTime.parse(db['meta_create_date'])
          : null,
      metaUpdateDate: db['meta_update_date'] != null
          ? DateTime.parse(db['meta_update_date'])
          : null,
    );
  }
}
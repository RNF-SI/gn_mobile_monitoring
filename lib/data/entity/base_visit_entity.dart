class BaseVisitEntity {
  final int idBaseVisit;
  final int? idBaseSite;
  final int idDataset;
  final int idModule;
  final int? idDigitiser;
  final String visitDateMin;
  final String? visitDateMax;
  final int? idNomenclatureTechCollectCampanule;
  final int? idNomenclatureGrpTyp;
  final String? comments;
  final String? uuidBaseVisit;
  final int? serverVisitId; // ID du serveur pour synchronisation
  final String? metaCreateDate;
  final String? metaUpdateDate;
  final List<int>? observers; // Liste des ID des observateurs
  final Map<String, dynamic>? data; // Données spécifiques au module

  BaseVisitEntity({
    required this.idBaseVisit,
    this.idBaseSite,
    required this.idDataset,
    required this.idModule,
    this.idDigitiser,
    required this.visitDateMin,
    this.visitDateMax,
    this.idNomenclatureTechCollectCampanule,
    this.idNomenclatureGrpTyp,
    this.comments,
    this.uuidBaseVisit,
    this.serverVisitId,
    this.metaCreateDate,
    this.metaUpdateDate,
    this.observers,
    this.data,
  });

  // Factory method to convert JSON to entity
  factory BaseVisitEntity.fromJson(Map<String, dynamic> json) {
    return BaseVisitEntity(
      idBaseVisit: json['id_base_visit'] as int,
      idBaseSite: json['id_base_site'] as int?,
      idDataset: json['id_dataset'] as int,
      idModule: json['id_module'] as int,
      idDigitiser: json['id_digitiser'] as int?,
      visitDateMin: json['visit_date_min'] as String,
      visitDateMax: json['visit_date_max'] as String?,
      idNomenclatureTechCollectCampanule: 
          json['id_nomenclature_tech_collect_campanule'] as int?,
      idNomenclatureGrpTyp: json['id_nomenclature_grp_typ'] as int?,
      comments: json['comments'] as String?,
      uuidBaseVisit: json['uuid_base_visit'] as String?,
      serverVisitId: json['server_visit_id'] as int?,
      metaCreateDate: json['meta_create_date'] as String?,
      metaUpdateDate: json['meta_update_date'] as String?,
      observers: (json['observers'] as List<dynamic>?)?.map((e) => e as int).toList(),
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  // Method to convert entity to JSON
  Map<String, dynamic> toJson() {
    return {
      'id_base_visit': idBaseVisit,
      'id_base_site': idBaseSite,
      'id_dataset': idDataset,
      'id_module': idModule,
      'id_digitiser': idDigitiser,
      'visit_date_min': visitDateMin,
      'visit_date_max': visitDateMax,
      'id_nomenclature_tech_collect_campanule': idNomenclatureTechCollectCampanule,
      'id_nomenclature_grp_typ': idNomenclatureGrpTyp,
      'comments': comments,
      'uuid_base_visit': uuidBaseVisit,
      'server_visit_id': serverVisitId,
      'meta_create_date': metaCreateDate,
      'meta_update_date': metaUpdateDate,
      'observers': observers,
      'data': data,
    };
  }

  // CopyWith method for easy updates
  BaseVisitEntity copyWith({
    int? idBaseVisit,
    int? idBaseSite,
    int? idDataset,
    int? idModule,
    int? idDigitiser,
    String? visitDateMin,
    String? visitDateMax,
    int? idNomenclatureTechCollectCampanule,
    int? idNomenclatureGrpTyp,
    String? comments,
    String? uuidBaseVisit,
    int? serverVisitId,
    String? metaCreateDate,
    String? metaUpdateDate,
    List<int>? observers,
    Map<String, dynamic>? data,
  }) {
    return BaseVisitEntity(
      idBaseVisit: idBaseVisit ?? this.idBaseVisit,
      idBaseSite: idBaseSite ?? this.idBaseSite,
      idDataset: idDataset ?? this.idDataset,
      idModule: idModule ?? this.idModule,
      idDigitiser: idDigitiser ?? this.idDigitiser,
      visitDateMin: visitDateMin ?? this.visitDateMin,
      visitDateMax: visitDateMax ?? this.visitDateMax,
      idNomenclatureTechCollectCampanule: idNomenclatureTechCollectCampanule ?? this.idNomenclatureTechCollectCampanule,
      idNomenclatureGrpTyp: idNomenclatureGrpTyp ?? this.idNomenclatureGrpTyp,
      comments: comments ?? this.comments,
      uuidBaseVisit: uuidBaseVisit ?? this.uuidBaseVisit,
      serverVisitId: serverVisitId ?? this.serverVisitId,
      metaCreateDate: metaCreateDate ?? this.metaCreateDate,
      metaUpdateDate: metaUpdateDate ?? this.metaUpdateDate,
      observers: observers ?? this.observers,
      data: data ?? this.data,
    );
  }
}
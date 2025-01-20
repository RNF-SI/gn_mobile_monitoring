class DatasetEntity {
  final int idDataset;
  final String uniqueDatasetId;
  final int idAcquisitionFramework;
  final String datasetName;
  final String datasetShortname;
  final String datasetDesc;
  final int idNomenclatureDataType;
  final String? keywords;
  final bool marineDomain;
  final bool terrestrialDomain;
  final int idNomenclatureDatasetObjectif;
  final double? bboxWest;
  final double? bboxEast;
  final double? bboxSouth;
  final double? bboxNorth;
  final int idNomenclatureCollectingMethod;
  final int idNomenclatureDataOrigin;
  final int idNomenclatureSourceStatus;
  final int idNomenclatureResourceType;
  final bool? active;
  final bool? validable;
  final int? idDigitizer;
  final int? idTaxaList;
  final DateTime? metaCreateDate;
  final DateTime? metaUpdateDate;

  DatasetEntity({
    required this.idDataset,
    required this.uniqueDatasetId,
    required this.idAcquisitionFramework,
    required this.datasetName,
    required this.datasetShortname,
    required this.datasetDesc,
    required this.idNomenclatureDataType,
    this.keywords,
    required this.marineDomain,
    required this.terrestrialDomain,
    required this.idNomenclatureDatasetObjectif,
    this.bboxWest,
    this.bboxEast,
    this.bboxSouth,
    this.bboxNorth,
    required this.idNomenclatureCollectingMethod,
    required this.idNomenclatureDataOrigin,
    required this.idNomenclatureSourceStatus,
    required this.idNomenclatureResourceType,
    this.active,
    this.validable,
    this.idDigitizer,
    this.idTaxaList,
    this.metaCreateDate,
    this.metaUpdateDate,
  });

  factory DatasetEntity.fromJson(Map<String, dynamic> json) {
    return DatasetEntity(
      idDataset: json['id_dataset'] as int,
      uniqueDatasetId: json['unique_dataset_id'] as String,
      idAcquisitionFramework: json['id_acquisition_framework'] as int,
      datasetName: json['dataset_name'] as String,
      datasetShortname: json['dataset_shortname'] as String,
      datasetDesc: json['dataset_desc'] as String,
      idNomenclatureDataType: json['id_nomenclature_data_type'] as int,
      keywords: json['keywords'] as String?,
      marineDomain: json['marine_domain'] as bool,
      terrestrialDomain: json['terrestrial_domain'] as bool,
      idNomenclatureDatasetObjectif:
          json['id_nomenclature_dataset_objectif'] as int,
      bboxWest: (json['bbox_west'] as num?)?.toDouble(),
      bboxEast: (json['bbox_east'] as num?)?.toDouble(),
      bboxSouth: (json['bbox_south'] as num?)?.toDouble(),
      bboxNorth: (json['bbox_north'] as num?)?.toDouble(),
      idNomenclatureCollectingMethod:
          json['id_nomenclature_collecting_method'] as int,
      idNomenclatureDataOrigin: json['id_nomenclature_data_origin'] as int,
      idNomenclatureSourceStatus: json['id_nomenclature_source_status'] as int,
      idNomenclatureResourceType: json['id_nomenclature_resource_type'] as int,
      active: json['active'] as bool?,
      validable: json['validable'] as bool?,
      idDigitizer: json['id_digitizer'] as int?,
      idTaxaList: json['id_taxa_list'] as int?,
      metaCreateDate: json['meta_create_date'] != null
          ? DateTime.parse(json['meta_create_date'] as String)
          : null,
      metaUpdateDate: json['meta_update_date'] != null
          ? DateTime.parse(json['meta_update_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_dataset': idDataset,
      'unique_dataset_id': uniqueDatasetId,
      'id_acquisition_framework': idAcquisitionFramework,
      'dataset_name': datasetName,
      'dataset_shortname': datasetShortname,
      'dataset_desc': datasetDesc,
      'id_nomenclature_data_type': idNomenclatureDataType,
      'keywords': keywords,
      'marine_domain': marineDomain,
      'terrestrial_domain': terrestrialDomain,
      'id_nomenclature_dataset_objectif': idNomenclatureDatasetObjectif,
      'bbox_west': bboxWest,
      'bbox_east': bboxEast,
      'bbox_south': bboxSouth,
      'bbox_north': bboxNorth,
      'id_nomenclature_collecting_method': idNomenclatureCollectingMethod,
      'id_nomenclature_data_origin': idNomenclatureDataOrigin,
      'id_nomenclature_source_status': idNomenclatureSourceStatus,
      'id_nomenclature_resource_type': idNomenclatureResourceType,
      'active': active,
      'validable': validable,
      'id_digitizer': idDigitizer,
      'id_taxa_list': idTaxaList,
      'meta_create_date': metaCreateDate?.toIso8601String(),
      'meta_update_date': metaUpdateDate?.toIso8601String(),
    };
  }
}

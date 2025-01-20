import 'package:freezed_annotation/freezed_annotation.dart';

part 'dataset.freezed.dart';

@freezed
class Dataset with _$Dataset {
  const factory Dataset({
    required int id, // idDataset
    required String uniqueDatasetId, // UUID
    required int idAcquisitionFramework,
    required String datasetName,
    required String datasetShortname,
    required String datasetDesc,
    required int idNomenclatureDataType,
    String? keywords,
    required bool marineDomain,
    required bool terrestrialDomain,
    required int idNomenclatureDatasetObjectif,
    double? bboxWest,
    double? bboxEast,
    double? bboxSouth,
    double? bboxNorth,
    required int idNomenclatureCollectingMethod,
    required int idNomenclatureDataOrigin,
    required int idNomenclatureSourceStatus,
    required int idNomenclatureResourceType,
    bool? active,
    bool? validable,
    int? idDigitizer,
    int? idTaxaList,
    DateTime? metaCreateDate,
    DateTime? metaUpdateDate,
  }) = _Dataset;
}

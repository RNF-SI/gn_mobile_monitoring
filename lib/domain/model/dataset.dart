import 'package:freezed_annotation/freezed_annotation.dart';

part 'dataset.freezed.dart';

@freezed
abstract class Dataset with _$Dataset {
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
    int? idNomenclatureDatasetObjectif, // absent depuis GeoNature 2.18 (#4103)
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

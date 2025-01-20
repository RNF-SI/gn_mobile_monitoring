import 'package:gn_mobile_monitoring/data/entity/dataset_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/dataset.dart';

extension DatasetEntityMapper on DatasetEntity {
  Dataset toDomain() {
    return Dataset(
      id: idDataset,
      uniqueDatasetId: uniqueDatasetId, // Correct field name
      idAcquisitionFramework: idAcquisitionFramework,
      datasetName: datasetName,
      datasetShortname: datasetShortname,
      datasetDesc: datasetDesc,
      idNomenclatureDataType: idNomenclatureDataType,
      keywords: keywords,
      marineDomain: marineDomain,
      terrestrialDomain: terrestrialDomain,
      idNomenclatureDatasetObjectif: idNomenclatureDatasetObjectif,
      bboxWest: bboxWest,
      bboxEast: bboxEast,
      bboxSouth: bboxSouth,
      bboxNorth: bboxNorth,
      idNomenclatureCollectingMethod: idNomenclatureCollectingMethod,
      idNomenclatureDataOrigin: idNomenclatureDataOrigin,
      idNomenclatureSourceStatus: idNomenclatureSourceStatus,
      idNomenclatureResourceType: idNomenclatureResourceType,
      active: active ?? true,
      validable: validable ?? true,
      idDigitizer: idDigitizer,
      idTaxaList: idTaxaList,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
    );
  }
}

extension DomainDatasetMapper on Dataset {
  DatasetEntity toEntity() {
    return DatasetEntity(
      idDataset: id,
      uniqueDatasetId: uniqueDatasetId, // Correct field name
      idAcquisitionFramework: idAcquisitionFramework,
      datasetName: datasetName,
      datasetShortname: datasetShortname,
      datasetDesc: datasetDesc,
      idNomenclatureDataType: idNomenclatureDataType,
      keywords: keywords,
      marineDomain: marineDomain,
      terrestrialDomain: terrestrialDomain,
      idNomenclatureDatasetObjectif: idNomenclatureDatasetObjectif,
      bboxWest: bboxWest,
      bboxEast: bboxEast,
      bboxSouth: bboxSouth,
      bboxNorth: bboxNorth,
      idNomenclatureCollectingMethod: idNomenclatureCollectingMethod,
      idNomenclatureDataOrigin: idNomenclatureDataOrigin,
      idNomenclatureSourceStatus: idNomenclatureSourceStatus,
      idNomenclatureResourceType: idNomenclatureResourceType,
      active: active,
      validable: validable,
      idDigitizer: idDigitizer,
      idTaxaList: idTaxaList,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
    );
  }
}

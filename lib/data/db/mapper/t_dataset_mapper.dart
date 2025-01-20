import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/dataset.dart';

extension TDatasetMapper on TDataset {
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

extension DatasetMapper on Dataset {
  TDataset toDatabaseEntity() {
    return TDataset(
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
      active: active ?? false,
      validable: validable,
      idDigitizer: idDigitizer,
      idTaxaList: idTaxaList,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
    );
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/entity/nomenclature_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/dataset_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/nomenclature_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/dataset_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/model/dataset.dart';

void main() {
  group('NomenclatureEntityMapper', () {
    final now = DateTime(2024, 3, 15, 14, 30);
    final entity = NomenclatureEntity(
      idNomenclature: 100,
      idType: 10,
      cdNomenclature: 'NST',
      mnemonique: 'Nichoir_standard',
      codeType: 'TYPE_SITE',
      labelDefault: 'Nichoir standard',
      definitionDefault: 'Un nichoir standard',
      labelFr: 'Nichoir standard FR',
      definitionFr: 'Definition FR',
      labelEn: 'Standard nest EN',
      definitionEn: 'Definition EN',
      labelEs: 'Nido estandar ES',
      definitionEs: 'Definicion ES',
      labelDe: 'Standardnistkasten DE',
      definitionDe: 'Definition DE',
      labelIt: 'Nido standard IT',
      definitionIt: 'Definizione IT',
      source: 'SINP',
      statut: 'Validé',
      idBroader: 50,
      hierarchy: '010.002',
      active: true,
      metaCreateDate: now,
      metaUpdateDate: now,
    );

    group('toDomain', () {
      test('maps idNomenclature to id', () {
        final domain = entity.toDomain();

        expect(domain.id, 100);
        expect(domain.idType, 10);
        expect(domain.cdNomenclature, 'NST');
      });

      test('maps all fields correctly', () {
        final domain = entity.toDomain();

        expect(domain.mnemonique, 'Nichoir_standard');
        expect(domain.codeType, 'TYPE_SITE');
        expect(domain.labelDefault, 'Nichoir standard');
        expect(domain.labelFr, 'Nichoir standard FR');
        expect(domain.labelEn, 'Standard nest EN');
        expect(domain.labelEs, 'Nido estandar ES');
        expect(domain.labelDe, 'Standardnistkasten DE');
        expect(domain.labelIt, 'Nido standard IT');
        expect(domain.source, 'SINP');
        expect(domain.statut, 'Validé');
        expect(domain.idBroader, 50);
        expect(domain.hierarchy, '010.002');
        expect(domain.active, true);
        expect(domain.metaCreateDate, now);
        expect(domain.metaUpdateDate, now);
      });
    });

    group('toEntity', () {
      test('maps id to idNomenclature', () {
        final domain = entity.toDomain();
        final result = domain.toEntity();

        expect(result.idNomenclature, 100);
        expect(result.idType, 10);
        expect(result.cdNomenclature, 'NST');
      });

      test('coerces active: null active becomes false', () {
        const domain = Nomenclature(
          id: 1,
          idType: 1,
          cdNomenclature: 'T',
          active: null,
        );

        final result = domain.toEntity();

        expect(result.active, false);
      });

      test('coerces active: true stays true', () {
        const domain = Nomenclature(
          id: 1,
          idType: 1,
          cdNomenclature: 'T',
          active: true,
        );

        final result = domain.toEntity();

        expect(result.active, true);
      });
    });

    test('roundtrip preserves all fields', () {
      final roundtripped = entity.toDomain().toEntity();

      expect(roundtripped.idNomenclature, entity.idNomenclature);
      expect(roundtripped.idType, entity.idType);
      expect(roundtripped.cdNomenclature, entity.cdNomenclature);
      expect(roundtripped.codeType, entity.codeType);
      expect(roundtripped.labelFr, entity.labelFr);
      expect(roundtripped.active, entity.active);
      expect(roundtripped.metaCreateDate, entity.metaCreateDate);
    });
  });

  group('DatasetEntityMapper', () {
    final now = DateTime(2024, 6, 1, 12, 0);
    final entity = DatasetEntity(
      idDataset: 5,
      uniqueDatasetId: 'uuid-dataset-001',
      idAcquisitionFramework: 1,
      datasetName: 'Monitoring Oiseaux',
      datasetShortname: 'MON_OIS',
      datasetDesc: 'Dataset de monitoring ornithologique',
      idNomenclatureDataType: 10,
      keywords: 'oiseaux,monitoring',
      marineDomain: false,
      terrestrialDomain: true,
      idNomenclatureDatasetObjectif: 20,
      bboxWest: -5.0,
      bboxEast: 10.0,
      bboxSouth: 41.0,
      bboxNorth: 51.0,
      idNomenclatureCollectingMethod: 30,
      idNomenclatureDataOrigin: 40,
      idNomenclatureSourceStatus: 50,
      idNomenclatureResourceType: 60,
      active: true,
      validable: true,
      idDigitizer: 99,
      idTaxaList: 42,
      metaCreateDate: now,
      metaUpdateDate: now,
    );

    group('toDomain', () {
      test('maps idDataset to id', () {
        final domain = entity.toDomain();

        expect(domain.id, 5);
        expect(domain.uniqueDatasetId, 'uuid-dataset-001');
        expect(domain.datasetName, 'Monitoring Oiseaux');
      });

      test('defaults active to true when null', () {
        final nullActiveEntity = DatasetEntity(
          idDataset: 1,
          uniqueDatasetId: 'uid',
          idAcquisitionFramework: 1,
          datasetName: 'Test',
          datasetShortname: 'TST',
          datasetDesc: 'Desc',
          idNomenclatureDataType: 1,
          marineDomain: false,
          terrestrialDomain: true,
          idNomenclatureDatasetObjectif: 1,
          idNomenclatureCollectingMethod: 1,
          idNomenclatureDataOrigin: 1,
          idNomenclatureSourceStatus: 1,
          idNomenclatureResourceType: 1,
          active: null,
          validable: null,
        );

        final domain = nullActiveEntity.toDomain();

        expect(domain.active, true);
        expect(domain.validable, true);
      });

      test('maps all bbox fields', () {
        final domain = entity.toDomain();

        expect(domain.bboxWest, -5.0);
        expect(domain.bboxEast, 10.0);
        expect(domain.bboxSouth, 41.0);
        expect(domain.bboxNorth, 51.0);
      });
    });

    group('toEntity', () {
      test('maps id to idDataset', () {
        final domain = entity.toDomain();
        final result = domain.toEntity();

        expect(result.idDataset, 5);
        expect(result.uniqueDatasetId, 'uuid-dataset-001');
      });

      test('preserves nullable fields', () {
        const domain = Dataset(
          id: 1,
          uniqueDatasetId: 'uid',
          idAcquisitionFramework: 1,
          datasetName: 'Test',
          datasetShortname: 'TST',
          datasetDesc: 'Desc',
          idNomenclatureDataType: 1,
          marineDomain: false,
          terrestrialDomain: true,
          idNomenclatureDatasetObjectif: 1,
          idNomenclatureCollectingMethod: 1,
          idNomenclatureDataOrigin: 1,
          idNomenclatureSourceStatus: 1,
          idNomenclatureResourceType: 1,
          keywords: null,
          bboxWest: null,
          idDigitizer: null,
        );

        final result = domain.toEntity();

        expect(result.keywords, isNull);
        expect(result.bboxWest, isNull);
        expect(result.idDigitizer, isNull);
      });
    });

    test('roundtrip preserves all fields', () {
      final roundtripped = entity.toDomain().toEntity();

      expect(roundtripped.idDataset, entity.idDataset);
      expect(roundtripped.uniqueDatasetId, entity.uniqueDatasetId);
      expect(roundtripped.datasetName, entity.datasetName);
      expect(roundtripped.bboxWest, entity.bboxWest);
      expect(roundtripped.bboxNorth, entity.bboxNorth);
      expect(roundtripped.active, entity.active);
      expect(roundtripped.validable, entity.validable);
      expect(roundtripped.metaCreateDate, entity.metaCreateDate);
    });
  });
}

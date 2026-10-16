import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/entity/dataset_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/dataset_entity_mapper.dart';

void main() {
  // Réponse réelle de /monitorings/util/dataset/1 sur GeoNature develop (2.18) :
  // `id_nomenclature_dataset_objectif` n'existe plus (#4103).
  final geonature218Payload = <String, dynamic>{
    'active': true,
    'additional_data': {},
    'bbox_east': 6.85654,
    'bbox_north': 45.25,
    'bbox_south': 44.502,
    'bbox_west': 4.85695,
    'dataset_desc':
        'Observations aléatoires de la faune, de la flore ou de la fonge',
    'dataset_name': 'Contact aléatoire tous règnes confondus',
    'dataset_shortname': 'Contact aléatoire',
    'id_acquisition_framework': 1,
    'id_dataset': 1,
    'id_digitizer': null,
    'id_nomenclature_collecting_method': 396,
    'id_nomenclature_data_origin': 76,
    'id_nomenclature_data_type': 323,
    'id_nomenclature_resource_type': 321,
    'id_nomenclature_source_status': 73,
    'id_taxa_list': null,
    'keywords': 'Aléatoire, hors protocole, faune, flore, fonge',
    'marine_domain': false,
    'meta_create_date': '2026-05-19 13:56:25.815938',
    'meta_update_date': null,
    'terrestrial_domain': true,
    'unique_dataset_id': '4d331cae-65e4-4948-b0b2-a11bc5bb46c2',
    'validable': true,
  };

  group('DatasetEntity.fromJson', () {
    test('accepte un JDD sans id_nomenclature_dataset_objectif (GeoNature 2.18)',
        () {
      final entity = DatasetEntity.fromJson(geonature218Payload);

      expect(entity.idDataset, 1);
      expect(entity.datasetShortname, 'Contact aléatoire');
      expect(entity.idNomenclatureDatasetObjectif, isNull);

      final domain = entity.toDomain();
      expect(domain.id, 1);
      expect(domain.idNomenclatureDatasetObjectif, isNull);
    });

    test('conserve id_nomenclature_dataset_objectif quand il est fourni (2.17)',
        () {
      final entity = DatasetEntity.fromJson({
        ...geonature218Payload,
        'id_nomenclature_dataset_objectif': 408,
      });

      expect(entity.idNomenclatureDatasetObjectif, 408);
    });
  });
}

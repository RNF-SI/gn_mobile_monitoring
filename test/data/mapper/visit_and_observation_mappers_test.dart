import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/entity/base_visit_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/observation_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/observation_detail_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/visite_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/observation_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/observation_detail_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';

void main() {
  group('VisiteEntityMapper', () {
    group('toDomain', () {
      test('maps all fields correctly', () {
        final entity = BaseVisitEntity(
          idBaseVisit: 1,
          idBaseSite: 10,
          idDataset: 5,
          idModule: 3,
          idDigitiser: 99,
          visitDateMin: '2024-03-15',
          visitDateMax: '2024-03-16',
          idNomenclatureTechCollectCampanule: 7,
          idNomenclatureGrpTyp: 8,
          comments: 'Test visit',
          uuidBaseVisit: 'uuid-visit-001',
          metaCreateDate: '2024-03-15T10:00:00',
          metaUpdateDate: '2024-03-15T12:00:00',
          observers: [1, 2, 3],
          data: {'key': 'value'},
        );

        final domain = entity.toDomain();

        expect(domain.idBaseVisit, 1);
        expect(domain.idBaseSite, 10);
        expect(domain.idDataset, 5);
        expect(domain.idModule, 3);
        expect(domain.idDigitiser, 99);
        expect(domain.visitDateMin, '2024-03-15');
        expect(domain.visitDateMax, '2024-03-16');
        expect(domain.comments, 'Test visit');
        expect(domain.uuidBaseVisit, 'uuid-visit-001');
        expect(domain.observers, [1, 2, 3]);
      });

      test('normalizes time fields in data', () {
        final entity = BaseVisitEntity(
          idBaseVisit: 1,
          idDataset: 5,
          idModule: 3,
          visitDateMin: '2024-03-15',
          data: {
            'visit_time_start': '9:30',
            'visit_time_end': '16:5',
            'non_time_field': 'unchanged',
            'visit_date': '2024-03-15',
          },
        );

        final domain = entity.toDomain();

        expect(domain.data!['visit_time_start'], '09:30');
        expect(domain.data!['visit_time_end'], '16:05');
        expect(domain.data!['non_time_field'], 'unchanged');
        // 'date' fields should not be normalized even if they contain 'time'
        expect(domain.data!['visit_date'], '2024-03-15');
      });

      test('handles null data', () {
        final entity = BaseVisitEntity(
          idBaseVisit: 1,
          idDataset: 5,
          idModule: 3,
          visitDateMin: '2024-03-15',
          data: null,
        );

        final domain = entity.toDomain();

        expect(domain.data, isNull);
      });

      test('handles data with no time fields', () {
        final entity = BaseVisitEntity(
          idBaseVisit: 1,
          idDataset: 5,
          idModule: 3,
          visitDateMin: '2024-03-15',
          data: {'species_count': 5, 'weather': 'sunny'},
        );

        final domain = entity.toDomain();

        expect(domain.data!['species_count'], 5);
        expect(domain.data!['weather'], 'sunny');
      });
    });

    group('toEntity (BaseVisit -> BaseVisitEntity)', () {
      test('maps all fields and sets serverVisitId to null', () {
        const domain = BaseVisit(
          idBaseVisit: 1,
          idBaseSite: 10,
          idDataset: 5,
          idModule: 3,
          idDigitiser: 99,
          visitDateMin: '2024-03-15',
          visitDateMax: '2024-03-16',
          comments: 'Test',
          uuidBaseVisit: 'uuid-001',
          metaCreateDate: '2024-03-15T10:00:00',
          metaUpdateDate: '2024-03-15T12:00:00',
          observers: [1, 2],
          data: {'key': 'value'},
        );

        final entity = domain.toEntity();

        expect(entity.idBaseVisit, 1);
        expect(entity.idBaseSite, 10);
        expect(entity.idDataset, 5);
        expect(entity.idModule, 3);
        expect(entity.serverVisitId, isNull);
        expect(entity.observers, [1, 2]);
        expect(entity.data, {'key': 'value'});
      });
    });

    group('roundtrip', () {
      test('preserves fields (except serverVisitId)', () {
        final entity = BaseVisitEntity(
          idBaseVisit: 1,
          idBaseSite: 10,
          idDataset: 5,
          idModule: 3,
          visitDateMin: '2024-03-15',
          comments: 'Roundtrip test',
          observers: [1],
          data: {'count': 5},
        );

        final roundtripped = entity.toDomain().toEntity();

        expect(roundtripped.idBaseVisit, entity.idBaseVisit);
        expect(roundtripped.idBaseSite, entity.idBaseSite);
        expect(roundtripped.idDataset, entity.idDataset);
        expect(roundtripped.comments, entity.comments);
        // serverVisitId is lost in roundtrip (set to null)
        expect(roundtripped.serverVisitId, isNull);
      });
    });
  });

  group('ObservationEntityMapper', () {
    group('toDomain', () {
      test('maps all fields correctly', () {
        final entity = ObservationEntity(
          idObservation: 100,
          idBaseVisit: 10,
          idDigitiser: 5,
          cdNom: 12345,
          comments: 'Observed 3 individuals',
          uuidObservation: 'uuid-obs-001',
          serverObservationId: 500,
          metaCreateDate: '2024-03-15',
          metaUpdateDate: '2024-03-16',
          data: {'count': 3, 'sex': 'male'},
        );

        final domain = entity.toDomain();

        expect(domain.idObservation, 100);
        expect(domain.idBaseVisit, 10);
        expect(domain.idDigitiser, 5);
        expect(domain.cdNom, 12345);
        expect(domain.comments, 'Observed 3 individuals');
        expect(domain.uuidObservation, 'uuid-obs-001');
        expect(domain.serverObservationId, 500);
        expect(domain.data, {'count': 3, 'sex': 'male'});
      });
    });

    group('toEntity', () {
      test('maps all fields correctly', () {
        const domain = Observation(
          idObservation: 200,
          idBaseVisit: 20,
          cdNom: 99999,
          comments: 'Test obs',
          data: {'height': 1.5},
        );

        final entity = domain.toEntity();

        expect(entity.idObservation, 200);
        expect(entity.idBaseVisit, 20);
        expect(entity.cdNom, 99999);
        expect(entity.data, {'height': 1.5});
      });
    });

    test('roundtrip preserves all fields', () {
      final entity = ObservationEntity(
        idObservation: 50,
        idBaseVisit: 5,
        cdNom: 11111,
        data: {'test': true},
      );

      final roundtripped = entity.toDomain().toEntity();

      expect(roundtripped.idObservation, entity.idObservation);
      expect(roundtripped.idBaseVisit, entity.idBaseVisit);
      expect(roundtripped.cdNom, entity.cdNom);
      expect(roundtripped.data, entity.data);
    });

    test('handles null optional fields', () {
      final entity = ObservationEntity(idObservation: 1);

      final domain = entity.toDomain();

      expect(domain.idObservation, 1);
      expect(domain.idBaseVisit, isNull);
      expect(domain.cdNom, isNull);
      expect(domain.data, isNull);
    });
  });

  group('ObservationDetailEntityMapper', () {
    group('toDomain', () {
      test('decodes JSON data string to Map', () async {
        final entity = ObservationDetailEntity(
          idObservationDetail: 1,
          idObservation: 10,
          uuidObservationDetail: 'uuid-detail-001',
          data: '{"denombrement": 5, "hauteur_strate": "herbacee"}',
        );

        // Suppress logger output
        final domain = await runZoned(
          () async => entity.toDomain(),
          zoneSpecification: ZoneSpecification(
            print: (self, parent, zone, line) {},
          ),
        );

        expect(domain.idObservationDetail, 1);
        expect(domain.idObservation, 10);
        expect(domain.uuidObservationDetail, 'uuid-detail-001');
        expect(domain.data, {'denombrement': 5, 'hauteur_strate': 'herbacee'});
      });

      test('returns empty Map for null data', () async {
        final entity = ObservationDetailEntity(
          idObservationDetail: 1,
          idObservation: 10,
          data: null,
        );

        final domain = await runZoned(
          () async => entity.toDomain(),
          zoneSpecification: ZoneSpecification(
            print: (self, parent, zone, line) {},
          ),
        );

        expect(domain.data, isEmpty);
      });

      test('returns empty Map for empty data string', () async {
        final entity = ObservationDetailEntity(
          idObservationDetail: 1,
          idObservation: 10,
          data: '',
        );

        final domain = await runZoned(
          () async => entity.toDomain(),
          zoneSpecification: ZoneSpecification(
            print: (self, parent, zone, line) {},
          ),
        );

        expect(domain.data, isEmpty);
      });

      test('returns empty Map for invalid JSON', () async {
        final entity = ObservationDetailEntity(
          idObservationDetail: 1,
          idObservation: 10,
          data: 'not valid json{{{',
        );

        final domain = await runZoned(
          () async => entity.toDomain(),
          zoneSpecification: ZoneSpecification(
            print: (self, parent, zone, line) {},
          ),
        );

        expect(domain.data, isEmpty);
      });
    });

    group('toEntity', () {
      test('encodes Map data to JSON string', () async {
        const domain = ObservationDetail(
          idObservationDetail: 1,
          idObservation: 10,
          uuidObservationDetail: 'uuid-001',
          data: {'denombrement': 5, 'hauteur_strate': 'herbacee'},
        );

        final entity = await runZoned(
          () async => domain.toEntity(),
          zoneSpecification: ZoneSpecification(
            print: (self, parent, zone, line) {},
          ),
        );

        expect(entity.idObservationDetail, 1);
        expect(entity.idObservation, 10);
        expect(entity.uuidObservationDetail, 'uuid-001');

        final decodedData = jsonDecode(entity.data!);
        expect(decodedData['denombrement'], 5);
        expect(decodedData['hauteur_strate'], 'herbacee');
      });

      test('returns empty string for empty data Map', () async {
        const domain = ObservationDetail(
          idObservationDetail: 1,
          idObservation: 10,
          data: {},
        );

        final entity = await runZoned(
          () async => domain.toEntity(),
          zoneSpecification: ZoneSpecification(
            print: (self, parent, zone, line) {},
          ),
        );

        expect(entity.data, '');
      });
    });

    test('roundtrip preserves data content', () async {
      final entity = ObservationDetailEntity(
        idObservationDetail: 5,
        idObservation: 50,
        uuidObservationDetail: 'uuid-round',
        data: '{"count": 10, "type": "adult"}',
      );

      final roundtripped = await runZoned(
        () async => entity.toDomain().toEntity(),
        zoneSpecification: ZoneSpecification(
          print: (self, parent, zone, line) {},
        ),
      );

      expect(roundtripped.idObservationDetail, entity.idObservationDetail);
      expect(roundtripped.idObservation, entity.idObservation);

      final originalData = jsonDecode(entity.data!);
      final roundtrippedData = jsonDecode(roundtripped.data!);
      expect(roundtrippedData, originalData);
    });
  });
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/entity/base_site_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/site_group_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/site_complement_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/bib_type_site_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/base_site_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/site_group_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/site_complement_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/bib_type_site_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/bib_type_site.dart';

void main() {
  group('BaseSiteEntityMapper', () {
    final now = DateTime(2024, 6, 15, 10, 0);
    final entity = BaseSiteEntity(
      idBaseSite: 42,
      baseSiteName: 'Site Alpha',
      baseSiteDescription: 'A test site',
      baseSiteCode: 'SA-001',
      firstUseDate: now,
      geom: '{"type": "Point", "coordinates": [2.35, 48.85]}',
      uuidBaseSite: 'uuid-site-001',
      altitudeMin: 100,
      altitudeMax: 500,
      metaCreateDate: now,
      metaUpdateDate: now,
      data: {'habitat': 'forest'},
    );

    group('toDomain', () {
      test('maps all fields and sets isLocal to false', () {
        final domain = entity.toDomain();

        expect(domain.idBaseSite, 42);
        expect(domain.baseSiteName, 'Site Alpha');
        expect(domain.baseSiteDescription, 'A test site');
        expect(domain.baseSiteCode, 'SA-001');
        expect(domain.firstUseDate, now);
        expect(domain.geom, '{"type": "Point", "coordinates": [2.35, 48.85]}');
        expect(domain.uuidBaseSite, 'uuid-site-001');
        expect(domain.altitudeMin, 100);
        expect(domain.altitudeMax, 500);
        expect(domain.metaCreateDate, now);
        expect(domain.metaUpdateDate, now);
        expect(domain.data, {'habitat': 'forest'});
        expect(domain.isLocal, false);
      });
    });

    group('toEntity', () {
      test('maps all fields correctly', () {
        final domain = entity.toDomain();
        final result = domain.toEntity();

        expect(result.idBaseSite, 42);
        expect(result.baseSiteName, 'Site Alpha');
        expect(result.baseSiteDescription, 'A test site');
        expect(result.baseSiteCode, 'SA-001');
        expect(result.geom, entity.geom);
        expect(result.altitudeMin, 100);
        expect(result.altitudeMax, 500);
        expect(result.data, {'habitat': 'forest'});
      });

      test('does not include isLocal in entity', () {
        const domain = BaseSite(
          idBaseSite: 1,
          baseSiteName: 'Test',
          isLocal: true,
        );

        final result = domain.toEntity();

        // BaseSiteEntity does not have an isLocal field
        expect(result.idBaseSite, 1);
        expect(result.baseSiteName, 'Test');
      });
    });

    test('roundtrip preserves fields', () {
      final roundtripped = entity.toDomain().toEntity();

      expect(roundtripped.idBaseSite, entity.idBaseSite);
      expect(roundtripped.baseSiteName, entity.baseSiteName);
      expect(roundtripped.geom, entity.geom);
      expect(roundtripped.altitudeMin, entity.altitudeMin);
    });

    test('handles null optional fields', () {
      final minimalEntity = BaseSiteEntity(idBaseSite: 1);

      final domain = minimalEntity.toDomain();

      expect(domain.idBaseSite, 1);
      expect(domain.baseSiteName, isNull);
      expect(domain.geom, isNull);
      expect(domain.data, isNull);
      expect(domain.isLocal, false);
    });
  });

  group('SiteGroupEntityMapper', () {
    final now = DateTime(2024, 5, 1, 8, 0);

    group('toDomain', () {
      test('encodes Map data to JSON string', () {
        final entity = SiteGroupEntity(
          idSitesGroup: 10,
          sitesGroupName: 'Group A',
          sitesGroupCode: 'GRP-A',
          sitesGroupDescription: 'First group',
          uuidSitesGroup: 'uuid-group-001',
          comments: 'A group comment',
          data: {'habitat_type': 'wetland', 'area_ha': 15.5},
          metaCreateDate: now,
          metaUpdateDate: now,
          idDigitiser: 5,
          geom: '{"type": "Polygon", "coordinates": []}',
          altitudeMin: 50,
          altitudeMax: 200,
        );

        final domain = entity.toDomain();

        expect(domain.idSitesGroup, 10);
        expect(domain.sitesGroupName, 'Group A');
        expect(domain.sitesGroupCode, 'GRP-A');
        expect(domain.sitesGroupDescription, 'First group');

        // data should be a JSON string
        final decodedData = jsonDecode(domain.data!);
        expect(decodedData['habitat_type'], 'wetland');
        expect(decodedData['area_ha'], 15.5);

        expect(domain.geom, '{"type": "Polygon", "coordinates": []}');
        expect(domain.altitudeMin, 50);
        expect(domain.altitudeMax, 200);
      });

      test('handles null data', () {
        final entity = SiteGroupEntity(
          idSitesGroup: 1,
          data: null,
        );

        final domain = entity.toDomain();

        expect(domain.data, isNull);
      });
    });

    group('toEntity', () {
      test('decodes JSON string data to Map', () {
        final domain = SiteGroup(
          idSitesGroup: 10,
          sitesGroupName: 'Group B',
          data: jsonEncode({'type': 'forest'}),
          metaCreateDate: now,
        );

        final entity = domain.toEntity();

        expect(entity.idSitesGroup, 10);
        expect(entity.sitesGroupName, 'Group B');
        expect(entity.data, isA<Map<String, dynamic>>());
        expect(entity.data!['type'], 'forest');
      });

      test('handles null data', () {
        const domain = SiteGroup(
          idSitesGroup: 1,
          data: null,
        );

        final entity = domain.toEntity();

        expect(entity.data, isNull);
      });
    });

    test('roundtrip preserves all fields', () {
      final entity = SiteGroupEntity(
        idSitesGroup: 5,
        sitesGroupName: 'Roundtrip Group',
        sitesGroupCode: 'RND',
        comments: 'Test',
        data: {'key': 'value'},
        metaCreateDate: now,
        idDigitiser: 3,
        altitudeMin: 100,
      );

      final roundtripped = entity.toDomain().toEntity();

      expect(roundtripped.idSitesGroup, entity.idSitesGroup);
      expect(roundtripped.sitesGroupName, entity.sitesGroupName);
      expect(roundtripped.sitesGroupCode, entity.sitesGroupCode);
      expect(roundtripped.comments, entity.comments);
      expect(roundtripped.data, entity.data);
      expect(roundtripped.metaCreateDate, entity.metaCreateDate);
      expect(roundtripped.idDigitiser, entity.idDigitiser);
      expect(roundtripped.altitudeMin, entity.altitudeMin);
    });
  });

  group('SiteComplementEntityMapper', () {
    test('toDomain maps all fields', () {
      final entity = SiteComplementEntity(
        idBaseSite: 42,
        idSitesGroup: 10,
        data: '{"custom_field": "value"}',
      );

      final domain = entity.toDomain();

      expect(domain.idBaseSite, 42);
      expect(domain.idSitesGroup, 10);
      expect(domain.data, '{"custom_field": "value"}');
    });

    test('toEntity maps all fields', () {
      const domain = SiteComplement(
        idBaseSite: 42,
        idSitesGroup: 10,
        data: '{"custom_field": "value"}',
      );

      final entity = domain.toEntity();

      expect(entity.idBaseSite, 42);
      expect(entity.idSitesGroup, 10);
      expect(entity.data, '{"custom_field": "value"}');
    });

    test('roundtrip preserves all fields', () {
      final entity = SiteComplementEntity(
        idBaseSite: 5,
        idSitesGroup: 3,
        data: '{"test": true}',
      );

      final roundtripped = entity.toDomain().toEntity();

      expect(roundtripped.idBaseSite, entity.idBaseSite);
      expect(roundtripped.idSitesGroup, entity.idSitesGroup);
      expect(roundtripped.data, entity.data);
    });

    test('parseData decodes valid JSON', () {
      const domain = SiteComplement(
        idBaseSite: 1,
        data: '{"species_count": 42, "habitat": "forest"}',
      );

      final parsed = domain.parseData();

      expect(parsed, isNotNull);
      expect(parsed!['species_count'], 42);
      expect(parsed['habitat'], 'forest');
    });

    test('parseData returns null for null data', () {
      const domain = SiteComplement(
        idBaseSite: 1,
        data: null,
      );

      final parsed = domain.parseData();

      expect(parsed, isNull);
    });

    test('parseData returns null for empty data', () {
      const domain = SiteComplement(
        idBaseSite: 1,
        data: '',
      );

      final parsed = domain.parseData();

      expect(parsed, isNull);
    });

    test('parseData returns null for invalid JSON', () {
      const domain = SiteComplement(
        idBaseSite: 1,
        data: 'not json at all',
      );

      // Suppress print output from error handling
      final parsed = runZoned(
        () => domain.parseData(),
        zoneSpecification: ZoneSpecification(
          print: (self, parent, zone, line) {},
        ),
      );

      expect(parsed, isNull);
    });
  });

  group('BibTypeSiteEntityMapper', () {
    group('toDomain', () {
      test('decodes JSON config string to Map', () {
        final entity = BibTypeSiteEntity(
          idNomenclatureTypeSite: 42,
          config: '{"display_properties": ["name", "code"], "label": "Standard"}',
        );

        final domain = entity.toDomain();

        expect(domain.idNomenclatureTypeSite, 42);
        expect(domain.config, isNotNull);
        expect(domain.config!['label'], 'Standard');
        expect(domain.config!['display_properties'], ['name', 'code']);
      });

      test('handles null config', () {
        final entity = BibTypeSiteEntity(
          idNomenclatureTypeSite: 1,
          config: null,
        );

        final domain = entity.toDomain();

        expect(domain.idNomenclatureTypeSite, 1);
        expect(domain.config, isNull);
      });

      test('handles invalid JSON config gracefully', () {
        final entity = BibTypeSiteEntity(
          idNomenclatureTypeSite: 1,
          config: 'not valid json',
        );

        final domain = entity.toDomain();

        expect(domain.idNomenclatureTypeSite, 1);
        expect(domain.config, isNull);
      });
    });

    group('toEntity', () {
      test('encodes Map config to JSON string', () {
        const domain = BibTypeSite(
          idNomenclatureTypeSite: 42,
          config: {'label': 'Test', 'visible': true},
        );

        final entity = domain.toEntity();

        expect(entity.idNomenclatureTypeSite, 42);
        expect(entity.config, isNotNull);

        final decoded = jsonDecode(entity.config!);
        expect(decoded['label'], 'Test');
        expect(decoded['visible'], true);
      });

      test('handles null config', () {
        const domain = BibTypeSite(
          idNomenclatureTypeSite: 1,
          config: null,
        );

        final entity = domain.toEntity();

        expect(entity.config, isNull);
      });
    });

    test('roundtrip preserves config content', () {
      final entity = BibTypeSiteEntity(
        idNomenclatureTypeSite: 42,
        config: '{"key": "value", "number": 42}',
      );

      final roundtripped = entity.toDomain().toEntity();

      expect(roundtripped.idNomenclatureTypeSite, entity.idNomenclatureTypeSite);
      final originalConfig = jsonDecode(entity.config!);
      final roundtrippedConfig = jsonDecode(roundtripped.config!);
      expect(roundtrippedConfig, originalConfig);
    });
  });
}

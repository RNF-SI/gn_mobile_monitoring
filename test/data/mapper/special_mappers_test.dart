import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/entity/cor_visit_observer_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/module_complement_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/user_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/visit_observer_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/module_complement_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/user_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/visit_observer.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';

void main() {
  group('VisitObserverEntityMapper', () {
    group('toDomain', () {
      test('maps all fields correctly', () {
        final entity = CorVisitObserverEntity(
          idBaseVisit: 10,
          idRole: 5,
          uniqueIdCoreVisitObserver: 'uuid-observer-001',
        );

        final domain = VisitObserverEntityMapper.toDomain(entity);

        expect(domain.idBaseVisit, 10);
        expect(domain.idRole, 5);
        expect(domain.uniqueId, 'uuid-observer-001');
      });
    });

    group('toEntity', () {
      test('maps all fields correctly', () {
        const domain = VisitObserver(
          idBaseVisit: 20,
          idRole: 8,
          uniqueId: 'uuid-observer-002',
        );

        final entity = VisitObserverEntityMapper.toEntity(domain);

        expect(entity.idBaseVisit, 20);
        expect(entity.idRole, 8);
        expect(entity.uniqueIdCoreVisitObserver, 'uuid-observer-002');
      });
    });

    group('toDomainList', () {
      test('maps a list of entities to domain objects', () {
        final entities = [
          CorVisitObserverEntity(
            idBaseVisit: 1,
            idRole: 10,
            uniqueIdCoreVisitObserver: 'uid-1',
          ),
          CorVisitObserverEntity(
            idBaseVisit: 1,
            idRole: 20,
            uniqueIdCoreVisitObserver: 'uid-2',
          ),
          CorVisitObserverEntity(
            idBaseVisit: 1,
            idRole: 30,
            uniqueIdCoreVisitObserver: 'uid-3',
          ),
        ];

        final domains = VisitObserverEntityMapper.toDomainList(entities);

        expect(domains, hasLength(3));
        expect(domains[0].idRole, 10);
        expect(domains[1].idRole, 20);
        expect(domains[2].idRole, 30);
      });

      test('returns empty list for empty input', () {
        final domains = VisitObserverEntityMapper.toDomainList([]);

        expect(domains, isEmpty);
      });
    });

    group('toEntityList', () {
      test('maps a list of domain objects to entities', () {
        const domains = [
          VisitObserver(idBaseVisit: 1, idRole: 10, uniqueId: 'uid-1'),
          VisitObserver(idBaseVisit: 1, idRole: 20, uniqueId: 'uid-2'),
        ];

        final entities = VisitObserverEntityMapper.toEntityList(domains);

        expect(entities, hasLength(2));
        expect(entities[0].idRole, 10);
        expect(entities[0].uniqueIdCoreVisitObserver, 'uid-1');
        expect(entities[1].idRole, 20);
      });

      test('returns empty list for empty input', () {
        final entities = VisitObserverEntityMapper.toEntityList([]);

        expect(entities, isEmpty);
      });
    });

    test('roundtrip preserves all fields', () {
      final entity = CorVisitObserverEntity(
        idBaseVisit: 5,
        idRole: 15,
        uniqueIdCoreVisitObserver: 'uuid-round',
      );

      final roundtripped = VisitObserverEntityMapper.toEntity(
        VisitObserverEntityMapper.toDomain(entity),
      );

      expect(roundtripped.idBaseVisit, entity.idBaseVisit);
      expect(roundtripped.idRole, entity.idRole);
      expect(roundtripped.uniqueIdCoreVisitObserver,
          entity.uniqueIdCoreVisitObserver);
    });
  });

  group('ModuleComplementEntityMapper', () {
    group('toDomain', () {
      test('maps all fields correctly with valid configuration', () {
        final configJson = jsonEncode({
          'module': {
            'module_code': 'TEST',
            'module_label': 'Test Module',
          },
        });

        final entity = ModuleComplementEntity(
          idModule: 42,
          uuidModuleComplement: 'uuid-complement-001',
          idListObserver: 10,
          idListTaxonomy: 20,
          bSynthese: true,
          taxonomyDisplayFieldName: 'nom_vern,lb_nom',
          bDrawSitesGroup: true,
          data: '{"custom": "data"}',
          configuration: configJson,
        );

        // Suppress print output
        final domain = runZoned(
          () => entity.toDomain(),
          zoneSpecification: ZoneSpecification(
            print: (self, parent, zone, line) {},
          ),
        );

        expect(domain.idModule, 42);
        expect(domain.uuidModuleComplement, 'uuid-complement-001');
        expect(domain.idListObserver, 10);
        expect(domain.idListTaxonomy, 20);
        expect(domain.bSynthese, true);
        expect(domain.taxonomyDisplayFieldName, 'nom_vern,lb_nom');
        expect(domain.bDrawSitesGroup, true);
        expect(domain.data, '{"custom": "data"}');
        expect(domain.configuration, isNotNull);
        expect(domain.configuration!.module, isNotNull);
        expect(domain.configuration!.module!.moduleCode, 'TEST');
      });

      test('handles null configuration', () {
        final entity = ModuleComplementEntity(
          idModule: 1,
          bSynthese: false,
          taxonomyDisplayFieldName: 'lb_nom',
          configuration: null,
        );

        final domain = runZoned(
          () => entity.toDomain(),
          zoneSpecification: ZoneSpecification(
            print: (self, parent, zone, line) {},
          ),
        );

        expect(domain.configuration, isNull);
      });

      test('handles empty configuration', () {
        final entity = ModuleComplementEntity(
          idModule: 1,
          bSynthese: false,
          taxonomyDisplayFieldName: 'lb_nom',
          configuration: '',
        );

        final domain = runZoned(
          () => entity.toDomain(),
          zoneSpecification: ZoneSpecification(
            print: (self, parent, zone, line) {},
          ),
        );

        expect(domain.configuration, isNull);
      });

      test('handles invalid JSON configuration gracefully', () {
        final entity = ModuleComplementEntity(
          idModule: 1,
          bSynthese: false,
          taxonomyDisplayFieldName: 'lb_nom',
          configuration: 'not valid json at all {{{',
        );

        final domain = runZoned(
          () => entity.toDomain(),
          zoneSpecification: ZoneSpecification(
            print: (self, parent, zone, line) {},
          ),
        );

        expect(domain.idModule, 1);
        expect(domain.configuration, isNull);
      });
    });

    group('toEntity', () {
      test('maps all fields and serializes configuration', () {
        final configJson = jsonEncode({
          'module': {'module_code': 'TEST'},
        });

        final entity = ModuleComplementEntity(
          idModule: 42,
          uuidModuleComplement: 'uuid-001',
          idListObserver: 10,
          idListTaxonomy: 20,
          bSynthese: true,
          taxonomyDisplayFieldName: 'nom_vern,lb_nom',
          bDrawSitesGroup: false,
          data: '{"key": "val"}',
          configuration: configJson,
        );

        final domain = runZoned(
          () => entity.toDomain(),
          zoneSpecification: ZoneSpecification(
            print: (self, parent, zone, line) {},
          ),
        );

        final result = domain.toEntity();

        expect(result.idModule, 42);
        expect(result.uuidModuleComplement, 'uuid-001');
        expect(result.idListObserver, 10);
        expect(result.bSynthese, true);
        expect(result.configuration, isNotNull);
      });

      test('handles null configuration in domain', () {
        const domain = ModuleComplement(
          idModule: 1,
          configuration: null,
        );

        final entity = domain.toEntity();

        expect(entity.configuration, isNull);
      });
    });

    test('roundtrip preserves core fields', () {
      final entity = ModuleComplementEntity(
        idModule: 5,
        uuidModuleComplement: 'uuid-round',
        idListObserver: 15,
        idListTaxonomy: 25,
        bSynthese: true,
        taxonomyDisplayFieldName: 'nom_vern',
        bDrawSitesGroup: true,
        data: '{"test": 1}',
        configuration: null,
      );

      final domain = runZoned(
        () => entity.toDomain(),
        zoneSpecification: ZoneSpecification(
          print: (self, parent, zone, line) {},
        ),
      );

      final roundtripped = domain.toEntity();

      expect(roundtripped.idModule, entity.idModule);
      expect(roundtripped.uuidModuleComplement, entity.uuidModuleComplement);
      expect(roundtripped.idListObserver, entity.idListObserver);
      expect(roundtripped.idListTaxonomy, entity.idListTaxonomy);
      expect(roundtripped.bSynthese, entity.bSynthese);
      expect(roundtripped.taxonomyDisplayFieldName,
          entity.taxonomyDisplayFieldName);
      expect(roundtripped.bDrawSitesGroup, entity.bDrawSitesGroup);
      expect(roundtripped.data, entity.data);
    });
  });

  group('UserMapper', () {
    test('transformToModel maps all fields correctly', () {
      final entity = UserEntity(
        active: true,
        dateInsert: '2024-01-01',
        dateUpdate: '2024-06-15',
        email: 'user@test.com',
        groupe: false,
        idOrganisme: 1,
        idRole: 42,
        identifiant: 'user.test',
        maxLevelProfil: 3,
        nomComplet: 'John Doe',
        nomRole: 'Doe',
        prenomRole: 'John',
        token: 'jwt-token-123',
      );

      final user = UserMapper.transformToModel(entity);

      expect(user.id, 42);
      expect(user.name, 'John Doe');
      expect(user.email, 'user@test.com');
      expect(user.token, 'jwt-token-123');
    });

    test('defaults email to "No email provided" when null', () {
      final entity = UserEntity(
        active: true,
        dateInsert: '2024-01-01',
        dateUpdate: '2024-06-15',
        email: null,
        groupe: false,
        idOrganisme: 1,
        idRole: 1,
        identifiant: 'test',
        maxLevelProfil: 1,
        nomComplet: 'Test User',
        nomRole: 'User',
        prenomRole: 'Test',
        token: 'token',
      );

      final user = UserMapper.transformToModel(entity);

      expect(user.email, 'No email provided');
    });

    test('maps idRole to id (not idOrganisme)', () {
      final entity = UserEntity(
        active: true,
        dateInsert: '2024-01-01',
        dateUpdate: '2024-06-15',
        groupe: false,
        idOrganisme: 999,
        idRole: 42,
        identifiant: 'test',
        maxLevelProfil: 1,
        nomComplet: 'Test',
        nomRole: 'Test',
        prenomRole: 'Test',
        token: 'token',
      );

      final user = UserMapper.transformToModel(entity);

      expect(user.id, 42);
      expect(user.id, isNot(999));
    });
  });
}

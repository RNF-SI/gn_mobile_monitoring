import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/entity/module_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/module_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';

void main() {
  group('ModuleEntityMapper', () {
    group('toDomain', () {
      test('maps idModule to id and moduleName to moduleLabel', () {
        final entity = ModuleEntity(
          idModule: 42,
          moduleCode: 'TEST_MOD',
          moduleName: 'Test Module',
          moduleDesc: 'A test module',
          downloaded: true,
        );

        final domain = entity.toDomain();

        expect(domain.id, 42);
        expect(domain.moduleCode, 'TEST_MOD');
        expect(domain.moduleLabel, 'Test Module');
        expect(domain.moduleDesc, 'A test module');
        expect(domain.downloaded, true);
      });

      test('sets activeFrontend and activeBackend to null', () {
        final entity = ModuleEntity(
          idModule: 1,
          moduleCode: 'MOD',
          moduleName: 'Module',
          downloaded: false,
        );

        final domain = entity.toDomain();

        expect(domain.activeFrontend, isNull);
        expect(domain.activeBackend, isNull);
      });

      test('handles downloaded=false', () {
        final entity = ModuleEntity(
          idModule: 1,
          moduleCode: 'MOD',
          moduleName: 'Module',
          downloaded: false,
        );

        final domain = entity.toDomain();

        expect(domain.downloaded, false);
      });
    });

    group('toEntity', () {
      test('maps id to idModule and moduleLabel to moduleName', () {
        const domain = Module(
          id: 42,
          moduleCode: 'TEST_MOD',
          moduleLabel: 'Test Module',
          moduleDesc: 'A test module',
          downloaded: true,
        );

        final entity = domain.toEntity();

        expect(entity.idModule, 42);
        expect(entity.moduleCode, 'TEST_MOD');
        expect(entity.moduleName, 'Test Module');
        expect(entity.moduleDesc, 'A test module');
        expect(entity.downloaded, true);
      });

      test('defaults moduleCode to empty string when null', () {
        const domain = Module(
          id: 1,
          moduleCode: null,
          moduleLabel: 'Test',
        );

        final entity = domain.toEntity();

        expect(entity.moduleCode, '');
      });

      test('defaults moduleName to empty string when moduleLabel is null', () {
        const domain = Module(
          id: 1,
          moduleLabel: null,
        );

        final entity = domain.toEntity();

        expect(entity.moduleName, '');
      });

      test('coerces downloaded==null to false', () {
        const domain = Module(
          id: 1,
          downloaded: null,
        );

        final entity = domain.toEntity();

        expect(entity.downloaded, false);
      });

      test('sets cruved to empty map', () {
        const domain = Module(id: 1);

        final entity = domain.toEntity();

        expect(entity.cruved, isEmpty);
      });
    });

    group('roundtrip', () {
      test('preserves core fields through entity->domain->entity', () {
        final entity = ModuleEntity(
          idModule: 10,
          moduleCode: 'ROUND',
          moduleName: 'Roundtrip Test',
          moduleDesc: 'Testing roundtrip',
          downloaded: true,
        );

        final roundtripped = entity.toDomain().toEntity();

        expect(roundtripped.idModule, entity.idModule);
        expect(roundtripped.moduleCode, entity.moduleCode);
        expect(roundtripped.moduleName, entity.moduleName);
        expect(roundtripped.moduleDesc, entity.moduleDesc);
        expect(roundtripped.downloaded, entity.downloaded);
      });
    });
  });
}

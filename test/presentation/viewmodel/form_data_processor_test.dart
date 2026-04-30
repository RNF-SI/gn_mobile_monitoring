import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclature_by_id_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/nomenclature_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/taxon_service.dart';
import 'package:mocktail/mocktail.dart';

class MockNomenclatureService extends Mock implements NomenclatureService {}

class MockTaxonService extends Mock implements TaxonService {}

class MockGetNomenclatureByIdUseCase extends Mock
    implements GetNomenclatureByIdUseCase {}

class MockRef extends Mock implements Ref {}

void main() {
  late FormDataProcessor formDataProcessor;
  late MockNomenclatureService mockNomenclatureService;
  late MockGetNomenclatureByIdUseCase mockGetNomenclatureByIdUseCase;
  late MockRef mockRef;

  setUp(() {
    mockNomenclatureService = MockNomenclatureService();
    final mockTaxonService = MockTaxonService();
    mockGetNomenclatureByIdUseCase = MockGetNomenclatureByIdUseCase();
    mockRef = MockRef();

    when(() => mockRef.read(nomenclatureServiceProvider.notifier))
        .thenReturn(mockNomenclatureService);

    when(() => mockRef.read(taxonServiceProvider.notifier))
        .thenReturn(mockTaxonService);

    when(() => mockRef.read(getNomenclatureByIdUseCaseProvider))
        .thenReturn(mockGetNomenclatureByIdUseCase);

    formDataProcessor = FormDataProcessor(mockRef);
  });

  group('processFormData', () {
    test('should return the same data if no nomenclature fields', () async {
      final formData = {'field1': 'value1', 'field2': 42};

      final result = await formDataProcessor.processFormData(formData);

      expect(result, equals(formData));
    });

    test('should extract ID from nomenclature object with id field', () async {
      final formData = {
        'id_nomenclature_test': {
          'id': 42,
          'code_nomenclature_type': 'TEST',
          'cd_nomenclature': '5',
          'label': 'Test Value'
        }
      };

      final result = await formDataProcessor.processFormData(formData);

      expect(result, equals({'id_nomenclature_test': 42}));
    });

    test('should handle string ID and convert it to integer', () async {
      final formData = {
        'id_nomenclature_test': {
          'id': '42',
          'code_nomenclature_type': 'TEST',
          'cd_nomenclature': '5',
          'label': 'Test Value'
        }
      };

      final result = await formDataProcessor.processFormData(formData);

      expect(result, equals({'id_nomenclature_test': 42}));
    });

    test('should lookup nomenclature ID when only code and type are provided',
        () async {
      final formData = {
        'id_nomenclature_test': {
          'code_nomenclature_type': 'TEST',
          'cd_nomenclature': '5',
          'label': 'Test Value'
        }
      };

      final nomenclatures = [
        Nomenclature(
          id: 42,
          idType: 1,
          codeType: 'TEST',
          cdNomenclature: '5',
          labelFr: 'Test Value',
          labelDefault: 'Test Value',
          hierarchy: null,
        ),
      ];

      when(() => mockNomenclatureService.getNomenclaturesByTypeCode('TEST'))
          .thenAnswer((_) async => nomenclatures);

      final result = await formDataProcessor.processFormData(formData);

      expect(result, equals({'id_nomenclature_test': 42}));
      verify(() =>
              mockNomenclatureService.getNomenclaturesByTypeCode('TEST'))
          .called(1);
    });

    test('should preserve original data if nomenclature lookup fails',
        () async {
      final formData = {
        'id_nomenclature_test': {
          'code_nomenclature_type': 'TEST',
          'cd_nomenclature': 'UNKNOWN_CODE',
          'label': 'Test Value'
        }
      };

      final nomenclatures = [
        Nomenclature(
          id: 42,
          idType: 1,
          codeType: 'TEST',
          cdNomenclature: '5',
          labelFr: 'Test Value',
          labelDefault: 'Test Value',
          hierarchy: null,
        ),
      ];

      when(() => mockNomenclatureService.getNomenclaturesByTypeCode('TEST'))
          .thenAnswer((_) async => nomenclatures);

      final result = await formDataProcessor.processFormData(formData);

      expect(
          result,
          equals({
            'id_nomenclature_test': {
              'code_nomenclature_type': 'TEST',
              'cd_nomenclature': 'UNKNOWN_CODE',
              'label': 'Test Value'
            }
          }));
      verify(() =>
              mockNomenclatureService.getNomenclaturesByTypeCode('TEST'))
          .called(1);
    });
  });

  group('processFormDataForDisplay', () {
    test('should return the same data if no nomenclature fields', () async {
      final formData = {'field1': 'value1', 'field2': 42};

      final result =
          await formDataProcessor.processFormDataForDisplay(formData);

      expect(result, equals(formData));
    });

    test('should convert nomenclature ID to object', () async {
      final formData = {'id_nomenclature_test': 42};

      when(() => mockGetNomenclatureByIdUseCase.execute(42))
          .thenAnswer((_) async => Nomenclature(
                id: 42,
                idType: 1,
                codeType: 'BRAUNBLANQABDOM',
                cdNomenclature: '5',
                labelFr: 'Test Value',
                labelDefault: 'Default Label',
                hierarchy: null,
              ));

      final result =
          await formDataProcessor.processFormDataForDisplay(formData);

      expect(
          result,
          equals({
            'id_nomenclature_test': {
              'id': 42,
              'code_nomenclature_type': 'BRAUNBLANQABDOM',
              'cd_nomenclature': '5',
              'label': 'Test Value'
            }
          }));

      verify(() => mockGetNomenclatureByIdUseCase.execute(42)).called(1);
    });

    test(
        'should resolve any nomenclature type via its id (not just hardcoded types)',
        () async {
      // Régression #P4 : avant, seuls BRAUNBLANQABDOM/STADE_VIE/TYPE_MEDIA/
      // TYPE_SITE étaient résolus ; SEXE et les autres restaient à l'ID brut.
      final formData = {'id_nomenclature_sex': 163};

      when(() => mockGetNomenclatureByIdUseCase.execute(163))
          .thenAnswer((_) async => Nomenclature(
                id: 163,
                idType: 2,
                codeType: 'SEXE',
                cdNomenclature: 'M',
                labelFr: 'Mâle',
                labelDefault: 'Male',
                hierarchy: null,
              ));

      final result =
          await formDataProcessor.processFormDataForDisplay(formData);

      expect(
          result,
          equals({
            'id_nomenclature_sex': {
              'id': 163,
              'code_nomenclature_type': 'SEXE',
              'cd_nomenclature': 'M',
              'label': 'Mâle'
            }
          }));
    });

    test('should preserve ID if nomenclature lookup returns null', () async {
      final formData = {'id_nomenclature_test': 999};

      when(() => mockGetNomenclatureByIdUseCase.execute(999))
          .thenAnswer((_) async => null);

      final result =
          await formDataProcessor.processFormDataForDisplay(formData);

      expect(result, equals({'id_nomenclature_test': 999}));
    });

    test('should use labelDefault if labelFr is null', () async {
      final formData = {'id_nomenclature_test': 42};

      when(() => mockGetNomenclatureByIdUseCase.execute(42))
          .thenAnswer((_) async => Nomenclature(
                id: 42,
                idType: 1,
                codeType: 'BRAUNBLANQABDOM',
                cdNomenclature: '5',
                labelFr: null,
                labelDefault: 'Default Label',
                hierarchy: null,
              ));

      final result =
          await formDataProcessor.processFormDataForDisplay(formData);

      expect(
          result,
          equals({
            'id_nomenclature_test': {
              'id': 42,
              'code_nomenclature_type': 'BRAUNBLANQABDOM',
              'cd_nomenclature': '5',
              'label': 'Default Label'
            }
          }));
    });

    test('should use cdNomenclature if both labels are null', () async {
      final formData = {'id_nomenclature_test': 42};

      when(() => mockGetNomenclatureByIdUseCase.execute(42))
          .thenAnswer((_) async => Nomenclature(
                id: 42,
                idType: 1,
                codeType: 'BRAUNBLANQABDOM',
                cdNomenclature: '5',
                labelFr: null,
                labelDefault: null,
                hierarchy: null,
              ));

      final result =
          await formDataProcessor.processFormDataForDisplay(formData);

      expect(
          result,
          equals({
            'id_nomenclature_test': {
              'id': 42,
              'code_nomenclature_type': 'BRAUNBLANQABDOM',
              'cd_nomenclature': '5',
              'label': '5'
            }
          }));
    });
  });
}

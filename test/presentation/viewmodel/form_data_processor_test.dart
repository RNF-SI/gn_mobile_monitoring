import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/nomenclature_service.dart';
import 'package:mocktail/mocktail.dart';

class MockNomenclatureService extends Mock implements NomenclatureService {}

class MockRef extends Mock implements Ref {}

void main() {
  late FormDataProcessor formDataProcessor;
  late MockNomenclatureService mockNomenclatureService;
  late MockRef mockRef;

  setUp(() {
    mockNomenclatureService = MockNomenclatureService();
    mockRef = MockRef();
    
    // Setup the mock Ref to return mockNomenclatureService
    when(() => mockRef.read(nomenclatureServiceProvider.notifier))
        .thenReturn(mockNomenclatureService);
    
    formDataProcessor = FormDataProcessor(mockRef);
  });

  group('processFormData', () {
    test('should return the same data if no nomenclature fields', () async {
      // Arrange
      final formData = {'field1': 'value1', 'field2': 42};
      
      // Act
      final result = await formDataProcessor.processFormData(formData);
      
      // Assert
      expect(result, equals(formData));
    });

    test('should extract ID from nomenclature object with id field', () async {
      // Arrange
      final formData = {
        'id_nomenclature_test': {
          'id': 42,
          'code_nomenclature_type': 'TEST',
          'cd_nomenclature': '5',
          'label': 'Test Value'
        }
      };
      
      // Act
      final result = await formDataProcessor.processFormData(formData);
      
      // Assert
      expect(result, equals({'id_nomenclature_test': 42}));
    });
    
    test('should handle string ID and convert it to integer', () async {
      // Arrange
      final formData = {
        'id_nomenclature_test': {
          'id': '42',
          'code_nomenclature_type': 'TEST',
          'cd_nomenclature': '5',
          'label': 'Test Value'
        }
      };
      
      // Act
      final result = await formDataProcessor.processFormData(formData);
      
      // Assert
      expect(result, equals({'id_nomenclature_test': 42}));
    });
    
    test('should lookup nomenclature ID when only code and type are provided', () async {
      // Arrange
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
      
      // Act
      final result = await formDataProcessor.processFormData(formData);
      
      // Assert
      expect(result, equals({'id_nomenclature_test': 42}));
      verify(() => mockNomenclatureService.getNomenclaturesByTypeCode('TEST')).called(1);
    });
    
    test('should preserve original data if nomenclature lookup fails', () async {
      // Arrange
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
      
      // Act
      final result = await formDataProcessor.processFormData(formData);
      
      // Assert
      expect(result, equals(formData));
      verify(() => mockNomenclatureService.getNomenclaturesByTypeCode('TEST')).called(1);
    });
  });

  group('processFormDataForDisplay', () {
    test('should return the same data if no nomenclature fields', () async {
      // Arrange
      final formData = {'field1': 'value1', 'field2': 42};
      
      // Act
      final result = await formDataProcessor.processFormDataForDisplay(formData);
      
      // Assert
      expect(result, equals(formData));
    });
    
    test('should convert nomenclature ID to object', () async {
      // Arrange
      final formData = {'id_nomenclature_test': 42};
      
      // Create test data
      final nomenclatures = [
        Nomenclature(
          id: 42,
          idType: 1,
          codeType: 'BRAUNBLANQABDOM',
          cdNomenclature: '5',
          labelFr: 'Test Value',
          labelDefault: 'Default Label',
          hierarchy: null,
        ),
      ];
      
      // Setup mocks for specific type
      when(() => mockNomenclatureService.getNomenclaturesByTypeCode('BRAUNBLANQABDOM'))
          .thenAnswer((_) async => nomenclatures);
      
      // Setup mocks for other types to return empty lists
      when(() => mockNomenclatureService.getNomenclaturesByTypeCode('STADE_VIE'))
          .thenAnswer((_) async => <Nomenclature>[]);
      when(() => mockNomenclatureService.getNomenclaturesByTypeCode('TYPE_MEDIA'))
          .thenAnswer((_) async => <Nomenclature>[]);
      when(() => mockNomenclatureService.getNomenclaturesByTypeCode('TYPE_SITE'))
          .thenAnswer((_) async => <Nomenclature>[]);
      
      // Act
      final result = await formDataProcessor.processFormDataForDisplay(formData);
      
      // Assert
      expect(result, equals({
        'id_nomenclature_test': {
          'id': 42,
          'code_nomenclature_type': 'BRAUNBLANQABDOM',
          'cd_nomenclature': '5',
          'label': 'Test Value'
        }
      }));
      
      // Verify mock calls
      verify(() => mockRef.read(nomenclatureServiceProvider.notifier)).called(1);
      verify(() => mockNomenclatureService.getNomenclaturesByTypeCode('BRAUNBLANQABDOM')).called(1);
    });
    
    test('should search through multiple nomenclature types until finding a match', () async {
      // Arrange
      final formData = {'id_nomenclature_test': 42};
      
      // Setup empty lists for first two types
      when(() => mockNomenclatureService.getNomenclaturesByTypeCode('BRAUNBLANQABDOM'))
          .thenAnswer((_) async => <Nomenclature>[]);
      when(() => mockNomenclatureService.getNomenclaturesByTypeCode('STADE_VIE'))
          .thenAnswer((_) async => <Nomenclature>[]);
          
      // Set up a match for the third type
      final typeMediaNomenclatures = [
        Nomenclature(
          id: 42,
          idType: 1,
          codeType: 'TYPE_MEDIA',
          cdNomenclature: '5',
          labelFr: 'Media Label',
          labelDefault: 'Default Media Label',
          hierarchy: null,
        ),
      ];
      when(() => mockNomenclatureService.getNomenclaturesByTypeCode('TYPE_MEDIA'))
          .thenAnswer((_) async => typeMediaNomenclatures);
          
      // Set up fourth type which won't be called
      when(() => mockNomenclatureService.getNomenclaturesByTypeCode('TYPE_SITE'))
          .thenAnswer((_) async => <Nomenclature>[]);
      
      // Act
      final result = await formDataProcessor.processFormDataForDisplay(formData);
      
      // Assert
      expect(result, equals({
        'id_nomenclature_test': {
          'id': 42,
          'code_nomenclature_type': 'TYPE_MEDIA',
          'cd_nomenclature': '5',
          'label': 'Media Label'
        }
      }));
      
      // Verify we stopped searching after finding a match
      verify(() => mockNomenclatureService.getNomenclaturesByTypeCode('BRAUNBLANQABDOM')).called(1);
      verify(() => mockNomenclatureService.getNomenclaturesByTypeCode('STADE_VIE')).called(1);
      verify(() => mockNomenclatureService.getNomenclaturesByTypeCode('TYPE_MEDIA')).called(1);
      verifyNever(() => mockNomenclatureService.getNomenclaturesByTypeCode('TYPE_SITE'));
    });
    
    test('should preserve ID if nomenclature lookup fails for all types', () async {
      // Arrange
      final formData = {'id_nomenclature_test': 999};
      
      // All types return empty lists
      when(() => mockNomenclatureService.getNomenclaturesByTypeCode(any()))
          .thenAnswer((_) async => <Nomenclature>[]);
      
      // Act
      final result = await formDataProcessor.processFormDataForDisplay(formData);
      
      // Assert
      expect(result, equals({'id_nomenclature_test': 999}));
    });
    
    test('should use labelDefault if labelFr is null', () async {
      // Arrange
      final formData = {'id_nomenclature_test': 42};
      
      final nomenclatures = [
        Nomenclature(
          id: 42,
          idType: 1,
          codeType: 'BRAUNBLANQABDOM',
          cdNomenclature: '5',
          labelFr: null,
          labelDefault: 'Default Label',
          hierarchy: null,
        ),
      ];
      
      // Important: This needs to come BEFORE the generic any() matcher
      when(() => mockNomenclatureService.getNomenclaturesByTypeCode('BRAUNBLANQABDOM'))
          .thenAnswer((_) async => nomenclatures);
      
      // Configure other specific type codes to return empty lists
      when(() => mockNomenclatureService.getNomenclaturesByTypeCode('STADE_VIE'))
          .thenAnswer((_) async => <Nomenclature>[]);
      when(() => mockNomenclatureService.getNomenclaturesByTypeCode('TYPE_MEDIA'))
          .thenAnswer((_) async => <Nomenclature>[]);
      when(() => mockNomenclatureService.getNomenclaturesByTypeCode('TYPE_SITE'))
          .thenAnswer((_) async => <Nomenclature>[]);
      
      // Act
      final result = await formDataProcessor.processFormDataForDisplay(formData);
      
      // Assert
      expect(result, equals({
        'id_nomenclature_test': {
          'id': 42,
          'code_nomenclature_type': 'BRAUNBLANQABDOM',
          'cd_nomenclature': '5',
          'label': 'Default Label'
        }
      }));
    });
    
    test('should use cdNomenclature if both labels are null', () async {
      // Arrange
      final formData = {'id_nomenclature_test': 42};
      
      final nomenclatures = [
        Nomenclature(
          id: 42,
          idType: 1,
          codeType: 'BRAUNBLANQABDOM',
          cdNomenclature: '5',
          labelFr: null,
          labelDefault: null,
          hierarchy: null,
        ),
      ];
      
      // Important: This needs to come BEFORE any other matchers
      when(() => mockNomenclatureService.getNomenclaturesByTypeCode('BRAUNBLANQABDOM'))
          .thenAnswer((_) async => nomenclatures);
      
      // Configure other specific type codes to return empty lists  
      when(() => mockNomenclatureService.getNomenclaturesByTypeCode('STADE_VIE'))
          .thenAnswer((_) async => <Nomenclature>[]);
      when(() => mockNomenclatureService.getNomenclaturesByTypeCode('TYPE_MEDIA'))
          .thenAnswer((_) async => <Nomenclature>[]);
      when(() => mockNomenclatureService.getNomenclaturesByTypeCode('TYPE_SITE'))
          .thenAnswer((_) async => <Nomenclature>[]);
      
      // Act
      final result = await formDataProcessor.processFormDataForDisplay(formData);
      
      // Assert
      expect(result, equals({
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclatures_by_type_code_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart' as custom_async_state;
import 'package:gn_mobile_monitoring/presentation/viewmodel/nomenclature_service.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late ProviderContainer container;
  late MockGetNomenclaturesByTypeCodeUseCase mockGetNomenclaturesByTypeCodeUseCase;
  
  setUp(() {
    mockGetNomenclaturesByTypeCodeUseCase = MockGetNomenclaturesByTypeCodeUseCase();
    
    container = ProviderContainer(
      overrides: [
        // Override the provider to use our mock implementation
        getNomenclaturesByTypeCodeUseCaseProvider.overrideWithValue(
          mockGetNomenclaturesByTypeCodeUseCase,
        ),
      ],
    );
    
    // Setup default behavior for the mock
    when(() => mockGetNomenclaturesByTypeCodeUseCase.execute(any()))
        .thenAnswer((_) async => <Nomenclature>[]);
  });
  
  tearDown(() {
    container.dispose();
  });
  
  test('Initial state should be init', () async {
    final service = container.read(nomenclatureServiceProvider.notifier);
    final state = container.read(nomenclatureServiceProvider);
    
    expect(service, isNotNull);
    expect(state, isA<custom_async_state.Init>());
  });
  
  test('getNomenclaturesByTypeCode should fetch nomenclatures', () async {
    // Arrange
    final testNomenclatures = [
      Nomenclature(
        id: 1,
        idType: 100,
        cdNomenclature: 'TEST',
        labelDefault: 'Test Nomenclature',
      ),
    ];
    
    when(() => mockGetNomenclaturesByTypeCodeUseCase.execute('TYPE_TEST'))
        .thenAnswer((_) async => testNomenclatures);
    
    final service = container.read(nomenclatureServiceProvider.notifier);
    
    // Act
    final result = await service.getNomenclaturesByTypeCode('TYPE_TEST');
    
    // Assert
    expect(result, equals(testNomenclatures));
    verify(() => mockGetNomenclaturesByTypeCodeUseCase.execute('TYPE_TEST')).called(1);
  });
  
  test('getNomenclaturesByTypeCode should use cache for repeated calls', () async {
    // Arrange
    final testNomenclatures = [
      Nomenclature(
        id: 1,
        idType: 100,
        cdNomenclature: 'TEST',
        labelDefault: 'Test Nomenclature',
      ),
    ];
    
    when(() => mockGetNomenclaturesByTypeCodeUseCase.execute('TYPE_TEST'))
        .thenAnswer((_) async => testNomenclatures);
    
    final service = container.read(nomenclatureServiceProvider.notifier);
    
    // Act
    await service.getNomenclaturesByTypeCode('TYPE_TEST'); // First call
    await service.getNomenclaturesByTypeCode('TYPE_TEST'); // Second call (should use cache)
    
    // Assert
    verify(() => mockGetNomenclaturesByTypeCodeUseCase.execute('TYPE_TEST')).called(1);
  });
  
  test('clearCache should reset the state', () async {
    // Arrange
    final testNomenclatures = [
      Nomenclature(
        id: 1,
        idType: 100,
        cdNomenclature: 'TEST',
        labelDefault: 'Test Nomenclature',
      ),
    ];
    
    when(() => mockGetNomenclaturesByTypeCodeUseCase.execute('TYPE_TEST'))
        .thenAnswer((_) async => testNomenclatures);
    
    final service = container.read(nomenclatureServiceProvider.notifier);
    
    // Act
    await service.getNomenclaturesByTypeCode('TYPE_TEST'); // First call
    service.clearCache();
    await service.getNomenclaturesByTypeCode('TYPE_TEST'); // Call after clearing cache
    
    // Assert
    verify(() => mockGetNomenclaturesByTypeCodeUseCase.execute('TYPE_TEST')).called(2);
  });
  
  test('preloadNomenclatures should cache multiple types', () async {
    // Arrange
    final testType1Nomenclatures = [
      Nomenclature(
        id: 1,
        idType: 100,
        cdNomenclature: 'TEST_1',
        labelDefault: 'Test 1',
      ),
    ];
    
    final testType2Nomenclatures = [
      Nomenclature(
        id: 2,
        idType: 101,
        cdNomenclature: 'TEST_2',
        labelDefault: 'Test 2',
      ),
    ];
    
    when(() => mockGetNomenclaturesByTypeCodeUseCase.execute('TYPE_1'))
        .thenAnswer((_) async => testType1Nomenclatures);
    when(() => mockGetNomenclaturesByTypeCodeUseCase.execute('TYPE_2'))
        .thenAnswer((_) async => testType2Nomenclatures);
    
    final service = container.read(nomenclatureServiceProvider.notifier);
    
    // Act
    await service.preloadNomenclatures(['TYPE_1', 'TYPE_2']);
    final result1 = await service.getNomenclaturesByTypeCode('TYPE_1');
    final result2 = await service.getNomenclaturesByTypeCode('TYPE_2');
    
    // Assert
    expect(result1, equals(testType1Nomenclatures));
    expect(result2, equals(testType2Nomenclatures));
    verify(() => mockGetNomenclaturesByTypeCodeUseCase.execute('TYPE_1')).called(1);
    verify(() => mockGetNomenclaturesByTypeCodeUseCase.execute('TYPE_2')).called(1);
  });
}
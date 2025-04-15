import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_observation_detail_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observation_detail_by_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observation_details_by_observation_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/save_observation_detail_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observation_detail_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockGetObservationDetailsByObservationIdUseCase extends Mock
    implements GetObservationDetailsByObservationIdUseCase {}

class MockGetObservationDetailByIdUseCase extends Mock
    implements GetObservationDetailByIdUseCase {}

class MockSaveObservationDetailUseCase extends Mock
    implements SaveObservationDetailUseCase {}

class MockDeleteObservationDetailUseCase extends Mock
    implements DeleteObservationDetailUseCase {}

class MockFormDataProcessor extends Mock implements FormDataProcessor {}

void main() {
  late ObservationDetailViewModel viewModel;
  late MockGetObservationDetailsByObservationIdUseCase
      mockGetObservationDetailsByObservationIdUseCase;
  late MockGetObservationDetailByIdUseCase mockGetObservationDetailByIdUseCase;
  late MockSaveObservationDetailUseCase mockSaveObservationDetailUseCase;
  late MockDeleteObservationDetailUseCase mockDeleteObservationDetailUseCase;
  late MockFormDataProcessor mockFormDataProcessor;

  const observationId = 1;
  const detailId = 2;

  setUp(() {
    mockGetObservationDetailsByObservationIdUseCase =
        MockGetObservationDetailsByObservationIdUseCase();
    mockGetObservationDetailByIdUseCase = MockGetObservationDetailByIdUseCase();
    mockSaveObservationDetailUseCase = MockSaveObservationDetailUseCase();
    mockDeleteObservationDetailUseCase = MockDeleteObservationDetailUseCase();
    mockFormDataProcessor = MockFormDataProcessor();

    // Setup initial call for constructor
    when(() => mockGetObservationDetailsByObservationIdUseCase
        .execute(observationId)).thenAnswer((_) async => []);
        
    // Setup the FormDataProcessor mock - both methods need to be mocked
    when(() => mockFormDataProcessor.processFormData(any()))
        .thenAnswer((invocation) async => invocation.positionalArguments[0] as Map<String, dynamic>);
    
    when(() => mockFormDataProcessor.processFormDataForDisplay(any()))
        .thenAnswer((invocation) async => invocation.positionalArguments[0] as Map<String, dynamic>);
        
    // Register fallback values
    registerFallbackValue(<String, dynamic>{});
  });

  test('initial state should become loading and then data', () async {
    viewModel = ObservationDetailViewModel(
      mockGetObservationDetailsByObservationIdUseCase,
      mockGetObservationDetailByIdUseCase,
      mockSaveObservationDetailUseCase,
      mockDeleteObservationDetailUseCase,
      mockFormDataProcessor,
      observationId,
    );

    expect(viewModel.state.isLoading, isTrue);

    // Wait for the initial load to complete
    await Future.delayed(const Duration(milliseconds: 100));

    expect(viewModel.state.hasValue, isTrue);
    expect(viewModel.state.value, isEmpty);
  });

  group('loadObservationDetails', () {
    late ObservationDetailViewModel localViewModel;
    
    setUp(() {
      // Reset mocks to ensure clean environment
      reset(mockGetObservationDetailsByObservationIdUseCase);
      reset(mockGetObservationDetailByIdUseCase);
      reset(mockSaveObservationDetailUseCase);
      reset(mockDeleteObservationDetailUseCase);
      
      // Do not load initial data in setup - this leads to race conditions and timer/future issues in testing
      when(() => mockGetObservationDetailsByObservationIdUseCase.execute(observationId))
          .thenAnswer((_) async => []);
    });

    test('should update state to data when use case succeeds', () async {
      // Arrange - Set up the mock for this specific test with the data we want to return
      final details = [
        ObservationDetail(
          idObservationDetail: 1,
          idObservation: observationId,
          uuidObservationDetail: 'uuid-1',
          data: {'key': 'value1'},
        ),
        ObservationDetail(
          idObservationDetail: 2,
          idObservation: observationId,
          uuidObservationDetail: 'uuid-2',
          data: {'key': 'value2'},
        ),
      ];

      // Reset all mocks to start fresh
      reset(mockGetObservationDetailsByObservationIdUseCase);
      reset(mockGetObservationDetailByIdUseCase);
      reset(mockSaveObservationDetailUseCase);
      reset(mockDeleteObservationDetailUseCase);
      
      // First configure the mock to return an empty list for initial load
      when(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).thenAnswer((_) async => []);
          
      // Create the view model for this test
      final viewModel = ObservationDetailViewModel(
        mockGetObservationDetailsByObservationIdUseCase,
        mockGetObservationDetailByIdUseCase,
        mockSaveObservationDetailUseCase,
        mockDeleteObservationDetailUseCase,
        mockFormDataProcessor,
        observationId,
      );

      // Wait for the initial load to finish
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Now reconfigure the mock to return our test data
      reset(mockGetObservationDetailsByObservationIdUseCase);
      when(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).thenAnswer((_) async => details);
      
      // Explicitly call loadObservationDetails
      await viewModel.loadObservationDetails();
      
      // Wait a bit more to ensure state is updated
      await Future.delayed(const Duration(milliseconds: 50));

      // Assert - Check that state updated correctly
      expect(viewModel.state.value, details);
      verify(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).called(1);
    });

    test('should update state to error when use case throws', () async {
      // Arrange
      final exception = Exception('Error loading details');
      when(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).thenThrow(exception);

      // Create local viewmodel to avoid conflicts with other tests
      localViewModel = ObservationDetailViewModel(
        mockGetObservationDetailsByObservationIdUseCase,
        mockGetObservationDetailByIdUseCase,
        mockSaveObservationDetailUseCase,
        mockDeleteObservationDetailUseCase,
        mockFormDataProcessor,
        observationId,
      );

      // Act - Wait for the initial load to complete (which will throw an error)
      await Future.microtask(() => null);

      // Assert
      expect(localViewModel.state.hasError, isTrue);
      expect(localViewModel.state.error, exception);
      verify(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).called(1);
    });
  });

  group('getObservationDetailsByObservationId', () {
    late ObservationDetailViewModel localViewModel;
    
    setUp(() {
      // Reset mocks to ensure clean environment
      reset(mockGetObservationDetailsByObservationIdUseCase);
      reset(mockGetObservationDetailByIdUseCase);
      reset(mockSaveObservationDetailUseCase);
      reset(mockDeleteObservationDetailUseCase);
      
      // Configure the initial load to not interfere with our tests
      when(() => mockGetObservationDetailsByObservationIdUseCase.execute(observationId))
          .thenAnswer((_) async => []);
          
      // Create the view model
      localViewModel = ObservationDetailViewModel(
        mockGetObservationDetailsByObservationIdUseCase,
        mockGetObservationDetailByIdUseCase,
        mockSaveObservationDetailUseCase,
        mockDeleteObservationDetailUseCase,
        mockFormDataProcessor,
        observationId,
      );
    });

    test('should return details when use case succeeds', () async {
      // Reset all mocks to start fresh
      reset(mockGetObservationDetailsByObservationIdUseCase);
      reset(mockGetObservationDetailByIdUseCase);
      reset(mockSaveObservationDetailUseCase);
      reset(mockDeleteObservationDetailUseCase);
      reset(mockFormDataProcessor);
      
      // Prepare test data
      final details = [
        ObservationDetail(
          idObservationDetail: 1,
          idObservation: observationId,
          uuidObservationDetail: 'uuid-1',
          data: {'key': 'value1'},
        ),
      ];

      // Setup the mock for the viewModel initialization and the actual test
      when(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).thenAnswer((_) async => details);
      
      // Configure FormDataProcessor mock - both methods need mocking
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((invocation) async => invocation.positionalArguments[0] as Map<String, dynamic>);
      
      when(() => mockFormDataProcessor.processFormDataForDisplay(any()))
          .thenAnswer((invocation) async => invocation.positionalArguments[0] as Map<String, dynamic>);
      
      // Create a fresh viewModel
      final freshViewModel = ObservationDetailViewModel(
        mockGetObservationDetailsByObservationIdUseCase,
        mockGetObservationDetailByIdUseCase,
        mockSaveObservationDetailUseCase,
        mockDeleteObservationDetailUseCase,
        mockFormDataProcessor,
        observationId,
      );
      
      // Wait for initialization
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Reset interactions between initialization and actual call
      clearInteractions(mockGetObservationDetailsByObservationIdUseCase);
      
      // Setup mock again for clarity
      when(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).thenAnswer((_) async => details);

      // Act
      final result =
          await freshViewModel.getObservationDetailsByObservationId(observationId);

      // Assert
      expect(result, equals(details));
      verify(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).called(1);
    });

    test('should return empty list when use case throws', () async {
      // Arrange - Wait for initial loading to complete first
      await Future.microtask(() => null);
      
      // Reset the mock for this test
      reset(mockGetObservationDetailsByObservationIdUseCase);
      when(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).thenThrow(Exception('Error'));

      // Act
      final result =
          await localViewModel.getObservationDetailsByObservationId(observationId);

      // Assert
      expect(result, isEmpty);
      verify(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).called(1);
    });
  });

  group('getObservationDetailById', () {
    late ObservationDetailViewModel localViewModel;
    
    setUp(() {
      // Reset mocks to ensure clean environment
      reset(mockGetObservationDetailsByObservationIdUseCase);
      reset(mockGetObservationDetailByIdUseCase);
      reset(mockSaveObservationDetailUseCase);
      reset(mockDeleteObservationDetailUseCase);
      
      // Configure the initial load to not interfere with our tests
      when(() => mockGetObservationDetailsByObservationIdUseCase.execute(observationId))
          .thenAnswer((_) async => []);
      
      // Create view model for this group of tests
      localViewModel = ObservationDetailViewModel(
        mockGetObservationDetailsByObservationIdUseCase,
        mockGetObservationDetailByIdUseCase,
        mockSaveObservationDetailUseCase,
        mockDeleteObservationDetailUseCase,
        mockFormDataProcessor,
        observationId,
      );
    });

    test('should return detail when use case succeeds', () async {
      // Arrange
      // Wait for initial load to complete
      await Future.microtask(() => null);
      
      final detail = ObservationDetail(
        idObservationDetail: detailId,
        idObservation: observationId,
        uuidObservationDetail: 'uuid-1',
        data: {'key': 'value'},
      );

      when(() => mockGetObservationDetailByIdUseCase.execute(detailId))
          .thenAnswer((_) async => detail);

      // Act
      final result = await localViewModel.getObservationDetailById(detailId);

      // Assert
      expect(result, equals(detail));
      verify(() => mockGetObservationDetailByIdUseCase.execute(detailId))
          .called(1);
    });

    test('should return null when use case throws', () async {
      // Arrange
      // Wait for initial load to complete
      await Future.microtask(() => null);
      
      when(() => mockGetObservationDetailByIdUseCase.execute(detailId))
          .thenThrow(Exception('Error'));

      // Act
      final result = await localViewModel.getObservationDetailById(detailId);

      // Assert
      expect(result, isNull);
      verify(() => mockGetObservationDetailByIdUseCase.execute(detailId))
          .called(1);
    });
  });

  group('saveObservationDetail', () {
    late ObservationDetailViewModel localViewModel;
    
    setUp(() {
      // Reset mocks to ensure clean environment
      reset(mockGetObservationDetailsByObservationIdUseCase);
      reset(mockGetObservationDetailByIdUseCase);
      reset(mockSaveObservationDetailUseCase);
      reset(mockDeleteObservationDetailUseCase);
      reset(mockFormDataProcessor);
      
      // Configure the initial load to not interfere with our tests
      when(() => mockGetObservationDetailsByObservationIdUseCase.execute(observationId))
          .thenAnswer((_) async => []);
          
      // Setup the FormDataProcessor mock
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((invocation) async => invocation.positionalArguments[0] as Map<String, dynamic>);

      // Create view model
      localViewModel = ObservationDetailViewModel(
        mockGetObservationDetailsByObservationIdUseCase,
        mockGetObservationDetailByIdUseCase,
        mockSaveObservationDetailUseCase,
        mockDeleteObservationDetailUseCase,
        mockFormDataProcessor,
        observationId,
      );
    });

    test('should save detail and reload details when use case succeeds',
        () async {
      // Arrange
      // Reset all mocks to start fresh
      reset(mockGetObservationDetailsByObservationIdUseCase);
      reset(mockGetObservationDetailByIdUseCase);
      reset(mockSaveObservationDetailUseCase);
      reset(mockDeleteObservationDetailUseCase);
      reset(mockFormDataProcessor);
      
      const insertedId = 3;
      final detail = ObservationDetail(
        idObservation: observationId,
        data: {'key': 'value'},
      );

      final details = [
        ObservationDetail(
          idObservationDetail: insertedId,
          idObservation: observationId,
          data: {'key': 'value'},
        ),
      ];
      
      // Configure mocks for both initialization and test
      when(() => mockGetObservationDetailsByObservationIdUseCase.execute(observationId))
          .thenAnswer((_) async => []);
      
      // Configure FormDataProcessor mock - both methods need mocking
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((invocation) async => invocation.positionalArguments[0] as Map<String, dynamic>);
      
      when(() => mockFormDataProcessor.processFormDataForDisplay(any()))
          .thenAnswer((invocation) async => invocation.positionalArguments[0] as Map<String, dynamic>);
      
      // Create a fresh viewModel
      final freshViewModel = ObservationDetailViewModel(
        mockGetObservationDetailsByObservationIdUseCase,
        mockGetObservationDetailByIdUseCase,
        mockSaveObservationDetailUseCase,
        mockDeleteObservationDetailUseCase,
        mockFormDataProcessor,
        observationId,
      );
      
      // Wait for initialization
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Reset interactions after initialization
      clearInteractions(mockSaveObservationDetailUseCase);
      clearInteractions(mockGetObservationDetailsByObservationIdUseCase);
      
      // Configure mocks for the actual test case
      when(() => mockSaveObservationDetailUseCase.execute(detail))
          .thenAnswer((_) async => insertedId);
      when(() => mockGetObservationDetailsByObservationIdUseCase.execute(observationId))
          .thenAnswer((_) async => details);

      // Act
      final result = await freshViewModel.saveObservationDetail(detail);

      // Assert
      expect(result, equals(insertedId));
      verify(() => mockSaveObservationDetailUseCase.execute(detail)).called(1);
      verify(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).called(1);
    });

    test('should rethrow exception when use case throws', () async {
      // Arrange
      // Reset all mocks to start fresh
      reset(mockGetObservationDetailsByObservationIdUseCase);
      reset(mockGetObservationDetailByIdUseCase);
      reset(mockSaveObservationDetailUseCase);
      reset(mockDeleteObservationDetailUseCase);
      reset(mockFormDataProcessor);
      
      final detail = ObservationDetail(
        idObservation: observationId,
        data: {'key': 'value'},
      );

      final exception = Exception('Error saving detail');
      
      // Configure mocks for both initialization and test
      when(() => mockGetObservationDetailsByObservationIdUseCase.execute(observationId))
          .thenAnswer((_) async => []);
      
      // Configure FormDataProcessor mock - both methods need mocking
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((invocation) async => invocation.positionalArguments[0] as Map<String, dynamic>);
      
      when(() => mockFormDataProcessor.processFormDataForDisplay(any()))
          .thenAnswer((invocation) async => invocation.positionalArguments[0] as Map<String, dynamic>);
      
      when(() => mockSaveObservationDetailUseCase.execute(detail))
          .thenThrow(exception);
      
      // Create a fresh viewModel
      final freshViewModel = ObservationDetailViewModel(
        mockGetObservationDetailsByObservationIdUseCase,
        mockGetObservationDetailByIdUseCase,
        mockSaveObservationDetailUseCase,
        mockDeleteObservationDetailUseCase,
        mockFormDataProcessor,
        observationId,
      );
      
      // Wait for initialization
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Reset interactions after initialization
      clearInteractions(mockSaveObservationDetailUseCase);
      clearInteractions(mockGetObservationDetailsByObservationIdUseCase);

      // Act - Use a separate try/catch to verify the exception
      try {
        await freshViewModel.saveObservationDetail(detail);
        fail('Expected an exception');
      } catch (e) {
        expect(e, equals(exception));
      }
      
      // Assert - Need to verify after the exception is caught
      verify(() => mockSaveObservationDetailUseCase.execute(detail)).called(1);
      verifyNever(
          () => mockGetObservationDetailsByObservationIdUseCase.execute(any()));
    });
  });

  group('deleteObservationDetail', () {
    late ObservationDetailViewModel localViewModel;
    
    setUp(() {
      // Reset mocks to ensure clean environment
      reset(mockGetObservationDetailsByObservationIdUseCase);
      reset(mockGetObservationDetailByIdUseCase);
      reset(mockSaveObservationDetailUseCase);
      reset(mockDeleteObservationDetailUseCase);
      
      // Configure the initial load to not interfere with our tests
      when(() => mockGetObservationDetailsByObservationIdUseCase.execute(observationId))
          .thenAnswer((_) async => []);

      // Create view model
      localViewModel = ObservationDetailViewModel(
        mockGetObservationDetailsByObservationIdUseCase,
        mockGetObservationDetailByIdUseCase,
        mockSaveObservationDetailUseCase,
        mockDeleteObservationDetailUseCase,
        mockFormDataProcessor,
        observationId,
      );
    });

    test(
        'should delete detail and reload details when use case succeeds with true',
        () async {
      // Arrange
      // Wait for initial load to complete
      await Future.microtask(() => null);
      
      // Reset all mocks to start fresh
      reset(mockGetObservationDetailsByObservationIdUseCase);
      reset(mockDeleteObservationDetailUseCase);
      reset(mockGetObservationDetailByIdUseCase);
      reset(mockSaveObservationDetailUseCase);
      
      const detailId = 2;
      final details = [
        ObservationDetail(
          idObservationDetail: 1,
          idObservation: observationId,
          data: {'key': 'value1'},
        ),
      ];

      // Set up mocks with fresh expectations
      when(() => mockDeleteObservationDetailUseCase.execute(detailId))
          .thenAnswer((_) async => true);
      when(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).thenAnswer((_) async => details);

      // Create a fresh viewModel for clean state
      final freshViewModel = ObservationDetailViewModel(
        mockGetObservationDetailsByObservationIdUseCase,
        mockGetObservationDetailByIdUseCase,
        mockSaveObservationDetailUseCase,
        mockDeleteObservationDetailUseCase,
        mockFormDataProcessor,
        observationId,
      );
      
      // Wait for initialization
      await Future.microtask(() => null);
      
      // Clear interactions after setup
      clearInteractions(mockDeleteObservationDetailUseCase);
      clearInteractions(mockGetObservationDetailsByObservationIdUseCase);

      // Act
      final result = await freshViewModel.deleteObservationDetail(detailId);

      // Assert
      expect(result, isTrue);
      verify(() => mockDeleteObservationDetailUseCase.execute(detailId))
          .called(1);
      verify(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).called(1);
    });

    test('should not reload details when use case returns false', () async {
      // Arrange
      // Reset all mocks to start fresh
      reset(mockGetObservationDetailsByObservationIdUseCase);
      reset(mockDeleteObservationDetailUseCase);
      reset(mockGetObservationDetailByIdUseCase);
      reset(mockSaveObservationDetailUseCase);
      
      const detailId = 2;

      // Set up mocks with new expectations
      when(() => mockGetObservationDetailsByObservationIdUseCase.execute(observationId))
          .thenAnswer((_) async => []);
      when(() => mockDeleteObservationDetailUseCase.execute(detailId))
          .thenAnswer((_) async => false);

      // Create a fresh viewModel
      final freshViewModel = ObservationDetailViewModel(
        mockGetObservationDetailsByObservationIdUseCase,
        mockGetObservationDetailByIdUseCase,
        mockSaveObservationDetailUseCase,
        mockDeleteObservationDetailUseCase,
        mockFormDataProcessor,
        observationId,
      );
      
      // Wait for initialization
      await Future.microtask(() => null);
      
      // Clear all interactions before actual test
      clearInteractions(mockDeleteObservationDetailUseCase);
      clearInteractions(mockGetObservationDetailsByObservationIdUseCase);

      // Act
      final result = await freshViewModel.deleteObservationDetail(detailId);

      // Assert
      expect(result, isFalse);
      verify(() => mockDeleteObservationDetailUseCase.execute(detailId))
          .called(1);
      verifyNever(
          () => mockGetObservationDetailsByObservationIdUseCase.execute(any()));
    });

    test('should rethrow exception when use case throws', () async {
      // Arrange
      // Reset all mocks to start fresh
      reset(mockGetObservationDetailsByObservationIdUseCase);
      reset(mockDeleteObservationDetailUseCase);
      reset(mockGetObservationDetailByIdUseCase);
      reset(mockSaveObservationDetailUseCase);
      
      const detailId = 2;
      final exception = Exception('Error deleting detail');

      // Configure mocks with fresh expectations
      when(() => mockGetObservationDetailsByObservationIdUseCase.execute(observationId))
          .thenAnswer((_) async => []);
      when(() => mockDeleteObservationDetailUseCase.execute(detailId))
          .thenThrow(exception);

      // Create a fresh viewModel
      final freshViewModel = ObservationDetailViewModel(
        mockGetObservationDetailsByObservationIdUseCase,
        mockGetObservationDetailByIdUseCase,
        mockSaveObservationDetailUseCase,
        mockDeleteObservationDetailUseCase,
        mockFormDataProcessor,
        observationId,
      );
      
      // Wait for initialization
      await Future.microtask(() => null);
      
      // Clear all interactions before actual test
      clearInteractions(mockDeleteObservationDetailUseCase);
      clearInteractions(mockGetObservationDetailsByObservationIdUseCase);

      // Act & Assert
      expect(
        () => freshViewModel.deleteObservationDetail(detailId),
        throwsA(equals(exception)),
      );
      
      verify(() => mockDeleteObservationDetailUseCase.execute(detailId))
          .called(1);
      verifyNever(
          () => mockGetObservationDetailsByObservationIdUseCase.execute(any()));
    });
  });
}

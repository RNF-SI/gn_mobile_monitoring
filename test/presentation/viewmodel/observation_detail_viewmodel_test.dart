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

      // Make sure the mock returns our test data
      when(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).thenAnswer((_) async => details);
          
      // Create a new local view model for this test specifically
      localViewModel = ObservationDetailViewModel(
        mockGetObservationDetailsByObservationIdUseCase,
        mockGetObservationDetailByIdUseCase,
        mockSaveObservationDetailUseCase,
        mockDeleteObservationDetailUseCase,
        mockFormDataProcessor,
        observationId,
      );

      // Act - Wait for the initial load from constructor to complete
      await Future.microtask(() => null);

      // Assert - Initial load should have already called the use case and updated the state
      expect(localViewModel.state.hasValue, isTrue);
      expect(localViewModel.state.value, details);
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
      // Arrange - Wait for initial loading to complete first
      await Future.microtask(() => null);
      
      // Reset the mock to return our test data
      reset(mockGetObservationDetailsByObservationIdUseCase);
      
      final details = [
        ObservationDetail(
          idObservationDetail: 1,
          idObservation: observationId,
          uuidObservationDetail: 'uuid-1',
          data: {'key': 'value1'},
        ),
      ];

      when(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).thenAnswer((_) async => details);

      // Act
      final result =
          await localViewModel.getObservationDetailsByObservationId(observationId);

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

    test('should save detail and reload details when use case succeeds',
        () async {
      // Arrange
      // Wait for initial load to complete
      await Future.microtask(() => null);
      
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

      when(() => mockSaveObservationDetailUseCase.execute(detail))
          .thenAnswer((_) async => insertedId);
      when(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).thenAnswer((_) async => details);

      // Act
      final result = await localViewModel.saveObservationDetail(detail);

      // Assert
      expect(result, equals(insertedId));
      verify(() => mockSaveObservationDetailUseCase.execute(detail)).called(1);
      verify(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).called(1);
    });

    test('should rethrow exception when use case throws', () async {
      // Arrange
      // Wait for initial load to complete
      await Future.microtask(() => null);
      
      final detail = ObservationDetail(
        idObservation: observationId,
        data: {'key': 'value'},
      );

      final exception = Exception('Error saving detail');
      when(() => mockSaveObservationDetailUseCase.execute(detail))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => localViewModel.saveObservationDetail(detail),
        throwsA(equals(exception)),
      );
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
      
      const detailId = 2;
      final details = [
        ObservationDetail(
          idObservationDetail: 1,
          idObservation: observationId,
          data: {'key': 'value1'},
        ),
      ];

      when(() => mockDeleteObservationDetailUseCase.execute(detailId))
          .thenAnswer((_) async => true);
      when(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).thenAnswer((_) async => details);

      // Act
      final result = await localViewModel.deleteObservationDetail(detailId);

      // Assert
      expect(result, isTrue);
      verify(() => mockDeleteObservationDetailUseCase.execute(detailId))
          .called(1);
      verify(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).called(1);
    });

    test('should not reload details when use case returns false', () async {
      // Arrange
      // Wait for initial load to complete
      await Future.microtask(() => null);
      
      const detailId = 2;

      when(() => mockDeleteObservationDetailUseCase.execute(detailId))
          .thenAnswer((_) async => false);

      // Act
      final result = await localViewModel.deleteObservationDetail(detailId);

      // Assert
      expect(result, isFalse);
      verify(() => mockDeleteObservationDetailUseCase.execute(detailId))
          .called(1);
      verifyNever(
          () => mockGetObservationDetailsByObservationIdUseCase.execute(any()));
    });

    test('should rethrow exception when use case throws', () async {
      // Arrange
      // Wait for initial load to complete
      await Future.microtask(() => null);
      
      const detailId = 2;
      final exception = Exception('Error deleting detail');

      when(() => mockDeleteObservationDetailUseCase.execute(detailId))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => localViewModel.deleteObservationDetail(detailId),
        throwsA(equals(exception)),
      );
      verify(() => mockDeleteObservationDetailUseCase.execute(detailId))
          .called(1);
      verifyNever(
          () => mockGetObservationDetailsByObservationIdUseCase.execute(any()));
    });
  });
}

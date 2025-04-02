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
    setUp(() async {
      viewModel = ObservationDetailViewModel(
        mockGetObservationDetailsByObservationIdUseCase,
        mockGetObservationDetailByIdUseCase,
        mockSaveObservationDetailUseCase,
        mockDeleteObservationDetailUseCase,
        mockFormDataProcessor,
        observationId,
      );

      // Wait for the initial load to complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Reset mock for the next calls
      reset(mockGetObservationDetailsByObservationIdUseCase);
    });

    test('should update state to data when use case succeeds', () async {
      // Arrange
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

      when(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).thenAnswer((_) async => details);

      // Act
      await viewModel.loadObservationDetails();

      // Assert
      expect(viewModel.state.hasValue, isTrue);
      expect(viewModel.state.value, details);
      verify(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).called(1);
    });

    test('should update state to error when use case throws', () async {
      // Arrange
      final exception = Exception('Error loading details');
      when(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).thenThrow(exception);

      // Act
      await viewModel.loadObservationDetails();

      // Assert
      expect(viewModel.state.hasError, isTrue);
      expect(viewModel.state.error, exception);
      verify(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).called(1);
    });
  });

  group('getObservationDetailsByObservationId', () {
    setUp(() async {
      viewModel = ObservationDetailViewModel(
        mockGetObservationDetailsByObservationIdUseCase,
        mockGetObservationDetailByIdUseCase,
        mockSaveObservationDetailUseCase,
        mockDeleteObservationDetailUseCase,
        mockFormDataProcessor,
        observationId,
      );

      // Wait for the initial load to complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Reset mock for the next calls
      reset(mockGetObservationDetailsByObservationIdUseCase);
    });

    test('should return details when use case succeeds', () async {
      // Arrange
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
          await viewModel.getObservationDetailsByObservationId(observationId);

      // Assert
      expect(result, equals(details));
      verify(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).called(1);
    });

    test('should return empty list when use case throws', () async {
      // Arrange
      when(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).thenThrow(Exception('Error'));

      // Act
      final result =
          await viewModel.getObservationDetailsByObservationId(observationId);

      // Assert
      expect(result, isEmpty);
      verify(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).called(1);
    });
  });

  group('getObservationDetailById', () {
    setUp(() async {
      viewModel = ObservationDetailViewModel(
        mockGetObservationDetailsByObservationIdUseCase,
        mockGetObservationDetailByIdUseCase,
        mockSaveObservationDetailUseCase,
        mockDeleteObservationDetailUseCase,
        mockFormDataProcessor,
        observationId,
      );

      // Wait for the initial load to complete
      await Future.delayed(const Duration(milliseconds: 100));
    });

    test('should return detail when use case succeeds', () async {
      // Arrange
      final detail = ObservationDetail(
        idObservationDetail: detailId,
        idObservation: observationId,
        uuidObservationDetail: 'uuid-1',
        data: {'key': 'value'},
      );

      when(() => mockGetObservationDetailByIdUseCase.execute(detailId))
          .thenAnswer((_) async => detail);

      // Act
      final result = await viewModel.getObservationDetailById(detailId);

      // Assert
      expect(result, equals(detail));
      verify(() => mockGetObservationDetailByIdUseCase.execute(detailId))
          .called(1);
    });

    test('should return null when use case throws', () async {
      // Arrange
      when(() => mockGetObservationDetailByIdUseCase.execute(detailId))
          .thenThrow(Exception('Error'));

      // Act
      final result = await viewModel.getObservationDetailById(detailId);

      // Assert
      expect(result, isNull);
      verify(() => mockGetObservationDetailByIdUseCase.execute(detailId))
          .called(1);
    });
  });

  group('saveObservationDetail', () {
    setUp(() async {
      viewModel = ObservationDetailViewModel(
        mockGetObservationDetailsByObservationIdUseCase,
        mockGetObservationDetailByIdUseCase,
        mockSaveObservationDetailUseCase,
        mockDeleteObservationDetailUseCase,
        mockFormDataProcessor,
        observationId,
      );

      // Wait for the initial load to complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Reset mock for the next calls
      reset(mockGetObservationDetailsByObservationIdUseCase);
    });

    test('should save detail and reload details when use case succeeds',
        () async {
      // Arrange
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
      final result = await viewModel.saveObservationDetail(detail);

      // Assert
      expect(result, equals(insertedId));
      verify(() => mockSaveObservationDetailUseCase.execute(detail)).called(1);
      verify(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).called(1);
    });

    test('should rethrow exception when use case throws', () async {
      // Arrange
      final detail = ObservationDetail(
        idObservation: observationId,
        data: {'key': 'value'},
      );

      final exception = Exception('Error saving detail');
      when(() => mockSaveObservationDetailUseCase.execute(detail))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => viewModel.saveObservationDetail(detail),
        throwsA(equals(exception)),
      );
      verify(() => mockSaveObservationDetailUseCase.execute(detail)).called(1);
      verifyNever(
          () => mockGetObservationDetailsByObservationIdUseCase.execute(any()));
    });
  });

  group('deleteObservationDetail', () {
    setUp(() async {
      viewModel = ObservationDetailViewModel(
        mockGetObservationDetailsByObservationIdUseCase,
        mockGetObservationDetailByIdUseCase,
        mockSaveObservationDetailUseCase,
        mockDeleteObservationDetailUseCase,
        mockFormDataProcessor,
        observationId,
      );

      // Wait for the initial load to complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Reset mock for the next calls
      reset(mockGetObservationDetailsByObservationIdUseCase);
    });

    test(
        'should delete detail and reload details when use case succeeds with true',
        () async {
      // Arrange
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
      final result = await viewModel.deleteObservationDetail(detailId);

      // Assert
      expect(result, isTrue);
      verify(() => mockDeleteObservationDetailUseCase.execute(detailId))
          .called(1);
      verify(() => mockGetObservationDetailsByObservationIdUseCase
          .execute(observationId)).called(1);
    });

    test('should not reload details when use case returns false', () async {
      // Arrange
      const detailId = 2;

      when(() => mockDeleteObservationDetailUseCase.execute(detailId))
          .thenAnswer((_) async => false);

      // Act
      final result = await viewModel.deleteObservationDetail(detailId);

      // Assert
      expect(result, isFalse);
      verify(() => mockDeleteObservationDetailUseCase.execute(detailId))
          .called(1);
      verifyNever(
          () => mockGetObservationDetailsByObservationIdUseCase.execute(any()));
    });

    test('should rethrow exception when use case throws', () async {
      // Arrange
      const detailId = 2;
      final exception = Exception('Error deleting detail');

      when(() => mockDeleteObservationDetailUseCase.execute(detailId))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => viewModel.deleteObservationDetail(detailId),
        throwsA(equals(exception)),
      );
      verify(() => mockDeleteObservationDetailUseCase.execute(detailId))
          .called(1);
      verifyNever(
          () => mockGetObservationDetailsByObservationIdUseCase.execute(any()));
    });
  });
}

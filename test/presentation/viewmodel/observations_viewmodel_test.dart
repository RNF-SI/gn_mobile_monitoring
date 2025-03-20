import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_observation_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_observation_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observations_by_visit_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_observation_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockGetObservationsByVisitIdUseCase extends Mock
    implements GetObservationsByVisitIdUseCase {}

class MockCreateObservationUseCase extends Mock
    implements CreateObservationUseCase {}

class MockUpdateObservationUseCase extends Mock
    implements UpdateObservationUseCase {}

class MockDeleteObservationUseCase extends Mock
    implements DeleteObservationUseCase {}

void main() {
  late MockGetObservationsByVisitIdUseCase mockGetObservationsByVisitIdUseCase;
  late MockCreateObservationUseCase mockCreateObservationUseCase;
  late MockUpdateObservationUseCase mockUpdateObservationUseCase;
  late MockDeleteObservationUseCase mockDeleteObservationUseCase;
  late ObservationsViewModel viewModel;
  const int testVisitId = 1;

  setUp(() {
    mockGetObservationsByVisitIdUseCase = MockGetObservationsByVisitIdUseCase();
    mockCreateObservationUseCase = MockCreateObservationUseCase();
    mockUpdateObservationUseCase = MockUpdateObservationUseCase();
    mockDeleteObservationUseCase = MockDeleteObservationUseCase();

    // Simuler un chargement initial des observations
    when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
        .thenAnswer((_) async => []);

    viewModel = ObservationsViewModel(
      mockGetObservationsByVisitIdUseCase,
      mockCreateObservationUseCase,
      mockUpdateObservationUseCase,
      mockDeleteObservationUseCase,
      testVisitId,
    );

    // Réinitialiser les compteurs d'appel après l'initialisation
    reset(mockGetObservationsByVisitIdUseCase);
    reset(mockCreateObservationUseCase);
    reset(mockUpdateObservationUseCase);
    reset(mockDeleteObservationUseCase);
  });

  group('ObservationsViewModel - Basic operations', () {
    final testObservations = [
      Observation(
        idObservation: 1,
        idBaseVisit: testVisitId,
        cdNom: 123,
        comments: 'Test observation 1',
      ),
      Observation(
        idObservation: 2,
        idBaseVisit: testVisitId,
        cdNom: 456,
        comments: 'Test observation 2',
      ),
    ];

    test('initial state should be loading after setUp', () {
      expect(viewModel.state, const AsyncValue<List<Observation>>.loading());
    });

    test('loadObservations should update state with observations from use case',
        () async {
      // Arrange
      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenAnswer((_) async => testObservations);

      // Act
      await viewModel.loadObservations();

      // Assert
      expect(viewModel.state, AsyncValue.data(testObservations));
      verify(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .called(1);
    });

    test('loadObservations should handle error', () async {
      // Arrange
      final exception = Exception('Test error');
      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenThrow(exception);

      // Act
      await viewModel.loadObservations();

      // Assert
      expect(viewModel.state.hasError, true);
      verify(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .called(1);
    });

    test('getObservationsByVisitId should return observations from use case',
        () async {
      // Arrange
      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenAnswer((_) async => testObservations);

      // Act
      final result = await viewModel.getObservationsByVisitId();

      // Assert
      expect(result, testObservations);
      verify(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .called(1);
    });

    test('getObservationsByVisitId should return empty list on error', () async {
      // Arrange
      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenThrow(Exception('Test error'));

      // Act
      final result = await viewModel.getObservationsByVisitId();

      // Assert
      expect(result, []);
      verify(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .called(1);
    });

    test(
        'deleteObservation should call deleteObservationUseCase and reload observations',
        () async {
      // Arrange
      const observationIdToDelete = 1;

      when(() => mockDeleteObservationUseCase.execute(observationIdToDelete))
          .thenAnswer((_) async => true);

      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenAnswer((_) async =>
              [testObservations[1]]); // Returned list without deleted observation

      // Act
      final result = await viewModel.deleteObservation(observationIdToDelete);

      // Assert
      expect(result, true);
      verify(() => mockDeleteObservationUseCase.execute(observationIdToDelete))
          .called(1);
      verify(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .called(1);
    });

    test(
        'deleteObservation should return false and not reload when use case fails',
        () async {
      // Arrange
      const observationIdToDelete = 1;

      when(() => mockDeleteObservationUseCase.execute(observationIdToDelete))
          .thenAnswer((_) async => false);

      // Act
      final result = await viewModel.deleteObservation(observationIdToDelete);

      // Assert
      expect(result, false);
      verify(() => mockDeleteObservationUseCase.execute(observationIdToDelete))
          .called(1);
      verifyNever(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId));
    });

    test('deleteObservation should handle exceptions', () async {
      // Arrange
      const observationIdToDelete = 1;

      when(() => mockDeleteObservationUseCase.execute(observationIdToDelete))
          .thenThrow(Exception('Test error'));

      // Act & Assert
      expect(() => viewModel.deleteObservation(observationIdToDelete),
          throwsException);
      verify(() => mockDeleteObservationUseCase.execute(observationIdToDelete))
          .called(1);
    });
  });

  group('ObservationsViewModel - Form Data Processing', () {
    test('createObservation should convert form data correctly', () async {
      // Arrange
      final formData = {
        'cd_nom': 123,
        'comments': 'Test observation',
        'field1': 'value1',
        'field2': 42,
      };

      // Configure the mock to return a new ID
      when(() => mockCreateObservationUseCase.execute(any()))
          .thenAnswer((_) async => 3);

      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenAnswer((_) async => []);

      // Act
      final result = await viewModel.createObservation(formData);

      // Assert
      expect(result, 3);
      verify(() => mockCreateObservationUseCase.execute(any())).called(1);
      verify(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .called(1);
    });

    test('createObservation should handle null values', () async {
      // Arrange
      final formData = {
        'cd_nom': null,
        'comments': null,
        'field1': 'value1',
      };

      // Configure the mock to return a new ID
      when(() => mockCreateObservationUseCase.execute(any()))
          .thenAnswer((_) async => 3);

      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenAnswer((_) async => []);

      // Act
      final result = await viewModel.createObservation(formData);

      // Assert
      expect(result, 3);
      verify(() => mockCreateObservationUseCase.execute(any())).called(1);
      verify(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .called(1);
    });

    test('updateObservation should convert form data correctly', () async {
      // Arrange
      const observationId = 5;
      final existingObservation = Observation(
        idObservation: observationId,
        idBaseVisit: testVisitId,
        cdNom: 789,
        comments: 'Original comment',
        uuidObservation: 'test-uuid',
        metaCreateDate: '2023-01-01T12:00:00',
      );
      
      final formData = {
        'cd_nom': 123,
        'comments': 'Updated comment',
        'field1': 'updated value',
        'field2': 99,
      };

      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenAnswer((_) async => [existingObservation]);

      // Configure the mock to return true
      when(() => mockUpdateObservationUseCase.execute(any()))
          .thenAnswer((_) async => true);

      // Act
      final result = await viewModel.updateObservation(formData, observationId);

      // Assert
      expect(result, true);
      verify(() => mockUpdateObservationUseCase.execute(any())).called(1);
      verify(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .called(2); // Once for fetching existing, once for reloading
    });

    test('updateObservation should return false when update fails', () async {
      // Arrange
      const observationId = 5;
      final existingObservation = Observation(
        idObservation: observationId,
        idBaseVisit: testVisitId,
        cdNom: 789,
        comments: 'Original comment',
      );
      
      final formData = {
        'comments': 'Updated comment',
      };

      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenAnswer((_) async => [existingObservation]);

      when(() => mockUpdateObservationUseCase.execute(any()))
          .thenAnswer((_) async => false);

      // Act
      final result = await viewModel.updateObservation(formData, observationId);

      // Assert
      expect(result, false);
      verify(() => mockUpdateObservationUseCase.execute(any())).called(1);
      verify(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .called(1); // Only for fetching existing
    });

    test('updateObservation should throw when observation not found', () async {
      // Arrange
      const observationId = 5;
      final formData = {
        'comments': 'Updated comment',
      };

      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenAnswer((_) async => []); // Empty list, no observation found

      // Act & Assert
      expect(
        () => viewModel.updateObservation(formData, observationId),
        throwsException,
      );
      verifyNever(() => mockUpdateObservationUseCase.execute(any()));
    });
  });

  group('ObservationsViewModel - Data Type Processing', () {
    test('_extractObservationSpecificData should convert numeric strings',
        () async {
      // Arrange
      final formData = {
        'cd_nom': 123,
        'comments': 'Test observation',
        'int_value': '42',
        'float_value': '3.14',
      };

      // Configure the mock to return a new ID
      when(() => mockCreateObservationUseCase.execute(any()))
          .thenAnswer((_) async => 1);

      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenAnswer((_) async => []);

      // Act
      await viewModel.createObservation(formData);

      // Assert
      verify(() => mockCreateObservationUseCase.execute(any())).called(1);

      // We can't directly test private methods, but we can verify the behavior
      // by checking that the mock was called with an observation containing
      // properly converted data
      final capturedValue = verify(() => mockCreateObservationUseCase.execute(captureAny())).captured.single as Observation;
      expect(capturedValue.data?['int_value'], 42);
      expect(capturedValue.data?['float_value'], 3.14);
    });

    test('_extractObservationSpecificData should ignore standard fields',
        () async {
      // Arrange
      final formData = {
        'id_observation': 123,
        'id_base_visit': 456,
        'cd_nom': 789,
        'comments': 'Test observation',
        'uuid_observation': 'test-uuid',
        'custom_field': 'custom value',
      };

      // Configure the mock to return a new ID
      when(() => mockCreateObservationUseCase.execute(any()))
          .thenAnswer((_) async => 1);

      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenAnswer((_) async => []);

      // Act
      await viewModel.createObservation(formData);

      // Assert
      verify(() => mockCreateObservationUseCase.execute(any())).called(1);

      // We can check that standard fields are not included in the data map
      final capturedValue = verify(() => mockCreateObservationUseCase.execute(captureAny())).captured.single as Observation;
      expect(capturedValue.data?['id_observation'], isNull);
      expect(capturedValue.data?['id_base_visit'], isNull);
      expect(capturedValue.data?['cd_nom'], isNull);
      expect(capturedValue.data?['comments'], isNull);
      expect(capturedValue.data?['uuid_observation'], isNull);
      expect(capturedValue.data?['custom_field'], 'custom value');
    });

    test('_extractObservationSpecificData should handle DateTime values',
        () async {
      // Arrange
      final now = DateTime.now();
      final formData = {
        'cd_nom': 123,
        'date_field': now,
      };

      // Configure the mock to return a new ID
      when(() => mockCreateObservationUseCase.execute(any()))
          .thenAnswer((_) async => 1);

      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenAnswer((_) async => []);

      // Act
      await viewModel.createObservation(formData);

      // Assert
      verify(() => mockCreateObservationUseCase.execute(any())).called(1);

      // Check that DateTime is converted to ISO8601 string
      final capturedValue = verify(() => mockCreateObservationUseCase.execute(captureAny())).captured.single as Observation;
      expect(capturedValue.data?['date_field'], now.toIso8601String());
    });
  });

  group('ObservationsViewModel - Error Handling', () {
    test('createObservation should log and rethrow errors', () async {
      // Arrange
      final formData = {'cd_nom': 123};

      when(() => mockCreateObservationUseCase.execute(any()))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => viewModel.createObservation(formData),
        throwsException,
      );
    });

    test('loadObservations does nothing when component is disposed', () async {
      // Arrange
      viewModel.dispose();

      // Act
      await viewModel.loadObservations();

      // Assert - no exception thrown, no mock called
      verifyNever(() => mockGetObservationsByVisitIdUseCase.execute(any()));
    });
  });
}
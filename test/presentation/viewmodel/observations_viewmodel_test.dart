import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_observation_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_observation_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observation_by_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observations_by_visit_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_observation_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockGetObservationsByVisitIdUseCase extends Mock
    implements GetObservationsByVisitIdUseCase {}

class MockGetObservationByIdUseCase extends Mock
    implements GetObservationByIdUseCase {}

class MockCreateObservationUseCase extends Mock
    implements CreateObservationUseCase {}

class MockUpdateObservationUseCase extends Mock
    implements UpdateObservationUseCase {}

class MockDeleteObservationUseCase extends Mock
    implements DeleteObservationUseCase {}

void main() {
  // Test pour les fonctionnalités de base
  group('ObservationsViewModel - Basic operations', () {
    late MockGetObservationsByVisitIdUseCase mockGetObservationsByVisitIdUseCase;
    late MockCreateObservationUseCase mockCreateObservationUseCase;
    late MockUpdateObservationUseCase mockUpdateObservationUseCase;
    late MockDeleteObservationUseCase mockDeleteObservationUseCase;
    late MockGetObservationByIdUseCase mockGetObservationByIdUseCase;
    late ObservationsViewModel viewModel;
    const int testVisitId = 1;

    setUp(() {
      mockGetObservationsByVisitIdUseCase = MockGetObservationsByVisitIdUseCase();
      mockCreateObservationUseCase = MockCreateObservationUseCase();
      mockUpdateObservationUseCase = MockUpdateObservationUseCase();
      mockDeleteObservationUseCase = MockDeleteObservationUseCase();
      mockGetObservationByIdUseCase = MockGetObservationByIdUseCase();

      registerFallbackValue(const Observation(idObservation: 1));
    });

    test('initial state should be loading and loadObservations should be called', () async {
      // Configure la réponse du mock
      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenAnswer((_) async => []);

      // Crée le viewModel, ce qui appelera loadObservations
      viewModel = ObservationsViewModel(
        mockGetObservationsByVisitIdUseCase,
        mockCreateObservationUseCase,
        mockUpdateObservationUseCase,
        mockDeleteObservationUseCase,
        mockGetObservationByIdUseCase,
        testVisitId,
      );

      // Vérifie que l'état initial est chargement
      expect(viewModel.state, const AsyncValue<List<Observation>>.loading());

      // Attendre que la méthode asynchrone se termine
      await Future.delayed(Duration.zero);

      // Vérifier que loadObservations a été appelé
      verify(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId)).called(1);
    });

    test('loadObservations should update state with observations from use case', () async {
      // Configure les mocks
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

      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenAnswer((_) async => testObservations);

      // Crée le viewModel, qui appelle loadObservations
      viewModel = ObservationsViewModel(
        mockGetObservationsByVisitIdUseCase,
        mockCreateObservationUseCase,
        mockUpdateObservationUseCase,
        mockDeleteObservationUseCase,
        mockGetObservationByIdUseCase,
        testVisitId,
      );

      // Attendre que l'état se mette à jour
      await Future.delayed(Duration.zero);

      // Vérifier l'état
      expect(viewModel.state, AsyncValue.data(testObservations));
    });

    test('loadObservations should handle error', () async {
      // Arrange - simuler une erreur
      final exception = Exception('Test error');
      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenThrow(exception);

      // Crée le viewModel, qui appelle loadObservations
      viewModel = ObservationsViewModel(
        mockGetObservationsByVisitIdUseCase,
        mockCreateObservationUseCase,
        mockUpdateObservationUseCase,
        mockDeleteObservationUseCase,
        mockGetObservationByIdUseCase,
        testVisitId,
      );

      // Attendre que l'état se mette à jour
      await Future.delayed(Duration.zero);

      // Vérifier l'état d'erreur
      expect(viewModel.state.hasError, true);
      expect(viewModel.state.error, exception);
    });

    test('getObservationsByVisitId should return observations from use case', () async {
      // Arrange
      final testObservations = [
        Observation(
          idObservation: 1,
          idBaseVisit: testVisitId,
          cdNom: 123,
          comments: 'Test observation',
        ),
      ];

      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenAnswer((_) async => testObservations);

      // Initialiser le viewModel mais avec un mock déjà configuré
      viewModel = ObservationsViewModel(
        mockGetObservationsByVisitIdUseCase,
        mockCreateObservationUseCase,
        mockUpdateObservationUseCase,
        mockDeleteObservationUseCase,
        mockGetObservationByIdUseCase,
        testVisitId,
      );

      // Attendre la fin de l'initialisation
      await Future.delayed(Duration.zero);

      // Réinitialiser les appels pour ne compter que ceux de getObservationsByVisitId
      clearInteractions(mockGetObservationsByVisitIdUseCase);

      // Act
      final result = await viewModel.getObservationsByVisitId();

      // Assert
      expect(result, testObservations);
      verify(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId)).called(1);
    });

    test('getObservationsByVisitId should return empty list on error', () async {
      // Arrange
      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenThrow(Exception('Test error'));

      // Initialiser le viewModel 
      viewModel = ObservationsViewModel(
        mockGetObservationsByVisitIdUseCase,
        mockCreateObservationUseCase,
        mockUpdateObservationUseCase,
        mockDeleteObservationUseCase,
        mockGetObservationByIdUseCase,
        testVisitId,
      );

      // Attendre la fin de l'initialisation et l'erreur de chargement
      await Future.delayed(Duration.zero);

      // Réinitialiser les appels pour ne compter que ceux de getObservationsByVisitId
      clearInteractions(mockGetObservationsByVisitIdUseCase);

      // Reconfigurer le mock pour le prochain appel
      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenThrow(Exception('Test error'));

      // Act
      final result = await viewModel.getObservationsByVisitId();

      // Assert
      expect(result, []);
      verify(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId)).called(1);
    });
  });

  // Test pour les opérations CRUD
  group('ObservationsViewModel - CRUD operations', () {
    late MockGetObservationsByVisitIdUseCase mockGetObservationsByVisitIdUseCase;
    late MockCreateObservationUseCase mockCreateObservationUseCase;
    late MockUpdateObservationUseCase mockUpdateObservationUseCase;
    late MockDeleteObservationUseCase mockDeleteObservationUseCase;
    late MockGetObservationByIdUseCase mockGetObservationByIdUseCase;
    late ObservationsViewModel viewModel;
    const int testVisitId = 1;

    setUp(() {
      mockGetObservationsByVisitIdUseCase = MockGetObservationsByVisitIdUseCase();
      mockCreateObservationUseCase = MockCreateObservationUseCase();
      mockUpdateObservationUseCase = MockUpdateObservationUseCase();
      mockDeleteObservationUseCase = MockDeleteObservationUseCase();
      mockGetObservationByIdUseCase = MockGetObservationByIdUseCase();

      // Configurer pour les opérations CRUD
      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenAnswer((_) async => []);
      
      registerFallbackValue(const Observation(idObservation: 1));

      // Créer le viewModel
      viewModel = ObservationsViewModel(
        mockGetObservationsByVisitIdUseCase,
        mockCreateObservationUseCase,
        mockUpdateObservationUseCase,
        mockDeleteObservationUseCase,
        mockGetObservationByIdUseCase,
        testVisitId,
      );

      // Attendre la fin de l'initialisation
      Future.delayed(Duration.zero);
      
      // Réinitialiser les compteurs d'appels après l'initialisation
      clearInteractions(mockGetObservationsByVisitIdUseCase);
      clearInteractions(mockCreateObservationUseCase);
      clearInteractions(mockUpdateObservationUseCase);
      clearInteractions(mockDeleteObservationUseCase);
    });

    test('deleteObservation should call deleteObservationUseCase and reload observations',
        () async {
      // Arrange
      const observationIdToDelete = 1;

      when(() => mockDeleteObservationUseCase.execute(observationIdToDelete))
          .thenAnswer((_) async => true);

      when(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId))
          .thenAnswer((_) async => []);

      // Act
      final result = await viewModel.deleteObservation(observationIdToDelete);

      // Assert
      expect(result, true);
      verify(() => mockDeleteObservationUseCase.execute(observationIdToDelete)).called(1);
      verify(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId)).called(1);
    });

    test('deleteObservation should return false and not reload when use case fails',
        () async {
      // Arrange
      const observationIdToDelete = 1;

      when(() => mockDeleteObservationUseCase.execute(observationIdToDelete))
          .thenAnswer((_) async => false);

      // Act
      final result = await viewModel.deleteObservation(observationIdToDelete);

      // Assert
      expect(result, false);
      verify(() => mockDeleteObservationUseCase.execute(observationIdToDelete)).called(1);
      verifyNever(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId));
    });

    test('deleteObservation should handle exceptions', () async {
      // Arrange
      const observationIdToDelete = 1;

      when(() => mockDeleteObservationUseCase.execute(observationIdToDelete))
          .thenThrow(Exception('Test error'));

      // Act & Assert
      expect(() => viewModel.deleteObservation(observationIdToDelete), throwsException);
      verify(() => mockDeleteObservationUseCase.execute(observationIdToDelete)).called(1);
    });

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
      verify(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId)).called(1);
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
      verify(() => mockGetObservationsByVisitIdUseCase.execute(testVisitId)).called(2); 
      // Une fois pour récupérer l'observation existante, une fois pour recharger après
    });
  });
}
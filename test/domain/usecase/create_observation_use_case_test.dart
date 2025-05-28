import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/repository/observations_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_observation_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_observation_use_case_impl.dart';

// Mock des dépendances
class MockObservationsRepository extends Mock implements ObservationsRepository {}

void main() {
  late CreateObservationUseCase useCase;
  late MockObservationsRepository mockRepository;

  setUp(() {
    mockRepository = MockObservationsRepository();
    useCase = CreateObservationUseCaseImpl(mockRepository);
    
    // Enregistrer un comportement par défaut pour les méthodes mock
    registerFallbackValue(const Observation(
      idObservation: 0,
      idBaseVisit: 1,
    ));
  });

  group('CreateObservationUseCase', () {
    final testObservation = Observation(
      idObservation: 0, // ID temporaire qui sera remplacé
      idBaseVisit: 10,
      cdNom: 123,
      comments: 'Test observation',
      data: {'field1': 'value1', 'field2': 42},
    );
    
    const createdObservationId = 123;

    test('should create observation with repository', () async {
      // Arrange
      when(() => mockRepository.createObservation(any()))
          .thenAnswer((_) async => createdObservationId);

      // Act
      final result = await useCase.execute(testObservation);

      // Assert
      expect(result, equals(createdObservationId));
      
      // Vérifier que la méthode du repository a été appelée
      verify(() => mockRepository.createObservation(any())).called(1);
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      when(() => mockRepository.createObservation(any()))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => useCase.execute(testObservation),
        throwsA(isA<Exception>()),
      );
    });
    
    test('should handle observation without data', () async {
      // Arrange
      final observationWithoutData = Observation(
        idObservation: 0,
        idBaseVisit: 10,
        cdNom: 123,
        comments: 'Test observation',
        data: null, // Pas de données complémentaires
      );
      
      when(() => mockRepository.createObservation(any()))
          .thenAnswer((_) async => createdObservationId);
      
      // Act
      final result = await useCase.execute(observationWithoutData);
      
      // Assert
      expect(result, equals(createdObservationId));
      verify(() => mockRepository.createObservation(any())).called(1);
    });
    
    test('should handle observation with empty data map', () async {
      // Arrange
      final observationWithEmptyData = Observation(
        idObservation: 0,
        idBaseVisit: 10,
        cdNom: 123,
        comments: 'Test observation',
        data: {}, // Données vides
      );
      
      when(() => mockRepository.createObservation(any()))
          .thenAnswer((_) async => createdObservationId);
      
      // Act
      final result = await useCase.execute(observationWithEmptyData);
      
      // Assert
      expect(result, equals(createdObservationId));
      verify(() => mockRepository.createObservation(any())).called(1);
    });
  });
}
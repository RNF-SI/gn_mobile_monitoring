import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/repository/observations_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observations_by_visit_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observations_by_visit_id_use_case_impl.dart';

// Mock des dépendances
class MockObservationsRepository extends Mock implements ObservationsRepository {}

void main() {
  late GetObservationsByVisitIdUseCase useCase;
  late MockObservationsRepository mockRepository;

  setUp(() {
    mockRepository = MockObservationsRepository();
    useCase = GetObservationsByVisitIdUseCaseImpl(mockRepository);
  });

  group('GetObservationsByVisitIdUseCase', () {
    const testVisitId = 10;
    
    final testObservations = [
      Observation(
        idObservation: 1,
        idBaseVisit: testVisitId,
        cdNom: 123,
        comments: 'Observation 1',
        data: {'field1': 'value1'},
      ),
      Observation(
        idObservation: 2,
        idBaseVisit: testVisitId,
        cdNom: 456,
        comments: 'Observation 2',
        data: {'field2': 42},
      ),
    ];

    test('should get observations from repository', () async {
      // Arrange
      when(() => mockRepository.getObservationsByVisitId(any()))
          .thenAnswer((_) async => testObservations);

      // Act
      final result = await useCase.execute(testVisitId);

      // Assert
      expect(result, equals(testObservations));
      expect(result.length, 2);
      
      // Vérifier que la méthode du repository a été appelée avec le bon ID
      verify(() => mockRepository.getObservationsByVisitId(testVisitId)).called(1);
    });

    test('should return empty list when no observations found', () async {
      // Arrange
      when(() => mockRepository.getObservationsByVisitId(any()))
          .thenAnswer((_) async => []);

      // Act
      final result = await useCase.execute(testVisitId);

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getObservationsByVisitId(testVisitId)).called(1);
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      when(() => mockRepository.getObservationsByVisitId(any()))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => useCase.execute(testVisitId),
        throwsA(isA<Exception>()),
      );
    });
    
    test('should handle invalid visit id', () async {
      // Arrange - ID invalide (0 ou négatif)
      const invalidVisitId = 0;
      
      when(() => mockRepository.getObservationsByVisitId(any()))
          .thenAnswer((_) async => []);
      
      // Act
      final result = await useCase.execute(invalidVisitId);
      
      // Assert - Le cas d'utilisation ne valide pas l'ID, juste passe l'appel au repository
      expect(result, isEmpty);
      verify(() => mockRepository.getObservationsByVisitId(invalidVisitId)).called(1);
    });
    
    test('should handle observations with different data structures', () async {
      // Arrange - Observations avec différentes structures de données
      final mixedObservations = [
        Observation(
          idObservation: 1,
          idBaseVisit: testVisitId,
          cdNom: 123,
          comments: 'With data',
          data: {'field1': 'value1'},
        ),
        Observation(
          idObservation: 2,
          idBaseVisit: testVisitId,
          cdNom: 456,
          comments: 'Without data',
          data: null,
        ),
        Observation(
          idObservation: 3,
          idBaseVisit: testVisitId,
          cdNom: 789,
          comments: 'With empty data',
          data: {},
        ),
      ];
      
      when(() => mockRepository.getObservationsByVisitId(any()))
          .thenAnswer((_) async => mixedObservations);
      
      // Act
      final result = await useCase.execute(testVisitId);
      
      // Assert
      expect(result, equals(mixedObservations));
      expect(result.length, 3);
      verify(() => mockRepository.getObservationsByVisitId(testVisitId)).called(1);
    });
  });
}
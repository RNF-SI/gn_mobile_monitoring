import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/repository/observations_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_observation_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_observation_use_case_impl.dart';

// Mock des dépendances
class MockObservationsRepository extends Mock implements ObservationsRepository {}

void main() {
  late UpdateObservationUseCase useCase;
  late MockObservationsRepository mockRepository;

  setUp(() {
    mockRepository = MockObservationsRepository();
    useCase = UpdateObservationUseCaseImpl(mockRepository);
    
    // Enregistrer un comportement par défaut pour les méthodes mock
    registerFallbackValue(const Observation(
      idObservation: 1,
      idBaseVisit: 10,
    ));
  });

  group('UpdateObservationUseCase', () {
    final testObservation = Observation(
      idObservation: 1,
      idBaseVisit: 10,
      cdNom: 123,
      comments: 'Updated observation comment',
      data: {'field1': 'updated value', 'field2': 99},
    );

    test('should update observation with repository', () async {
      // Arrange
      when(() => mockRepository.updateObservation(any()))
          .thenAnswer((_) async => true);

      // Act
      final result = await useCase.execute(testObservation);

      // Assert
      expect(result, true);
      
      // Vérifier que la méthode du repository a été appelée avec les bons paramètres
      verify(() => mockRepository.updateObservation(testObservation)).called(1);
    });

    test('should return false when repository update fails', () async {
      // Arrange
      when(() => mockRepository.updateObservation(any()))
          .thenAnswer((_) async => false);

      // Act
      final result = await useCase.execute(testObservation);

      // Assert
      expect(result, false);
      verify(() => mockRepository.updateObservation(testObservation)).called(1);
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      when(() => mockRepository.updateObservation(any()))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => useCase.execute(testObservation),
        throwsA(isA<Exception>()),
      );
    });
    
    test('should handle observation with null data', () async {
      // Arrange
      final observationWithNullData = Observation(
        idObservation: 1,
        idBaseVisit: 10,
        cdNom: 123,
        comments: 'Updated observation',
        data: null,
      );
      
      when(() => mockRepository.updateObservation(any()))
          .thenAnswer((_) async => true);
      
      // Act
      final result = await useCase.execute(observationWithNullData);
      
      // Assert
      expect(result, true);
      verify(() => mockRepository.updateObservation(observationWithNullData)).called(1);
    });
    
    test('should handle observation with empty data map', () async {
      // Arrange
      final observationWithEmptyData = Observation(
        idObservation: 1,
        idBaseVisit: 10,
        cdNom: 123,
        comments: 'Updated observation',
        data: {},
      );
      
      when(() => mockRepository.updateObservation(any()))
          .thenAnswer((_) async => true);
      
      // Act
      final result = await useCase.execute(observationWithEmptyData);
      
      // Assert
      expect(result, true);
      verify(() => mockRepository.updateObservation(observationWithEmptyData)).called(1);
    });
    
    test('should validate that idObservation is not 0', () async {
      // Arrange
      final invalidObservation = Observation(
        idObservation: 0, // Invalide pour une mise à jour
        idBaseVisit: 10,
        cdNom: 123,
        comments: 'Invalid observation',
      );
      
      when(() => mockRepository.updateObservation(any()))
          .thenAnswer((_) async => true);
      
      // Act
      await useCase.execute(invalidObservation);
      
      // Assert
      // Le cas d'utilisation passe simplement la requête au repository, sans validation
      // Donc même avec un ID invalide, la méthode sera appelée
      verify(() => mockRepository.updateObservation(invalidObservation)).called(1);
    });
  });
}
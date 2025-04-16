import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/domain/repository/observations_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_observation_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_observation_use_case_impl.dart';

// Mock des dépendances
class MockObservationsRepository extends Mock implements ObservationsRepository {}

void main() {
  late DeleteObservationUseCase useCase;
  late MockObservationsRepository mockRepository;

  setUp(() {
    mockRepository = MockObservationsRepository();
    useCase = DeleteObservationUseCaseImpl(mockRepository);
  });

  group('DeleteObservationUseCase', () {
    const testObservationId = 1;

    test('should delete observation with repository', () async {
      // Arrange
      when(() => mockRepository.deleteObservation(any()))
          .thenAnswer((_) async => true);

      // Act
      final result = await useCase.execute(testObservationId);

      // Assert
      expect(result, true);
      
      // Vérifier que la méthode du repository a été appelée avec le bon ID
      verify(() => mockRepository.deleteObservation(testObservationId)).called(1);
    });

    test('should return false when repository delete fails', () async {
      // Arrange
      when(() => mockRepository.deleteObservation(any()))
          .thenAnswer((_) async => false);

      // Act
      final result = await useCase.execute(testObservationId);

      // Assert
      expect(result, false);
      verify(() => mockRepository.deleteObservation(testObservationId)).called(1);
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      when(() => mockRepository.deleteObservation(any()))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => useCase.execute(testObservationId),
        throwsA(isA<Exception>()),
      );
    });
    
    test('should handle invalid observation id', () async {
      // Arrange - ID invalide (0 ou négatif)
      const invalidObservationId = 0;
      
      when(() => mockRepository.deleteObservation(any()))
          .thenAnswer((_) async => false);
      
      // Act
      final result = await useCase.execute(invalidObservationId);
      
      // Assert - Le cas d'utilisation ne valide pas l'ID, juste passe l'appel au repository
      expect(result, false);
      verify(() => mockRepository.deleteObservation(invalidObservationId)).called(1);
    });
    
    test('should handle non-existent observation id', () async {
      // Arrange - ID qui n'existe pas dans la base de données
      const nonExistentId = 999;
      
      when(() => mockRepository.deleteObservation(any()))
          .thenAnswer((_) async => false); // Repository indique échec car non trouvé
      
      // Act
      final result = await useCase.execute(nonExistentId);
      
      // Assert
      expect(result, false);
      verify(() => mockRepository.deleteObservation(nonExistentId)).called(1);
    });
  });
}
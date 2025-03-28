import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/domain/repository/observation_details_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_observation_details_by_observation_id_use_case.dart';

// Mock des dépendances
class MockObservationDetailsRepository extends Mock implements ObservationDetailsRepository {}

void main() {
  late DeleteObservationDetailsByObservationIdUseCase useCase;
  late MockObservationDetailsRepository mockRepository;

  setUp(() {
    mockRepository = MockObservationDetailsRepository();
    useCase = DeleteObservationDetailsByObservationIdUseCaseImpl(mockRepository);
  });

  group('DeleteObservationDetailsByObservationIdUseCase', () {
    const int observationId = 1;
    
    test('should return true when repository deletion is successful', () async {
      // Arrange
      when(() => mockRepository.deleteObservationDetailsByObservationId(observationId))
          .thenAnswer((_) async => true);

      // Act
      final result = await useCase.execute(observationId);

      // Assert
      expect(result, isTrue);
      verify(() => mockRepository.deleteObservationDetailsByObservationId(observationId)).called(1);
    });

    test('should return false when repository deletion fails', () async {
      // Arrange
      when(() => mockRepository.deleteObservationDetailsByObservationId(observationId))
          .thenAnswer((_) async => false);

      // Act
      final result = await useCase.execute(observationId);

      // Assert
      expect(result, isFalse);
      verify(() => mockRepository.deleteObservationDetailsByObservationId(observationId)).called(1);
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      final exception = Exception('Database error');
      when(() => mockRepository.deleteObservationDetailsByObservationId(observationId))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => useCase.execute(observationId),
        throwsA(equals(exception)),
      );
      verify(() => mockRepository.deleteObservationDetailsByObservationId(observationId)).called(1);
    });
  });
}
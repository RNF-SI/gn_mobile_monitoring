import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/domain/repository/observation_details_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_observation_detail_use_case.dart';

// Mock des dépendances
class MockObservationDetailsRepository extends Mock implements ObservationDetailsRepository {}

void main() {
  late DeleteObservationDetailUseCase useCase;
  late MockObservationDetailsRepository mockRepository;

  setUp(() {
    mockRepository = MockObservationDetailsRepository();
    useCase = DeleteObservationDetailUseCaseImpl(mockRepository);
  });

  group('DeleteObservationDetailUseCase', () {
    const int detailId = 1;
    
    test('should return true when repository deletion is successful', () async {
      // Arrange
      when(() => mockRepository.deleteObservationDetail(detailId))
          .thenAnswer((_) async => true);

      // Act
      final result = await useCase.execute(detailId);

      // Assert
      expect(result, isTrue);
      verify(() => mockRepository.deleteObservationDetail(detailId)).called(1);
    });

    test('should return false when repository deletion fails', () async {
      // Arrange
      when(() => mockRepository.deleteObservationDetail(detailId))
          .thenAnswer((_) async => false);

      // Act
      final result = await useCase.execute(detailId);

      // Assert
      expect(result, isFalse);
      verify(() => mockRepository.deleteObservationDetail(detailId)).called(1);
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      final exception = Exception('Database error');
      when(() => mockRepository.deleteObservationDetail(detailId))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => useCase.execute(detailId),
        throwsA(equals(exception)),
      );
      verify(() => mockRepository.deleteObservationDetail(detailId)).called(1);
    });
  });
}
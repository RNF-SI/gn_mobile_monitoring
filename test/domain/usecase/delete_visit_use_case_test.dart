import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_visit_use_case_impl.dart';

// Mock des dépendances
class MockVisitRepository extends Mock implements VisitRepository {}

void main() {
  late DeleteVisitUseCase useCase;
  late MockVisitRepository mockRepository;

  setUp(() {
    mockRepository = MockVisitRepository();
    useCase = DeleteVisitUseCaseImpl(mockRepository);
  });

  group('DeleteVisitUseCase', () {
    const visitId = 123;

    test('should delete visit using repository', () async {
      // Arrange
      when(() => mockRepository.deleteVisit(any()))
          .thenAnswer((_) async => true);

      // Act
      final result = await useCase.execute(visitId);

      // Assert
      expect(result, equals(true));
      verify(() => mockRepository.deleteVisit(visitId)).called(1);
    });

    test('should return false if repository delete fails', () async {
      // Arrange
      when(() => mockRepository.deleteVisit(any()))
          .thenAnswer((_) async => false);

      // Act
      final result = await useCase.execute(visitId);

      // Assert
      expect(result, equals(false));
      verify(() => mockRepository.deleteVisit(visitId)).called(1);
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      when(() => mockRepository.deleteVisit(any()))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => useCase.execute(visitId),
        throwsA(isA<Exception>()),
      );
      verify(() => mockRepository.deleteVisit(visitId)).called(1);
    });
  });
}
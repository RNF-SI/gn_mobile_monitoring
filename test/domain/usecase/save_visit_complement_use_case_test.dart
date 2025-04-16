import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/visit_complement.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/save_visit_complement_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/save_visit_complement_use_case_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockVisitRepository extends Mock implements VisitRepository {}

void main() {
  late MockVisitRepository mockVisitRepository;
  late SaveVisitComplementUseCase useCase;

  setUp(() {
    mockVisitRepository = MockVisitRepository();
    useCase = SaveVisitComplementUseCaseImpl(mockVisitRepository);
  });

  group('SaveVisitComplementUseCase', () {
    const testVisitComplement = VisitComplement(
      idBaseVisit: 1,
      data: '{"key1": "value1", "key2": 42}',
    );

    test('should save visit complement to the repository', () async {
      // Arrange
      when(() => mockVisitRepository.saveVisitComplementDomain(testVisitComplement))
          .thenAnswer((_) async {});

      // Act
      await useCase.execute(testVisitComplement);

      // Assert
      verify(() => mockVisitRepository.saveVisitComplementDomain(testVisitComplement)).called(1);
    });

    test('should throw an exception when repository throws an exception', () async {
      // Arrange
      when(() => mockVisitRepository.saveVisitComplementDomain(testVisitComplement))
          .thenThrow(Exception('Test error'));

      // Act & Assert
      expect(
        () => useCase.execute(testVisitComplement),
        throwsA(isA<Exception>()),
      );
      verify(() => mockVisitRepository.saveVisitComplementDomain(testVisitComplement)).called(1);
    });

    test('should handle complement with null data', () async {
      // Arrange
      const visitComplement = VisitComplement(
        idBaseVisit: 1,
        data: null,
      );
      when(() => mockVisitRepository.saveVisitComplementDomain(visitComplement))
          .thenAnswer((_) async {});

      // Act
      await useCase.execute(visitComplement);

      // Assert
      verify(() => mockVisitRepository.saveVisitComplementDomain(visitComplement)).called(1);
    });
  });
}
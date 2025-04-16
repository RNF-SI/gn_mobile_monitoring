import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/visit_complement.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_complement_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_complement_use_case_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockVisitRepository extends Mock implements VisitRepository {}

void main() {
  late MockVisitRepository mockVisitRepository;
  late GetVisitComplementUseCase useCase;

  setUp(() {
    mockVisitRepository = MockVisitRepository();
    useCase = GetVisitComplementUseCaseImpl(mockVisitRepository);
  });

  group('GetVisitComplementUseCase', () {
    const testVisitComplement = VisitComplement(
      idBaseVisit: 1,
      data: '{"key1": "value1", "key2": 42}',
    );

    test('should get visit complement from the repository', () async {
      // Arrange
      const visitId = 1;
      when(() => mockVisitRepository.getVisitComplementDomain(visitId))
          .thenAnswer((_) async => testVisitComplement);

      // Act
      final result = await useCase.execute(visitId);

      // Assert
      verify(() => mockVisitRepository.getVisitComplementDomain(visitId)).called(1);
      expect(result, isA<VisitComplement>());
      expect(result?.idBaseVisit, 1);
      expect(result?.data, '{"key1": "value1", "key2": 42}');
    });

    test('should return null when no complement exists', () async {
      // Arrange
      const visitId = 99;
      when(() => mockVisitRepository.getVisitComplementDomain(visitId))
          .thenAnswer((_) async => null);

      // Act
      final result = await useCase.execute(visitId);

      // Assert
      verify(() => mockVisitRepository.getVisitComplementDomain(visitId)).called(1);
      expect(result, isNull);
    });

    test('should throw an exception when repository throws an exception', () async {
      // Arrange
      const visitId = 1;
      when(() => mockVisitRepository.getVisitComplementDomain(visitId))
          .thenThrow(Exception('Test error'));

      // Act & Assert
      expect(
        () => useCase.execute(visitId),
        throwsA(isA<Exception>()),
      );
      verify(() => mockVisitRepository.getVisitComplementDomain(visitId)).called(1);
    });
  });
}
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/entity/base_visit_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_with_details_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_with_details_use_case_impl.dart'
    as impl;
import 'package:mocktail/mocktail.dart';

class MockVisitRepository extends Mock implements VisitRepository {}

void main() {
  late MockVisitRepository mockVisitRepository;
  late GetVisitWithDetailsUseCase useCase;

  setUp(() {
    mockVisitRepository = MockVisitRepository();
    useCase = impl.GetVisitWithDetailsUseCaseImpl(mockVisitRepository);
  });

  group('GetVisitWithDetailsUseCase', () {
    final testVisitEntity = BaseVisitEntity(
      idBaseVisit: 1,
      idBaseSite: 1,
      idDataset: 1,
      idModule: 1,
      visitDateMin: '2024-03-20',
      comments: 'Test comment',
      observers: [1, 2],
      data: {'field1': 'value1', 'field2': 42},
    );

    test('should get a visit with all its details from the repository',
        () async {
      // Arrange
      when(() => mockVisitRepository.getVisitWithFullDetails(1))
          .thenAnswer((_) async => testVisitEntity);

      // Act
      final result = await useCase.execute(1);

      // Assert
      verify(() => mockVisitRepository.getVisitWithFullDetails(1)).called(1);
      expect(result, isA<BaseVisit>());
      expect(result.idBaseVisit, 1);
      expect(result.data, isNotNull);
      expect(result.data!['field1'], 'value1');
      expect(result.data!['field2'], 42);
      expect(result.observers, [1, 2]);
    });

    test('should throw an exception when repository throws an exception',
        () async {
      // Arrange
      when(() => mockVisitRepository.getVisitWithFullDetails(1))
          .thenThrow(Exception('Test error'));

      // Act & Assert
      expect(
        () => useCase.execute(1),
        throwsA(isA<Exception>()),
      );
      verify(() => mockVisitRepository.getVisitWithFullDetails(1)).called(1);
    });
  });
}

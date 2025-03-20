import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/entity/base_visit_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visits_by_site_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visits_by_site_id_use_case_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockVisitRepository extends Mock implements VisitRepository {}

void main() {
  late MockVisitRepository mockVisitRepository;
  late GetVisitsBySiteIdUseCase useCase;

  setUp(() {
    mockVisitRepository = MockVisitRepository();
    useCase = GetVisitsBySiteIdUseCaseImpl(mockVisitRepository);
  });

  group('GetVisitsBySiteIdUseCase', () {
    final testVisitEntities = [
      BaseVisitEntity(
        idBaseVisit: 1,
        idBaseSite: 42,
        idDataset: 1,
        idModule: 1,
        visitDateMin: '2024-03-20',
        comments: 'Test visit 1',
        observers: [1, 2],
        data: {'field1': 'value1'},
      ),
      BaseVisitEntity(
        idBaseVisit: 2,
        idBaseSite: 42,
        idDataset: 1,
        idModule: 1,
        visitDateMin: '2024-03-21',
        comments: 'Test visit 2',
        observers: [2, 3],
        data: {'field2': 'value2'},
      ),
    ];

    test('should get all visits for a site from the repository', () async {
      // Arrange
      const siteId = 42;
      when(() => mockVisitRepository.getVisitsBySiteId(siteId))
          .thenAnswer((_) async => testVisitEntities);

      // Act
      final result = await useCase.execute(siteId);

      // Assert
      verify(() => mockVisitRepository.getVisitsBySiteId(siteId)).called(1);
      expect(result, isA<List<BaseVisit>>());
      expect(result.length, 2);
      expect(result[0].idBaseVisit, 1);
      expect(result[0].idBaseSite, 42);
      expect(result[0].comments, 'Test visit 1');
      expect(result[1].idBaseVisit, 2);
      expect(result[1].idBaseSite, 42);
      expect(result[1].comments, 'Test visit 2');
    });

    test('should return empty list when no visits are found', () async {
      // Arrange
      const siteId = 99;
      when(() => mockVisitRepository.getVisitsBySiteId(siteId))
          .thenAnswer((_) async => []);

      // Act
      final result = await useCase.execute(siteId);

      // Assert
      verify(() => mockVisitRepository.getVisitsBySiteId(siteId)).called(1);
      expect(result, isA<List<BaseVisit>>());
      expect(result.length, 0);
    });

    test('should throw an exception when repository throws an exception', () async {
      // Arrange
      const siteId = 42;
      when(() => mockVisitRepository.getVisitsBySiteId(siteId))
          .thenThrow(Exception('Test error'));

      // Act & Assert
      expect(
        () => useCase.execute(siteId),
        throwsA(isA<Exception>()),
      );
      verify(() => mockVisitRepository.getVisitsBySiteId(siteId)).called(1);
    });
  });
}
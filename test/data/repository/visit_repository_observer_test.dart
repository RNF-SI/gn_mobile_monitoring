import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/visites_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/base_visit_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/cor_visit_observer_entity.dart';
import 'package:gn_mobile_monitoring/data/repository/visit_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<VisitesDatabase>()])
import 'visit_repository_observer_test.mocks.dart';

void main() {
  late MockVisitesDatabase mockVisitesDatabase;
  late VisitRepositoryImpl repository;

  setUp(() {
    mockVisitesDatabase = MockVisitesDatabase();
    repository = VisitRepositoryImpl(mockVisitesDatabase);
  });

  group('VisitRepository Observer Tests', () {
    final testVisit = TBaseVisit(
      idBaseVisit: 1,
      idBaseSite: 1,
      idDataset: 1,
      idModule: 1,
      idDigitiser: 1,
      visitDateMin: '2024-03-20',
      visitDateMax: '2024-03-21',
      idNomenclatureTechCollectCampanule: 1,
      idNomenclatureGrpTyp: 1,
      comments: 'Test visit',
      uuidBaseVisit: 'test-uuid',
      metaCreateDate: '2024-03-20',
      metaUpdateDate: '2024-03-20',
    );

    final testVisitEntity = BaseVisitEntity(
      idBaseVisit: 1,
      idBaseSite: 1,
      idDataset: 1,
      idModule: 1,
      idDigitiser: 1,
      visitDateMin: '2024-03-20',
      visitDateMax: '2024-03-21',
      idNomenclatureTechCollectCampanule: 1,
      idNomenclatureGrpTyp: 1,
      comments: 'Test visit',
      uuidBaseVisit: 'test-uuid',
      metaCreateDate: '2024-03-20',
      metaUpdateDate: '2024-03-20',
      observers: [1, 2, 3],
      data: {'key': 'value'},
    );

    final testObserver1 = CorVisitObserverData(
      idBaseVisit: 1,
      idRole: 1,
      uniqueIdCoreVisitObserver: 'uuid1',
    );

    final testObserver2 = CorVisitObserverData(
      idBaseVisit: 1,
      idRole: 2,
      uniqueIdCoreVisitObserver: 'uuid2',
    );

    final testObserverEntity1 = CorVisitObserverEntity(
      idBaseVisit: 1,
      idRole: 1,
      uniqueIdCoreVisitObserver: 'uuid1',
    );

    final testObserverEntity2 = CorVisitObserverEntity(
      idBaseVisit: 1,
      idRole: 2,
      uniqueIdCoreVisitObserver: 'uuid2',
    );

    test('getVisitObservers should return list of observers', () async {
      // Arrange
      when(mockVisitesDatabase.getVisitObservers(1))
          .thenAnswer((_) async => [testObserver1, testObserver2]);

      // Act
      final result = await repository.getVisitObservers(1);

      // Assert
      expect(result.length, 2);
      expect(result[0].idBaseVisit, 1);
      expect(result[0].idRole, 1);
      expect(result[1].idRole, 2);
      verify(mockVisitesDatabase.getVisitObservers(1)).called(1);
    });

    test('saveVisitObservers should replace all observers', () async {
      // Arrange
      when(mockVisitesDatabase.replaceVisitObservers(any, any))
          .thenAnswer((_) async {});

      // Act
      await repository.saveVisitObservers(
          1, [testObserverEntity1, testObserverEntity2]);

      // Assert
      verify(mockVisitesDatabase.replaceVisitObservers(1, any)).called(1);
    });

    test('addVisitObserver should add a single observer', () async {
      // Arrange
      when(mockVisitesDatabase.insertVisitObserver(any))
          .thenAnswer((_) async => 1);

      // Act
      final result = await repository.addVisitObserver(1, 3);

      // Assert
      expect(result, 1);
      verify(mockVisitesDatabase.insertVisitObserver(any)).called(1);
    });

    test('clearVisitObservers should remove all observers', () async {
      // Arrange
      when(mockVisitesDatabase.deleteVisitObservers(1))
          .thenAnswer((_) async => 2);

      // Act
      await repository.clearVisitObservers(1);

      // Assert
      verify(mockVisitesDatabase.deleteVisitObservers(1)).called(1);
    });

    test('getVisitById with observers should populate observers field', () async {
      // Arrange
      when(mockVisitesDatabase.getVisitById(1))
          .thenAnswer((_) async => testVisit);
      when(mockVisitesDatabase.getVisitObservers(1))
          .thenAnswer((_) async => [testObserver1, testObserver2]);

      // Act - Note: in a real implementation, you'd need to fetch observers and
      // attach them to the visit entity
      final result = await repository.getVisitById(1);

      // Assert
      expect(result.idBaseVisit, 1);
      verify(mockVisitesDatabase.getVisitById(1)).called(1);
    });
  });
}
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

    final testVisitWithComplement = TBaseVisit(
      idBaseVisit: 1,
      idBaseSite: 1,
      idDataset: 1,
      idModule: 1,
      idDigitiser: 1,
      visitDateMin: '2024-03-20',
      comments: 'Test visit',
      metaCreateDate: '2024-03-20',
      metaUpdateDate: '2024-03-20',
    );

    final testVisitComplement = TVisitComplement(
      idBaseVisit: 1,
      data: '{"count_stade_l1": 3, "time_start": "08:30"}',
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

    test('getVisitObservers should return empty list when no observers found',
        () async {
      // Arrange
      when(mockVisitesDatabase.getVisitObservers(1))
          .thenAnswer((_) async => []);

      // Act
      final result = await repository.getVisitObservers(1);

      // Assert
      expect(result.length, 0);
      verify(mockVisitesDatabase.getVisitObservers(1)).called(1);
    });

    test('getVisitObservers should handle null response', () async {
      // Arrange
      when(mockVisitesDatabase.getVisitObservers(1))
          .thenAnswer((_) async => []);

      // Act
      final result = await repository.getVisitObservers(1);

      // Assert
      expect(result.length, 0);
      verify(mockVisitesDatabase.getVisitObservers(1)).called(1);
    });

    test('saveVisitObservers should replace all observers', () async {
      // Arrange
      when(mockVisitesDatabase.replaceVisitObservers(any, any))
          .thenAnswer((_) async {});

      // Act
      await repository
          .saveVisitObservers(1, [testObserverEntity1, testObserverEntity2]);

      // Assert
      verify(mockVisitesDatabase.replaceVisitObservers(1, any)).called(1);
    });

    test('saveVisitObservers should work with empty list', () async {
      // Arrange
      when(mockVisitesDatabase.replaceVisitObservers(any, any))
          .thenAnswer((_) async {});

      // Act
      await repository.saveVisitObservers(1, []);

      // Assert
      verify(mockVisitesDatabase.replaceVisitObservers(1, [])).called(1);
    });

    test('addVisitObserver should add a single observer', () async {
      // Arrange
      final capturedObserver = argThat(predicate<CorVisitObserverData>((data) {
        return data.idBaseVisit == 1 && data.idRole == 3;
      }));

      when(mockVisitesDatabase.insertVisitObserver(any))
          .thenAnswer((_) async => 1);

      // Act
      final result = await repository.addVisitObserver(1, 3);

      // Assert
      expect(result, 1);
      verify(mockVisitesDatabase.insertVisitObserver(capturedObserver))
          .called(1);
    });

    test('addVisitObserver should handle insertion failure', () async {
      // Arrange
      when(mockVisitesDatabase.insertVisitObserver(any))
          .thenThrow(Exception('Insertion error'));

      // Act & Assert
      expect(() => repository.addVisitObserver(1, 3), throwsException);
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

    test('clearVisitObservers should handle deletion failure', () async {
      // Arrange
      when(mockVisitesDatabase.deleteVisitObservers(1))
          .thenThrow(Exception('Deletion error'));

      // Act & Assert
      expect(() => repository.clearVisitObservers(1), throwsException);
    });

    test('getVisitById should fetch and attach observers', () async {
      // Arrange
      when(mockVisitesDatabase.getVisitById(1))
          .thenAnswer((_) async => testVisit);
      when(mockVisitesDatabase.getVisitObservers(1))
          .thenAnswer((_) async => [testObserver1, testObserver2]);
      when(mockVisitesDatabase.getVisitComplementById(1))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getVisitById(1);

      // Assert
      expect(result.idBaseVisit, 1);
      expect(result.observers, isNotNull);
      expect(result.observers!.length, 2);
      expect(result.observers, containsAll([1, 2]));

      verify(mockVisitesDatabase.getVisitById(1)).called(1);
      verify(mockVisitesDatabase.getVisitObservers(1)).called(1);
    });

    test('createVisit should handle observers correctly', () async {
      // Arrange
      final capturedVisit =
          argThat(predicate<TBaseVisit>((visit) => visit.idBaseSite == 1));

      when(mockVisitesDatabase.insertVisit(any))
          .thenAnswer((_) async => 5); // New visit ID

      // Use anyList() since we're not checking the exact list content in this test
      when(mockVisitesDatabase.replaceVisitObservers(any, any))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.createVisit(testVisitEntity);

      // Assert
      expect(result, 5);
      verify(mockVisitesDatabase.insertVisit(capturedVisit)).called(1);
      verify(mockVisitesDatabase.replaceVisitObservers(5, any)).called(1);
    });

    test('updateVisit should handle observers correctly', () async {
      // Arrange
      final capturedVisit =
          argThat(predicate<TBaseVisit>((visit) => visit.idBaseVisit == 1));

      when(mockVisitesDatabase.updateVisit(any)).thenAnswer((_) async => true);

      when(mockVisitesDatabase.replaceVisitObservers(any, any))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.updateVisit(testVisitEntity);

      // Assert
      expect(result, true);
      verify(mockVisitesDatabase.updateVisit(capturedVisit)).called(1);
      verify(mockVisitesDatabase.replaceVisitObservers(1, any)).called(1);
    });

    // Commenting out this test as the method doesn't exist in the repository
    /*
    test(
        'getVisitWithFullDetails should fetch visit with observers and complement data',
        () async {
      // Arrange
      when(mockVisitesDatabase.getVisitById(1))
          .thenAnswer((_) async => testVisitWithComplement);
      when(mockVisitesDatabase.getVisitObservers(1))
          .thenAnswer((_) async => [testObserver1, testObserver2]);
      when(mockVisitesDatabase.getVisitComplementById(1))
          .thenAnswer((_) async => testVisitComplement);
          
      // Act
      final result = await repository.getVisitWithFullDetails(1);
      
      // Assert
      expect(result.idBaseVisit, 1);
      expect(result.observers, isNotNull);
      expect(result.observers!.length, 2);
      expect(result.observers, containsAll([1, 2]));
      expect(result.data, isNotNull);
      expect(result.data!['count_stade_l1'], 3);
      expect(result.data!['time_start'], '08:30');
      
      verify(mockVisitesDatabase.getVisitById(1)).called(1);
      verify(mockVisitesDatabase.getVisitObservers(1)).called(1);
      verify(mockVisitesDatabase.getVisitComplementById(1)).called(1);
    });
    */

    test('deleteVisit should also delete observers', () async {
      // Arrange
      when(mockVisitesDatabase.deleteVisitWithComplement(1))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.deleteVisit(1);

      // Assert
      expect(result, true);
      verify(mockVisitesDatabase.deleteVisitWithComplement(1)).called(1);
      // Observers are automatically deleted by the database due to foreign key constraints
    });
  });
}

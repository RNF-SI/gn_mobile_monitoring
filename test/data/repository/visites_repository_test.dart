import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/visites_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/base_visit_entity.dart';
import 'package:gn_mobile_monitoring/data/repository/visit_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<VisitesDatabase>()])
import 'visites_repository_test.mocks.dart';

void main() {
  late MockVisitesDatabase mockVisitesDatabase;
  late VisitRepositoryImpl repository;

  setUp(() {
    mockVisitesDatabase = MockVisitesDatabase();
    repository = VisitRepositoryImpl(mockVisitesDatabase);
  });

  group('VisitRepository Tests', () {
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
    );

    test('getAllVisits should return list of visits', () async {
      when(mockVisitesDatabase.getAllVisits())
          .thenAnswer((_) async => [testVisit]);

      final result = await repository.getAllVisits();

      expect(result.length, 1);
      expect(result.first.idBaseVisit, testVisitEntity.idBaseVisit);
      verify(mockVisitesDatabase.getAllVisits()).called(1);
    });

    test('getVisitById should return a visit', () async {
      when(mockVisitesDatabase.getVisitById(1))
          .thenAnswer((_) async => testVisit);

      final result = await repository.getVisitById(1);

      expect(result.idBaseVisit, testVisitEntity.idBaseVisit);
      verify(mockVisitesDatabase.getVisitById(1)).called(1);
    });

    test('createVisit should return visit id', () async {
      when(mockVisitesDatabase.insertVisit(any)).thenAnswer((_) async => 1);

      final result = await repository.createVisit(testVisitEntity);

      expect(result, 1);
      verify(mockVisitesDatabase.insertVisit(any)).called(1);
    });

    test('updateVisit should return success', () async {
      when(mockVisitesDatabase.updateVisit(any)).thenAnswer((_) async => true);

      final result = await repository.updateVisit(testVisitEntity);

      expect(result, true);
      verify(mockVisitesDatabase.updateVisit(any)).called(1);
    });

    test('deleteVisit should return success', () async {
      when(mockVisitesDatabase.deleteVisitWithComplement(1))
          .thenAnswer((_) async {});

      final result = await repository.deleteVisit(1);

      expect(result, true);
      verify(mockVisitesDatabase.deleteVisitWithComplement(1)).called(1);
    });

    test('deleteVisit should handle errors', () async {
      when(mockVisitesDatabase.deleteVisitWithComplement(1))
          .thenThrow(Exception('Error'));

      final result = await repository.deleteVisit(1);

      expect(result, false);
      verify(mockVisitesDatabase.deleteVisitWithComplement(1)).called(1);
    });

    group('Visit Complement Tests', () {
      final testComplement = TVisitComplement(
        idBaseVisit: 1,
        data: 'Test data',
      );

      test('getVisitComplementData should return data', () async {
        when(mockVisitesDatabase.getVisitComplementById(1))
            .thenAnswer((_) async => testComplement);

        final result = await repository.getVisitComplementData(1);

        expect(result, 'Test data');
        verify(mockVisitesDatabase.getVisitComplementById(1)).called(1);
      });

      test('saveVisitComplementData should insert new complement', () async {
        when(mockVisitesDatabase.insertVisitComplement(any))
            .thenAnswer((_) async => 1);

        await repository.saveVisitComplementData(1, 'Test data');

        verify(mockVisitesDatabase.insertVisitComplement(any)).called(1);
      });

      test(
          'saveVisitComplementData should update existing complement on conflict',
          () async {
        when(mockVisitesDatabase.insertVisitComplement(any))
            .thenThrow(Exception('Unique constraint'));
        when(mockVisitesDatabase.updateVisitComplement(any))
            .thenAnswer((_) async => true);

        await repository.saveVisitComplementData(1, 'Test data');

        verify(mockVisitesDatabase.insertVisitComplement(any)).called(1);
        verify(mockVisitesDatabase.updateVisitComplement(any)).called(1);
      });

      test('deleteVisitComplementData should delete complement', () async {
        when(mockVisitesDatabase.deleteVisitComplement(1))
            .thenAnswer((_) async => 1);

        await repository.deleteVisitComplementData(1);

        verify(mockVisitesDatabase.deleteVisitComplement(1)).called(1);
      });
    });
  });
}

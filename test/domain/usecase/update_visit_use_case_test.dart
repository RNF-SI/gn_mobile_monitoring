import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/data/entity/base_visit_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/cor_visit_observer_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/visite_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_visit_use_case_impl.dart';

// Mock des dépendances
class MockVisitRepository extends Mock implements VisitRepository {}

void main() {
  late UpdateVisitUseCase useCase;
  late MockVisitRepository mockRepository;

  setUp(() {
    mockRepository = MockVisitRepository();
    useCase = UpdateVisitUseCaseImpl(mockRepository);
    
    // Enregistrer un comportement par défaut pour les méthodes mock que nous allons utiliser
    registerFallbackValue(BaseVisitEntity(
      idBaseVisit: 1,
      idDataset: 1,
      idModule: 1,
      visitDateMin: '2023-01-01',
    ));
    
    registerFallbackValue(CorVisitObserverEntity(
      idBaseVisit: 1, 
      idRole: 1,
      uniqueIdCoreVisitObserver: '',
    ));
  });

  group('UpdateVisitUseCase', () {
    final testVisit = BaseVisit(
      idBaseVisit: 123, // ID existant
      idBaseSite: 1,
      idDataset: 1,
      idModule: 2,
      visitDateMin: '2023-01-01',
      observers: [1, 2],
      data: {'field1': 'value1', 'field2': 42},
    );
    
    test('should update visit with repository', () async {
      // Arrange
      when(() => mockRepository.updateVisit(any()))
          .thenAnswer((_) async => true);
      
      when(() => mockRepository.saveVisitComplementData(any(), any()))
          .thenAnswer((_) async {});
          
      when(() => mockRepository.clearVisitObservers(any()))
          .thenAnswer((_) async {});

      when(() => mockRepository.saveVisitObservers(any(), any()))
          .thenAnswer((_) async {});

      // Act
      final result = await useCase.execute(testVisit);

      // Assert
      expect(result, equals(true));
      
      // Vérifier que les méthodes du repository ont été appelées avec les bons arguments
      verify(() => mockRepository.updateVisit(any())).called(1);
      
      // Vérifier que les données complémentaires ont été sauvegardées
      verify(() => mockRepository.saveVisitComplementData(
        testVisit.idBaseVisit, 
        any()
      )).called(1);
      
      // Vérifier que les observateurs ont été mis à jour (supprimés puis ajoutés)
      verify(() => mockRepository.clearVisitObservers(testVisit.idBaseVisit)).called(1);
      verify(() => mockRepository.saveVisitObservers(
        testVisit.idBaseVisit, 
        any()
      )).called(1);
    });

    test('should return false if repository update fails', () async {
      // Arrange
      when(() => mockRepository.updateVisit(any()))
          .thenAnswer((_) async => false);

      // Act
      final result = await useCase.execute(testVisit);

      // Assert
      expect(result, equals(false));
      
      // Vérifier que les méthodes complémentaires n'ont PAS été appelées
      verifyNever(() => mockRepository.saveVisitComplementData(any(), any()));
      verifyNever(() => mockRepository.clearVisitObservers(any()));
      verifyNever(() => mockRepository.saveVisitObservers(any(), any()));
    });

    test('should not save complement data if visit data is empty', () async {
      // Arrange
      final visitWithoutData = BaseVisit(
        idBaseVisit: 123,
        idBaseSite: 1,
        idDataset: 1,
        idModule: 2,
        visitDateMin: '2023-01-01',
        observers: [1, 2],
        data: {}, // Données vides
      );
      
      when(() => mockRepository.updateVisit(any()))
          .thenAnswer((_) async => true);
          
      when(() => mockRepository.clearVisitObservers(any()))
          .thenAnswer((_) async {});
      
      when(() => mockRepository.saveVisitObservers(any(), any()))
          .thenAnswer((_) async {});

      // Act
      final result = await useCase.execute(visitWithoutData);

      // Assert
      expect(result, equals(true));
      verify(() => mockRepository.updateVisit(any())).called(1);
      
      // Vérifier que les données complémentaires n'ont PAS été sauvegardées
      verifyNever(() => mockRepository.saveVisitComplementData(any(), any()));
      
      // Vérifier que les observateurs ont été mis à jour
      verify(() => mockRepository.clearVisitObservers(visitWithoutData.idBaseVisit)).called(1);
      verify(() => mockRepository.saveVisitObservers(
        visitWithoutData.idBaseVisit, 
        any()
      )).called(1);
    });

    test('should not update observers if observers list is null', () async {
      // Arrange
      final visitWithNullObservers = BaseVisit(
        idBaseVisit: 123,
        idBaseSite: 1,
        idDataset: 1,
        idModule: 2,
        visitDateMin: '2023-01-01',
        observers: null, // Liste null
        data: {'field1': 'value1'},
      );
      
      when(() => mockRepository.updateVisit(any()))
          .thenAnswer((_) async => true);
      
      when(() => mockRepository.saveVisitComplementData(any(), any()))
          .thenAnswer((_) async {});

      // Act
      final result = await useCase.execute(visitWithNullObservers);

      // Assert
      expect(result, equals(true));
      verify(() => mockRepository.updateVisit(any())).called(1);
      
      // Vérifier que les données complémentaires ont été sauvegardées
      verify(() => mockRepository.saveVisitComplementData(
        visitWithNullObservers.idBaseVisit, 
        any()
      )).called(1);
      
      // Vérifier que les observateurs n'ont PAS été mis à jour
      verifyNever(() => mockRepository.clearVisitObservers(any()));
      verifyNever(() => mockRepository.saveVisitObservers(any(), any()));
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      when(() => mockRepository.updateVisit(any()))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => useCase.execute(testVisit),
        throwsA(isA<Exception>()),
      );
    });
  });
}
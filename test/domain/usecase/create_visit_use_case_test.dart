import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/data/entity/base_visit_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/cor_visit_observer_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/visite_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_visit_use_case_impl.dart';

// Mock des dépendances
class MockVisitRepository extends Mock implements VisitRepository {}

void main() {
  late CreateVisitUseCase useCase;
  late MockVisitRepository mockRepository;

  setUp(() {
    mockRepository = MockVisitRepository();
    useCase = CreateVisitUseCaseImpl(mockRepository);
    
    // Enregistrer un comportement par défaut pour les méthodes mock que nous allons utiliser
    registerFallbackValue(BaseVisitEntity(
      idBaseVisit: 0,
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

  group('CreateVisitUseCase', () {
    final testVisit = BaseVisit(
      idBaseVisit: 0, // ID temporaire qui sera remplacé
      idBaseSite: 1,
      idDataset: 1,
      idModule: 2,
      visitDateMin: '2023-01-01',
      observers: [1, 2],
      data: {'field1': 'value1', 'field2': 42},
    );
    
    final testVisitEntity = testVisit.toEntity();
    const createdVisitId = 123;

    test('should create visit with repository', () async {
      // Arrange
      when(() => mockRepository.createVisit(any()))
          .thenAnswer((_) async => createdVisitId);
      
      when(() => mockRepository.saveVisitComplementData(any(), any()))
          .thenAnswer((_) async {});

      when(() => mockRepository.saveVisitObservers(any(), any()))
          .thenAnswer((_) async {});

      // Act
      final result = await useCase.execute(testVisit);

      // Assert
      expect(result, equals(createdVisitId));
      
      // Vérifier que les méthodes du repository ont été appelées avec les bons arguments
      verify(() => mockRepository.createVisit(any())).called(1);
      
      // Vérifier que les données complémentaires ont été sauvegardées
      verify(() => mockRepository.saveVisitComplementData(
        createdVisitId, 
        any()
      )).called(1);
      
      // Vérifier que les observateurs ont été sauvegardés
      verify(() => mockRepository.saveVisitObservers(
        createdVisitId, 
        any()
      )).called(1);
    });

    test('should not save complement data if visit data is empty', () async {
      // Arrange
      final visitWithoutData = BaseVisit(
        idBaseVisit: 0,
        idBaseSite: 1,
        idDataset: 1,
        idModule: 2,
        visitDateMin: '2023-01-01',
        observers: [1, 2],
        data: {}, // Données vides
      );
      
      when(() => mockRepository.createVisit(any()))
          .thenAnswer((_) async => createdVisitId);
      
      when(() => mockRepository.saveVisitObservers(any(), any()))
          .thenAnswer((_) async {});

      // Act
      final result = await useCase.execute(visitWithoutData);

      // Assert
      expect(result, equals(createdVisitId));
      verify(() => mockRepository.createVisit(any())).called(1);
      
      // Vérifier que les données complémentaires n'ont PAS été sauvegardées
      verifyNever(() => mockRepository.saveVisitComplementData(any(), any()));
      
      // Vérifier que les observateurs ont été sauvegardés
      verify(() => mockRepository.saveVisitObservers(
        createdVisitId, 
        any()
      )).called(1);
    });

    test('should not save observers if observers list is empty', () async {
      // Arrange
      final visitWithoutObservers = BaseVisit(
        idBaseVisit: 0,
        idBaseSite: 1,
        idDataset: 1,
        idModule: 2,
        visitDateMin: '2023-01-01',
        observers: [], // Liste vide
        data: {'field1': 'value1'},
      );
      
      when(() => mockRepository.createVisit(any()))
          .thenAnswer((_) async => createdVisitId);
      
      when(() => mockRepository.saveVisitComplementData(any(), any()))
          .thenAnswer((_) async {});

      // Act
      final result = await useCase.execute(visitWithoutObservers);

      // Assert
      expect(result, equals(createdVisitId));
      verify(() => mockRepository.createVisit(any())).called(1);
      
      // Vérifier que les données complémentaires ont été sauvegardées
      verify(() => mockRepository.saveVisitComplementData(
        createdVisitId, 
        any()
      )).called(1);
      
      // Vérifier que les observateurs n'ont PAS été sauvegardés
      verifyNever(() => mockRepository.saveVisitObservers(any(), any()));
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      when(() => mockRepository.createVisit(any()))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => useCase.execute(testVisit),
        throwsA(isA<Exception>()),
      );
    });
  });
}
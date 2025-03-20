import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/observations_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/observation_entity.dart';
import 'package:gn_mobile_monitoring/data/repository/observations_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<ObservationsDatabase>()])
import 'observations_repository_test.mocks.dart';

void main() {
  late MockObservationsDatabase mockObservationsDatabase;
  late ObservationsRepositoryImpl repository;

  setUp(() {
    mockObservationsDatabase = MockObservationsDatabase();
    repository = ObservationsRepositoryImpl(mockObservationsDatabase);
  });

  group('ObservationsRepository Tests', () {
    // Données de test
    final testObservationEntity = ObservationEntity(
      idObservation: 1,
      idBaseVisit: 10,
      cdNom: 123,
      comments: 'Test observation',
      uuidObservation: 'test-uuid',
      metaCreateDate: '2024-03-20',
      metaUpdateDate: '2024-03-20',
      data: {'key1': 'value1', 'key2': 42},
    );
    
    final expectedObservation = Observation(
      idObservation: 1,
      idBaseVisit: 10,
      cdNom: 123,
      comments: 'Test observation',
      uuidObservation: 'test-uuid',
      metaCreateDate: '2024-03-20',
      metaUpdateDate: '2024-03-20',
      data: {'key1': 'value1', 'key2': 42},
    );

    test('getObservationsByVisitId should return list of observations', () async {
      // Arrange
      when(mockObservationsDatabase.getObservationsByVisitId(10))
          .thenAnswer((_) async => [testObservationEntity]);

      // Act
      final result = await repository.getObservationsByVisitId(10);

      // Assert
      expect(result.length, 1);
      expect(result.first.idObservation, expectedObservation.idObservation);
      expect(result.first.idBaseVisit, expectedObservation.idBaseVisit);
      expect(result.first.comments, expectedObservation.comments);
      expect(result.first.data, expectedObservation.data);
      verify(mockObservationsDatabase.getObservationsByVisitId(10)).called(1);
    });

    test('getObservationById should return an observation', () async {
      // Arrange
      when(mockObservationsDatabase.getObservationById(1))
          .thenAnswer((_) async => testObservationEntity);

      // Act
      final result = await repository.getObservationById(1);

      // Assert
      expect(result, isNotNull);
      expect(result!.idObservation, expectedObservation.idObservation);
      expect(result.comments, expectedObservation.comments);
      verify(mockObservationsDatabase.getObservationById(1)).called(1);
    });
    
    test('getObservationById should return null when not found', () async {
      // Arrange
      when(mockObservationsDatabase.getObservationById(999))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getObservationById(999);

      // Assert
      expect(result, isNull);
      verify(mockObservationsDatabase.getObservationById(999)).called(1);
    });

    test('createObservation should return observation id', () async {
      // Arrange
      when(mockObservationsDatabase.saveObservation(any))
          .thenAnswer((_) async => 1);

      // Act
      final result = await repository.createObservation(expectedObservation);

      // Assert
      expect(result, 1);
      verify(mockObservationsDatabase.saveObservation(any)).called(1);
    });

    test('updateObservation should return true on success', () async {
      // Arrange
      when(mockObservationsDatabase.saveObservation(any))
          .thenAnswer((_) async => 1);

      // Act
      final result = await repository.updateObservation(expectedObservation);

      // Assert
      expect(result, true);
      verify(mockObservationsDatabase.saveObservation(any)).called(1);
    });
    
    test('updateObservation should return false on failure', () async {
      // Arrange
      when(mockObservationsDatabase.saveObservation(any))
          .thenAnswer((_) async => 0);

      // Act
      final result = await repository.updateObservation(expectedObservation);

      // Assert
      expect(result, false);
      verify(mockObservationsDatabase.saveObservation(any)).called(1);
    });

    test('deleteObservation should return success status', () async {
      // Arrange
      when(mockObservationsDatabase.deleteObservation(1))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.deleteObservation(1);

      // Assert
      expect(result, true);
      verify(mockObservationsDatabase.deleteObservation(1)).called(1);
    });
    
    test('deleteObservation should return false on failure', () async {
      // Arrange
      when(mockObservationsDatabase.deleteObservation(1))
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.deleteObservation(1);

      // Assert
      expect(result, false);
      verify(mockObservationsDatabase.deleteObservation(1)).called(1);
    });
    
    test('repository should correctly map domain model to entity', () async {
      // Arrange
      when(mockObservationsDatabase.saveObservation(any))
          .thenAnswer((_) async => 1);
      
      final domainObservation = Observation(
        idObservation: 0, // New observation
        idBaseVisit: 10,
        cdNom: 456,
        comments: 'New observation',
        data: {'test': 'value'},
      );

      // Act
      await repository.createObservation(domainObservation);

      // Assert - Verify the entity mapping
      final captured = verify(mockObservationsDatabase.saveObservation(captureAny)).captured;
      final capturedEntity = captured.first as ObservationEntity;
      
      expect(capturedEntity.idObservation, 0);
      expect(capturedEntity.idBaseVisit, 10);
      expect(capturedEntity.cdNom, 456);
      expect(capturedEntity.comments, 'New observation');
      expect(capturedEntity.data, {'test': 'value'});
    });
  });
}
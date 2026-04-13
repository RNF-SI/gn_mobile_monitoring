import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/observations_database.dart';
import 'package:gn_mobile_monitoring/data/entity/observation_entity.dart';
import 'package:gn_mobile_monitoring/data/repository/observations_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:mocktail/mocktail.dart';

class MockObservationsDatabase extends Mock implements ObservationsDatabase {}

void main() {
  late ObservationsRepositoryImpl repository;
  late MockObservationsDatabase mockDatabase;

  setUpAll(() {
    registerFallbackValue(ObservationEntity(
      idObservation: 0,
      idBaseVisit: 1,
      cdNom: 123,
      comments: 'test',
      uuidObservation: 'uuid-test',
      data: {},
    ));
  });

  setUp(() {
    mockDatabase = MockObservationsDatabase();
    repository = ObservationsRepositoryImpl(mockDatabase);
  });

  group('updateObservation', () {
    test('should return true when update succeeds', () async {
      // Arrange
      final observation = Observation(
        idObservation: 123,
        idBaseVisit: 1,
        cdNom: 456,
        comments: 'Updated comment',
        uuidObservation: 'uuid-123',
        data: {'key': 'value'},
      );

      when(() => mockDatabase.updateObservation(any()))
          .thenAnswer((_) async => true); // Retourner true pour succès

      // Act
      final result = await repository.updateObservation(observation);

      // Assert
      expect(result, true);
      verify(() => mockDatabase.updateObservation(any())).called(1);
    });

    test('should return false when update returns false', () async {
      // Arrange
      final observation = Observation(
        idObservation: 123,
        idBaseVisit: 1,
        cdNom: 456,
        comments: 'Updated comment',
        uuidObservation: 'uuid-123',
        data: {'key': 'value'},
      );

      when(() => mockDatabase.updateObservation(any()))
          .thenAnswer((_) async => false); // Retourner false

      // Act
      final result = await repository.updateObservation(observation);

      // Assert
      expect(result, false);
      verify(() => mockDatabase.updateObservation(any())).called(1);
    });

    test('should return false when update throws exception', () async {
      // Arrange
      final observation = Observation(
        idObservation: 123,
        idBaseVisit: 1,
        cdNom: 456,
        comments: 'Updated comment',
        uuidObservation: 'uuid-123',
        data: {'key': 'value'},
      );

      when(() => mockDatabase.updateObservation(any()))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await repository.updateObservation(observation);

      // Assert
      expect(result, false);
      verify(() => mockDatabase.updateObservation(any())).called(1);
    });
  });

  group('createObservation', () {
    test('should return new ID when create succeeds', () async {
      // Arrange
      final observation = Observation(
        idObservation: 0,
        idBaseVisit: 1,
        cdNom: 456,
        comments: 'New observation',
        uuidObservation: 'uuid-new',
        data: {'key': 'value'},
      );

      when(() => mockDatabase.createObservation(any()))
          .thenAnswer((_) async => 123); // Retourner le nouvel ID

      // Act
      final result = await repository.createObservation(observation);

      // Assert
      expect(result, 123);
      verify(() => mockDatabase.createObservation(any())).called(1);
    });
  });
}
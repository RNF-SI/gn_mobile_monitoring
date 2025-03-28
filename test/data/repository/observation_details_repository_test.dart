import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/observation_details_database.dart';
import 'package:gn_mobile_monitoring/data/entity/observation_detail_entity.dart';
import 'package:gn_mobile_monitoring/data/repository/observation_details_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/domain/repository/observation_details_repository.dart';

// Mock des dépendances
class MockObservationDetailsDatabase extends Mock implements ObservationDetailsDatabase {}

// Fake pour le fallback value
class FakeObservationDetailEntity extends Fake implements ObservationDetailEntity {}

void main() {
  late ObservationDetailsRepository repository;
  late MockObservationDetailsDatabase mockDatabase;

  setUpAll(() {
    // Enregistrer le fallback value pour ObservationDetailEntity
    registerFallbackValue(FakeObservationDetailEntity());
  });

  setUp(() {
    mockDatabase = MockObservationDetailsDatabase();
    repository = ObservationDetailsRepositoryImpl(mockDatabase);
  });

  group('ObservationDetailsRepository', () {
    const int observationId = 1;
    const int detailId = 2;
    
    final testData = {'key': 'value', 'number': 42};
    final jsonData = jsonEncode(testData);
    
    final detailEntity = ObservationDetailEntity(
      idObservationDetail: detailId,
      idObservation: observationId,
      uuidObservationDetail: 'test-uuid',
      data: jsonData,
    );
    
    final detailModel = ObservationDetail(
      idObservationDetail: detailId,
      idObservation: observationId,
      uuidObservationDetail: 'test-uuid',
      data: testData,
    );

    test('getObservationDetailsByObservationId should return list of ObservationDetail when successful', () async {
      // Arrange
      when(() => mockDatabase.getObservationDetailsByObservationId(observationId))
          .thenAnswer((_) async => [detailEntity]);

      // Act
      final result = await repository.getObservationDetailsByObservationId(observationId);

      // Assert
      expect(result.length, 1);
      expect(result.first.idObservationDetail, detailId);
      expect(result.first.idObservation, observationId);
      expect(result.first.uuidObservationDetail, 'test-uuid');
      expect(result.first.data, testData);
      verify(() => mockDatabase.getObservationDetailsByObservationId(observationId)).called(1);
    });

    test('getObservationDetailsByObservationId should return empty list when no details found', () async {
      // Arrange
      when(() => mockDatabase.getObservationDetailsByObservationId(observationId))
          .thenAnswer((_) async => []);

      // Act
      final result = await repository.getObservationDetailsByObservationId(observationId);

      // Assert
      expect(result, isEmpty);
      verify(() => mockDatabase.getObservationDetailsByObservationId(observationId)).called(1);
    });

    test('getObservationDetailById should return ObservationDetail when found', () async {
      // Arrange
      when(() => mockDatabase.getObservationDetailById(detailId))
          .thenAnswer((_) async => detailEntity);

      // Act
      final result = await repository.getObservationDetailById(detailId);

      // Assert
      expect(result, isNotNull);
      expect(result!.idObservationDetail, detailId);
      expect(result.idObservation, observationId);
      expect(result.uuidObservationDetail, 'test-uuid');
      expect(result.data, testData);
      verify(() => mockDatabase.getObservationDetailById(detailId)).called(1);
    });

    test('getObservationDetailById should return null when detail not found', () async {
      // Arrange
      when(() => mockDatabase.getObservationDetailById(detailId))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getObservationDetailById(detailId);

      // Assert
      expect(result, isNull);
      verify(() => mockDatabase.getObservationDetailById(detailId)).called(1);
    });

    test('saveObservationDetail should return id when successful', () async {
      // Arrange
      const insertedId = 3;
      
      when(() => mockDatabase.saveObservationDetail(any()))
          .thenAnswer((_) async => insertedId);

      // Act
      final result = await repository.saveObservationDetail(detailModel);

      // Assert
      expect(result, insertedId);
      verify(() => mockDatabase.saveObservationDetail(any())).called(1);
    });

    test('deleteObservationDetail should return true when deletion successful', () async {
      // Arrange
      when(() => mockDatabase.deleteObservationDetail(detailId))
          .thenAnswer((_) async => 1);

      // Act
      final result = await repository.deleteObservationDetail(detailId);

      // Assert
      expect(result, true);
      verify(() => mockDatabase.deleteObservationDetail(detailId)).called(1);
    });

    test('deleteObservationDetail should return false when no rows deleted', () async {
      // Arrange
      when(() => mockDatabase.deleteObservationDetail(detailId))
          .thenAnswer((_) async => 0);

      // Act
      final result = await repository.deleteObservationDetail(detailId);

      // Assert
      expect(result, false);
      verify(() => mockDatabase.deleteObservationDetail(detailId)).called(1);
    });

    test('deleteObservationDetailsByObservationId should return true when deletion successful', () async {
      // Arrange
      when(() => mockDatabase.deleteObservationDetailsByObservationId(observationId))
          .thenAnswer((_) async => 2);

      // Act
      final result = await repository.deleteObservationDetailsByObservationId(observationId);

      // Assert
      expect(result, true);
      verify(() => mockDatabase.deleteObservationDetailsByObservationId(observationId)).called(1);
    });

    test('deleteObservationDetailsByObservationId should return false when no rows deleted', () async {
      // Arrange
      when(() => mockDatabase.deleteObservationDetailsByObservationId(observationId))
          .thenAnswer((_) async => 0);

      // Act
      final result = await repository.deleteObservationDetailsByObservationId(observationId);

      // Assert
      expect(result, false);
      verify(() => mockDatabase.deleteObservationDetailsByObservationId(observationId)).called(1);
    });
  });
}
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/domain/repository/observation_details_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observation_details_by_observation_id_use_case.dart';

// Mock des dépendances
class MockObservationDetailsRepository extends Mock implements ObservationDetailsRepository {}

void main() {
  late GetObservationDetailsByObservationIdUseCase useCase;
  late MockObservationDetailsRepository mockRepository;

  setUp(() {
    mockRepository = MockObservationDetailsRepository();
    useCase = GetObservationDetailsByObservationIdUseCaseImpl(mockRepository);
  });

  group('GetObservationDetailsByObservationIdUseCase', () {
    const int observationId = 1;
    
    test('should return list of ObservationDetail when repository returns values', () async {
      // Arrange
      final details = [
        ObservationDetail(
          idObservationDetail: 1,
          idObservation: observationId,
          uuidObservationDetail: 'test-uuid-1',
          data: {'key': 'value1', 'number': 42},
        ),
        ObservationDetail(
          idObservationDetail: 2,
          idObservation: observationId,
          uuidObservationDetail: 'test-uuid-2',
          data: {'key': 'value2', 'number': 43},
        ),
      ];

      when(() => mockRepository.getObservationDetailsByObservationId(observationId))
          .thenAnswer((_) async => details);

      // Act
      final result = await useCase.execute(observationId);

      // Assert
      expect(result, equals(details));
      expect(result.length, 2);
      verify(() => mockRepository.getObservationDetailsByObservationId(observationId)).called(1);
    });

    test('should return empty list when repository returns empty list', () async {
      // Arrange
      when(() => mockRepository.getObservationDetailsByObservationId(observationId))
          .thenAnswer((_) async => []);

      // Act
      final result = await useCase.execute(observationId);

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getObservationDetailsByObservationId(observationId)).called(1);
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      final exception = Exception('Database error');
      when(() => mockRepository.getObservationDetailsByObservationId(observationId))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => useCase.execute(observationId),
        throwsA(equals(exception)),
      );
      verify(() => mockRepository.getObservationDetailsByObservationId(observationId)).called(1);
    });
  });
}
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/repository/observations_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observation_by_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observation_by_id_use_case_impl.dart';

// Mock des dépendances
class MockObservationsRepository extends Mock implements ObservationsRepository {}

void main() {
  late GetObservationByIdUseCase useCase;
  late MockObservationsRepository mockRepository;

  setUp(() {
    mockRepository = MockObservationsRepository();
    useCase = GetObservationByIdUseCaseImpl(mockRepository);
  });

  group('GetObservationByIdUseCase', () {
    const int observationId = 1;
    
    test('should return Observation when repository returns a value', () async {
      // Arrange
      final observation = Observation(
        idObservation: observationId,
        idBaseVisit: 2,
        cdNom: 123,
        comments: 'Test observation',
        data: {'key': 'value', 'number': 42},
      );

      when(() => mockRepository.getObservationById(observationId))
          .thenAnswer((_) async => observation);

      // Act
      final result = await useCase.execute(observationId);

      // Assert
      expect(result, equals(observation));
      verify(() => mockRepository.getObservationById(observationId)).called(1);
    });

    test('should return null when repository returns null', () async {
      // Arrange
      when(() => mockRepository.getObservationById(observationId))
          .thenAnswer((_) async => null);

      // Act
      final result = await useCase.execute(observationId);

      // Assert
      expect(result, isNull);
      verify(() => mockRepository.getObservationById(observationId)).called(1);
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      final exception = Exception('Database error');
      when(() => mockRepository.getObservationById(observationId))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => useCase.execute(observationId),
        throwsA(equals(exception)),
      );
      verify(() => mockRepository.getObservationById(observationId)).called(1);
    });
  });
}
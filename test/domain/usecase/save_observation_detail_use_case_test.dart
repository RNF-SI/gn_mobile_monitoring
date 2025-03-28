import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/domain/repository/observation_details_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/save_observation_detail_use_case.dart';

// Mock des dépendances
class MockObservationDetailsRepository extends Mock implements ObservationDetailsRepository {}

void main() {
  late SaveObservationDetailUseCase useCase;
  late MockObservationDetailsRepository mockRepository;

  setUp(() {
    mockRepository = MockObservationDetailsRepository();
    useCase = SaveObservationDetailUseCaseImpl(mockRepository);
  });

  group('SaveObservationDetailUseCase', () {
    test('should save observation detail and return id when repository succeeds', () async {
      // Arrange
      const int observationId = 1;
      const int detailId = 2;
      const int insertedId = 3;
      
      final detail = ObservationDetail(
        idObservationDetail: detailId,
        idObservation: observationId,
        uuidObservationDetail: 'test-uuid',
        data: {'key': 'value', 'number': 42},
      );

      when(() => mockRepository.saveObservationDetail(detail))
          .thenAnswer((_) async => insertedId);

      // Act
      final result = await useCase.execute(detail);

      // Assert
      expect(result, equals(insertedId));
      verify(() => mockRepository.saveObservationDetail(detail)).called(1);
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      const int observationId = 1;
      const int detailId = 2;
      
      final detail = ObservationDetail(
        idObservationDetail: detailId,
        idObservation: observationId,
        uuidObservationDetail: 'test-uuid',
        data: {'key': 'value', 'number': 42},
      );

      final exception = Exception('Database error');
      when(() => mockRepository.saveObservationDetail(detail))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => useCase.execute(detail),
        throwsA(equals(exception)),
      );
      verify(() => mockRepository.saveObservationDetail(detail)).called(1);
    });
  });
}
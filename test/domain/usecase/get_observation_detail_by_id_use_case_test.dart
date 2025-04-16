import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/domain/repository/observation_details_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observation_detail_by_id_use_case.dart';

// Mock des dépendances
class MockObservationDetailsRepository extends Mock implements ObservationDetailsRepository {}

void main() {
  late GetObservationDetailByIdUseCase useCase;
  late MockObservationDetailsRepository mockRepository;

  setUp(() {
    mockRepository = MockObservationDetailsRepository();
    useCase = GetObservationDetailByIdUseCaseImpl(mockRepository);
  });

  group('GetObservationDetailByIdUseCase', () {
    const int detailId = 1;
    
    test('should return ObservationDetail when repository returns a value', () async {
      // Arrange
      final detail = ObservationDetail(
        idObservationDetail: detailId,
        idObservation: 2,
        uuidObservationDetail: 'test-uuid',
        data: {'key': 'value', 'number': 42},
      );

      when(() => mockRepository.getObservationDetailById(detailId))
          .thenAnswer((_) async => detail);

      // Act
      final result = await useCase.execute(detailId);

      // Assert
      expect(result, equals(detail));
      verify(() => mockRepository.getObservationDetailById(detailId)).called(1);
    });

    test('should return null when repository returns null', () async {
      // Arrange
      when(() => mockRepository.getObservationDetailById(detailId))
          .thenAnswer((_) async => null);

      // Act
      final result = await useCase.execute(detailId);

      // Assert
      expect(result, isNull);
      verify(() => mockRepository.getObservationDetailById(detailId)).called(1);
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      final exception = Exception('Database error');
      when(() => mockRepository.getObservationDetailById(detailId))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => useCase.execute(detailId),
        throwsA(equals(exception)),
      );
      verify(() => mockRepository.getObservationDetailById(detailId)).called(1);
    });
  });
}
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/repository/global_database_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_local_monitoring_database_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_local_monitoring_database_usecase_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockGlobalDatabaseRepository extends Mock implements GlobalDatabaseRepository {}

void main() {
  late MockGlobalDatabaseRepository mockRepository;
  late DeleteLocalMonitoringDatabaseUseCase useCase;

  setUp(() {
    mockRepository = MockGlobalDatabaseRepository();
    useCase = DeleteLocalMonitoringDatabaseUseCaseImpl(mockRepository);
  });

  group('DeleteLocalMonitoringDatabaseUseCase', () {
    test('should delete the database through the repository', () async {
      // Arrange
      when(() => mockRepository.deleteDatabase()).thenAnswer((_) async {});

      // Act
      await useCase.execute();

      // Assert
      verify(() => mockRepository.deleteDatabase()).called(1);
    });

    test('should throw an exception when repository throws an exception', () async {
      // Arrange
      when(() => mockRepository.deleteDatabase())
          .thenThrow(Exception('Test error'));

      // Act & Assert
      expect(
        () => useCase.execute(),
        throwsA(isA<Exception>()),
      );
      verify(() => mockRepository.deleteDatabase()).called(1);
    });
  });
}
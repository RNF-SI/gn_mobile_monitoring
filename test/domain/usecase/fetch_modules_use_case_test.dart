import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_modules_usecase_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late FetchModulesUseCase useCase;
  late MockModulesRepository mockModulesRepository;

  setUp(() {
    mockModulesRepository = MockModulesRepository();
    useCase = FetchModulesUseCaseImpl(mockModulesRepository);
  });

  group('FetchModulesUseCase', () {
    test('should call repository fetchAndSyncModulesFromApi with provided token', () async {
      // Arrange
      final token = 'test_token';
      when(() => mockModulesRepository.fetchAndSyncModulesFromApi(any()))
          .thenAnswer((_) async => {});

      // Act
      await useCase.execute(token);

      // Assert
      verify(() => mockModulesRepository.fetchAndSyncModulesFromApi(token)).called(1);
    });

    test('should rethrow exception when repository throws an error', () async {
      // Arrange
      final token = 'test_token';
      final exception = Exception('Failed to sync modules');
      when(() => mockModulesRepository.fetchAndSyncModulesFromApi(any()))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => useCase.execute(token),
        throwsA(equals(exception)),
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_module_data_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_module_data_usecase_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late DownloadModuleDataUseCase useCase;
  late MockModulesRepository mockModulesRepository;

  setUp(() {
    mockModulesRepository = MockModulesRepository();
    useCase = DownloadModuleDataUseCaseImpl(mockModulesRepository);
  });

  group('DownloadModuleDataUseCase', () {
    test('should call repository downloadModuleData with provided moduleId', () async {
      // Arrange
      final moduleId = 1;
      double progress = 0.0;
      void onProgressUpdate(double value) => progress = value;
      
      when(() => mockModulesRepository.downloadModuleData(any()))
          .thenAnswer((_) async => {});

      // Act
      await useCase.execute(moduleId, onProgressUpdate);

      // Assert
      verify(() => mockModulesRepository.downloadModuleData(moduleId)).called(1);
    });

    test('should rethrow exception when repository throws an error', () async {
      // Arrange
      final moduleId = 1;
      double progress = 0.0;
      void onProgressUpdate(double value) => progress = value;
      
      final exception = Exception('Failed to download module data');
      when(() => mockModulesRepository.downloadModuleData(any()))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => useCase.execute(moduleId, onProgressUpdate),
        throwsA(equals(exception)),
      );
    });
  });
}

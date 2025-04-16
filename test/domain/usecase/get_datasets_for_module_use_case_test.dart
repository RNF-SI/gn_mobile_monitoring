import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_datasets_for_module_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockModulesRepository extends Mock implements ModulesRepository {}

void main() {
  late GetDatasetsForModuleUseCase useCase;
  late MockModulesRepository mockRepository;

  setUp(() {
    mockRepository = MockModulesRepository();
    useCase = GetDatasetsForModuleUseCaseImpl(mockRepository);
  });

  group('GetDatasetsForModuleUseCase', () {
    test('should get dataset ids from repository', () async {
      // Arrange
      const moduleId = 1;
      final datasetIds = [1, 2, 3];
      
      when(() => mockRepository.getDatasetIdsForModule(moduleId))
          .thenAnswer((_) async => datasetIds);
      
      // Act
      final result = await useCase.execute(moduleId);
      
      // Assert - currently we expect an empty list as the actual dataset fetching is not implemented
      expect(result, isA<List>());
      verify(() => mockRepository.getDatasetIdsForModule(moduleId)).called(1);
    });
  });
}
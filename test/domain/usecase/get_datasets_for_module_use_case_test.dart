import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/dataset.dart';
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
    test('should get datasets for module from repository', () async {
      // Arrange
      const moduleId = 1;
      final datasetIds = [1, 2, 3];
      final datasets = [
        Dataset(
          id: 1,
          uniqueDatasetId: 'uuid1',
          idAcquisitionFramework: 1,
          datasetName: 'Dataset 1',
          datasetShortname: 'DS1',
          datasetDesc: 'Description 1',
          idNomenclatureDataType: 1,
          keywords: 'keywords',
          marineDomain: false,
          terrestrialDomain: true,
          idNomenclatureDatasetObjectif: 1,
          idNomenclatureCollectingMethod: 1,
          idNomenclatureDataOrigin: 1,
          idNomenclatureSourceStatus: 1,
          idNomenclatureResourceType: 1,
        ),
        Dataset(
          id: 2,
          uniqueDatasetId: 'uuid2',
          idAcquisitionFramework: 2,
          datasetName: 'Dataset 2',
          datasetShortname: 'DS2',
          datasetDesc: 'Description 2',
          idNomenclatureDataType: 2,
          keywords: 'keywords',
          marineDomain: true,
          terrestrialDomain: false,
          idNomenclatureDatasetObjectif: 2,
          idNomenclatureCollectingMethod: 2,
          idNomenclatureDataOrigin: 2,
          idNomenclatureSourceStatus: 2,
          idNomenclatureResourceType: 2,
        ),
        Dataset(
          id: 3,
          uniqueDatasetId: 'uuid3',
          idAcquisitionFramework: 3,
          datasetName: 'Dataset 3',
          datasetShortname: 'DS3',
          datasetDesc: 'Description 3',
          idNomenclatureDataType: 3,
          keywords: 'keywords',
          marineDomain: true,
          terrestrialDomain: true,
          idNomenclatureDatasetObjectif: 3,
          idNomenclatureCollectingMethod: 3,
          idNomenclatureDataOrigin: 3,
          idNomenclatureSourceStatus: 3,
          idNomenclatureResourceType: 3,
        ),
      ];
      
      when(() => mockRepository.getDatasetIdsForModule(moduleId))
          .thenAnswer((_) async => datasetIds);
      
      when(() => mockRepository.getDatasetsByIds(datasetIds))
          .thenAnswer((_) async => datasets);
      
      // Act
      final result = await useCase.execute(moduleId);
      
      // Assert
      expect(result, equals(datasets));
      verify(() => mockRepository.getDatasetIdsForModule(moduleId)).called(1);
      verify(() => mockRepository.getDatasetsByIds(datasetIds)).called(1);
    });
    
    test('should return empty list when no datasets for module', () async {
      // Arrange
      const moduleId = 1;
      final emptyIds = <int>[];
      final emptyDatasets = <Dataset>[];
      
      when(() => mockRepository.getDatasetIdsForModule(moduleId))
          .thenAnswer((_) async => emptyIds);
      
      when(() => mockRepository.getDatasetsByIds(emptyIds))
          .thenAnswer((_) async => emptyDatasets);
      
      // Act
      final result = await useCase.execute(moduleId);
      
      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getDatasetIdsForModule(moduleId)).called(1);
      verify(() => mockRepository.getDatasetsByIds(emptyIds)).called(1);
    });
  });
}
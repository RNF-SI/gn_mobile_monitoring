import 'package:gn_mobile_monitoring/domain/model/dataset.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';

abstract class GetDatasetsForModuleUseCase {
  Future<List<Dataset>> execute(int moduleId);
}

class GetDatasetsForModuleUseCaseImpl implements GetDatasetsForModuleUseCase {
  final ModulesRepository _modulesRepository;

  GetDatasetsForModuleUseCaseImpl(this._modulesRepository);

  @override
  Future<List<Dataset>> execute(int moduleId) async {
    // Get dataset IDs for the module
    final datasetIds = await _modulesRepository.getDatasetIdsForModule(moduleId);
    
    // For now, we'll return empty list
    // In a future implementation, we should load the actual dataset objects
    return [];
  }
}
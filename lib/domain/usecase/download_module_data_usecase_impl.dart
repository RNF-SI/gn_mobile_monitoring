import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_module_data_usecase.dart';

class DownloadModuleDataUseCaseImpl implements DownloadModuleDataUseCase {
  final ModulesRepository _modulesRepository;

  DownloadModuleDataUseCaseImpl(this._modulesRepository);

  @override
  Future<void> execute(
    int moduleId,
    Function(double) onProgressUpdate,
  ) async {
    await _modulesRepository.downloadModuleData(moduleId);
  }
}

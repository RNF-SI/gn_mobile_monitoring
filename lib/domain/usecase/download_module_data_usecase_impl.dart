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
    try {
      // Mise à jour initiale de la progression
      onProgressUpdate(0.1);
      
      // Téléchargement des données du module (nomenclatures, datasets, etc.)
      await _modulesRepository.downloadModuleData(moduleId);
      
      // Mise à jour finale de la progression
      onProgressUpdate(1.0);
    } catch (e) {
      // En cas d'erreur, mettre à jour la progression à 0
      onProgressUpdate(0.0);
      rethrow;
    }
  }
}

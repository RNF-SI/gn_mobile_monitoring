import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_complete_module_usecase.dart';

/// Implémentation du use case pour télécharger un module complet depuis le serveur.
class DownloadCompleteModuleUseCaseImpl implements DownloadCompleteModuleUseCase {
  final ModulesRepository _modulesRepository;

  DownloadCompleteModuleUseCaseImpl(this._modulesRepository);

  @override
  Future<void> execute(
    int moduleId,
    String token,
    Function(double) onProgressUpdate,
  ) async {
    try {
      // Mise à jour initiale de la progression (10%)
      onProgressUpdate(0.1);
      
      // Téléchargement de toutes les données du module
      // Incluant : configuration, nomenclatures, datasets, sites et groupes de sites
      await _modulesRepository.downloadCompleteModule(moduleId, token);
      
      // Mise à jour finale de la progression (100%)
      onProgressUpdate(1.0);
    } catch (e) {
      // En cas d'erreur, réinitialiser la progression à 0
      onProgressUpdate(0.0);
      rethrow;
    }
  }
}

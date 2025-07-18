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
    Function(double) onProgressUpdate, [
    Function(String)? onStepUpdate,
  ]) async {
    try {
      // Début du téléchargement
      onStepUpdate?.call('Préparation...');
      onProgressUpdate(0.05);
      
      // Téléchargement de toutes les données du module
      // Incluant : configuration, nomenclatures, datasets, sites et groupes de sites
      await _modulesRepository.downloadCompleteModule(
        moduleId, 
        token,
        onProgressUpdate: onProgressUpdate,
        onStepUpdate: onStepUpdate,
      );
      
      // Finalisation (100%)
      onStepUpdate?.call('Terminé!');
      onProgressUpdate(1.0);
    } catch (e) {
      // En cas d'erreur, réinitialiser la progression à 0
      onStepUpdate?.call('Erreur');
      onProgressUpdate(0.0);
      rethrow;
    }
  }
}

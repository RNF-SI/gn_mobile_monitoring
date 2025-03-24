import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_module_with_config_usecase.dart';

class GetModuleWithConfigUseCaseImpl implements GetModuleWithConfigUseCase {
  final ModulesRepository _modulesRepository;

  GetModuleWithConfigUseCaseImpl(this._modulesRepository);

  @override
  Future<Module> execute(int moduleId) async {
    // Attendre un peu avant la première tentative pour laisser le temps à la configuration de se charger
    await Future.delayed(const Duration(milliseconds: 500));

    // Récupérer le module
    final module = await _modulesRepository.getModuleWithConfig(moduleId);

    // Si le module n'a pas de complément ou si la configuration est déjà disponible, retourner le module tel quel
    if (module.complement == null || module.complement!.configuration != null) {
      return module;
    }

    // Si la configuration n'est pas disponible, essayer une seule fois de la télécharger
    try {
      await _modulesRepository.downloadModuleData(moduleId);
      final updatedModule =
          await _modulesRepository.getModuleWithConfig(moduleId);
      return updatedModule;
    } catch (e) {
      // En cas d'erreur, retourner le module sans configuration
      return module;
    }
  }
}

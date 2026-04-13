import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_complete_module_usecase.dart';

/// Implémentation du use case pour récupérer un module complet depuis la base locale.
class GetCompleteModuleUseCaseImpl implements GetCompleteModuleUseCase {
  final ModulesRepository _modulesRepository;

  GetCompleteModuleUseCaseImpl(this._modulesRepository);

  @override
  Future<Module> execute(int moduleId) async {
    // Récupère le module complet depuis la base de données locale
    // Cela inclut : module de base + configuration + sites + groupes de sites
    return await _modulesRepository.getCompleteModule(moduleId);
  }
}

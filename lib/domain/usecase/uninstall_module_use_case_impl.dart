import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/uninstall_module_use_case.dart';

class UninstallModuleUseCaseImpl implements UninstallModuleUseCase {
  final ModulesRepository _modulesRepository;

  UninstallModuleUseCaseImpl(this._modulesRepository);

  @override
  Future<void> execute(int moduleId) {
    return _modulesRepository.uninstallModule(moduleId);
  }
}

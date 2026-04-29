import 'package:gn_mobile_monitoring/domain/model/module_uninstall_stats.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_module_uninstall_stats_use_case.dart';

class GetModuleUninstallStatsUseCaseImpl
    implements GetModuleUninstallStatsUseCase {
  final ModulesRepository _modulesRepository;

  GetModuleUninstallStatsUseCaseImpl(this._modulesRepository);

  @override
  Future<ModuleUninstallStats> execute(int moduleId) {
    return _modulesRepository.getUninstallStats(moduleId);
  }
}

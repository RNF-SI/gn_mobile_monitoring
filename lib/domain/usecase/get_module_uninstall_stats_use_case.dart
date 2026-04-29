import 'package:gn_mobile_monitoring/domain/model/module_uninstall_stats.dart';

abstract class GetModuleUninstallStatsUseCase {
  /// Retourne les stats à afficher dans la modale de confirmation de
  /// désinstallation : nombre de visites/observations, sites exclusifs,
  /// saisies non téléversées (données qui seront définitivement perdues).
  Future<ModuleUninstallStats> execute(int moduleId);
}

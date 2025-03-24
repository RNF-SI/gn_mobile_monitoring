import 'package:gn_mobile_monitoring/domain/model/module.dart';

abstract class GetModuleWithConfigUseCase {
  /// Récupère un module avec sa configuration complète.
  /// Retourne un Future qui complète seulement lorsque la configuration est disponible.
  Future<Module> execute(int moduleId);
}

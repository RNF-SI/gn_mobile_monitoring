import 'package:gn_mobile_monitoring/domain/model/mobile_app_version.dart';

/// Vérifie si une mise à jour de l'application est disponible sur le serveur.
abstract class CheckAppUpdateUseCase {
  /// Retourne un [MobileAppVersion] si une mise à jour est disponible, null sinon.
  Future<MobileAppVersion?> execute(String token);
}

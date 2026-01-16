import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';

/// Use case pour synchroniser les sites locaux vers le serveur
abstract class SyncSitesToServerUseCase {
  /// Synchronise les sites créés localement vers le serveur pour un module donné
  ///
  /// [token] Jeton d'authentification
  /// [moduleCode] Code du module pour lequel synchroniser les sites
  ///
  /// Retourne un [SyncResult] avec les statistiques de synchronisation
  Future<SyncResult> execute(String token, String moduleCode);
}

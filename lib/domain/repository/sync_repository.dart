import 'package:gn_mobile_monitoring/domain/repository/downstream_sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/upstream_sync_repository.dart';

/// Repository principal pour la synchronisation des données
/// Cette interface sert de façade et combine les fonctionnalités des repositories
/// de synchronisation ascendante et descendante
abstract class SyncRepository implements DownstreamSyncRepository, UpstreamSyncRepository {
  /// Vérifie la connectivité avec le serveur
  @override
  Future<bool> checkConnectivity();

  /// Récupère la date de dernière synchronisation
  @override
  Future<DateTime?> getLastSyncDate(String entityType);

  /// Met à jour la date de dernière synchronisation
  @override
  Future<void> updateLastSyncDate(String entityType, DateTime syncDate);
}

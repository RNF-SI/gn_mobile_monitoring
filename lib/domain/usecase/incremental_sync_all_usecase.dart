import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';

abstract class IncrementalSyncAllUseCase {
  /// Effectue une synchronisation complète de toutes les données
  /// 
  /// Paramètres:
  /// - token: Le token d'authentification
  /// - syncConfiguration: Indique si la configuration doit être synchronisée
  /// - syncNomenclatures: Indique si les nomenclatures doivent être synchronisées
  /// - syncTaxons: Indique si les taxons doivent être synchronisées
  /// - syncObservers: Indique si les observateurs doivent être synchronisés
  /// - syncModules: Indique si les modules doivent être synchronisés
  /// - syncSites: Indique si les sites doivent être synchronisés
  /// - syncSiteGroups: Indique si les groupes de sites doivent être synchronisés
  /// La synchronisation des observations sera implémentée dans une version future
  /// 
  /// Retourne un Map contenant les résultats de chaque opération de synchronisation
  Future<Map<String, SyncResult>> execute(
    String token, {
    bool syncConfiguration = true,
    bool syncNomenclatures = true,
    bool syncTaxons = true,
    bool syncObservers = true,
    bool syncModules = true,
    bool syncSites = true,
    bool syncSiteGroups = true,
  });
}
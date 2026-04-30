import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/site_visit_stats.dart';

abstract class VisitesDatabase {
  /// Get all visits
  Future<List<TBaseVisit>> getAllVisits();

  /// Get all visits for a specific site and module
  Future<List<TBaseVisit>> getVisitsBySiteIdAndModuleId(
      int siteId, int moduleId);

  /// Get a specific visit by ID
  Future<TBaseVisit> getVisitById(int id);

  /// Insert a new visit
  Future<int> insertVisit(TBaseVisitsCompanion visit);

  /// Update an existing visit
  Future<bool> updateVisit(TBaseVisitsCompanion visit);

  /// Delete a visit by ID
  Future<int> deleteVisit(int id);

  /// Get visit complement by visit ID
  Future<TVisitComplement?> getVisitComplementById(int visitId);

  /// Insert a new visit complement
  Future<int> insertVisitComplement(TVisitComplementsCompanion complement);

  /// Update an existing visit complement
  Future<bool> updateVisitComplement(TVisitComplementsCompanion complement);

  /// Delete a visit complement by visit ID
  Future<int> deleteVisitComplement(int visitId);

  /// Delete both visit and its complement in a single transaction
  Future<void> deleteVisitWithComplement(int visitId);

  /// Get observers for a visit
  Future<List<CorVisitObserverData>> getVisitObservers(int visitId);

  /// Insert a new visit observer
  Future<int> insertVisitObserver(CorVisitObserverCompanion observer);

  /// Delete all observers for a visit
  Future<int> deleteVisitObservers(int visitId);

  /// Replace all observers for a visit
  Future<void> replaceVisitObservers(
      int visitId, List<CorVisitObserverCompanion> observers);
      
  /// Get all visits for a specific site
  Future<List<TBaseVisit>> getVisitsBySite(int siteId);

  /// Met à jour l'ID serveur d'une visite pour le suivi de synchronisation
  Future<bool> updateVisitServerId(int localVisitId, int serverId);

  /// IDs des modules ayant au moins une visite locale non téléversée.
  /// Utilisé sur la home page pour afficher un badge sur les cards module.
  Future<Set<int>> getModuleIdsWithUnsyncedVisits();

  /// IDs des sites d'un module qui ont des visites non synchronisées
  /// (serverVisitId NULL). Utilisé pour l'indicateur visuel dans la liste
  /// des sites d'un module.
  Future<Set<int>> getSiteIdsWithUnsyncedVisitsForModule(int moduleId);

  /// IDs des groupes de sites d'un module dont au moins un site contient une
  /// visite non synchronisée. Utilisé pour propager le badge orange à la
  /// vue groupes (sans avoir à déplier chaque groupe).
  Future<Set<int>> getSiteGroupIdsWithUnsyncedVisitsForModule(int moduleId);

  /// Dernière visite et nombre total de visites par site pour un module
  /// donné, calculés depuis le cache local (inclut les saisies offline).
  /// Clé = idBaseSite.
  Future<Map<int, SiteVisitStats>> getVisitStatsForModule(int moduleId);

  /// Nombre d'observations rattachées à chaque visite d'un module donné.
  /// Utilisé pour la colonne `nb_observations` du tableau de visites et
  /// pour l'affichage au détail visite. Clé = idBaseVisit.
  Future<Map<int, int>> getObservationCountByVisitForModule(int moduleId);
}

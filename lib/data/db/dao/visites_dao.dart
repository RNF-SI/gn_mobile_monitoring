import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_visit_observer.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_base_visits.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_observations.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_sites_complements.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_visit_complements.dart';
import 'package:gn_mobile_monitoring/domain/model/site_visit_stats.dart';

part 'visites_dao.g.dart';

@DriftAccessor(tables: [
  TBaseVisits,
  TVisitComplements,
  CorVisitObserver,
  TSiteComplements,
  TObservations,
])
class VisitesDao extends DatabaseAccessor<AppDatabase> with _$VisitesDaoMixin {
  VisitesDao(super.db);

  Future<List<TBaseVisit>> getAllVisits() => select(tBaseVisits).get();

  Future<List<TBaseVisit>> getVisitsBySiteIdAndModuleId(
          int siteId, int moduleId) =>
      (select(tBaseVisits)
            ..where((t) =>
                t.idBaseSite.equals(siteId) & t.idModule.equals(moduleId)))
          .get();
          
  Future<List<TBaseVisit>> getVisitsBySite(int siteId) =>
      (select(tBaseVisits)..where((t) => t.idBaseSite.equals(siteId))).get();

  /// Statistiques de visites agrégées par site pour un module donné. Pour
  /// chaque site ayant au moins une visite enregistrée localement (uploadée
  /// ou pas), on retourne la date de la dernière visite et le nombre total.
  /// Source de la colonne "Dernier passage" et "Nb. passages" de l'onglet
  /// Sites, remplaçant les champs serveur last_visit / nb_visits qui ne
  /// tiennent pas compte des saisies offline pas encore téléversées.
  Future<Map<int, SiteVisitStats>> getVisitStatsForModule(int moduleId) async {
    // visitDateMin est stocké en TEXT au format ISO ("YYYY-MM-DD..."), ce qui
    // reste lexicographiquement ordonnable → MAX() texte = date max réelle.
    final query = customSelect(
      'SELECT id_base_site, COUNT(*) AS nb_visits, '
      'MAX(visit_date_min) AS last_visit '
      'FROM t_base_visits '
      'WHERE id_module = ? AND id_base_site IS NOT NULL '
      'GROUP BY id_base_site',
      variables: [Variable.withInt(moduleId)],
      readsFrom: {tBaseVisits},
    );
    final rows = await query.get();
    final Map<int, SiteVisitStats> result = {};
    for (final row in rows) {
      final siteId = row.read<int>('id_base_site');
      final nb = row.read<int>('nb_visits');
      final lastVisitStr = row.readNullable<String>('last_visit');
      result[siteId] = SiteVisitStats(
        lastVisit: lastVisitStr != null ? DateTime.tryParse(lastVisitStr) : null,
        nbVisits: nb,
      );
    }
    return result;
  }

  /// IDs des modules ayant au moins une visite locale non téléversée.
  /// Utilisé par la home page pour signaler les modules avec des saisies en
  /// attente de sync — équivalent global de
  /// `getSiteIdsWithUnsyncedVisitsForModule`, mais agrégé sur tous les modules.
  Future<Set<int>> getModuleIdsWithUnsyncedVisits() async {
    final query = selectOnly(tBaseVisits, distinct: true)
      ..addColumns([tBaseVisits.idModule])
      ..where(tBaseVisits.serverVisitId.isNull());
    final rows = await query.get();
    return rows
        .map((r) => r.read(tBaseVisits.idModule))
        .whereType<int>()
        .toSet();
  }

  /// IDs des sites du module qui ont au moins une visite pas encore téléversée
  /// (serverVisitId NULL). Utilisé par l'UI pour signaler visuellement les
  /// sites ayant des saisies locales en attente de synchronisation.
  Future<Set<int>> getSiteIdsWithUnsyncedVisitsForModule(int moduleId) async {
    final query = selectOnly(tBaseVisits, distinct: true)
      ..addColumns([tBaseVisits.idBaseSite])
      ..where(tBaseVisits.idModule.equals(moduleId) &
          tBaseVisits.serverVisitId.isNull() &
          tBaseVisits.idBaseSite.isNotNull());
    final rows = await query.get();
    return rows
        .map((r) => r.read(tBaseVisits.idBaseSite))
        .whereType<int>()
        .toSet();
  }

  /// Nombre d'observations rattachées à chaque visite d'un module donné,
  /// calculé localement. Utilisé pour la colonne `nb_observations` du
  /// tableau de visites (display_list) et pour l'affichage au détail visite.
  /// Clé = idBaseVisit, valeur = compte d'observations. Inclut 0 pour les
  /// visites sans observation grâce à un LEFT JOIN.
  Future<Map<int, int>> getObservationCountByVisitForModule(
      int moduleId) async {
    final query = customSelect(
      'SELECT tbv.id_base_visit AS id_base_visit, '
      '       COUNT(t_obs.id_observation) AS nb_observations '
      'FROM t_base_visits tbv '
      'LEFT JOIN t_observations t_obs '
      '  ON t_obs.id_base_visit = tbv.id_base_visit '
      'WHERE tbv.id_module = ? '
      'GROUP BY tbv.id_base_visit',
      variables: [Variable.withInt(moduleId)],
      readsFrom: {tBaseVisits, tObservations},
    );
    final rows = await query.get();
    final Map<int, int> result = {};
    for (final row in rows) {
      final visitId = row.read<int>('id_base_visit');
      final nb = row.read<int>('nb_observations');
      result[visitId] = nb;
    }
    return result;
  }

  /// IDs des groupes de sites du module dont au moins un site a une visite
  /// pas encore téléversée. Le rattachement site→groupe est porté par
  /// `t_site_complements.id_sites_group`. Permet à la vue groupes de
  /// remonter le badge orange même quand l'utilisateur n'a pas encore
  /// déplié le groupe pour voir le site concerné.
  Future<Set<int>> getSiteGroupIdsWithUnsyncedVisitsForModule(
      int moduleId) async {
    final query = customSelect(
      'SELECT DISTINCT tsc.id_sites_group AS id_sites_group '
      'FROM t_base_visits tbv '
      'INNER JOIN t_site_complements tsc '
      '  ON tsc.id_base_site = tbv.id_base_site '
      'WHERE tbv.id_module = ? '
      '  AND tbv.server_visit_id IS NULL '
      '  AND tsc.id_sites_group IS NOT NULL',
      variables: [Variable.withInt(moduleId)],
      readsFrom: {tBaseVisits, tSiteComplements},
    );
    final rows = await query.get();
    return rows
        .map((r) => r.readNullable<int>('id_sites_group'))
        .whereType<int>()
        .toSet();
  }

  Future<TBaseVisit> getVisitById(int id) =>
      (select(tBaseVisits)..where((t) => t.idBaseVisit.equals(id))).getSingle();

  Future<int> insertVisit(TBaseVisitsCompanion visit) =>
      into(tBaseVisits).insert(visit);

  Future<bool> updateVisit(TBaseVisitsCompanion visit) =>
      update(tBaseVisits).replace(visit);

  Future<int> deleteVisit(int id) =>
      (delete(tBaseVisits)..where((t) => t.idBaseVisit.equals(id))).go();

  Future<TVisitComplement?> getVisitComplementById(int visitId) =>
      (select(tVisitComplements)..where((t) => t.idBaseVisit.equals(visitId)))
          .getSingleOrNull();

  Future<int> insertVisitComplement(TVisitComplementsCompanion complement) =>
      into(tVisitComplements).insert(complement);

  Future<bool> updateVisitComplement(TVisitComplementsCompanion complement) =>
      update(tVisitComplements).replace(complement);

  Future<int> deleteVisitComplement(int visitId) =>
      (delete(tVisitComplements)..where((t) => t.idBaseVisit.equals(visitId)))
          .go();

  Future<void> deleteVisitWithComplement(int visitId) => transaction(() async {
        // Supprimer d'abord tous les détails d'observation de cette visite
        await db.observationDetailDao.deleteObservationDetailsByVisitId(visitId);
        
        // Supprimer les compléments des observations de cette visite
        await db.observationDao.deleteObservationComplementsByVisitId(visitId);
        
        // Supprimer toutes les observations de cette visite
        await db.observationDao.deleteObservationsByVisitId(visitId);
        
        // Supprimer les compléments de la visite
        await deleteVisitComplement(visitId);
        
        // Supprimer les observateurs de la visite
        await deleteVisitObservers(visitId);
        
        // Supprimer la visite elle-même
        await deleteVisit(visitId);
      });

  // Méthodes pour gérer les observateurs de visite
  Future<List<CorVisitObserverData>> getVisitObservers(int visitId) =>
      (select(corVisitObserver)..where((t) => t.idBaseVisit.equals(visitId)))
          .get();

  Future<int> insertVisitObserver(CorVisitObserverCompanion observer) =>
      into(corVisitObserver).insert(observer);

  Future<int> deleteVisitObservers(int visitId) =>
      (delete(corVisitObserver)..where((t) => t.idBaseVisit.equals(visitId)))
          .go();

  Future<int> deleteVisitObserver(int visitId, int idRole) => (delete(
          corVisitObserver)
        ..where((t) => t.idBaseVisit.equals(visitId) & t.idRole.equals(idRole)))
      .go();

  Future<void> replaceVisitObservers(
          int visitId, List<CorVisitObserverCompanion> observers) =>
      transaction(() async {
        await deleteVisitObservers(visitId);
        for (final observer in observers) {
          await insertVisitObserver(observer);
        }
      });
      
  /// Récupère les compléments de visite qui référencent une nomenclature spécifique
  Future<List<TVisitComplement>> getVisitComplementsByNomenclatureId(int nomenclatureId) async {
    final allComplements = await (select(tVisitComplements)).get();
    final result = <TVisitComplement>[];
    
    for (final complement in allComplements) {
      if (complement.data != null) {
        try {
          final Map<String, dynamic> dataMap = jsonDecode(complement.data!);
          // Vérifier si le champ data contient une référence à la nomenclature
          final hasReference = _checkNomenclatureReference(dataMap, nomenclatureId);
          if (hasReference) {
            result.add(complement);
          }
        } catch (e) {
          // Ignorer les erreurs de parsing JSON
        }
      }
    }
    
    return result;
  }
  
  /// Vérifie récursivement si un objet JSON contient une référence à la nomenclature
  bool _checkNomenclatureReference(dynamic data, int nomenclatureId) {
    if (data is Map<String, dynamic>) {
      // Chercher directement les clés qui pourraient contenir une nomenclature
      for (final entry in data.entries) {
        if (entry.key.toLowerCase().contains('id_nomenclature') && 
            entry.value is int && 
            entry.value == nomenclatureId) {
          return true;
        }
        
        // Récursion sur les objets imbriqués
        if (entry.value is Map || entry.value is List) {
          if (_checkNomenclatureReference(entry.value, nomenclatureId)) {
            return true;
          }
        }
      }
    } else if (data is List) {
      // Récursion sur chaque élément de la liste
      for (final item in data) {
        if (_checkNomenclatureReference(item, nomenclatureId)) {
          return true;
        }
      }
    }
    
    return false;
  }
  
  /// Met à jour l'ID serveur d'une visite pour le suivi de synchronisation
  Future<bool> updateVisitServerId(int localVisitId, int serverId) async {
    debugPrint('🔄 [VISIT_DAO] DÉBUT mise à jour ID serveur: local=$localVisitId, serveur=$serverId');
    
    // Vérifier que la visite existe avant la mise à jour
    final existingVisit = await (select(tBaseVisits)
      ..where((t) => t.idBaseVisit.equals(localVisitId)))
      .getSingleOrNull();
    
    if (existingVisit == null) {
      debugPrint('❌ [VISIT_DAO] Visite $localVisitId introuvable pour mise à jour ID serveur');
      return false;
    }
    
    debugPrint('✅ [VISIT_DAO] Visite trouvée: ID=${existingVisit.idBaseVisit}, currentServerID=${existingVisit.serverVisitId}');
    
    final updated = await (update(tBaseVisits)
      ..where((t) => t.idBaseVisit.equals(localVisitId)))
      .write(TBaseVisitsCompanion(
        serverVisitId: Value(serverId),
      ));
    
    debugPrint('🔄 [VISIT_DAO] Résultat mise à jour: $updated lignes affectées');
    
    // Vérifier que la mise à jour a bien fonctionné
    final updatedVisit = await (select(tBaseVisits)
      ..where((t) => t.idBaseVisit.equals(localVisitId)))
      .getSingleOrNull();
    
    if (updatedVisit != null) {
      debugPrint('✅ [VISIT_DAO] Vérification: serverVisitId après mise à jour = ${updatedVisit.serverVisitId}');
    }
    
    return updated > 0;
  }
}

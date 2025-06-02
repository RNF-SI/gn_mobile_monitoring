import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_visit_observer.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_base_visits.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_visit_complements.dart';

part 'visites_dao.g.dart';

@DriftAccessor(tables: [TBaseVisits, TVisitComplements, CorVisitObserver])
class VisitesDao extends DatabaseAccessor<AppDatabase> with _$VisitesDaoMixin {
  VisitesDao(AppDatabase db) : super(db);

  Future<List<TBaseVisit>> getAllVisits() => select(tBaseVisits).get();

  Future<List<TBaseVisit>> getVisitsBySiteIdAndModuleId(
          int siteId, int moduleId) =>
      (select(tBaseVisits)
            ..where((t) =>
                t.idBaseSite.equals(siteId) & t.idModule.equals(moduleId)))
          .get();
          
  Future<List<TBaseVisit>> getVisitsBySite(int siteId) =>
      (select(tBaseVisits)..where((t) => t.idBaseSite.equals(siteId))).get();

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

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_observations.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_observations_complements.dart';

part 'observation_dao.g.dart';

@DriftAccessor(tables: [TObservations, TObservationComplements])
class ObservationDao extends DatabaseAccessor<AppDatabase>
    with _$ObservationDaoMixin {
  ObservationDao(super.db);

  /// Récupère toutes les observations liées à une visite
  Future<List<TObservation>> getObservationsByVisitId(int visitId) async {
    return await (select(tObservations)
          ..where((tbl) => tbl.idBaseVisit.equals(visitId)))
        .get();
  }

  /// Récupère une observation par son ID
  Future<TObservation?> getObservationById(int observationId) async {
    return await (select(tObservations)
          ..where((tbl) => tbl.idObservation.equals(observationId)))
        .getSingleOrNull();
  }

  /// Récupère les données complémentaires d'une observation
  Future<TObservationComplement?> getObservationComplementById(
      int observationId) async {
    return await (select(tObservationComplements)
          ..where((tbl) => tbl.idObservation.equals(observationId)))
        .getSingleOrNull();
  }

  /// Insère ou met à jour une observation
  Future<int> insertOrUpdateObservation(
      TObservationsCompanion observation) async {
    return await into(tObservations).insertOnConflictUpdate(observation);
  }

  /// Insère ou met à jour les données complémentaires d'une observation
  Future<int> insertOrUpdateObservationComplement(
      TObservationComplementsCompanion complement) async {
    return await into(tObservationComplements)
        .insertOnConflictUpdate(complement);
  }

  /// Supprime une observation
  Future<int> deleteObservation(int observationId) async {
    return await (delete(tObservations)
          ..where((tbl) => tbl.idObservation.equals(observationId)))
        .go();
  }

  /// Supprime les données complémentaires d'une observation
  Future<int> deleteObservationComplement(int observationId) async {
    return await (delete(tObservationComplements)
          ..where((tbl) => tbl.idObservation.equals(observationId)))
        .go();
  }

  /// Récupère une observation avec ses données complémentaires
  Future<Map<String, dynamic>> getObservationWithComplement(
      int observationId) async {
    final observation = await getObservationById(observationId);
    if (observation == null) {
      throw Exception('Observation not found');
    }

    final complement = await getObservationComplementById(observationId);

    return {
      'observation': observation,
      'complement': complement,
    };
  }
  
  /// Récupère les observations qui référencent une nomenclature spécifique
  Future<List<TObservation>> getObservationsByNomenclatureId(int nomenclatureId) async {
    final allObservations = await (select(tObservations)).get();
    final result = <TObservation>[];
    
    for (final observation in allObservations) {
      final complement = await getObservationComplementById(observation.idObservation);
      if (complement != null && complement.data != null) {
        try {
          final Map<String, dynamic> dataMap = jsonDecode(complement.data!);
          // Parcourir l'objet data pour trouver les références à la nomenclature
          final hasReference = _checkNomenclatureReference(dataMap, nomenclatureId);
          if (hasReference) {
            result.add(observation);
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
}

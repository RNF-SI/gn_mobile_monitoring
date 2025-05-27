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

  /// Insère une nouvelle observation
  Future<int> insertObservation(TObservationsCompanion observation) async {
    return await into(tObservations).insert(observation);
  }

  /// Met à jour une observation existante
  Future<bool> updateObservation(TObservationsCompanion observation) async {
    // Vérifier que l'ID est présent
    if (!observation.idObservation.present || observation.idObservation.value == 0) {
      throw ArgumentError('Observation ID must be provided for update');
    }
    
    final updated = await (update(tObservations)
      ..where((tbl) => tbl.idObservation.equals(observation.idObservation.value!)))
      .write(observation);
    
    return updated > 0;
  }

  /// Met à jour l'ID serveur d'une observation
  Future<bool> updateObservationServerId(int localObservationId, int serverObservationId) async {
    final updated = await (update(tObservations)
      ..where((tbl) => tbl.idObservation.equals(localObservationId)))
      .write(TObservationsCompanion(
        serverObservationId: Value(serverObservationId),
      ));
    
    return updated > 0;
  }

  /// Insère ou met à jour les données complémentaires d'une observation
  Future<int> insertOrUpdateObservationComplement(
      TObservationComplementsCompanion complement) async {
    // Si l'ID observation est présent, on vérifie s'il existe déjà
    if (complement.idObservation.present && complement.idObservation.value != 0) {
      final existing = await (select(tObservationComplements)
        ..where((tbl) => tbl.idObservation.equals(complement.idObservation.value!)))
        .getSingleOrNull();
      
      if (existing != null) {
        // Update si existe déjà
        final updated = await (update(tObservationComplements)
          ..where((tbl) => tbl.idObservation.equals(complement.idObservation.value!)))
          .write(complement);
        return updated > 0 ? complement.idObservation.value! : 0;
      } else {
        // Insert si n'existe pas
        return await into(tObservationComplements).insert(complement);
      }
    } else {
      // Insert par défaut
      return await into(tObservationComplements).insert(complement);
    }
  }

  /// Insère de nouvelles données complémentaires pour une observation
  Future<int> insertObservationComplement(
      TObservationComplementsCompanion complement) async {
    return await into(tObservationComplements).insert(complement);
  }

  /// Met à jour les données complémentaires existantes d'une observation
  Future<bool> updateObservationComplement(
      TObservationComplementsCompanion complement) async {
    // Vérifier que l'ID observation est présent
    if (!complement.idObservation.present || complement.idObservation.value == 0) {
      throw ArgumentError('Observation ID must be provided for update');
    }
    
    final updated = await (update(tObservationComplements)
      ..where((tbl) => tbl.idObservation.equals(complement.idObservation.value!)))
      .write(complement);
    
    return updated > 0;
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

  /// Supprime toutes les observations d'une visite
  Future<int> deleteObservationsByVisitId(int visitId) async {
    return await (delete(tObservations)
          ..where((tbl) => tbl.idBaseVisit.equals(visitId)))
        .go();
  }

  /// Supprime toutes les données complémentaires des observations d'une visite
  Future<int> deleteObservationComplementsByVisitId(int visitId) async {
    // Récupérer d'abord les IDs des observations de cette visite
    final observations = await (select(tObservations)
          ..where((tbl) => tbl.idBaseVisit.equals(visitId)))
        .get();
    
    // Supprimer les compléments pour chaque observation
    for (final observation in observations) {
      await deleteObservationComplement(observation.idObservation);
    }
    
    return observations.length;
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
  
  /// Récupère les observations qui référencent un taxon spécifique par cd_nom
  Future<List<TObservation>> getObservationsByCdNom(int cdNom) async {
    return (select(tObservations)..where((o) => o.cdNom.equals(cdNom))).get();
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

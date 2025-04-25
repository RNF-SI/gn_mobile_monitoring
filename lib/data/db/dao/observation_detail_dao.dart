import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_observation_details.dart';

part 'observation_detail_dao.g.dart';

@DriftAccessor(tables: [TObservationDetails])
class ObservationDetailDao extends DatabaseAccessor<AppDatabase>
    with _$ObservationDetailDaoMixin {
  ObservationDetailDao(super.db);

  /// Récupère tous les détails d'observation liés à une observation
  Future<List<TObservationDetail>> getObservationDetailsByObservationId(int observationId) async {
    return await (select(tObservationDetails)
          ..where((tbl) => tbl.idObservation.equals(observationId)))
        .get();
  }

  /// Récupère un détail d'observation par son ID
  Future<TObservationDetail?> getObservationDetailById(int detailId) async {
    return await (select(tObservationDetails)
          ..where((tbl) => tbl.idObservationDetail.equals(detailId)))
        .getSingleOrNull();
  }

  /// Insère ou met à jour un détail d'observation
  Future<int> insertOrUpdateObservationDetail(
      TObservationDetailsCompanion detail) async {
    return await into(tObservationDetails).insertOnConflictUpdate(detail);
  }

  /// Supprime un détail d'observation
  Future<int> deleteObservationDetail(int detailId) async {
    return await (delete(tObservationDetails)
          ..where((tbl) => tbl.idObservationDetail.equals(detailId)))
        .go();
  }

  /// Supprime tous les détails d'une observation
  Future<int> deleteObservationDetailsByObservationId(int observationId) async {
    return await (delete(tObservationDetails)
          ..where((tbl) => tbl.idObservation.equals(observationId)))
        .go();
  }
  
  /// Récupère les détails d'observation qui font référence à une nomenclature spécifique
  Future<List<TObservationDetail>> getObservationDetailsByNomenclatureId(int nomenclatureId) async {
    final allDetails = await (select(tObservationDetails)).get();
    final result = <TObservationDetail>[];
    
    for (final detail in allDetails) {
      if (detail.data != null) {
        try {
          final Map<String, dynamic> dataMap = jsonDecode(detail.data!);
          // Vérifier si le champ data contient une référence à la nomenclature
          final hasReference = _checkNomenclatureReference(dataMap, nomenclatureId);
          if (hasReference) {
            result.add(detail);
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

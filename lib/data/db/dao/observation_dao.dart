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
}

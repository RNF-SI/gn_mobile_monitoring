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
}

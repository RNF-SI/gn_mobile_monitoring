import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/observations_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/observation_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/observation_entity_mapper.dart';

/// Implementation de l'interface ObservationsDatabase
class ObservationsDatabaseImpl implements ObservationsDatabase {
  Future<AppDatabase> get _database async => await DB.instance.database;

  @override
  Future<List<ObservationEntity>> getObservationsByVisitId(int visitId) async {
    final db = await _database;

    final observations =
        await db.observationDao.getObservationsByVisitId(visitId);

    // Récupérer les compléments pour chaque observation
    final List<ObservationEntity> result = [];

    for (final observation in observations) {
      final complement = await db.observationDao
          .getObservationComplementById(observation.idObservation);

      result.add(observation.toEntity(complement: complement));
    }

    return result;
  }

  @override
  Future<ObservationEntity?> getObservationById(int observationId) async {
    final db = await _database;

    final observation =
        await db.observationDao.getObservationById(observationId);

    if (observation == null) {
      return null;
    }

    final complement = await db.observationDao
        .getObservationComplementById(observation.idObservation);

    return observation.toEntity(complement: complement);
  }

  @override
  Future<int> saveObservation(ObservationEntity observation) async {
    final db = await _database;
    // Insérer/mettre à jour l'observation
    final observationId = await db.observationDao
        .insertOrUpdateObservation(observation.toCompanion());

    // Mettre à jour l'ID de l'observation si c'est une insertion
    final entity = observation.idObservation == 0
        ? observation.copyWith(idObservation: observationId)
        : observation;

    // Insérer/mettre à jour les données complémentaires
    if (entity.data != null && entity.data!.isNotEmpty) {
      await db.observationDao
          .insertOrUpdateObservationComplement(entity.toComplementCompanion());
    }

    return observationId;
  }

  @override
  Future<bool> deleteObservation(int observationId) async {
    final db = await _database;
    // Supprimer les données complémentaires d'abord
    await db.observationDao.deleteObservationComplement(observationId);

    // Supprimer l'observation
    final result = await db.observationDao.deleteObservation(observationId);

    return result > 0;
  }
}

/// Extension pour ajouter la méthode copyWith à ObservationEntity
extension ObservationEntityExtension on ObservationEntity {
  ObservationEntity copyWith({
    int? idObservation,
    int? idBaseVisit,
    int? cdNom,
    String? comments,
    String? uuidObservation,
    String? metaCreateDate,
    String? metaUpdateDate,
    Map<String, dynamic>? data,
  }) {
    return ObservationEntity(
      idObservation: idObservation ?? this.idObservation,
      idBaseVisit: idBaseVisit ?? this.idBaseVisit,
      cdNom: cdNom ?? this.cdNom,
      comments: comments ?? this.comments,
      uuidObservation: uuidObservation ?? this.uuidObservation,
      metaCreateDate: metaCreateDate ?? this.metaCreateDate,
      metaUpdateDate: metaUpdateDate ?? this.metaUpdateDate,
      data: data ?? this.data,
    );
  }
}

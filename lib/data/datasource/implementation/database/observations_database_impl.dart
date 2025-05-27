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
  Future<int> createObservation(ObservationEntity observation) async {
    final db = await _database;
    // Insérer la nouvelle observation
    final observationId = await db.observationDao
        .insertObservation(observation.toCompanion());

    // Insérer les données complémentaires si nécessaire (relation 1:1)
    if (observation.data != null && observation.data!.isNotEmpty) {
      final entity = observation.copyWith(idObservation: observationId);
      await db.observationDao
          .insertObservationComplement(entity.toComplementCompanion());
    }
    // Note: Pas besoin de supprimer car c'est une création, il n'y a pas de complément existant

    return observationId;
  }

  @override
  Future<bool> updateObservation(ObservationEntity observation) async {
    final db = await _database;
    
    // Vérifier que l'observation a un ID valide
    if (observation.idObservation == 0) {
      throw ArgumentError('Cannot update observation without valid ID');
    }

    // Mettre à jour l'observation
    final observationUpdated = await db.observationDao
        .updateObservation(observation.toCompanion());

    if (!observationUpdated) {
      return false;
    }

    // Gérer les données complémentaires (relation 1:1)
    final existingComplement = await db.observationDao
        .getObservationComplementById(observation.idObservation);
    
    if (observation.data != null && observation.data!.isNotEmpty) {
      // Si on a des données à sauvegarder
      if (existingComplement != null) {
        // Mettre à jour les compléments existants
        await db.observationDao
            .updateObservationComplement(observation.toComplementCompanion());
      } else {
        // Insérer de nouveaux compléments
        await db.observationDao
            .insertObservationComplement(observation.toComplementCompanion());
      }
    } else {
      // Si les données sont vides mais qu'un complément existe, le supprimer
      if (existingComplement != null) {
        await db.observationDao
            .deleteObservationComplement(observation.idObservation);
      }
    }

    return true;
  }

  @override
  Future<bool> deleteObservation(int observationId) async {
    final db = await _database;
    
    // Supprimer les détails d'observation d'abord
    await db.observationDetailDao.deleteObservationDetailsByObservationId(observationId);
    
    // Supprimer les données complémentaires
    await db.observationDao.deleteObservationComplement(observationId);

    // Supprimer l'observation
    final result = await db.observationDao.deleteObservation(observationId);

    return result > 0;
  }

  @override
  Future<bool> updateObservationServerId(int localObservationId, int serverObservationId) async {
    final db = await _database;
    return await db.observationDao.updateObservationServerId(localObservationId, serverObservationId);
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
    int? serverObservationId,
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
      serverObservationId: serverObservationId ?? this.serverObservationId,
      metaCreateDate: metaCreateDate ?? this.metaCreateDate,
      metaUpdateDate: metaUpdateDate ?? this.metaUpdateDate,
      data: data ?? this.data,
    );
  }
}

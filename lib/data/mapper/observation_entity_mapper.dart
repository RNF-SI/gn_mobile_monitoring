import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/observation_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';

/// Extension pour mapper une entité ObservationEntity vers un objet de domaine Observation
extension ObservationEntityMapper on ObservationEntity {
  Observation toDomain() {
    return Observation(
      idObservation: idObservation,
      idBaseVisit: idBaseVisit,
      cdNom: cdNom,
      comments: comments,
      uuidObservation: uuidObservation,
      serverObservationId: serverObservationId,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
      data: data,
    );
  }
}

/// Extension pour mapper un objet de domaine Observation vers une entité ObservationEntity
extension ObservationMapper on Observation {
  ObservationEntity toEntity() {
    return ObservationEntity(
      idObservation: idObservation,
      idBaseVisit: idBaseVisit,
      cdNom: cdNom,
      comments: comments,
      uuidObservation: uuidObservation,
      serverObservationId: serverObservationId,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
      data: data,
    );
  }
}

/// Extension pour mapper une entrée de base de données (TObservation) vers une entité ObservationEntity
extension TObservationMapper on TObservation {
  ObservationEntity toEntity({TObservationComplement? complement}) {
    Map<String, dynamic>? complementData;

    if (complement?.data != null && complement!.data!.isNotEmpty) {
      try {
        complementData = jsonDecode(complement.data!);
      } catch (e) {
        // Gérer l'erreur de décodage JSON
        complementData = null;
      }
    }

    return ObservationEntity(
      idObservation: idObservation,
      idBaseVisit: idBaseVisit,
      cdNom: cdNom,
      comments: comments,
      uuidObservation: uuidObservation,
      serverObservationId: serverObservationId,
      // Les champs metaCreateDate et metaUpdateDate ne sont pas dans la table
      data: complementData,
    );
  }
}

/// Extension pour créer un TObservationsCompanion à partir d'une entité ObservationEntity
extension ObservationToCompanion on ObservationEntity {
  TObservationsCompanion toCompanion() {
    return TObservationsCompanion(
      idObservation:
          idObservation == 0 ? const Value.absent() : Value(idObservation),
      idBaseVisit:
          idBaseVisit == null ? const Value.absent() : Value(idBaseVisit),
      cdNom: cdNom == null ? const Value.absent() : Value(cdNom),
      comments: comments == null ? const Value.absent() : Value(comments),
      uuidObservation: uuidObservation == null
          ? const Value.absent()
          : Value(uuidObservation),
      serverObservationId: serverObservationId == null
          ? const Value.absent()
          : Value(serverObservationId),
    );
  }

  TObservationComplementsCompanion toComplementCompanion() {
    String? jsonData;

    if (data != null && data!.isNotEmpty) {
      try {
        jsonData = jsonEncode(data);
      } catch (e) {
        // Gérer l'erreur d'encodage JSON
        jsonData = null;
      }
    }

    return TObservationComplementsCompanion(
      idObservation: Value(idObservation),
      data: jsonData == null ? const Value.absent() : Value(jsonData),
    );
  }
}

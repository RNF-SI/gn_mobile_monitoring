import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/observation_detail_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';

/// Extension pour mapper une entité ObservationDetailEntity vers un objet de domaine ObservationDetail
extension ObservationDetailEntityMapper on ObservationDetailEntity {
  ObservationDetail toDomain() {
    Map<String, dynamic> dataMap = {};

    // Convertir la chaîne JSON en Map si elle n'est pas nulle
    if (data != null && data!.isNotEmpty) {
      try {
        dataMap = jsonDecode(data!);
      } catch (e) {
        print('Erreur lors de la conversion des données JSON: $e');
      }
    }

    return ObservationDetail(
      idObservationDetail: idObservationDetail,
      idObservation: idObservation,
      uuidObservationDetail: uuidObservationDetail,
      data: dataMap,
    );
  }
}

/// Extension pour mapper un objet de domaine ObservationDetail vers une entité ObservationDetailEntity
extension ObservationDetailMapper on ObservationDetail {
  ObservationDetailEntity toEntity() {
    String jsonData = '';
    
    if (data.isNotEmpty) {
      try {
        jsonData = jsonEncode(data);
      } catch (e) {
        print('Erreur lors de l\'encodage JSON: $e');
      }
    }
    
    return ObservationDetailEntity(
      idObservationDetail: idObservationDetail,
      idObservation: idObservation,
      uuidObservationDetail: uuidObservationDetail,
      data: jsonData,
    );
  }
}

/// Extension pour mapper une entrée de base de données (TObservationDetail) vers une entité ObservationDetailEntity
extension TObservationDetailMapper on TObservationDetail {
  ObservationDetailEntity toEntity() {
    return ObservationDetailEntity(
      idObservationDetail: idObservationDetail,
      idObservation: idObservation,
      uuidObservationDetail: uuidObservationDetail,
      data: data,
    );
  }
}

/// Extension pour créer un TObservationDetailsCompanion à partir d'une entité ObservationDetailEntity
extension ObservationDetailToCompanion on ObservationDetailEntity {
  TObservationDetailsCompanion toCompanion() {
    return TObservationDetailsCompanion(
      idObservationDetail: idObservationDetail == null || idObservationDetail == 0
          ? const Value.absent()
          : Value(idObservationDetail!),
      idObservation: idObservation == null
          ? const Value.absent()
          : Value(idObservation!),
      uuidObservationDetail: uuidObservationDetail == null
          ? const Value.absent()
          : Value(uuidObservationDetail!),
      data: data == null || data!.isEmpty
          ? const Value.absent()
          : Value(data!),
    );
  }
}

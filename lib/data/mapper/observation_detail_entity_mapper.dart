import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/observation_detail_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';

/// Extension pour mapper une entité ObservationDetailEntity vers un objet de domaine ObservationDetail
extension ObservationDetailEntityMapper on ObservationDetailEntity {
  ObservationDetail toDomain() {
    final logger = AppLogger();
    Map<String, dynamic> dataMap = {};

    // Convertir la chaîne JSON en Map si elle n'est pas nulle
    if (data != null && data!.isNotEmpty) {
      try {
        logger.i('Conversion des données JSON en Map: ${data!.substring(0, data!.length > 100 ? 100 : data!.length)}...', tag: 'mapper');
        dataMap = jsonDecode(data!);
        logger.i('Données JSON converties avec succès, ${dataMap.length} entrées', tag: 'mapper');
      } catch (e, stackTrace) {
        logger.e('Erreur lors de la conversion des données JSON: $e', 
          tag: 'mapper',
          error: e,
          stackTrace: stackTrace);
      }
    } else {
      logger.w('Données JSON nulles ou vides pour l\'observation détail ${idObservationDetail}', tag: 'mapper');
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
    final logger = AppLogger();
    String jsonData = '';
    
    if (data.isNotEmpty) {
      try {
        logger.i('Encodage des données en JSON: ${data.length} entrées - Clés: ${data.keys.join(', ')}', tag: 'mapper');
        jsonData = jsonEncode(data);
        if (jsonData.isNotEmpty) {
          logger.i('Données encodées avec succès: ${jsonData.substring(0, jsonData.length > 100 ? 100 : jsonData.length)}...', 
              tag: 'mapper');
        }
      } catch (e, stackTrace) {
        logger.e('Erreur lors de l\'encodage JSON: $e', 
          tag: 'mapper', 
          error: e, 
          stackTrace: stackTrace);
        
        // Tenter de diagnostiquer le problème
        try {
          // Vérifier chaque entrée individuellement
          for (final entry in data.entries) {
            try {
              final json = jsonEncode({entry.key: entry.value});
              logger.i('Encodage réussi pour: ${entry.key}', tag: 'mapper');
            } catch (entryError) {
              logger.e('Encodage échoué pour la clé: ${entry.key}, valeur: ${entry.value}, type: ${entry.value.runtimeType}', 
                tag: 'mapper', 
                error: entryError);
            }
          }
        } catch (diagError) {
          logger.e('Erreur lors du diagnostic: $diagError', tag: 'mapper');
        }
      }
    } else {
      logger.w('Données vides pour l\'observation détail ${idObservationDetail}', tag: 'mapper');
    }
    
    // Vérifier que jsonData n'est pas vide si data ne l'est pas
    if (data.isNotEmpty && jsonData.isEmpty) {
      logger.e('ALERTE: Les données JSON sont vides après encodage bien que data ne soit pas vide!', tag: 'mapper');
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
    final logger = AppLogger();
    logger.i('Conversion d\'une entrée DB vers entité: ID=${idObservationDetail}, ID Observation=${idObservation}', tag: 'mapper');
    
    if (data != null) {
      logger.i('Données présentes dans DB: ${data!.substring(0, data!.length > 100 ? 100 : data!.length)}...', tag: 'mapper');
    } else {
      logger.w('Données nulles dans DB pour l\'observation détail ${idObservationDetail}', tag: 'mapper');
    }
    
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
    final logger = AppLogger();
    
    logger.i('Conversion d\'une entité vers companion: ID=${idObservationDetail}, ID Observation=${idObservation}', tag: 'mapper');
    
    // Vérification des données
    if (data != null && data!.isNotEmpty) {
      logger.i('Données présentes: ${data!.substring(0, data!.length > 100 ? 100 : data!.length)}...', tag: 'mapper');
      try {
        // Vérification supplémentaire: tenter un décodage puis encodage pour valider le JSON
        final decodedData = jsonDecode(data!);
        final reEncodedData = jsonEncode(decodedData);
        logger.i('Validation JSON réussie', tag: 'mapper');
      } catch (e) {
        logger.e('ERREUR: Le JSON n\'est pas valide: $e', tag: 'mapper', error: e);
      }
    } else {
      logger.w('ATTENTION: Aucune donnée à enregistrer', tag: 'mapper');
    }

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

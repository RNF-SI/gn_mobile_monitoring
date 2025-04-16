import 'package:flutter/foundation.dart';

/// Représentation d'une observation dans la couche Data
class ObservationEntity {
  final int idObservation;
  final int? idBaseVisit;
  final int? cdNom;
  final String? comments;
  final String? uuidObservation;
  final String? metaCreateDate;
  final String? metaUpdateDate;
  final Map<String, dynamic>? data; // Données complémentaires
  
  ObservationEntity({
    required this.idObservation,
    this.idBaseVisit,
    this.cdNom,
    this.comments,
    this.uuidObservation,
    this.metaCreateDate,
    this.metaUpdateDate,
    this.data,
  });
}
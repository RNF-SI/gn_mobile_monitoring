import 'package:flutter/foundation.dart';

/// Représentation d'une observation dans la couche Data
class ObservationEntity {
  final int idObservation;
  final int? idBaseVisit;
  final int? idDigitiser;
  final int? cdNom;
  final String? comments;
  final String? uuidObservation;
  final int? serverObservationId;
  final String? metaCreateDate;
  final String? metaUpdateDate;
  final int? idIndividual;
  final Map<String, dynamic>? data; // Données complémentaires
  
  ObservationEntity({
    required this.idObservation,
    this.idBaseVisit,
    this.idDigitiser,
    this.cdNom,
    this.comments,
    this.uuidObservation,
    this.serverObservationId,
    this.metaCreateDate,
    this.metaUpdateDate,
    this.idIndividual,
    this.data,
  });
}
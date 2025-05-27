import 'package:freezed_annotation/freezed_annotation.dart';

part 'observation.freezed.dart';

@freezed
class Observation with _$Observation {
  const factory Observation({
    required int idObservation,
    int? idBaseVisit,
    int? cdNom,
    String? comments,
    String? uuidObservation,
    int? serverObservationId,
    String? metaCreateDate,
    String? metaUpdateDate,
    Map<String, dynamic>? data, // Données complémentaires
  }) = _Observation;
}

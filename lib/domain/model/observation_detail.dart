import 'package:freezed_annotation/freezed_annotation.dart';

part 'observation_detail.freezed.dart';

/// Représente un détail d'observation dans le domaine métier
@freezed
class ObservationDetail with _$ObservationDetail {
  const factory ObservationDetail({
    /// Identifiant unique du détail d'observation
    int? idObservationDetail,

    /// Identifiant de l'observation parente
    int? idObservation,

    /// UUID unique du détail d'observation
    String? uuidObservationDetail,

    /// Données sous forme de Map
    @Default({}) Map<String, dynamic> data,
  }) = _ObservationDetail;
}

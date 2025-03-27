import 'package:freezed_annotation/freezed_annotation.dart';

/// Représente un détail d'observation dans la base de données locale
class ObservationDetailEntity {
  /// Identifiant unique du détail d'observation
  final int? idObservationDetail;
  
  /// Identifiant de l'observation parente
  final int? idObservation;
  
  /// UUID unique du détail d'observation
  final String? uuidObservationDetail;
  
  /// Données sous forme de JSON formaté en texte
  final String? data;

  ObservationDetailEntity({
    this.idObservationDetail,
    this.idObservation,
    this.uuidObservationDetail,
    this.data,
  });

  factory ObservationDetailEntity.fromJson(Map<String, dynamic> json) {
    return ObservationDetailEntity(
      idObservationDetail: json['idObservationDetail'] as int?,
      idObservation: json['idObservation'] as int?,
      uuidObservationDetail: json['uuidObservationDetail'] as String?,
      data: json['data'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idObservationDetail': idObservationDetail,
      'idObservation': idObservation,
      'uuidObservationDetail': uuidObservationDetail,
      'data': data,
    };
  }

  ObservationDetailEntity copyWith({
    int? idObservationDetail,
    int? idObservation,
    String? uuidObservationDetail,
    String? data,
  }) {
    return ObservationDetailEntity(
      idObservationDetail: idObservationDetail ?? this.idObservationDetail,
      idObservation: idObservation ?? this.idObservation,
      uuidObservationDetail: uuidObservationDetail ?? this.uuidObservationDetail,
      data: data ?? this.data,
    );
  }
}

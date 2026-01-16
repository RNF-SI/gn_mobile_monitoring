import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_site.freezed.dart';

@freezed
class BaseSite with _$BaseSite {
  const factory BaseSite({
    required int idBaseSite,
    String? baseSiteName,
    String? baseSiteDescription,
    String? baseSiteCode,
    DateTime? firstUseDate,
    String? geom, // GeoJSON representation
    String? uuidBaseSite,
    int? altitudeMin,
    int? altitudeMax,
    DateTime? metaCreateDate,
    DateTime? metaUpdateDate,
    Map<String, dynamic>? data,
    bool? isLocal, // true si créé localement, false si récupéré depuis l'API
    int? serverSiteId, // ID du site sur le serveur (pour la synchronisation)
  }) = _BaseSite;
}

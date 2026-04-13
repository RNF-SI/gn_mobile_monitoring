import 'package:gn_mobile_monitoring/domain/model/map_feature.dart';

/// Use case pour charger les features de la carte depuis les données GeoJSON.
abstract class LoadMapFeaturesUseCase {
  /// Parse les données GeoJSON et retourne une liste de MapFeature.
  ///
  /// [geoJsonData] - Chaîne JSON représentant les features
  /// Retourne une liste vide si les données sont invalides.
  List<MapFeature> execute(String? geoJsonData);
}

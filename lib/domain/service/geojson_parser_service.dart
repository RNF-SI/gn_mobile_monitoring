import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/map_feature.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

/// Service pour le parsing et la conversion de données GeoJSON.
/// Gère la transformation entre les formats GeoJSON et les modèles MapFeature.
abstract class GeoJsonParserService {
  /// Parse une chaîne GeoJSON et retourne une liste de MapFeature.
  ///
  /// [geoJsonData] - Chaîne JSON représentant un tableau de features
  /// Retourne une liste vide si les données sont null ou invalides.
  List<MapFeature> parseGeoJson(String? geoJsonData);

  /// Convertit une liste de sites en GeoJSON.
  ///
  /// [sites] - Liste des sites à convertir
  /// Retourne null si la liste est vide ou si aucun site n'a de géométrie.
  String? sitesToGeoJson(List<BaseSite> sites);

  /// Convertit une liste de groupes de sites en GeoJSON.
  ///
  /// [groups] - Liste des groupes de sites à convertir
  /// Retourne null si la liste est vide ou si aucun groupe n'a de géométrie.
  String? siteGroupsToGeoJson(List<SiteGroup> groups);
}

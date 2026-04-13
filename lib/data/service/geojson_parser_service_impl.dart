import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/map_feature.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/service/geojson_parser_service.dart';
import 'package:latlong2/latlong.dart';

/// Implémentation du service de parsing GeoJSON.
class GeoJsonParserServiceImpl implements GeoJsonParserService {
  const GeoJsonParserServiceImpl();

  @override
  List<MapFeature> parseGeoJson(String? geoJsonData) {
    if (geoJsonData == null || geoJsonData.trim().isEmpty) {
      debugPrint('GeoJsonParser: JSON absent ou vide, aucune géométrie chargée.');
      return [];
    }

    try {
      final List<dynamic> data = jsonDecode(geoJsonData);

      if (data.isEmpty) {
        debugPrint('GeoJsonParser: JSON vide, aucune géométrie chargée.');
        return [];
      }

      return _parseFeatures(data);
    } catch (e) {
      debugPrint('GeoJsonParser: Erreur lors du parsing JSON: $e');
      return [];
    }
  }

  /// Parse une liste de features et les convertit en MapFeature
  List<MapFeature> _parseFeatures(List<dynamic> data) {
    final features = <MapFeature>[];

    for (final feature in data) {
      if (feature == null || feature['geom'] == null) continue;

      final geom = feature['geom'];
      final type = geom['type'];
      final coords = geom['coordinates'];

      // Extraire les propriétés (tout sauf geom)
      final properties = _extractProperties(feature);

      // Extraire l'ID du site si disponible
      final siteId = feature['id'] is int ? feature['id'] as int : null;

      final mapFeature = _createFeature(type, coords, properties, siteId);
      if (mapFeature != null) {
        features.add(mapFeature);
      }
    }

    return features;
  }

  /// Extrait les propriétés d'une feature (tout sauf geom)
  Map<String, dynamic> _extractProperties(Map<String, dynamic> feature) {
    final properties = <String, dynamic>{};
    feature.forEach((key, value) {
      if (key != 'geom') {
        properties[key] = value;
      }
    });
    return properties;
  }

  /// Crée une MapFeature selon le type de géométrie
  MapFeature? _createFeature(
    String type,
    dynamic coords,
    Map<String, dynamic> properties,
    int? siteId,
  ) {
    switch (type) {
      case 'Point':
        return _createPointFeature(coords, properties, siteId);
      case 'LineString':
        return _createPolylineFeature(coords, properties, siteId);
      case 'Polygon':
        return _createPolygonFeature(coords, properties, siteId);
      default:
        debugPrint('GeoJsonParser: Type de géométrie non supporté: $type');
        return null;
    }
  }

  /// Crée une MapFeature de type point
  MapFeature _createPointFeature(
    dynamic coords,
    Map<String, dynamic> properties,
    int? siteId,
  ) {
    final point = LatLng(
      (coords[1] as num).toDouble(),
      (coords[0] as num).toDouble(),
    );
    return MapFeature.point(
      point: point,
      properties: properties,
      siteId: siteId,
    );
  }

  /// Crée une MapFeature de type polyline
  MapFeature _createPolylineFeature(
    dynamic coords,
    Map<String, dynamic> properties,
    int? siteId,
  ) {
    final points = (coords as List)
        .map<LatLng>((c) => LatLng(
              (c[1] as num).toDouble(),
              (c[0] as num).toDouble(),
            ))
        .toList();
    return MapFeature.polyline(
      points: points,
      properties: properties,
      siteId: siteId,
    );
  }

  /// Crée une MapFeature de type polygon
  MapFeature _createPolygonFeature(
    dynamic coords,
    Map<String, dynamic> properties,
    int? siteId,
  ) {
    // Les polygones GeoJSON ont un tableau de tableaux de coordonnées
    // Le premier tableau est le contour extérieur
    final points = (coords[0] as List)
        .map<LatLng>((c) => LatLng(
              (c[1] as num).toDouble(),
              (c[0] as num).toDouble(),
            ))
        .toList();
    return MapFeature.polygon(
      points: points,
      properties: properties,
      siteId: siteId,
    );
  }

  @override
  String? sitesToGeoJson(List<BaseSite> sites) {
    if (sites.isEmpty) return null;

    final geoJsonFeatures = <Map<String, dynamic>>[];

    for (final site in sites) {
      if (site.geom == null || site.geom!.isEmpty) continue;

      try {
        final geometry = jsonDecode(site.geom!) as Map<String, dynamic>;

        final feature = <String, dynamic>{
          'id': site.idBaseSite,
          'name': site.baseSiteName ?? 'Site ${site.idBaseSite}',
          'description': site.baseSiteDescription ?? '',
          'geom': geometry,
        };

        // Ajouter les champs de base pour le display_list
        if (site.baseSiteCode != null) {
          feature['base_site_code'] = site.baseSiteCode;
        }
        if (site.baseSiteName != null) {
          feature['base_site_name'] = site.baseSiteName;
        }
        if (site.baseSiteDescription != null) {
          feature['base_site_description'] = site.baseSiteDescription;
        }
        if (site.firstUseDate != null) {
          feature['first_use_date'] = site.firstUseDate!.toIso8601String();
        }

        // Ajouter les données du champ data si disponible
        if (site.data != null && site.data!.isNotEmpty) {
          feature.addAll(site.data!);
        }

        geoJsonFeatures.add(feature);
      } catch (e) {
        debugPrint(
            'GeoJsonParser: Erreur parsing geometry pour site ${site.idBaseSite}: $e');
      }
    }

    if (geoJsonFeatures.isEmpty) return null;

    return jsonEncode(geoJsonFeatures);
  }

  @override
  String? siteGroupsToGeoJson(List<SiteGroup> groups) {
    if (groups.isEmpty) return null;

    final geoJsonFeatures = <Map<String, dynamic>>[];

    for (final group in groups) {
      if (group.geom == null || group.geom!.isEmpty) continue;

      try {
        final geometry = jsonDecode(group.geom!) as Map<String, dynamic>;

        final feature = <String, dynamic>{
          'id': group.idSitesGroup,
          'name': group.sitesGroupName ?? 'Groupe ${group.idSitesGroup}',
          'description': group.sitesGroupDescription ?? '',
          'geom': geometry,
        };

        // Ajouter les champs de base pour le display_list
        if (group.sitesGroupCode != null) {
          feature['sites_group_code'] = group.sitesGroupCode;
        }
        if (group.sitesGroupName != null) {
          feature['sites_group_name'] = group.sitesGroupName;
        }
        if (group.sitesGroupDescription != null) {
          feature['sites_group_description'] = group.sitesGroupDescription;
        }
        if (group.altitudeMin != null) {
          feature['altitude_min'] = group.altitudeMin;
        }
        if (group.altitudeMax != null) {
          feature['altitude_max'] = group.altitudeMax;
        }
        if (group.comments != null) {
          feature['comments'] = group.comments;
        }

        // Ajouter les données du champ data si disponible
        if (group.data != null && group.data!.isNotEmpty) {
          try {
            Map<String, dynamic> dataMap;
            if (group.data is String) {
              dataMap =
                  Map<String, dynamic>.from(jsonDecode(group.data as String));
            } else {
              dataMap = Map<String, dynamic>.from(group.data as Map);
            }
            feature.addAll(dataMap);
          } catch (e) {
            debugPrint(
                'GeoJsonParser: Erreur décodage données groupe ${group.idSitesGroup}: $e');
          }
        }

        geoJsonFeatures.add(feature);
      } catch (e) {
        debugPrint(
            'GeoJsonParser: Erreur parsing geometry pour groupe ${group.idSitesGroup}: $e');
      }
    }

    if (geoJsonFeatures.isEmpty) return null;

    return jsonEncode(geoJsonFeatures);
  }
}

import 'dart:convert';

class BaseSiteEntity {
  final int idBaseSite;
  final String? baseSiteName;
  final String? baseSiteDescription;
  final String? baseSiteCode;
  final DateTime? firstUseDate;
  final String? geom; // GeoJSON representation
  final String? uuidBaseSite;
  final int? altitudeMin;
  final int? altitudeMax;
  final DateTime? metaCreateDate;
  final DateTime? metaUpdateDate;

  BaseSiteEntity({
    required this.idBaseSite,
    this.baseSiteName,
    this.baseSiteDescription,
    this.baseSiteCode,
    this.firstUseDate,
    this.geom,
    this.uuidBaseSite,
    this.altitudeMin,
    this.altitudeMax,
    this.metaCreateDate,
    this.metaUpdateDate,
  });

  // Factory method to convert JSON to entity
  factory BaseSiteEntity.fromJson(Map<String, dynamic> json) {
    return BaseSiteEntity(
      idBaseSite: json['id_base_site'] as int,
      baseSiteName: json['base_site_name'] as String?,
      baseSiteDescription: json['base_site_description'] as String?,
      baseSiteCode: json['base_site_code'] as String?,
      firstUseDate: json['first_use_date'] != null
          ? DateTime.parse(json['first_use_date'])
          : null,
      geom: _parseGeometry(json['geometry'] ?? json['geom']),
      uuidBaseSite: json['uuid_base_site'] as String?,
      altitudeMin: json['altitude_min'] as int?,
      altitudeMax: json['altitude_max'] as int?,
      metaCreateDate: json['meta_create_date'] != null
          ? DateTime.parse(json['meta_create_date'])
          : null,
      metaUpdateDate: json['meta_update_date'] != null
          ? DateTime.parse(json['meta_update_date'])
          : null,
    );
  }

  // Method to convert entity to JSON
  Map<String, dynamic> toJson() {
    return {
      'id_base_site': idBaseSite,
      'base_site_name': baseSiteName,
      'base_site_description': baseSiteDescription,
      'base_site_code': baseSiteCode,
      'first_use_date': firstUseDate?.toIso8601String(),
      'geom': geom,
      'uuid_base_site': uuidBaseSite,
      'altitude_min': altitudeMin,
      'altitude_max': altitudeMax,
      'meta_create_date': metaCreateDate?.toIso8601String(),
      'meta_update_date': metaUpdateDate?.toIso8601String(),
    };
  }

  /// Parse geometry from various formats into JSON string
  /// Handles: Map<String, dynamic> (GeoJSON object), String (JSON/WKT), null
  static String? _parseGeometry(dynamic geometry) {
    if (geometry == null) return null;
    
    if (geometry is String) {
      // Already a string (JSON or WKT format)
      return geometry.isEmpty ? null : geometry;
    }
    
    if (geometry is Map<String, dynamic>) {
      // GeoJSON object - convert to JSON string
      try {
        return jsonEncode(geometry);
      } catch (e) {
        print('Error encoding geometry to JSON: $e');
        return null;
      }
    }
    
    // Unexpected type - try to convert to string
    try {
      return geometry.toString();
    } catch (e) {
      print('Error parsing geometry of type ${geometry.runtimeType}: $e');
      return null;
    }
  }
}

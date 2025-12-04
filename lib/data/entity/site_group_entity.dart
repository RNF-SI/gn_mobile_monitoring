import 'dart:convert';

class SiteGroupEntity {
  final int idSitesGroup;
  final String? sitesGroupName;
  final String? sitesGroupCode;
  final String? sitesGroupDescription;
  final String? uuidSitesGroup;
  final String? comments;
  final Map<String, dynamic>?
      data; // Changed from String? to Map<String, dynamic>?
  final DateTime? metaCreateDate;
  final DateTime? metaUpdateDate;
  final int? idDigitiser;
  final String? geom;
  final int? altitudeMin;
  final int? altitudeMax;

  SiteGroupEntity({
    required this.idSitesGroup,
    this.sitesGroupName,
    this.sitesGroupCode,
    this.sitesGroupDescription,
    this.uuidSitesGroup,
    this.comments,
    this.data,
    this.metaCreateDate,
    this.metaUpdateDate,
    this.idDigitiser,
    this.geom,
    this.altitudeMin,
    this.altitudeMax,
  });

  factory SiteGroupEntity.fromJson(Map<String, dynamic> json) {
    try {
      // Check required field `id_sites_group`
      final idSitesGroup = json['id_sites_group'];
      if (idSitesGroup == null) {
        throw Exception("Missing or null `id_sites_group` in JSON: $json");
      }
      if (idSitesGroup is! int) {
        throw Exception(
            "Invalid type for `id_sites_group`. Expected int, got ${idSitesGroup.runtimeType}: $json");
      }

      return SiteGroupEntity(
        idSitesGroup: idSitesGroup,
        sitesGroupName: json['sites_group_name'] as String?,
        sitesGroupCode: json['sites_group_code'] as String?,
        sitesGroupDescription: json['sites_group_description'] as String?,
        uuidSitesGroup: json['uuid_sites_group'] as String?,
        comments: json['comments'] as String?,
        data: json['data'] != null
            ? Map<String, dynamic>.from(json['data'])
            : null, // Handle `data` as Map<String, dynamic>
        metaCreateDate: json['meta_create_date'] != null
            ? DateTime.parse(json['meta_create_date'])
            : null,
        metaUpdateDate: json['meta_update_date'] != null
            ? DateTime.parse(json['meta_update_date'])
            : null,
        idDigitiser: json['id_digitiser'] as int?,
        geom: _parseGeometry(json['geometry'] ?? json['geom']),
        altitudeMin: json['altitude_min'] as int?,
        altitudeMax: json['altitude_max'] as int?,
      );
    } catch (e) {
      throw Exception("Error parsing SiteGroupEntity: $e\nJSON data: $json");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'idSitesGroup': idSitesGroup,
      'sitesGroupName': sitesGroupName,
      'sitesGroupCode': sitesGroupCode,
      'sitesGroupDescription': sitesGroupDescription,
      'uuidSitesGroup': uuidSitesGroup,
      'comments': comments,
      'data': data, // Serialize `data` as is
      'metaCreateDate': metaCreateDate?.toIso8601String(),
      'metaUpdateDate': metaUpdateDate?.toIso8601String(),
      'idDigitiser': idDigitiser,
      'geom': geom,
      'altitudeMin': altitudeMin,
      'altitudeMax': altitudeMax,
    };
  }

  /// Parse geometry from various formats into JSON string
  /// Handles: Map<String, dynamic> (GeoJSON object), String (JSON/WKT), null
  /// Adds SRID prefix if not present to satisfy database trigger
  static String? _parseGeometry(dynamic geometry) {
    if (geometry == null) return null;
    
    if (geometry is String) {
      // Already a string (JSON or WKT format)
      if (geometry.isEmpty) return null;
      
      // Add SRID prefix if not present to satisfy database trigger
      return _ensureSridPrefix(geometry);
    }
    
    if (geometry is Map<String, dynamic>) {
      // GeoJSON object - convert to JSON string and add SRID
      try {
        String geoJsonString = jsonEncode(geometry);
        return _ensureSridPrefix(geoJsonString);
      } catch (e) {
        print('Error encoding site group geometry to JSON: $e');
        return null;
      }
    }
    
    // Unexpected type - try to convert to string
    try {
      String geometryStr = geometry.toString();
      return _ensureSridPrefix(geometryStr);
    } catch (e) {
      print('Error parsing site group geometry of type ${geometry.runtimeType}: $e');
      return null;
    }
  }

  /// Ensure SRID prefix is present for database trigger compatibility
  /// Example: "{...}" -> "SRID=4326;{...}"
  static String _ensureSridPrefix(String geometry) {
    if (geometry.isEmpty) return geometry;
    
    // Check if geometry already has SRID pattern
    final sridPattern = RegExp(r'^SRID=\d+;\s*');
    if (sridPattern.hasMatch(geometry)) {
      return geometry; // Already has SRID
    }
    
    // Add SRID=4326 prefix to satisfy database trigger
    return 'SRID=4326;$geometry';
  }
}

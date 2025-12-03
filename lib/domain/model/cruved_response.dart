import 'package:freezed_annotation/freezed_annotation.dart';

part 'cruved_response.freezed.dart';
part 'cruved_response.g.dart';

/// Convertisseur personnalisé pour gérer les deux formats de CRUVED :
/// - Format booléen : {"C": true, "R": false, ...}
/// - Format numérique (scope) : {"C": 0, "R": 3, ...} où 0=none, 1=my data, 2=my org, 3=all data
class CruvedJsonConverter implements JsonConverter<bool, Object> {
  const CruvedJsonConverter();

  @override
  bool fromJson(Object json) {
    if (json is bool) {
      return json;
    }
    if (json is int) {
      // Convertir scope numérique en booléen
      // 0 = pas d'accès (false), 1+ = accès (true)
      return json > 0;
    }
    if (json is String) {
      // Gérer les cas où l'API renvoie des strings
      return json.toLowerCase() == 'true';
    }
    return false; // Par défaut
  }

  @override
  Object toJson(bool object) => object;
}

@freezed
class CruvedResponse with _$CruvedResponse {
  const factory CruvedResponse({
    @JsonKey(name: 'C') @CruvedJsonConverter() @Default(false) bool create,
    @JsonKey(name: 'R') @CruvedJsonConverter() @Default(false) bool read,
    @JsonKey(name: 'U') @CruvedJsonConverter() @Default(false) bool update,
    @JsonKey(name: 'V') @CruvedJsonConverter() @Default(false) bool validate,
    @JsonKey(name: 'E') @CruvedJsonConverter() @Default(false) bool export,
    @JsonKey(name: 'D') @CruvedJsonConverter() @Default(false) bool delete,
  }) = _CruvedResponse;

  factory CruvedResponse.fromJson(Map<String, dynamic> json) =>
      _$CruvedResponseFromJson(json);

  /// Convertit des données brutes CRUVED (format numérique) en CruvedResponse
  /// Utilisé pour les APIs qui renvoient des valeurs numériques de scope
  factory CruvedResponse.fromScope(Map<String, dynamic> scopeData) {
    return CruvedResponse(
      create: (scopeData['C'] as int? ?? 0) > 0,
      read: (scopeData['R'] as int? ?? 0) > 0,
      update: (scopeData['U'] as int? ?? 0) > 0,
      validate: (scopeData['V'] as int? ?? 0) > 0,
      export: (scopeData['E'] as int? ?? 0) > 0,
      delete: (scopeData['D'] as int? ?? 0) > 0,
    );
  }
}

/// Extension pour ajouter des méthodes utilitaires à CruvedResponse
extension CruvedResponseExtension on CruvedResponse {
  /// Convertit les permissions booléennes en valeurs de scope
  /// Retourne 3 (accès complet) si true, 0 (pas d'accès) si false
  Map<String, int> toScopeMap() {
    return {
      'C': create ? 3 : 0,
      'R': read ? 3 : 0,
      'U': update ? 3 : 0,
      'V': validate ? 3 : 0,
      'E': export ? 3 : 0,
      'D': delete ? 3 : 0,
    };
  }
}

@freezed
class MonitoringObjectResponse with _$MonitoringObjectResponse {
  const factory MonitoringObjectResponse({
    required int id,
    required Map<String, dynamic> properties,
    required CruvedResponse cruved,
  }) = _MonitoringObjectResponse;

  factory MonitoringObjectResponse.fromJson(Map<String, dynamic> json) =>
      _$MonitoringObjectResponseFromJson(json);
}

@freezed
class ModuleResponse with _$ModuleResponse {
  const factory ModuleResponse({
    required int id,
    required String name,
    required String code,
    String? description,
    required CruvedResponse cruved,
    Map<String, dynamic>? properties,
  }) = _ModuleResponse;

  factory ModuleResponse.fromJson(Map<String, dynamic> json) =>
      _$ModuleResponseFromJson(json);
}

@freezed
class SiteResponse with _$SiteResponse {
  const factory SiteResponse({
    required int id,
    String? name,
    String? description,
    String? code,
    Map<String, dynamic>? geometry,
    int? idDigitiser,
    int? idInventor,
    required CruvedResponse cruved,
    Map<String, dynamic>? properties,
  }) = _SiteResponse;

  factory SiteResponse.fromJson(Map<String, dynamic> json) =>
      _$SiteResponseFromJson(json);
}

@freezed
class VisitResponse with _$VisitResponse {
  const factory VisitResponse({
    required int id,
    required int idBaseSite,
    required int idDataset,
    required int idModule,
    int? idDigitiser,
    String? visitDateMin,
    String? visitDateMax,
    String? comments,
    List<int>? observers,
    required CruvedResponse cruved,
    Map<String, dynamic>? data,
  }) = _VisitResponse;

  factory VisitResponse.fromJson(Map<String, dynamic> json) =>
      _$VisitResponseFromJson(json);
}

@freezed
class SiteGroupResponse with _$SiteGroupResponse {
  const factory SiteGroupResponse({
    required int id,
    String? name,
    String? description,
    int? idDigitiser,
    List<int>? sites,
    Map<String, dynamic>? geometry,
    required CruvedResponse cruved,
    Map<String, dynamic>? properties,
  }) = _SiteGroupResponse;

  factory SiteGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$SiteGroupResponseFromJson(json);
}
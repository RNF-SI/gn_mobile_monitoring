class SiteGroupEntity {
  final int idSitesGroup;
  final String? sitesGroupName;
  final String? sitesGroupCode;
  final String? sitesGroupDescription;
  final String? uuidSitesGroup;
  final String? comments;
  final String? data;
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
    return SiteGroupEntity(
      idSitesGroup: json['idSitesGroup'] as int,
      sitesGroupName: json['sitesGroupName'] as String?,
      sitesGroupCode: json['sitesGroupCode'] as String?,
      sitesGroupDescription: json['sitesGroupDescription'] as String?,
      uuidSitesGroup: json['uuidSitesGroup'] as String?,
      comments: json['comments'] as String?,
      data: json['data'] as String?,
      metaCreateDate: json['metaCreateDate'] != null
          ? DateTime.parse(json['metaCreateDate'])
          : null,
      metaUpdateDate: json['metaUpdateDate'] != null
          ? DateTime.parse(json['metaUpdateDate'])
          : null,
      idDigitiser: json['idDigitiser'] as int?,
      geom: json['geom'] as String?,
      altitudeMin: json['altitudeMin'] as int?,
      altitudeMax: json['altitudeMax'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idSitesGroup': idSitesGroup,
      'sitesGroupName': sitesGroupName,
      'sitesGroupCode': sitesGroupCode,
      'sitesGroupDescription': sitesGroupDescription,
      'uuidSitesGroup': uuidSitesGroup,
      'comments': comments,
      'data': data,
      'metaCreateDate': metaCreateDate?.toIso8601String(),
      'metaUpdateDate': metaUpdateDate?.toIso8601String(),
      'idDigitiser': idDigitiser,
      'geom': geom,
      'altitudeMin': altitudeMin,
      'altitudeMax': altitudeMax,
    };
  }
}

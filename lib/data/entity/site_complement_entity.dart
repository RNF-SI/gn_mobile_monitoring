class SiteComplementEntity {
  final int idBaseSite;
  final int? idSitesGroup;
  final String? data;

  SiteComplementEntity({
    required this.idBaseSite,
    this.idSitesGroup,
    this.data,
  });

  factory SiteComplementEntity.fromJson(Map<String, dynamic> json) {
    return SiteComplementEntity(
      idBaseSite: json['idBaseSite'] as int,
      idSitesGroup: json['idSitesGroup'] as int?,
      data: json['data'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idBaseSite': idBaseSite,
      'idSitesGroup': idSitesGroup,
      'data': data,
    };
  }
}

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
      idBaseSite: json['id_base_site'] as int,
      idSitesGroup: json['id_sites_group'] as int?,
      data: json['data'] is Map
          ? json['data'].toString()
          : json['data'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_base_site': idBaseSite,
      'id_sites_group': idSitesGroup,
      'data': data,
    };
  }
}

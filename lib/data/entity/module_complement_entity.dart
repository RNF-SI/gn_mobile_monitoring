class ModuleComplementEntity {
  final int idModule;
  final String? uuidModuleComplement;
  final int? idListObserver;
  final int? idListTaxonomy;
  final bool bSynthese;
  final String taxonomyDisplayFieldName;
  final bool? bDrawSitesGroup;
  final String? data;

  ModuleComplementEntity({
    required this.idModule,
    this.uuidModuleComplement,
    this.idListObserver,
    this.idListTaxonomy,
    required this.bSynthese,
    required this.taxonomyDisplayFieldName,
    this.bDrawSitesGroup,
    this.data,
  });

  factory ModuleComplementEntity.fromJson(Map<String, dynamic> json) {
    return ModuleComplementEntity(
      idModule: json['id_module'] as int,
      uuidModuleComplement: json['uuid_module_complement'] as String?,
      idListObserver: json['id_list_observer'] as int?,
      idListTaxonomy: json['id_list_taxonomy'] as int?,
      bSynthese: json['b_synthese'] as bool? ?? true,
      taxonomyDisplayFieldName:
          json['taxonomy_display_field_name'] as String? ?? 'nom_vern,lb_nom',
      bDrawSitesGroup: json['b_draw_sites_group'] as bool?,
      data: json['data'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_module': idModule,
      'uuid_module_complement': uuidModuleComplement,
      'id_list_observer': idListObserver,
      'id_list_taxonomy': idListTaxonomy,
      'b_synthese': bSynthese,
      'taxonomy_display_field_name': taxonomyDisplayFieldName,
      'b_draw_sites_group': bDrawSitesGroup,
      'data': data,
    };
  }
}

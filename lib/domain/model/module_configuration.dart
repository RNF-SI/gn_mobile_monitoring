import 'dart:convert';

class ModuleConfiguration {
  final bool drawSitesGroup;
  final String? taxonomyDisplayFieldName;
  final List<int> typeSites;
  final String moduleLabel;
  final Map<String, dynamic>? custom;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? defaultDisplayFieldNames;
  final Map<String, dynamic>? displayFieldNames;
  final Map<String, dynamic>? module;
  final Map<String, dynamic>? observation;
  final Map<String, dynamic>? site;
  final dynamic synthese;
  final Map<String, dynamic>? tree;
  final Map<String, dynamic>? visit;

  ModuleConfiguration({
    required this.drawSitesGroup,
    required this.taxonomyDisplayFieldName,
    required this.typeSites,
    required this.moduleLabel,
    this.custom,
    this.data,
    this.defaultDisplayFieldNames,
    this.displayFieldNames,
    this.module,
    this.observation,
    this.site,
    this.synthese,
    this.tree,
    this.visit,
  });

  factory ModuleConfiguration.fromJson(Map<String, dynamic> json) {
    // Extract values from the module section which contains the core configuration
    final moduleData = json['module'] as Map<String, dynamic>? ?? {};

    return ModuleConfiguration(
      // Core fields from module section
      drawSitesGroup: moduleData['B_DRAW_SITES_GROUP'] as bool? ?? false,
      taxonomyDisplayFieldName:
          moduleData['TAXONOMY_DISPLAY_FIELD_NAME'] as String?,
      typeSites: (moduleData['TYPES_SITE'] as List<dynamic>?)
              ?.map((e) => e['id_nomenclature_type_site'] as int)
              .toList() ??
          [],
      moduleLabel: moduleData['MODULE_LABEL'] as String? ?? '',

      // Store all sections as they are
      custom: json['custom'] as Map<String, dynamic>?,
      data: json['data'] as Map<String, dynamic>?,
      defaultDisplayFieldNames:
          json['default_display_field_names'] as Map<String, dynamic>?,
      displayFieldNames: json['display_field_names'] as Map<String, dynamic>?,
      module: moduleData,
      observation: json['observation'] as Map<String, dynamic>?,
      site: json['site'] as Map<String, dynamic>?,
      synthese: json['synthese'],
      tree: json['tree'] as Map<String, dynamic>?,
      visit: json['visit'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'custom': custom ?? {},
      'data': data ?? {},
      'default_display_field_names': defaultDisplayFieldNames ?? {},
      'display_field_names': displayFieldNames ?? {},
      'module': {
        'B_DRAW_SITES_GROUP': drawSitesGroup,
        'TAXONOMY_DISPLAY_FIELD_NAME': taxonomyDisplayFieldName,
        'TYPES_SITE':
            typeSites.map((id) => {'id_nomenclature_type_site': id}).toList(),
        'MODULE_LABEL': moduleLabel,
        ...?module, // Include any additional module fields
      },
      'observation': observation ?? {},
      'site': site ?? {},
      'synthese': synthese,
      'tree': tree ?? {},
      'visit': visit ?? {},
    };
  }

  String toJsonString() {
    return json.encode(toJson());
  }
}

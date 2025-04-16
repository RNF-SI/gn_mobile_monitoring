import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'module_configuration.freezed.dart';

@freezed
class ModuleConfiguration with _$ModuleConfiguration {
  const factory ModuleConfiguration({
    CustomConfig? custom,
    DataConfig? data,
    Map<String, String?>? defaultDisplayFieldNames,
    Map<String, String?>? displayFieldNames,
    ModuleConfig? module,
    ObjectConfig? observation,
    ObjectConfig? observationDetail, // Nouvelle propriété pour les détails d'observation
    ObjectConfig? site,
    ObjectConfig? sitesGroup,
    dynamic synthese,
    TreeConfig? tree,
    ObjectConfig? visit,
  }) = _ModuleConfiguration;

  factory ModuleConfiguration.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert to Map
    Map<String, dynamic>? toSafeMap(dynamic value) {
      if (value == null) return null;
      if (value is Map<String, dynamic>) return value;
      return {};
    }
    
    // Helper function to safely convert to Map for string fields
    Map<String, String?>? toSafeStringMap(dynamic value) {
      if (value == null) return null;
      if (value is! Map) return {};
      try {
        return (value as Map<String, dynamic>).map((k, v) => MapEntry(k, v?.toString()));
      } catch (e) {
        return {};
      }
    }
    
    return ModuleConfiguration(
      custom: json['custom'] != null && json['custom'] is Map 
          ? CustomConfig.fromJson(toSafeMap(json['custom'])!)
          : null,
      data: json['data'] != null && json['data'] is Map
          ? DataConfig.fromJson(toSafeMap(json['data'])!)
          : null,
      defaultDisplayFieldNames: toSafeStringMap(json['default_display_field_names']),
      displayFieldNames: toSafeStringMap(json['display_field_names']),
      module: json['module'] != null && json['module'] is Map
          ? ModuleConfig.fromJson(toSafeMap(json['module'])!)
          : null,
      observation: json['observation'] != null && json['observation'] is Map
          ? ObjectConfig.fromJson(toSafeMap(json['observation'])!)
          : null,
      // Ajout du parsing de observation_detail
      observationDetail: json['observation_detail'] != null && json['observation_detail'] is Map
          ? ObjectConfig.fromJson(toSafeMap(json['observation_detail'])!)
          : null,
      site: json['site'] != null && json['site'] is Map
          ? ObjectConfig.fromJson(toSafeMap(json['site'])!)
          : null,
      sitesGroup: json['sites_group'] != null && json['sites_group'] is Map
          ? ObjectConfig.fromJson(toSafeMap(json['sites_group'])!)
          : null,
      synthese: json['synthese'],
      tree: json['tree'] != null && json['tree'] is Map
          ? TreeConfig.fromJson(toSafeMap(json['tree'])!)
          : null,
      visit: json['visit'] != null && json['visit'] is Map
          ? ObjectConfig.fromJson(toSafeMap(json['visit'])!)
          : null,
    );
  }
}

/// Extension to add toJson and toJsonString methods to ModuleConfiguration
extension ModuleConfigurationX on ModuleConfiguration {
  Map<String, dynamic> toJson() => {
        if (custom != null) 'custom': custom?.toJson(),
        if (data != null) 'data': data?.toJson(),
        if (defaultDisplayFieldNames != null)
          'default_display_field_names': defaultDisplayFieldNames,
        if (displayFieldNames != null) 'display_field_names': displayFieldNames,
        if (module != null) 'module': module?.toJson(),
        if (observation != null) 'observation': observation?.toJson(),
        // Ajout de l'observation_detail à la sérialisation
        if (observationDetail != null) 'observation_detail': observationDetail?.toJson(),
        if (site != null) 'site': site?.toJson(),
        if (sitesGroup != null) 'sites_group': sitesGroup?.toJson(),
        if (synthese != null) 'synthese': synthese,
        if (tree != null) 'tree': tree?.toJson(),
        if (visit != null) 'visit': visit?.toJson(),
      };

  String toJsonString() => json.encode(toJson());
}

@freezed
class CustomConfig with _$CustomConfig {
  const factory CustomConfig({
    @JsonKey(name: '__MODULE.B_DRAW_SITES_GROUP') bool? drawSitesGroup,
    @JsonKey(name: '__MODULE.B_SYNTHESE') bool? synthese,
    @JsonKey(name: '__MODULE.IDS_TYPE_SITE') List<TypeSite>? typeSites,
    @JsonKey(name: '__MODULE.ID_LIST_OBSERVER') int? idListObserver,
    @JsonKey(name: '__MODULE.ID_LIST_TAXONOMY') int? idListTaxonomy,
    @JsonKey(name: '__MODULE.ID_MODULE') int? idModule,
    @JsonKey(name: '__MODULE.MODULE_CODE') String? moduleCode,
    @JsonKey(name: '__MODULE.TAXONOMY_DISPLAY_FIELD_NAME')
    String? taxonomyDisplayFieldName,
    @JsonKey(name: '__MODULE.TYPES_SITE') List<TypeSite>? typesSite,
    @JsonKey(name: '__MONITORINGS_PATH') String? monitoringsPath,
  }) = _CustomConfig;

  factory CustomConfig.fromJson(Map<String, dynamic> json) {
    // Safe conversion helper for bool
    bool? toBool(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == 'true';
      if (value is num) return value != 0;
      return null;
    }
    
    // Safe conversion helper for int
    int? toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      if (value is double) return value.toInt();
      return null;
    }
    
    // Safe conversion helper for string
    String? toString(dynamic value) {
      if (value == null) return null;
      return value.toString();
    }
    
    // Safe conversion helper for TypeSite list
    List<TypeSite>? toTypeSiteList(dynamic value) {
      if (value == null) return null;
      if (value is! List) return [];
      
      try {
        return value.map((e) {
          if (e is Map<String, dynamic>) {
            return TypeSite.fromJson(e);
          } else {
            return TypeSite(idNomenclatureTypeSite: null, config: null);
          }
        }).toList();
      } catch (e) {
        return [];
      }
    }
    
    return CustomConfig(
      drawSitesGroup: toBool(json['__MODULE.B_DRAW_SITES_GROUP']),
      synthese: toBool(json['__MODULE.B_SYNTHESE']),
      typeSites: toTypeSiteList(json['__MODULE.IDS_TYPE_SITE']),
      idListObserver: toInt(json['__MODULE.ID_LIST_OBSERVER']),
      idListTaxonomy: toInt(json['__MODULE.ID_LIST_TAXONOMY']),
      idModule: toInt(json['__MODULE.ID_MODULE']),
      moduleCode: toString(json['__MODULE.MODULE_CODE']),
      taxonomyDisplayFieldName: toString(json['__MODULE.TAXONOMY_DISPLAY_FIELD_NAME']),
      typesSite: toTypeSiteList(json['__MODULE.TYPES_SITE']),
      monitoringsPath: toString(json['__MONITORINGS_PATH']),
    );
  }
}

extension CustomConfigX on CustomConfig {
  Map<String, dynamic> toJson() => {
        if (drawSitesGroup != null)
          '__MODULE.B_DRAW_SITES_GROUP': drawSitesGroup,
        if (synthese != null) '__MODULE.B_SYNTHESE': synthese,
        if (typeSites != null)
          '__MODULE.IDS_TYPE_SITE': typeSites?.map((e) => e.toJson()).toList(),
        if (idListObserver != null) '__MODULE.ID_LIST_OBSERVER': idListObserver,
        if (idListTaxonomy != null) '__MODULE.ID_LIST_TAXONOMY': idListTaxonomy,
        if (idModule != null) '__MODULE.ID_MODULE': idModule,
        if (moduleCode != null) '__MODULE.MODULE_CODE': moduleCode,
        if (taxonomyDisplayFieldName != null)
          '__MODULE.TAXONOMY_DISPLAY_FIELD_NAME': taxonomyDisplayFieldName,
        if (typesSite != null)
          '__MODULE.TYPES_SITE': typesSite?.map((e) => e.toJson()).toList(),
        if (monitoringsPath != null) '__MONITORINGS_PATH': monitoringsPath,
      };
}

@freezed
class TypeSite with _$TypeSite {
  const factory TypeSite({
    int? idNomenclatureTypeSite,
    dynamic config,
  }) = _TypeSite;

  factory TypeSite.fromJson(Map<String, dynamic> json) {
    return TypeSite(
      idNomenclatureTypeSite: json['id_nomenclature_type_site'] as int?,
      config: json['config'],
    );
  }
}

extension TypeSiteX on TypeSite {
  Map<String, dynamic> toJson() => {
        if (idNomenclatureTypeSite != null)
          'id_nomenclature_type_site': idNomenclatureTypeSite,
        if (config != null) 'config': config,
      };
}

@freezed
class DataConfig with _$DataConfig {
  const factory DataConfig({
    List<String>? nomenclature,
    int? user,
  }) = _DataConfig;

  factory DataConfig.fromJson(Map<String, dynamic> json) {
    return DataConfig(
      nomenclature: (json['nomenclature'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      user: json['user'] as int?,
    );
  }
}

extension DataConfigX on DataConfig {
  Map<String, dynamic> toJson() => {
        if (nomenclature != null) 'nomenclature': nomenclature,
        if (user != null) 'user': user,
      };
}

@freezed
class ModuleConfig with _$ModuleConfig {
  const factory ModuleConfig({
    @JsonKey(name: 'b_draw_sites_group') bool? drawSitesGroup,
    @JsonKey(name: 'b_synthese') bool? synthese,
    List<String>? childrenTypes,
    String? color,
    CruvedConfig? cruved,
    String? descriptionFieldName,
    List<String>? displayForm,
    List<String>? displayList,
    List<String>? displayProperties,
    List<ExportConfig>? exportCsv,
    List<ExportConfig>? exportPdf,
    Map<String, dynamic>? filters,
    Map<String, GenericFieldConfig>? generic,
    String? genre,
    String? idFieldName,
    int? idListObserver,
    int? idListTaxonomy,
    int? idModule,
    int? idTableLocation,
    String? label,
    String? moduleCode,
    String? moduleDesc,
    String? moduleLabel,
    List<String>? parentTypes,
    List<String>? propertiesKeys,
    bool? rootObject,
    Map<String, dynamic>? specific,
    String? taxonomyDisplayFieldName,
    Map<String, TypeSiteConfig>? typesSite,
    String? uuidFieldName,
  }) = _ModuleConfig;

  factory ModuleConfig.fromJson(Map<String, dynamic> json) {
    return ModuleConfig(
      drawSitesGroup: json['b_draw_sites_group'] as bool?,
      synthese: json['b_synthese'] as bool?,
      childrenTypes: (json['children_types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      color: json['color'] as String?,
      cruved: json['cruved'] == null
          ? null
          : CruvedConfig.fromJson(json['cruved'] as Map<String, dynamic>),
      descriptionFieldName: json['description_field_name'] as String?,
      displayForm: (json['display_form'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      displayList: (json['display_list'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      displayProperties: (json['display_properties'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      exportCsv: (json['export_csv'] as List<dynamic>?)
          ?.map((e) => ExportConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
      exportPdf: (json['export_pdf'] as List<dynamic>?)
          ?.map((e) => ExportConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
      filters: json['filters'] as Map<String, dynamic>?,
      generic: (json['generic'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, GenericFieldConfig.fromJson(e as Map<String, dynamic>)),
      ),
      genre: json['genre'] as String?,
      idFieldName: json['id_field_name'] as String?,
      idListObserver: json['id_list_observer'] as int?,
      idListTaxonomy: json['id_list_taxonomy'] as int?,
      idModule: json['id_module'] as int?,
      idTableLocation: json['id_table_location'] as int?,
      label: json['label'] as String?,
      moduleCode: json['module_code'] as String?,
      moduleDesc: json['module_desc'] as String?,
      moduleLabel: json['module_label'] as String?,
      parentTypes: (json['parent_types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      propertiesKeys: (json['properties_keys'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      rootObject: json['root_object'] as bool?,
      specific: json['specific'] as Map<String, dynamic>?,
      taxonomyDisplayFieldName: json['taxonomy_display_field_name'] as String?,
      typesSite: (json['types_site'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, TypeSiteConfig.fromJson(e as Map<String, dynamic>)),
      ),
      uuidFieldName: json['uuid_field_name'] as String?,
    );
  }
}

extension ModuleConfigX on ModuleConfig {
  Map<String, dynamic> toJson() => {
        if (drawSitesGroup != null) 'b_draw_sites_group': drawSitesGroup,
        if (synthese != null) 'b_synthese': synthese,
        if (childrenTypes != null) 'children_types': childrenTypes,
        if (color != null) 'color': color,
        if (cruved != null) 'cruved': cruved?.toJson(),
        if (descriptionFieldName != null)
          'description_field_name': descriptionFieldName,
        if (displayForm != null) 'display_form': displayForm,
        if (displayList != null) 'display_list': displayList,
        if (displayProperties != null) 'display_properties': displayProperties,
        if (exportCsv != null)
          'export_csv': exportCsv?.map((e) => e.toJson()).toList(),
        if (exportPdf != null)
          'export_pdf': exportPdf?.map((e) => e.toJson()).toList(),
        if (filters != null) 'filters': filters,
        if (generic != null)
          'generic': generic?.map((k, v) => MapEntry(k, v.toJson())),
        if (genre != null) 'genre': genre,
        if (idFieldName != null) 'id_field_name': idFieldName,
        if (idListObserver != null) 'id_list_observer': idListObserver,
        if (idListTaxonomy != null) 'id_list_taxonomy': idListTaxonomy,
        if (idModule != null) 'id_module': idModule,
        if (idTableLocation != null) 'id_table_location': idTableLocation,
        if (label != null) 'label': label,
        if (moduleCode != null) 'module_code': moduleCode,
        if (moduleDesc != null) 'module_desc': moduleDesc,
        if (moduleLabel != null) 'module_label': moduleLabel,
        if (parentTypes != null) 'parent_types': parentTypes,
        if (propertiesKeys != null) 'properties_keys': propertiesKeys,
        if (rootObject != null) 'root_object': rootObject,
        if (specific != null) 'specific': specific,
        if (taxonomyDisplayFieldName != null)
          'taxonomy_display_field_name': taxonomyDisplayFieldName,
        if (typesSite != null)
          'types_site': typesSite?.map((k, v) => MapEntry(k, v.toJson())),
        if (uuidFieldName != null) 'uuid_field_name': uuidFieldName,
      };
}

@freezed
class CruvedConfig with _$CruvedConfig {
  const factory CruvedConfig({
    int? C,
    int? R,
    int? U,
    int? V,
    int? E,
    int? D,
  }) = _CruvedConfig;

  factory CruvedConfig.fromJson(Map<String, dynamic> json) {
    return CruvedConfig(
      C: json['C'] as int?,
      R: json['R'] as int?,
      U: json['U'] as int?,
      V: json['V'] as int?,
      E: json['E'] as int?,
      D: json['D'] as int?,
    );
  }
}

extension CruvedConfigX on CruvedConfig {
  Map<String, dynamic> toJson() => {
        if (C != null) 'C': C,
        if (R != null) 'R': R,
        if (U != null) 'U': U,
        if (V != null) 'V': V,
        if (E != null) 'E': E,
        if (D != null) 'D': D,
      };
}

@freezed
class ExportConfig with _$ExportConfig {
  const factory ExportConfig({
    String? label,
    String? method,
    String? type,
    String? template,
  }) = _ExportConfig;

  factory ExportConfig.fromJson(Map<String, dynamic> json) {
    return ExportConfig(
      label: json['label'] as String?,
      method: json['method'] as String?,
      type: json['type'] as String?,
      template: json['template'] as String?,
    );
  }
}

extension ExportConfigX on ExportConfig {
  Map<String, dynamic> toJson() => {
        if (label != null) 'label': label,
        if (method != null) 'method': method,
        if (type != null) 'type': type,
        if (template != null) 'template': template,
      };
}

/// Helper function to safely convert a value to bool
bool? _toBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is String) {
    return value.toLowerCase() == 'true';
  }
  return null;
}

@freezed
class GenericFieldConfig with _$GenericFieldConfig {
  const factory GenericFieldConfig({
    @JsonKey(name: 'attribut_label') String? attributLabel,
    String? definition,
    bool? hidden,
    bool? required,
    String? typeWidget,
    String? typeUtil,
    bool? multiSelect,
    String? api,
    String? application,
    String? keyLabel,
    String? keyValue,
    bool? multiple,
    List<Map<String, dynamic>>? values,
    Map<String, dynamic>? default_,
    String? designStyle,
    String? dataPath,
    @JsonKey(name: 'id_list') dynamic idList, // Peut être un entier ou une chaîne
  }) = _GenericFieldConfig;

  factory GenericFieldConfig.fromJson(Map<String, dynamic> json) {
    return GenericFieldConfig(
      attributLabel: json['attribut_label'] as String?,
      definition: json['definition'] as String?,
      hidden: _toBool(json['hidden']),
      required: _toBool(json['required']),
      typeWidget: json['type_widget'] as String?,
      typeUtil: json['type_util'] as String?,
      multiSelect: _toBool(json['multi_select']),
      api: json['api'] as String?,
      application: json['application'] as String?,
      keyLabel: json['keyLabel'] as String?,
      keyValue: json['keyValue'] as String?,
      multiple: _toBool(json['multiple']),
      values: (json['values'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      default_: json['default'] as Map<String, dynamic>?,
      designStyle: json['designStyle'] as String?,
      dataPath: json['data_path'] as String?,
      idList: json['id_list'], // Peut être un entier ou une chaîne
    );
  }
}

extension GenericFieldConfigX on GenericFieldConfig {
  Map<String, dynamic> toJson() => {
        if (attributLabel != null) 'attribut_label': attributLabel,
        if (definition != null) 'definition': definition,
        if (hidden != null) 'hidden': hidden,
        if (required != null) 'required': required,
        if (typeWidget != null) 'type_widget': typeWidget,
        if (typeUtil != null) 'type_util': typeUtil,
        if (multiSelect != null) 'multi_select': multiSelect,
        if (api != null) 'api': api,
        if (application != null) 'application': application,
        if (keyLabel != null) 'keyLabel': keyLabel,
        if (keyValue != null) 'keyValue': keyValue,
        if (multiple != null) 'multiple': multiple,
        if (values != null) 'values': values,
        if (default_ != null) 'default': default_,
        if (designStyle != null) 'designStyle': designStyle,
        if (dataPath != null) 'data_path': dataPath,
        if (idList != null) 'id_list': idList,
      };
}

@freezed
class TypeSiteConfig with _$TypeSiteConfig {
  const factory TypeSiteConfig({
    List<dynamic>? displayProperties,
    String? name,
  }) = _TypeSiteConfig;

  factory TypeSiteConfig.fromJson(Map<String, dynamic> json) {
    return TypeSiteConfig(
      displayProperties: json['display_properties'] as List<dynamic>?,
      name: json['name'] as String?,
    );
  }
}

extension TypeSiteConfigX on TypeSiteConfig {
  Map<String, dynamic> toJson() => {
        if (displayProperties != null) 'display_properties': displayProperties,
        if (name != null) 'name': name,
      };
}

@freezed
class ObjectConfig with _$ObjectConfig {
  const factory ObjectConfig({
    bool? chained,
    List<String>? childrenTypes,
    String? descriptionFieldName,
    List<String>? displayForm,
    List<String>? displayList,
    List<String>? displayProperties,
    List<ExportConfig>? exportPdf,
    Map<String, dynamic>? filters,
    Map<String, GenericFieldConfig>? generic,
    String? genre,
    String? geomFieldName,
    String? geometryType,
    String? idFieldName,
    int? idTableLocation,
    String? label,
    String? labelList,
    String? mapLabelFieldName,
    List<String>? parentTypes,
    List<String>? propertiesKeys,
    List<SortConfig>? sorts,
    Map<String, dynamic>? specific,
    Map<String, TypeSiteConfig>? typesSite,
    String? uuidFieldName,
  }) = _ObjectConfig;

  factory ObjectConfig.fromJson(Map<String, dynamic> json) {
    // Safe conversion helpers
    bool? toBool(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == 'true';
      if (value is num) return value != 0;
      return null;
    }
    
    int? toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      if (value is double) return value.toInt();
      return null;
    }
    
    String? toString(dynamic value) {
      if (value == null) return null;
      return value.toString();
    }
    
    // Safe conversion for string lists
    List<String>? toStringList(dynamic value) {
      if (value == null) return null;
      if (value is! List) return [];
      try {
        return value.map((e) => e?.toString() ?? "").toList();
      } catch (e) {
        return [];
      }
    }
    
    // Safe conversion for ExportConfig list
    List<ExportConfig>? toExportConfigList(dynamic value) {
      if (value == null) return null;
      if (value is! List) return [];
      try {
        return value.map((e) {
          if (e is Map<String, dynamic>) {
            return ExportConfig.fromJson(e);
          } else {
            return ExportConfig();
          }
        }).toList();
      } catch (e) {
        return [];
      }
    }
    
    // Safe conversion for SortConfig list
    List<SortConfig>? toSortConfigList(dynamic value) {
      if (value == null) return null;
      if (value is! List) return [];
      try {
        return value.map((e) {
          if (e is Map<String, dynamic>) {
            return SortConfig.fromJson(e);
          } else {
            return SortConfig();
          }
        }).toList();
      } catch (e) {
        return [];
      }
    }
    
    // Safe conversion for Map
    Map<String, dynamic>? toSafeMap(dynamic value) {
      if (value == null) return null;
      if (value is Map<String, dynamic>) return value;
      return {};
    }
    
    // Safe conversion for GenericFieldConfig map
    Map<String, GenericFieldConfig>? toGenericFieldConfigMap(dynamic value) {
      if (value == null) return null;
      if (value is! Map) return {};
      try {
        final result = <String, GenericFieldConfig>{};
        (value as Map).forEach((k, v) {
          if (v is Map<String, dynamic>) {
            result[k.toString()] = GenericFieldConfig.fromJson(v);
          } else {
            result[k.toString()] = GenericFieldConfig();
          }
        });
        return result;
      } catch (e) {
        return {};
      }
    }
    
    // Safe conversion for TypeSiteConfig map
    Map<String, TypeSiteConfig>? toTypeSiteConfigMap(dynamic value) {
      if (value == null) return null;
      if (value is! Map) return {};
      try {
        final result = <String, TypeSiteConfig>{};
        (value as Map).forEach((k, v) {
          if (v is Map<String, dynamic>) {
            result[k.toString()] = TypeSiteConfig.fromJson(v);
          } else {
            result[k.toString()] = TypeSiteConfig();
          }
        });
        return result;
      } catch (e) {
        return {};
      }
    }
    
    return ObjectConfig(
      chained: toBool(json['chained']),
      childrenTypes: toStringList(json['children_types']),
      descriptionFieldName: toString(json['description_field_name']),
      displayForm: toStringList(json['display_form']),
      displayList: toStringList(json['display_list']),
      displayProperties: toStringList(json['display_properties']),
      exportPdf: toExportConfigList(json['export_pdf']),
      filters: toSafeMap(json['filters']),
      generic: toGenericFieldConfigMap(json['generic']),
      genre: toString(json['genre']),
      geomFieldName: toString(json['geom_field_name']),
      geometryType: toString(json['geometry_type']),
      idFieldName: toString(json['id_field_name']),
      idTableLocation: toInt(json['id_table_location']),
      label: toString(json['label']),
      labelList: toString(json['label_list']),
      mapLabelFieldName: toString(json['map_label_field_name']),
      parentTypes: toStringList(json['parent_types']),
      propertiesKeys: toStringList(json['properties_keys']),
      sorts: toSortConfigList(json['sorts']),
      specific: toSafeMap(json['specific']),
      typesSite: toTypeSiteConfigMap(json['types_site']),
      uuidFieldName: toString(json['uuid_field_name']),
    );
  }
}

extension ObjectConfigX on ObjectConfig {
  Map<String, dynamic> toJson() => {
        if (chained != null) 'chained': chained,
        if (childrenTypes != null) 'children_types': childrenTypes,
        if (descriptionFieldName != null)
          'description_field_name': descriptionFieldName,
        if (displayForm != null) 'display_form': displayForm,
        if (displayList != null) 'display_list': displayList,
        if (displayProperties != null) 'display_properties': displayProperties,
        if (exportPdf != null)
          'export_pdf': exportPdf?.map((e) => e.toJson()).toList(),
        if (filters != null) 'filters': filters,
        if (generic != null)
          'generic': generic?.map((k, v) => MapEntry(k, v.toJson())),
        if (genre != null) 'genre': genre,
        if (geomFieldName != null) 'geom_field_name': geomFieldName,
        if (geometryType != null) 'geometry_type': geometryType,
        if (idFieldName != null) 'id_field_name': idFieldName,
        if (idTableLocation != null) 'id_table_location': idTableLocation,
        if (label != null) 'label': label,
        if (labelList != null) 'label_list': labelList,
        if (mapLabelFieldName != null)
          'map_label_field_name': mapLabelFieldName,
        if (parentTypes != null) 'parent_types': parentTypes,
        if (propertiesKeys != null) 'properties_keys': propertiesKeys,
        if (sorts != null) 'sorts': sorts?.map((e) => e.toJson()).toList(),
        if (specific != null) 'specific': specific,
        if (typesSite != null)
          'types_site': typesSite?.map((k, v) => MapEntry(k, v.toJson())),
        if (uuidFieldName != null) 'uuid_field_name': uuidFieldName,
      };
}

@freezed
class SortConfig with _$SortConfig {
  const factory SortConfig({
    String? dir,
    String? prop,
  }) = _SortConfig;

  factory SortConfig.fromJson(Map<String, dynamic> json) {
    return SortConfig(
      dir: json['dir'] as String?,
      prop: json['prop'] as String?,
    );
  }
}

extension SortConfigX on SortConfig {
  Map<String, dynamic> toJson() => {
        if (dir != null) 'dir': dir,
        if (prop != null) 'prop': prop,
      };
}

@freezed
class TreeConfig with _$TreeConfig {
  const factory TreeConfig({
    Map<String, dynamic>? module,
  }) = _TreeConfig;

  factory TreeConfig.fromJson(Map<String, dynamic> json) {
    return TreeConfig(
      module: json['module'] as Map<String, dynamic>?,
    );
  }
}

extension TreeConfigX on TreeConfig {
  Map<String, dynamic> toJson() => {
        if (module != null) 'module': module,
      };
}

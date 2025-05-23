import 'dart:convert';

import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';

extension TModuleComplementMapper on TModuleComplement {
  ModuleComplement toDomain() {
    return ModuleComplement(
      idModule: idModule,
      uuidModuleComplement: uuidModuleComplement,
      idListObserver: idListObserver,
      idListTaxonomy: idListTaxonomy,
      bSynthese: bSynthese,
      taxonomyDisplayFieldName: taxonomyDisplayFieldName,
      bDrawSitesGroup: bDrawSitesGroup,
      data: data,
      configuration: _parseConfiguration(configuration),
    );
  }

  ModuleConfiguration? _parseConfiguration(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty || jsonString == '{}') {
      return null;
    }
    try {
      // Sanitize the JSON string by removing any invalid characters
      final sanitizedJson = jsonString.trim();

      // Parse the JSON string into a Map
      final Map<String, dynamic> jsonData = json.decode(sanitizedJson);

      // Check if the parsed JSON is empty
      if (jsonData.isEmpty) {
        return null;
      }

      // Create ModuleConfiguration from the parsed JSON
      return ModuleConfiguration.fromJson(jsonData);
    } catch (e) {
      // Return ModuleConfiguration with default values if there is an error
      // Créer une configuration minimale mais valide
      final Map<String, dynamic> defaultConfig = {
        'module': {'children_types': [], 'label': 'Module'},
        'site': {'label': 'Site', 'label_list': 'Sites'},
        'sites_group': {'label': 'Groupe de sites', 'label_list': 'Groupes de sites'}
      };
      
      return ModuleConfiguration.fromJson(defaultConfig);
    }
  }
}

extension ModuleComplementMapper on ModuleComplement {
  TModuleComplement toDatabaseEntity() {
    return TModuleComplement(
      idModule: idModule,
      uuidModuleComplement: uuidModuleComplement,
      idListObserver: idListObserver,
      idListTaxonomy: idListTaxonomy,
      bSynthese: bSynthese,
      taxonomyDisplayFieldName: taxonomyDisplayFieldName,
      bDrawSitesGroup: bDrawSitesGroup,
      data: data,
      configuration: configuration?.toJsonString(),
    );
  }
}

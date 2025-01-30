import 'dart:convert';

import 'package:gn_mobile_monitoring/data/entity/module_complement_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';

extension ModuleComplementEntityMapper on ModuleComplementEntity {
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
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }
    try {
      // Sanitize the JSON string by removing any invalid characters
      final sanitizedJson = jsonString.trim();

      // Parse the JSON string into a Map
      final Map<String, dynamic> jsonData = json.decode(sanitizedJson);

      // Create ModuleConfiguration from the parsed JSON
      return ModuleConfiguration.fromJson(jsonData);
    } catch (e) {
      // Log the error and the problematic JSON string for debugging
      print('Error parsing JSON configuration: $e');
      print('Problematic JSON string: $jsonString');
      return null;
    }
  }
}

extension DomainModuleComplementEntityMapper on ModuleComplement {
  ModuleComplementEntity toEntity() {
    return ModuleComplementEntity(
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

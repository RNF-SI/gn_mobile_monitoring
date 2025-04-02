import 'dart:convert';
import 'package:gn_mobile_monitoring/data/entity/bib_type_site_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/bib_type_site.dart';

extension BibTypeSiteEntityMapper on BibTypeSiteEntity {
  BibTypeSite toDomain() {
    Map<String, dynamic>? configMap;
    if (config != null) {
      try {
        configMap = json.decode(config!) as Map<String, dynamic>;
      } catch (e) {
        // Ignorer les erreurs de parsing du JSON
      }
    }
    
    return BibTypeSite(
      idNomenclatureTypeSite: idNomenclatureTypeSite,
      config: configMap,
    );
  }
}

extension DomainBibTypeSiteEntityMapper on BibTypeSite {
  BibTypeSiteEntity toEntity() {
    String? configStr;
    if (config != null) {
      try {
        configStr = json.encode(config);
      } catch (e) {
        // Ignorer les erreurs de conversion en JSON
      }
    }
    
    return BibTypeSiteEntity(
      idNomenclatureTypeSite: idNomenclatureTypeSite,
      config: configStr,
    );
  }
}
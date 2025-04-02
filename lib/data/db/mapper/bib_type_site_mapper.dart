import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart' as db;
import 'package:gn_mobile_monitoring/domain/model/bib_type_site.dart';

extension BibTypeSiteMapper on BibTypeSite {
  db.BibTypeSitesTableCompanion toDatabaseEntity() {
    String? configStr;
    if (config != null) {
      try {
        configStr = json.encode(config);
      } catch (e) {
        // Ignorer les erreurs de conversion en JSON
      }
    }

    return db.BibTypeSitesTableCompanion(
      idNomenclatureTypeSite: Value(idNomenclatureTypeSite),
      config: Value(configStr),
    );
  }
}

extension TBibTypeSiteMapper on db.BibTypeSite {
  Map<String, dynamic>? parseConfig(String? configStr) {
    if (configStr == null) return null;
    try {
      return json.decode(configStr) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  BibTypeSite toDomain() {
    return BibTypeSite(
      idNomenclatureTypeSite: idNomenclatureTypeSite,
      config: parseConfig(config),
    );
  }
}

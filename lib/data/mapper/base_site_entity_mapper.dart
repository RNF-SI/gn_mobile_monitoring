import 'dart:convert';

import 'package:gn_mobile_monitoring/data/db/tables/t_sites_complements.dart';
import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/base_site_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';


extension BaseSiteEntityMapper on BaseSiteEntity {
  BaseSite toDomain() {
    return BaseSite(
      idBaseSite: idBaseSite,
      baseSiteName: baseSiteName,
      baseSiteDescription: baseSiteDescription,
      baseSiteCode: baseSiteCode,
      firstUseDate: firstUseDate,
      geom: geom,
      uuidBaseSite: uuidBaseSite,
      altitudeMin: altitudeMin,
      altitudeMax: altitudeMax,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
      data: data,
      isLocal: false, // Sites récupérés depuis l'API ne sont pas locaux
    );
  }
}

/// Extension pour mapper un objet de domaine Observation vers une entité ObservationEntity
extension BaseSiteMapper on BaseSite {
  BaseSiteEntity toEntity() {
    return BaseSiteEntity(
      idBaseSite: idBaseSite,
      baseSiteName: baseSiteName,
      baseSiteDescription: baseSiteDescription,
      baseSiteCode: baseSiteCode,
      firstUseDate: firstUseDate,
      geom: geom,
      uuidBaseSite: uuidBaseSite,
      altitudeMin: altitudeMin,
      altitudeMax: altitudeMax,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
      data: data,
    );
  }
}


/// Extension pour mapper une entrée de base de données (TSiteComplement) vers une entité ObservationEntity
extension TSiteComplementsMapper on TBaseSite {
  BaseSiteEntity toEntity({TSiteComplement? complement}) {
    Map<String, dynamic>? complementData;

    if (complement?.data != null && complement!.data!.isNotEmpty) {
      try {
        complementData = jsonDecode(complement.data!);
      } catch (e) {
        // Gérer l'erreur de décodage JSON
        complementData = null;
      }
    }

    return BaseSiteEntity(
      idBaseSite: idBaseSite,
      // Les champs metaCreateDate et metaUpdateDate ne sont pas dans la table
      data: complementData, 
    );
  }
}

/// Extension pour créer un TObservationsCompanion à partir d'une entité ObservationEntity
extension BaseSiteToCompanion on BaseSiteEntity {
  TBaseSitesCompanion toCompanion() {
    return TBaseSitesCompanion(
      idBaseSite:
          idBaseSite == 0 ? const Value.absent() : Value(idBaseSite),
      baseSiteName:
          baseSiteName == null ? const Value.absent() : Value(baseSiteName),
      baseSiteDescription:
          baseSiteDescription == null ? const Value.absent() : Value(baseSiteDescription),
      baseSiteCode: baseSiteCode == null ? const Value.absent() : Value(baseSiteCode),
      firstUseDate:firstUseDate == null ? const Value.absent() : Value(firstUseDate),
      geom: geom == null
          ? const Value.absent()
          : Value(geom),
      uuidBaseSite: uuidBaseSite == null
          ? const Value.absent()
          : Value(uuidBaseSite),
      altitudeMin: altitudeMin == null
          ? const Value.absent()
          : Value(altitudeMin),
      altitudeMax: altitudeMax == null
          ? const Value.absent()
          : Value(altitudeMax),
    );
  }

  TSiteComplementsCompanion toComplementCompanion() {
    String? jsonData;

    if (data != null && data!.isNotEmpty) {
      try {
        jsonData = jsonEncode(data);
      } catch (e) {
        // Gérer l'erreur d'encodage JSON
        jsonData = null;
      }
    }

    return TSiteComplementsCompanion(
      idBaseSite: Value(idBaseSite),
      data: jsonData == null ? const Value.absent() : Value(jsonData),
    );
  }
}
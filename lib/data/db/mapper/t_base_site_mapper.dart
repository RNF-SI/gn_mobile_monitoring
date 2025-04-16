import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';

extension TBaseSiteMapper on TBaseSite {
  BaseSite toDomain() {
    DateTime? parseDate(String? date) {
      if (date == null) return null;
      try {
        return DateTime.parse(date); // ISO8601 format
      } catch (e) {
        return null;
      }
    }

    return BaseSite(
      idBaseSite: idBaseSite,
      baseSiteName: baseSiteName,
      baseSiteDescription: baseSiteDescription,
      baseSiteCode: baseSiteCode,
      firstUseDate: parseDate(firstUseDate?.toIso8601String()),
      geom: geom,
      uuidBaseSite: uuidBaseSite,
      altitudeMin: altitudeMin,
      altitudeMax: altitudeMax,
      metaCreateDate: parseDate(metaCreateDate?.toIso8601String()),
      metaUpdateDate: parseDate(metaUpdateDate?.toIso8601String()),
    );
  }
}

extension BaseSiteMapper on BaseSite {
  TBaseSitesCompanion toDatabaseEntity() {
    return TBaseSitesCompanion(
      idBaseSite: Value(idBaseSite),
      baseSiteName: Value(baseSiteName),
      baseSiteDescription: Value(baseSiteDescription),
      baseSiteCode: Value(baseSiteCode),
      firstUseDate: Value(firstUseDate),
      geom: Value(geom),
      uuidBaseSite: Value(uuidBaseSite),
      altitudeMin: Value(altitudeMin),
      altitudeMax: Value(altitudeMax),
    );
  }
}

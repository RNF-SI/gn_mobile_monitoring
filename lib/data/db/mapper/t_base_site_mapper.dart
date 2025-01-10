import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';

extension TBaseSiteMapper on TBaseSite {
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

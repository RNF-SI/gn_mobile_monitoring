import '../../domain/model/base_site.dart';
import '../entity/base_site_entity.dart';

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
    );
  }
}

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
    );
  }
}

import '../../domain/model/base_site.dart';
import '../entity/base_site_entity.dart';

extension SiteEntityMapper on BaseSiteEntity {
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

extension SiteMapper on BaseSite {
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

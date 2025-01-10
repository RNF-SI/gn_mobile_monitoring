import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

extension TSitesGroupMapper on TSitesGroup {
  SiteGroup toDomain() {
    return SiteGroup(
      idSitesGroup: idSitesGroup,
      sitesGroupName: sitesGroupName,
      sitesGroupCode: sitesGroupCode,
      sitesGroupDescription: sitesGroupDescription,
      uuidSitesGroup: uuidSitesGroup,
      comments: comments,
      data: data,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
      idDigitiser: idDigitiser,
      geom: geom,
      altitudeMin: altitudeMin,
      altitudeMax: altitudeMax,
    );
  }
}

extension SiteGroupMapper on SiteGroup {
  TSitesGroupsCompanion toDatabaseEntity() {
    return TSitesGroupsCompanion(
      idSitesGroup: Value(idSitesGroup),
      sitesGroupName: Value(sitesGroupName),
      sitesGroupCode: Value(sitesGroupCode),
      sitesGroupDescription: Value(sitesGroupDescription),
      uuidSitesGroup: Value(uuidSitesGroup),
      comments: Value(comments),
      data: Value(data),
      metaCreateDate: Value(metaCreateDate),
      metaUpdateDate: Value(metaUpdateDate),
      idDigitiser: Value(idDigitiser),
      geom: Value(geom),
      altitudeMin: Value(altitudeMin),
      altitudeMax: Value(altitudeMax),
    );
  }
}

import 'dart:convert'; // Needed for JSON encoding and decoding

import '../../domain/model/site_group.dart';
import '../entity/site_group_entity.dart';

extension SiteGroupEntityMapper on SiteGroupEntity {
  SiteGroup toDomain() {
    return SiteGroup(
      idSitesGroup: idSitesGroup,
      sitesGroupName: sitesGroupName,
      sitesGroupCode: sitesGroupCode,
      sitesGroupDescription: sitesGroupDescription,
      uuidSitesGroup: uuidSitesGroup,
      comments: comments,
      data: data != null ? jsonEncode(data) : null,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
      idDigitiser: idDigitiser,
      geom: geom,
      altitudeMin: altitudeMin,
      altitudeMax: altitudeMax,
    );
  }
}

extension DomainSiteGroupEntityMapper on SiteGroup {
  SiteGroupEntity toEntity() {
    return SiteGroupEntity(
      idSitesGroup: idSitesGroup,
      sitesGroupName: sitesGroupName,
      sitesGroupCode: sitesGroupCode,
      sitesGroupDescription: sitesGroupDescription,
      uuidSitesGroup: uuidSitesGroup,
      comments: comments,
      data: data != null ? jsonDecode(data!) as Map<String, dynamic> : null,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
      idDigitiser: idDigitiser,
      geom: geom,
      altitudeMin: altitudeMin,
      altitudeMax: altitudeMax,
    );
  }
}

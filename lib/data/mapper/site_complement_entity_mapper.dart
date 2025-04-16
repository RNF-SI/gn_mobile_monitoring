import 'dart:convert';

import 'package:gn_mobile_monitoring/data/entity/site_complement_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';

extension SiteComplementEntityMapper on SiteComplementEntity {
  SiteComplement toDomain() {
    return SiteComplement(
      idBaseSite: idBaseSite,
      idSitesGroup: idSitesGroup,
      data: data,
    );
  }
}

extension DomainSiteComplementEntityMapper on SiteComplement {
  SiteComplementEntity toEntity() {
    return SiteComplementEntity(
      idBaseSite: idBaseSite,
      idSitesGroup: idSitesGroup,
      data: data,
    );
  }

  /// Parse the data string (JSON) into a Map
  Map<String, dynamic>? parseData() {
    if (data == null || data!.isEmpty) {
      return null;
    }
    try {
      return json.decode(data!) as Map<String, dynamic>;
    } catch (e) {
      print('Error parsing site complement data: $e');
      return null;
    }
  }
}
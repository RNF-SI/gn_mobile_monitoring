import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';

extension TSiteComplementMapper on TSiteComplement {
  SiteComplement toDomain() {
    return SiteComplement(
      idBaseSite: idBaseSite,
      idSitesGroup: idSitesGroup,
      data: data,
    );
  }
}

extension SiteComplementMapper on SiteComplement {
  TSiteComplementsCompanion toDatabaseEntity() {
    return TSiteComplementsCompanion(
      idBaseSite: Value(idBaseSite),
      idSitesGroup: Value(idSitesGroup),
      data: Value(data),
    );
  }
}

// mapper for cor_sites_group_module

import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/sites_group_module.dart';

extension CorSitesGroupModuleMapper on CorSitesGroupModule {
  SitesGroupModule toDomain() {
    return SitesGroupModule(
      idSitesGroup: idSitesGroup,
      idModule: idModule,
    );
  }
}

extension SitesGroupModuleMapper on SitesGroupModule {
  CorSitesGroupModule toDatabaseEntity() {
    return CorSitesGroupModule(
      idSitesGroup: idSitesGroup,
      idModule: idModule,
    );
  }
}

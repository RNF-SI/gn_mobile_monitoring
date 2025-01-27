// create a mapper for cor_site_module inspired by cor_site_group_module_mapper.dart
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/site_module.dart';

extension CorSiteModuleMapper on CorSiteModule {
  SiteModule toDomain() {
    return SiteModule(idSite: idBaseSite, idModule: idModule);
  }
}

extension SiteModuleMapper on SiteModule {
  CorSiteModule toDatabaseEntity() {
    return CorSiteModule(idBaseSite: idSite, idModule: idModule);
  }
}

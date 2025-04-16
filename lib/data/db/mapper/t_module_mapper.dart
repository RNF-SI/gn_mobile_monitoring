import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

extension TModuleMapper on TModule {
  Module toDomain() {
    return Module(
      id: idModule,
      moduleCode: moduleCode,
      moduleLabel: moduleLabel,
      moduleDesc: moduleDesc,
      activeFrontend: activeFrontend ?? false,
      activeBackend: activeBackend ?? false,
      downloaded: downloaded,
    );
  }

  Module toDomainWithComplementSitesAndSiteGroups(ModuleComplement? complement,
      List<BaseSite> sites, List<SiteGroup> siteGroups) {
    return Module(
      id: idModule,
      moduleCode: moduleCode,
      moduleLabel: moduleLabel,
      moduleDesc: moduleDesc,
      activeFrontend: activeFrontend ?? false,
      activeBackend: activeBackend ?? false,
      downloaded: downloaded,
      complement: complement,
      sites: sites,
      sitesGroup: siteGroups, // Attach the fetched site groups
    );
  }
}

extension ModuleMapper on Module {
  TModule toDatabaseEntity() {
    return TModule(
      idModule: id,
      moduleCode: moduleCode, // Module code should never be null
      moduleLabel: moduleLabel,
      moduleDesc: moduleDesc,
      activeFrontend: activeFrontend ?? false,
      activeBackend: activeBackend ?? false,
      downloaded: downloaded ?? false, // New property
    );
  }
}

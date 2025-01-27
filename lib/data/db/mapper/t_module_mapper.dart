import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

extension TModuleMapper on TModule {
  Module toDomain() {
    return Module(
      id: idModule,
      moduleCode: moduleCode,
      moduleLabel: moduleLabel,
      moduleDesc: moduleDesc,
      activeFrontend: activeFrontend ?? false, // Default value
      activeBackend: activeBackend ?? false, // Default value
      downloaded: downloaded ?? false, // New property, default to false
    );
  }

  Module toDomainWithSiteGroups(List<SiteGroup> siteGroups) {
    return Module(
      id: idModule,
      moduleCode: moduleCode,
      moduleLabel: moduleLabel,
      moduleDesc: moduleDesc,
      activeFrontend: activeFrontend ?? false,
      activeBackend: activeBackend ?? false,
      downloaded: downloaded ?? false,
      sitesGroup: siteGroups, // Attach the fetched site groups
    );
  }
}

extension ModuleMapper on Module {
  TModule toDatabaseEntity() {
    return TModule(
      idModule: id,
      moduleCode: moduleCode ?? '', // Ensure a non-null value
      moduleLabel: moduleLabel ?? '',
      moduleDesc: moduleDesc,
      activeFrontend: activeFrontend ?? false,
      activeBackend: activeBackend ?? false,
      downloaded: downloaded ?? false, // New property
    );
  }
}

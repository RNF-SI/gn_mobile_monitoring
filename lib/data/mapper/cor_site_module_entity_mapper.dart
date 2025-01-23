import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/cor_site_module_entity.dart';

extension CorSiteModuleEntityMapper on CorSiteModuleEntity {
  CorSiteModule toDomain() {
    return CorSiteModule(
      idModule: idModule,
      idBaseSite: idBaseSite,
    );
  }
}

extension CorSiteModuleMapper on CorSiteModule {
  CorSiteModuleEntity toEntity() {
    return CorSiteModuleEntity(
      idModule: idModule,
      idBaseSite: idBaseSite,
    );
  }
}

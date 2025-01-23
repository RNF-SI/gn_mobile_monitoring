import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/cor_sites_group_module_entity.dart';

extension SitesGroupModuleEntityMapper on CorSitesGroupModuleEntity {
  CorSitesGroupModule toDomain() {
    return CorSitesGroupModule(
      idSitesGroup: idSitesGroup,
      idModule: idModule,
    );
  }
}

extension CorSitesGroupModuleMapper on CorSitesGroupModule {
  CorSitesGroupModuleEntity toEntity() {
    return CorSitesGroupModuleEntity(
      idSitesGroup: idSitesGroup,
      idModule: idModule,
    );
  }
}

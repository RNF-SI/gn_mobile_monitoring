import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';

extension TModuleMapper on TModule {
  Module toDomain() {
    return Module(
      id: idModule,
      moduleCode: moduleCode,
      moduleLabel: moduleLabel,
      modulePicto: modulePicto,
      moduleDesc: moduleDesc,
      moduleGroup: moduleGroup,
      modulePath: modulePath,
      moduleExternalUrl: moduleExternalUrl,
      moduleTarget: moduleTarget,
      moduleComment: moduleComment,
      activeFrontend: activeFrontend,
      activeBackend: activeBackend,
      moduleDocUrl: moduleDocUrl,
      moduleOrder: moduleOrder,
      ngModule: ngModule,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
    );
  }
}

import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/module_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';

class ModuleMapper {
  static Module toDomain(ModuleEntity entity) {
    return Module(
      id: 0,
      moduleCode: entity.moduleCode,
      moduleLabel: entity.moduleName,
      modulePicto: null,
      moduleDesc: null,
      moduleGroup: null,
      modulePath: null,
      moduleExternalUrl: null,
      moduleTarget: null,
      moduleComment: null,
      activeFrontend: null,
      activeBackend: null,
      moduleDocUrl: null,
      moduleOrder: null,
      ngModule: null,
      metaCreateDate: null,
      metaUpdateDate: null,
    );
  }

  static ModuleEntity fromDomain(Module module) {
    return ModuleEntity(
      moduleCode: module.moduleCode ?? '',
      moduleName: module.moduleLabel ?? '',
      cruved: {}, // Handle proper mapping
    );
  }

  static Module toDomainFromDatabase(TModule dbModule) {
    return Module(
      id: dbModule.idModule,
      moduleCode: dbModule.moduleCode,
      moduleLabel: dbModule.moduleLabel,
      modulePicto: dbModule.modulePicto,
      moduleDesc: dbModule.moduleDesc,
      moduleGroup: dbModule.moduleGroup,
      modulePath: dbModule.modulePath,
      moduleExternalUrl: dbModule.moduleExternalUrl,
      moduleTarget: dbModule.moduleTarget,
      moduleComment: dbModule.moduleComment,
      activeFrontend: dbModule.activeFrontend,
      activeBackend: dbModule.activeBackend,
      moduleDocUrl: dbModule.moduleDocUrl,
      moduleOrder: dbModule.moduleOrder,
      ngModule: dbModule.ngModule,
      metaCreateDate: dbModule.metaCreateDate,
      metaUpdateDate: dbModule.metaUpdateDate,
    );
  }

  static TModule toDatabaseEntity(Module module) {
    return TModule(
      idModule: module.id,
      moduleCode: module.moduleCode,
      moduleLabel: module.moduleLabel,
      modulePicto: module.modulePicto,
      moduleDesc: module.moduleDesc,
      moduleGroup: module.moduleGroup,
      modulePath: module.modulePath,
      moduleExternalUrl: module.moduleExternalUrl,
      moduleTarget: module.moduleTarget,
      moduleComment: module.moduleComment,
      activeFrontend: module.activeFrontend,
      activeBackend: module.activeBackend,
      moduleDocUrl: module.moduleDocUrl,
      moduleOrder: module.moduleOrder,
      ngModule: module.ngModule,
      metaCreateDate: module.metaCreateDate,
      metaUpdateDate: module.metaUpdateDate,
    );
  }
}

import 'package:gn_mobile_monitoring/data/entity/module_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';

extension ModuleEntityMapper on ModuleEntity {
  Module toDomain() {
    return Module(
      id: idModule,
      moduleCode: moduleCode,
      moduleLabel: moduleName,
      moduleDesc: moduleDesc,
      activeFrontend: null, // Si l'API ne fournit pas cette info
      activeBackend: null, // Si l'API ne fournit pas cette info
    );
  }
}

extension DomainModuleEntityMapper on Module {
  ModuleEntity toEntity() {
    return ModuleEntity(
      idModule: id,
      moduleCode: moduleCode ?? '',
      moduleName: moduleLabel ?? '',
      moduleDesc: moduleDesc,
      cruved: {}, // Placeholder, selon vos besoins
    );
  }
}

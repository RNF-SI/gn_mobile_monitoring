import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';

extension TModuleMapper on TModule {
  Module toDomain() {
    return Module(
      id: idModule,
      moduleCode: moduleCode,
      moduleLabel: moduleLabel,
      moduleDesc: moduleDesc,
      activeFrontend: activeFrontend,
      activeBackend: activeBackend,
    );
  }
}

extension ModuleMapper on Module {
  TModule toDatabaseEntity() {
    return TModule(
      idModule: id,
      moduleCode: moduleCode,
      moduleLabel: moduleLabel,
      moduleDesc: moduleDesc,
      activeFrontend: activeFrontend,
      activeBackend: activeBackend,
    );
  }
}

import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';

extension TModuleMapper on TModule {
  Module toDomain() {
    return Module(
      id: idModule,
      moduleCode: moduleCode,
      moduleLabel: moduleLabel,
      moduleDesc: moduleDesc,
      activeFrontend: activeFrontend ?? false, // Default value
      activeBackend: activeBackend ?? false, // Default value
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
    );
  }
}

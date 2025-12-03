import 'package:gn_mobile_monitoring/data/entity/module_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/cruved_response.dart';

extension ModuleEntityMapper on ModuleEntity {
  Module toDomain() {
    return Module(
      id: idModule,
      moduleCode: moduleCode,
      moduleLabel: moduleName,
      moduleDesc: moduleDesc,
      activeFrontend: null, // API may not provide this
      activeBackend: null, // API may not provide this
      downloaded: downloaded, // New property
      cruved: cruved != null ? CruvedResponse.fromJson(cruved!) : null,
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
      downloaded: downloaded == true, // New property
      cruved: cruved?.toJson(),
    );
  }
}

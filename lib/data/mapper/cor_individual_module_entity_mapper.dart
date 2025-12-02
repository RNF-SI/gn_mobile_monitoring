import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/cor_individual_module_entity.dart';

extension CorIndividualModuleEntityMapper on CorIndividualModuleEntity {
  CorIndividualModule toDomain() {
    return CorIndividualModule(
      idModule: idModule,
      idIndividual: idIndividual,
    );
  }
}

extension CorIndividualModuleMapper on CorIndividualModule {
  CorIndividualModuleEntity toEntity() {
    return CorIndividualModuleEntity(
      idModule: idModule,
      idIndividual: idIndividual,
    );
  }
}

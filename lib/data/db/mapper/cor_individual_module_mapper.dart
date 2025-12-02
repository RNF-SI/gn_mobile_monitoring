// create a mapper for cor_site_module inspired by cor_site_group_module_mapper.dart
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/individual_module.dart';

extension CorIndividualModuleMapper on CorIndividualModule {
  IndividualModule toDomain() {
    return IndividualModule(idIndividual: idIndividual, idModule: idModule);
  }
}

extension IndividualModuleMapper on IndividualModule {
  CorIndividualModule toDatabaseEntity() {
    return CorIndividualModule(idIndividual: idIndividual, idModule: idModule);
  }
}

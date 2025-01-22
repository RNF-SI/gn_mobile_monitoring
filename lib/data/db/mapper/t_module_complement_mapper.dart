import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';

extension TModuleComplementMapper on TModuleComplement {
  ModuleComplement toDomain() {
    return ModuleComplement(
      idModule: idModule,
      uuidModuleComplement: uuidModuleComplement,
      idListObserver: idListObserver,
      idListTaxonomy: idListTaxonomy,
      bSynthese: bSynthese,
      taxonomyDisplayFieldName: taxonomyDisplayFieldName,
      bDrawSitesGroup: bDrawSitesGroup,
      data: data,
      configuration: configuration,
    );
  }
}

extension ModuleComplementMapper on ModuleComplement {
  TModuleComplement toDatabaseEntity() {
    return TModuleComplement(
      idModule: idModule,
      uuidModuleComplement: uuidModuleComplement,
      idListObserver: idListObserver,
      idListTaxonomy: idListTaxonomy,
      bSynthese: bSynthese,
      taxonomyDisplayFieldName: taxonomyDisplayFieldName,
      bDrawSitesGroup: bDrawSitesGroup,
      data: data,
      configuration: configuration,
    );
  }
}

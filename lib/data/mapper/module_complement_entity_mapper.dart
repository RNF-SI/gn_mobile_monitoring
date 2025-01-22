import 'package:gn_mobile_monitoring/data/entity/module_complement_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';

extension ModuleComplementEntityMapper on ModuleComplementEntity {
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
    );
  }
}

extension DomainModuleComplementEntityMapper on ModuleComplement {
  ModuleComplementEntity toEntity() {
    return ModuleComplementEntity(
      idModule: idModule,
      uuidModuleComplement: uuidModuleComplement,
      idListObserver: idListObserver,
      idListTaxonomy: idListTaxonomy,
      bSynthese: bSynthese ?? false,
      taxonomyDisplayFieldName: taxonomyDisplayFieldName ?? '',
      bDrawSitesGroup: bDrawSitesGroup,
      data: data,
    );
  }
}

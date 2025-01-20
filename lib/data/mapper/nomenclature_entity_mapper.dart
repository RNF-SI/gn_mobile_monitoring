import 'package:gn_mobile_monitoring/data/entity/nomenclature_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';

extension NomenclatureEntityMapper on NomenclatureEntity {
  Nomenclature toDomain() {
    return Nomenclature(
      id: idNomenclature,
      idType: idType,
      cdNomenclature: cdNomenclature,
      mnemonique: mnemonique,
      labelDefault: labelDefault,
      definitionDefault: definitionDefault,
      labelFr: labelFr,
      definitionFr: definitionFr,
      labelEn: labelEn,
      definitionEn: definitionEn,
      labelEs: labelEs,
      definitionEs: definitionEs,
      labelDe: labelDe,
      definitionDe: definitionDe,
      labelIt: labelIt,
      definitionIt: definitionIt,
      source: source,
      statut: statut,
      idBroader: idBroader,
      hierarchy: hierarchy,
      active: active,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
    );
  }
}

extension DomainNomenclatureEntityMapper on Nomenclature {
  NomenclatureEntity toEntity() {
    return NomenclatureEntity(
      idNomenclature: id,
      idType: idType,
      cdNomenclature: cdNomenclature,
      mnemonique: mnemonique,
      labelDefault: labelDefault,
      definitionDefault: definitionDefault,
      labelFr: labelFr,
      definitionFr: definitionFr,
      labelEn: labelEn,
      definitionEn: definitionEn,
      labelEs: labelEs,
      definitionEs: definitionEs,
      labelDe: labelDe,
      definitionDe: definitionDe,
      labelIt: labelIt,
      definitionIt: definitionIt,
      source: source,
      statut: statut,
      idBroader: idBroader,
      hierarchy: hierarchy,
      active: active == true ? true : false,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
    );
  }
}

import 'package:gn_mobile_monitoring/data/entity/nomenclature_type_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature_type.dart';

extension NomenclatureTypeEntityMapper on NomenclatureTypeEntity {
  NomenclatureType toDomain() {
    return NomenclatureType(
      idType: idType,
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
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
    );
  }
}

extension DomainNomenclatureTypeEntityMapper on NomenclatureType {
  NomenclatureTypeEntity toEntity() {
    return NomenclatureTypeEntity(
      idType: idType,
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
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
    );
  }
}
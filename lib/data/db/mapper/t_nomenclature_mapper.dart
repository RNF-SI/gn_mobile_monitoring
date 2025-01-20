import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';

extension TNomenclatureMapper on TNomenclature {
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
      active: active ?? false, // Default to false if null
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
    );
  }
}

extension NomenclatureMapper on Nomenclature {
  TNomenclature toDatabaseEntity() {
    return TNomenclature(
      idNomenclature: id,
      idType: idType,
      cdNomenclature: cdNomenclature ?? '', // Ensure a non-null value
      mnemonique: mnemonique ?? '',
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
      active: active ?? true, // Default to true if null
      metaCreateDate: metaCreateDate != null ? metaUpdateDate! : DateTime.now(),
      metaUpdateDate: metaUpdateDate,
    );
  }
}

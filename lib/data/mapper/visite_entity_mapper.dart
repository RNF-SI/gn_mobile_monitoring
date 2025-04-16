import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/base_visit_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';

import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';

extension VisiteEntityMapper on BaseVisitEntity {
  BaseVisit toDomain() {
    // Normaliser les données (champs d'heure, etc.) avant de créer l'objet de domaine
    Map<String, dynamic>? normalizedData;
    
    if (data != null) {
      normalizedData = {};
      // Traiter chaque entrée pour s'assurer qu'elle est dans le bon format
      data!.forEach((key, value) {
        // Pour les champs d'heure, normaliser le format
        if (key.toLowerCase().contains('time') && 
            !key.toLowerCase().contains('date') &&
            value is String) {
          normalizedData![key] = normalizeTimeFormat(value);
        } else {
          normalizedData![key] = value;
        }
      });
    }
    
    return BaseVisit(
      idBaseVisit: idBaseVisit,
      idBaseSite: idBaseSite,
      idDataset: idDataset,
      idModule: idModule,
      idDigitiser: idDigitiser,
      visitDateMin: visitDateMin,
      visitDateMax: visitDateMax,
      idNomenclatureTechCollectCampanule: idNomenclatureTechCollectCampanule,
      idNomenclatureGrpTyp: idNomenclatureGrpTyp,
      comments: comments,
      uuidBaseVisit: uuidBaseVisit,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
      observers: observers,
      data: normalizedData,
    );
  }

  TBaseVisitsCompanion toCompanion() {
    return TBaseVisitsCompanion(
      // Pour les nouvelles visites (ID=0), utiliser Value.absent() pour laisser SQLite générer un ID
      idBaseVisit: idBaseVisit == 0 ? const Value.absent() : Value(idBaseVisit),
      idBaseSite: idBaseSite == null ? const Value.absent() : Value(idBaseSite),
      idDataset: Value(idDataset),
      idModule: Value(idModule),
      idDigitiser:
          idDigitiser == null ? const Value.absent() : Value(idDigitiser),
      visitDateMin: Value(visitDateMin),
      visitDateMax:
          visitDateMax == null ? const Value.absent() : Value(visitDateMax),
      idNomenclatureTechCollectCampanule:
          idNomenclatureTechCollectCampanule == null
              ? const Value.absent()
              : Value(idNomenclatureTechCollectCampanule),
      idNomenclatureGrpTyp: idNomenclatureGrpTyp == null
          ? const Value.absent()
          : Value(idNomenclatureGrpTyp),
      comments: comments == null ? const Value.absent() : Value(comments),
      uuidBaseVisit:
          uuidBaseVisit == null ? const Value.absent() : Value(uuidBaseVisit),
      metaCreateDate: const Value.absent(),
      metaUpdateDate: const Value.absent(),
    );
  }
}

extension BaseVisitMapper on BaseVisit {
  BaseVisitEntity toEntity() {
    return BaseVisitEntity(
      idBaseVisit: idBaseVisit,
      idBaseSite: idBaseSite,
      idDataset: idDataset,
      idModule: idModule,
      idDigitiser: idDigitiser,
      visitDateMin: visitDateMin,
      visitDateMax: visitDateMax,
      idNomenclatureTechCollectCampanule: idNomenclatureTechCollectCampanule,
      idNomenclatureGrpTyp: idNomenclatureGrpTyp,
      comments: comments,
      uuidBaseVisit: uuidBaseVisit,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
      observers: observers,
      data: data,
    );
  }
}

extension TBaseVisitMapper on TBaseVisit {
  BaseVisitEntity toEntity() {
    return BaseVisitEntity(
      idBaseVisit: idBaseVisit,
      idBaseSite: idBaseSite,
      idDataset: idDataset,
      idModule: idModule,
      idDigitiser: idDigitiser,
      visitDateMin: visitDateMin,
      visitDateMax: visitDateMax,
      idNomenclatureTechCollectCampanule: idNomenclatureTechCollectCampanule,
      idNomenclatureGrpTyp: idNomenclatureGrpTyp,
      comments: comments,
      uuidBaseVisit: uuidBaseVisit,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
      // Note: observers and data need to be loaded separately
    );
  }
}

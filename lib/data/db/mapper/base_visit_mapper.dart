import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/base_visit_entity.dart';

extension BaseVisitMapper on TBaseVisit {
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
    );
  }
}

extension BaseVisitEntityMapper on BaseVisitEntity {
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

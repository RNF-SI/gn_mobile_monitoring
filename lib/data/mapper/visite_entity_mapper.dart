import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/base_visit_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';

extension VisiteEntityMapper on BaseVisitEntity {
  BaseVisit toDomain() {
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
    );
  }

  TBaseVisitsCompanion toCompanion() {
    return TBaseVisitsCompanion(
      idBaseVisit: Value(idBaseVisit),
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
    );
  }
}

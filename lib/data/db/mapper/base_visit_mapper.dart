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
      serverVisitId: serverVisitId, // 🔧 FIX: Ajouter le mapping du serverVisitId
    );
  }
}

extension BaseVisitEntityMapper on BaseVisitEntity {
  TBaseVisitsCompanion toCompanion() {
    final nowIso = DateTime.now().toIso8601String();
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
      serverVisitId: serverVisitId == null ? const Value.absent() : Value(serverVisitId), // 🔧 FIX: Ajouter le mapping du serverVisitId
      // Aligné sur GeoNature web (DEFAULT now() côté Postgres) : on fournit
      // explicitement la date côté client, fallback maintenant si l'entité
      // n'en a pas. L'ancien DEFAULT était la chaîne littérale
      // "CURRENT_TIMESTAMP" — corrigé sur le stock par migration029.
      metaCreateDate: Value(metaCreateDate ?? nowIso),
      metaUpdateDate: Value(metaUpdateDate ?? nowIso),
    );
  }

  /// Companion pour un UPDATE : préserve `metaCreateDate` (jamais réécrite)
  /// et force `metaUpdateDate` à maintenant.
  TBaseVisitsCompanion toCompanionForUpdate() {
    return toCompanion().copyWith(
      metaCreateDate: const Value.absent(),
      metaUpdateDate: Value(DateTime.now().toIso8601String()),
    );
  }
}

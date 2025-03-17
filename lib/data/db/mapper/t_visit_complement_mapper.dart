import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/visit_complement_entity.dart';

/// Mapper entre TVisitComplement (table) et VisitComplementEntity
class TVisitComplementMapper {
  /// Convertit un objet TVisitComplement en VisitComplementEntity
  static VisitComplementEntity toEntity(TVisitComplement model) {
    return VisitComplementEntity(
      idBaseVisit: model.idBaseVisit,
      data: model.data,
    );
  }

  /// Convertit un VisitComplementEntity en TVisitComplementsCompanion pour insertion/mise à jour
  static TVisitComplementsCompanion toCompanion(VisitComplementEntity entity) {
    return TVisitComplementsCompanion(
      idBaseVisit: Value(entity.idBaseVisit),
      data: Value(entity.data),
    );
  }
}
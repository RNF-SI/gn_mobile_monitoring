import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_visit_observer.dart';
import 'package:gn_mobile_monitoring/data/entity/cor_visit_observer_entity.dart';

/// Mapper pour convertir entre les objets de base de données et les entités CorVisitObserver
class CorVisitObserverMapper {
  /// Convertit un objet de base de données en entité
  static CorVisitObserverEntity toEntity(CorVisitObserverData data) {
    return CorVisitObserverEntity(
      idBaseVisit: data.idBaseVisit,
      idRole: data.idRole,
      uniqueIdCoreVisitObserver: data.uniqueIdCoreVisitObserver,
    );
  }

  /// Convertit une entité en compagnon pour insertion/mise à jour
  static CorVisitObserverCompanion toCompanion(CorVisitObserverEntity entity) {
    return CorVisitObserverCompanion(
      idBaseVisit: Value(entity.idBaseVisit),
      idRole: Value(entity.idRole),
      uniqueIdCoreVisitObserver: Value(entity.uniqueIdCoreVisitObserver),
    );
  }
}
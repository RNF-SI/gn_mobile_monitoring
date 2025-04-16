import 'package:gn_mobile_monitoring/data/entity/cor_visit_observer_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/visit_observer.dart';

/// Mapper pour convertir entre les entités CorVisitObserver et les modèles de domaine VisitObserver
class VisitObserverEntityMapper {
  /// Convertit une entité en modèle de domaine
  static VisitObserver toDomain(CorVisitObserverEntity entity) {
    return VisitObserver(
      idBaseVisit: entity.idBaseVisit,
      idRole: entity.idRole,
      uniqueId: entity.uniqueIdCoreVisitObserver,
    );
  }

  /// Convertit un modèle de domaine en entité
  static CorVisitObserverEntity toEntity(VisitObserver domain) {
    return CorVisitObserverEntity(
      idBaseVisit: domain.idBaseVisit,
      idRole: domain.idRole,
      uniqueIdCoreVisitObserver: domain.uniqueId,
    );
  }

  /// Convertit une liste d'entités en liste de modèles de domaine
  static List<VisitObserver> toDomainList(List<CorVisitObserverEntity> entities) {
    return entities.map((entity) => toDomain(entity)).toList();
  }

  /// Convertit une liste de modèles de domaine en liste d'entités
  static List<CorVisitObserverEntity> toEntityList(List<VisitObserver> domains) {
    return domains.map((domain) => toEntity(domain)).toList();
  }
}
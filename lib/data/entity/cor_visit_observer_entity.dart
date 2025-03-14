class CorVisitObserverEntity {
  final int idBaseVisit;
  final int idRole;
  final String uniqueIdCoreVisitObserver;

  CorVisitObserverEntity({
    required this.idBaseVisit,
    required this.idRole,
    required this.uniqueIdCoreVisitObserver,
  });

  // Factory method to convert JSON to entity
  factory CorVisitObserverEntity.fromJson(Map<String, dynamic> json) {
    return CorVisitObserverEntity(
      idBaseVisit: json['id_base_visit'] as int,
      idRole: json['id_role'] as int,
      uniqueIdCoreVisitObserver: json['unique_id_core_visit_observer'] as String,
    );
  }

  // Method to convert entity to JSON
  Map<String, dynamic> toJson() {
    return {
      'id_base_visit': idBaseVisit,
      'id_role': idRole,
      'unique_id_core_visit_observer': uniqueIdCoreVisitObserver,
    };
  }
}
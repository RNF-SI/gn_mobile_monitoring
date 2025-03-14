import 'package:freezed_annotation/freezed_annotation.dart';

part 'cor_visit_observer_entity.freezed.dart';
part 'cor_visit_observer_entity.g.dart';

@freezed
class CorVisitObserverEntity with _$CorVisitObserverEntity {
  const factory CorVisitObserverEntity({
    required int idBaseVisit,
    required int idRole,
    required String uniqueIdCoreVisitObserver,
  }) = _CorVisitObserverEntity;

  factory CorVisitObserverEntity.fromJson(Map<String, dynamic> json) =>
      _$CorVisitObserverEntityFromJson(json);
}
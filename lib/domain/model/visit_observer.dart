import 'package:freezed_annotation/freezed_annotation.dart';

part 'visit_observer.freezed.dart';

@freezed
class VisitObserver with _$VisitObserver {
  const factory VisitObserver({
    required int idBaseVisit,
    required int idRole,
    required String uniqueId,
  }) = _VisitObserver;
}
import 'package:freezed_annotation/freezed_annotation.dart';

part 'visit_complement.freezed.dart';

@freezed
class VisitComplement with _$VisitComplement {
  const factory VisitComplement({
    required int idBaseVisit,
    String? data,
  }) = _VisitComplement;
}
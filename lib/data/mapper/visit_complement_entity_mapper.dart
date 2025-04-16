import '../../domain/model/visit_complement.dart';
import '../entity/visit_complement_entity.dart';

extension VisitComplementEntityMapper on VisitComplementEntity {
  VisitComplement toDomain() {
    return VisitComplement(
      idBaseVisit: idBaseVisit,
      data: data,
    );
  }
}

extension VisitComplementMapper on VisitComplement {
  VisitComplementEntity toEntity() {
    return VisitComplementEntity(
      idBaseVisit: idBaseVisit,
      data: data,
    );
  }
}
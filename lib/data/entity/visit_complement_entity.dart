class VisitComplementEntity {
  final int idBaseVisit;
  final String? data;

  VisitComplementEntity({
    required this.idBaseVisit,
    this.data,
  });

  factory VisitComplementEntity.fromJson(Map<String, dynamic> json) {
    return VisitComplementEntity(
      idBaseVisit: json['idBaseVisit'] as int,
      data: json['data'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idBaseVisit': idBaseVisit,
      'data': data,
    };
  }
}
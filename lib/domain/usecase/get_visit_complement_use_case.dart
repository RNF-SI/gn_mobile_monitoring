import 'package:gn_mobile_monitoring/domain/model/visit_complement.dart';

/// Use case pour récupérer les données complémentaires d'une visite
abstract class GetVisitComplementUseCase {
  /// Récupère les données complémentaires d'une visite par son ID
  Future<VisitComplement?> execute(int visitId);
}
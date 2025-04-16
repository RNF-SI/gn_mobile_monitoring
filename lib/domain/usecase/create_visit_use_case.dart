import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';

abstract class CreateVisitUseCase {
  /// Crée une nouvelle visite dans la base de données
  /// 
  /// Prend en paramètre un objet [BaseVisit] contenant les données de la visite à créer
  /// Retourne l'ID de la visite créée
  Future<int> execute(BaseVisit visit);
}
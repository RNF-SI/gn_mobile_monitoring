import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';

abstract class UpdateVisitUseCase {
  /// Met à jour une visite existante dans la base de données
  /// 
  /// Prend en paramètre un objet [BaseVisit] contenant les données mises à jour
  /// Retourne true si la mise à jour a réussi, false sinon
  Future<bool> execute(BaseVisit visit);
}
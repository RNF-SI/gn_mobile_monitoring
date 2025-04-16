import 'package:gn_mobile_monitoring/domain/model/visit_complement.dart';

/// Use case pour sauvegarder les données complémentaires d'une visite
abstract class SaveVisitComplementUseCase {
  /// Sauvegarde les données complémentaires d'une visite
  Future<void> execute(VisitComplement complement);
}
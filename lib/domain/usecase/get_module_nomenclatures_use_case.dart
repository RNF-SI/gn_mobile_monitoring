import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';

abstract class GetModuleNomenclaturesUseCase {
  /// Récupère toutes les nomenclatures associées à un module spécifique
  /// en se basant sur sa configuration
  Future<List<Nomenclature>> execute(int moduleId);
}
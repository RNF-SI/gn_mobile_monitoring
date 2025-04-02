import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';

abstract class GetNomenclaturesUseCase {
  /// Récupère toutes les nomenclatures stockées localement
  Future<List<Nomenclature>> execute();
  
  /// Récupère les nomenclatures filtrées par type
  Future<List<Nomenclature>> executeByType(int idType);

  /// Récupère les nomenclatures filtrées par code de type
  Future<List<Nomenclature>> executeByTypeCode(String typeCode);
}
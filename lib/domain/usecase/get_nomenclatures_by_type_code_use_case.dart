import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';

abstract class GetNomenclaturesByTypeCodeUseCase {
  /// Récupère les nomenclatures filtrées par code de type (par exemple 'TYPE_MEDIA')
  Future<List<Nomenclature>> execute(String typeCode);
}
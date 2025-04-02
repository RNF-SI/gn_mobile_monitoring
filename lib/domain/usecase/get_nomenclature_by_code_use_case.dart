import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';

abstract class GetNomenclatureByCodeUseCase {
  /// Récupère une nomenclature spécifique par son type (typeCode) et son code (cdNomenclature)
  /// Retourne null si la nomenclature n'est pas trouvée
  Future<Nomenclature?> execute(String typeCode, String cdNomenclature);
}
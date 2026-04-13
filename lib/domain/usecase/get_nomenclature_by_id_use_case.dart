import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';

/// Interface pour récupérer une nomenclature par son ID
abstract class GetNomenclatureByIdUseCase {
  /// Récupère une nomenclature par son ID
  /// Retourne null si aucune nomenclature n'est trouvée
  Future<Nomenclature?> execute(int id);
}
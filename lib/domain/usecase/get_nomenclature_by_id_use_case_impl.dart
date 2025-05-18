import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclature_by_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclatures_use_case.dart';

class GetNomenclatureByIdUseCaseImpl implements GetNomenclatureByIdUseCase {
  final GetNomenclaturesUseCase _getNomenclaturesUseCase;

  GetNomenclatureByIdUseCaseImpl(this._getNomenclaturesUseCase);

  @override
  Future<Nomenclature?> execute(int id) async {
    try {
      // Récupérer toutes les nomenclatures
      final nomenclatures = await _getNomenclaturesUseCase.execute();
      
      // Rechercher par ID
      for (final nomenclature in nomenclatures) {
        if (nomenclature.id == id) {
          return nomenclature;
        }
      }
      
      return null;
    } catch (e) {
      // En cas d'erreur, retourner null
      return null;
    }
  }
}
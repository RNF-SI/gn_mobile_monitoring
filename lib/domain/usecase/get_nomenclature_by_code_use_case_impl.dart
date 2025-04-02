import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclature_by_code_use_case.dart';

class GetNomenclatureByCodeUseCaseImpl implements GetNomenclatureByCodeUseCase {
  final ModulesRepository _repository;

  GetNomenclatureByCodeUseCaseImpl(this._repository);

  @override
  Future<Nomenclature?> execute(String typeCode, String cdNomenclature) async {
    final mappings = await _repository.getNomenclatureTypeMapping();
    
    // Si le code de type n'existe pas dans le mapping, retourne null
    if (!mappings.containsKey(typeCode)) {
      return null;
    }
    
    final idType = mappings[typeCode];
    final nomenclatures = await _repository.getNomenclatures();
    
    try {
      return nomenclatures.firstWhere(
        (n) => n.idType == idType && n.cdNomenclature == cdNomenclature
      );
    } catch (e) {
      // Si la nomenclature n'est pas trouvée, retourne null
      return null;
    }
  }
}
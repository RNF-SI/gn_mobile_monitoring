import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclatures_by_type_code_use_case.dart';

class GetNomenclaturesByTypeCodeUseCaseImpl implements GetNomenclaturesByTypeCodeUseCase {
  final ModulesRepository _repository;

  GetNomenclaturesByTypeCodeUseCaseImpl(this._repository);

  @override
  Future<List<Nomenclature>> execute(String typeCode) async {
    // Le typeCode peut être un code de type (TYPE_MEDIA) ou une mnémonique (STADE_VIE)
    int? idType;
    
    // Essayer d'abord avec le mapping standard
    final mappings = await _repository.getNomenclatureTypeMapping();
    if (mappings.containsKey(typeCode)) {
      idType = mappings[typeCode];
    } else {
      // Si non trouvé, essayer avec la recherche directe par mnémonique
      idType = await _repository.getNomenclatureTypeIdByMnemonique(typeCode);
    }
    
    // Si aucun idType n'est trouvé, retourner une liste vide
    if (idType == null) {
      return [];
    }
    
    // Récupérer toutes les nomenclatures et filtrer par idType
    final nomenclatures = await _repository.getNomenclatures();
    return nomenclatures.where((n) => n.idType == idType).toList();
  }
}
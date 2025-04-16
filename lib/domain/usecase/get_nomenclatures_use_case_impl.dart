import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclatures_use_case.dart';

class GetNomenclaturesUseCaseImpl implements GetNomenclaturesUseCase {
  final ModulesRepository _repository;

  GetNomenclaturesUseCaseImpl(this._repository);

  @override
  Future<List<Nomenclature>> execute() async {
    return await _repository.getNomenclatures();
  }

  @override
  Future<List<Nomenclature>> executeByType(int idType) async {
    final nomenclatures = await _repository.getNomenclatures();
    return nomenclatures.where((n) => n.idType == idType).toList();
  }

  @override
  Future<List<Nomenclature>> executeByTypeCode(String typeCode) async {
    final mappings = await _repository.getNomenclatureTypeMapping();
    
    // Si le code de type n'existe pas dans le mapping, retourne une liste vide
    if (!mappings.containsKey(typeCode)) {
      return [];
    }
    
    final idType = mappings[typeCode];
    return executeByType(idType!);
  }
}
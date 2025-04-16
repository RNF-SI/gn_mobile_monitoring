import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';

abstract class GetModuleTaxonsUseCase {
  Future<List<Taxon>> execute(int moduleId);
}

class GetModuleTaxonsUseCaseImpl implements GetModuleTaxonsUseCase {
  final TaxonRepository _taxonRepository;

  GetModuleTaxonsUseCaseImpl(this._taxonRepository);

  @override
  Future<List<Taxon>> execute(int moduleId) {
    return _taxonRepository.getTaxonsByModuleId(moduleId);
  }
}
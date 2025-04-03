import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';

abstract class SearchTaxonsUseCase {
  Future<List<Taxon>> execute(String searchTerm);
}

class SearchTaxonsUseCaseImpl implements SearchTaxonsUseCase {
  final TaxonRepository _taxonRepository;

  SearchTaxonsUseCaseImpl(this._taxonRepository);

  @override
  Future<List<Taxon>> execute(String searchTerm) {
    return _taxonRepository.searchTaxons(searchTerm);
  }
}

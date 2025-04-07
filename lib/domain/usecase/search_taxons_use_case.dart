import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';

abstract class SearchTaxonsUseCase {
  Future<List<Taxon>> execute(String searchTerm, {int? idListe});
}

class SearchTaxonsUseCaseImpl implements SearchTaxonsUseCase {
  final TaxonRepository _taxonRepository;

  SearchTaxonsUseCaseImpl(this._taxonRepository);

  @override
  Future<List<Taxon>> execute(String searchTerm, {int? idListe}) {
    if (idListe != null) {
      return _taxonRepository.searchTaxonsByListId(searchTerm, idListe);
    }
    return _taxonRepository.searchTaxons(searchTerm);
  }
}

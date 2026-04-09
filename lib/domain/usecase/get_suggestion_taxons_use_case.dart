import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';

abstract class GetSuggestionTaxonsUseCase {
  Future<List<Taxon>> execute(int idListe, {int limit});
}

class GetSuggestionTaxonsUseCaseImpl implements GetSuggestionTaxonsUseCase {
  final TaxonRepository _taxonRepository;

  GetSuggestionTaxonsUseCaseImpl(this._taxonRepository);

  @override
  Future<List<Taxon>> execute(int idListe, {int limit = 10}) {
    return _taxonRepository.getSuggestionTaxons(idListe, limit: limit);
  }
}

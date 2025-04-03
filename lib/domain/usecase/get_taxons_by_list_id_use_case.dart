import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';

abstract class GetTaxonsByListIdUseCase {
  Future<List<Taxon>> execute(int listId);
}

class GetTaxonsByListIdUseCaseImpl implements GetTaxonsByListIdUseCase {
  final TaxonRepository _taxonRepository;

  GetTaxonsByListIdUseCaseImpl(this._taxonRepository);

  @override
  Future<List<Taxon>> execute(int listId) {
    return _taxonRepository.getTaxonsByListId(listId);
  }
}

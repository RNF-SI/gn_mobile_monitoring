import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';

abstract class IsTaxonInListUseCase {
  Future<bool> execute(int cdNom, int idListe);
}

class IsTaxonInListUseCaseImpl implements IsTaxonInListUseCase {
  final TaxonRepository _taxonRepository;

  IsTaxonInListUseCaseImpl(this._taxonRepository);

  @override
  Future<bool> execute(int cdNom, int idListe) {
    return _taxonRepository.isTaxonInList(cdNom, idListe);
  }
}

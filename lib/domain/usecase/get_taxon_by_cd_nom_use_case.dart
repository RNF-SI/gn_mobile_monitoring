import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';

abstract class GetTaxonByCdNomUseCase {
  Future<Taxon?> execute(int cdNom);
}

class GetTaxonByCdNomUseCaseImpl implements GetTaxonByCdNomUseCase {
  final TaxonRepository _taxonRepository;

  GetTaxonByCdNomUseCaseImpl(this._taxonRepository);

  @override
  Future<Taxon?> execute(int cdNom) {
    return _taxonRepository.getTaxonByCdNom(cdNom);
  }
}

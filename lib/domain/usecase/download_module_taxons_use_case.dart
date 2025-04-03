import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';

abstract class DownloadModuleTaxonsUseCase {
  Future<void> execute(int moduleId);
}

class DownloadModuleTaxonsUseCaseImpl implements DownloadModuleTaxonsUseCase {
  final TaxonRepository _taxonRepository;

  DownloadModuleTaxonsUseCaseImpl(this._taxonRepository);

  @override
  Future<void> execute(int moduleId) {
    return _taxonRepository.downloadModuleTaxons(moduleId);
  }
}

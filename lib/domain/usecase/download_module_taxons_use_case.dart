import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';

abstract class DownloadModuleTaxonsUseCase {
  Future<void> execute(int moduleId, String token);
}

class DownloadModuleTaxonsUseCaseImpl implements DownloadModuleTaxonsUseCase {
  final TaxonRepository _taxonRepository;

  DownloadModuleTaxonsUseCaseImpl(this._taxonRepository);

  @override
  Future<void> execute(int moduleId, String token) {
    return _taxonRepository.downloadModuleTaxons(moduleId, token);
  }
}

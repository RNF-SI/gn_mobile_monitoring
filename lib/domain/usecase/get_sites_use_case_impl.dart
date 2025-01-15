import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_use_case.dart';

class GetSitesUseCaseImpl implements GetSitesUseCase {
  final SitesRepository _sitesRepository;

  GetSitesUseCaseImpl(this._sitesRepository);

  @override
  Future<List<BaseSite>> execute() {
    return _sitesRepository.getSites();
  }
}

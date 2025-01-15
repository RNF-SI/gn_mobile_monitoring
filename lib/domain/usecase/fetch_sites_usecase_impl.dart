import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_sites_usecase.dart';

class FetchSitesUseCaseImpl implements FetchSitesUseCase {
  final SitesRepository _sitesRepository;

  FetchSitesUseCaseImpl(this._sitesRepository);

  @override
  Future<List<BaseSite>> execute(String token) async {
    return await _sitesRepository.fetchSites(token);
  }
}

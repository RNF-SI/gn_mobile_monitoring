import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_sites_and_site_groups_usecase.dart';

class FetchSitesAndSiteGroupsUseCaseImpl
    implements FetchSitesAndSiteGroupsUseCase {
  final SitesRepository _sitesRepository;

  FetchSitesAndSiteGroupsUseCaseImpl(this._sitesRepository);

  @override
  Future<void> execute(String token) async {
    await _sitesRepository.fetchSites(token);
    await _sitesRepository.fetchSiteGroups(token);
  }
}

import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_site_groups_usecase.dart';

class FetchSiteGroupsUsecaseImpl implements FetchSiteGroupsUsecase {
  final SitesRepository _sitesRepository;

  FetchSiteGroupsUsecaseImpl(this._sitesRepository);

  @override
  Future<List<SiteGroup>> execute(String token) {
    return _sitesRepository.fetchSiteGroups(token);
  }
}

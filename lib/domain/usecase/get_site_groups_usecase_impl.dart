import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_groups_usecase.dart';

class GetSiteGroupsUseCaseImpl implements GetSiteGroupsUseCase {
  final SitesRepository _sitesRepository;

  GetSiteGroupsUseCaseImpl(this._sitesRepository);

  @override
  Future<List<SiteGroup>> execute() {
    return _sitesRepository.getSiteGroups();
  }
}

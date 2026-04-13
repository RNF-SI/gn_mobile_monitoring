import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_groups_by_id_usecase.dart';

class GetSiteGroupsByIdUseCaseImpl implements GetSiteGroupsByIdUseCase {
  final SitesRepository _sitesRepository;

  GetSiteGroupsByIdUseCaseImpl(this._sitesRepository);

  @override
  Future<SiteGroup?> execute(int siteGroupId) {
    return _sitesRepository.getSiteGroupsById(siteGroupId);
  }
}

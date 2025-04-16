import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_by_site_group_usecase.dart';

class GetSitesBySiteGroupUseCaseImpl implements GetSitesBySiteGroupUseCase {
  final SitesRepository _sitesRepository;

  GetSitesBySiteGroupUseCaseImpl(this._sitesRepository);

  @override
  Future<List<BaseSite>> execute(int siteGroupId) async {
    return await _sitesRepository.getSitesBySiteGroup(siteGroupId);
  }
}
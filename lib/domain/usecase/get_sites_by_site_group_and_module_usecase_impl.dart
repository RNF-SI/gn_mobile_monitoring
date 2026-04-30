import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_by_site_group_and_module_usecase.dart';

class GetSitesBySiteGroupAndModuleUseCaseImpl
    implements GetSitesBySiteGroupAndModuleUseCase {
  final SitesRepository _sitesRepository;

  GetSitesBySiteGroupAndModuleUseCaseImpl(this._sitesRepository);

  @override
  Future<List<BaseSite>> execute(int siteGroupId, int moduleId) async {
    return await _sitesRepository
        .getSitesBySiteGroupAndModule(siteGroupId, moduleId);
  }
}

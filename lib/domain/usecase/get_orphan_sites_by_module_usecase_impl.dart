import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_orphan_sites_by_module_usecase.dart';

class GetOrphanSitesByModuleUseCaseImpl
    implements GetOrphanSitesByModuleUseCase {
  final SitesRepository _sitesRepository;

  GetOrphanSitesByModuleUseCaseImpl(this._sitesRepository);

  @override
  Future<List<BaseSite>> execute(int moduleId) async {
    return await _sitesRepository.getOrphanSitesByModuleId(moduleId);
  }
}

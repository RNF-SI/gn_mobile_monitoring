import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_and_sync_modules_and_sites_usecase.dart';

class FetchAndSyncModulesAndSitesUseCaseImpl
    implements FetchAndSyncModulesAndSitesUseCase {
  final ModulesRepository _modulesRepository;
  final SitesRepository _sitesRepository;

  const FetchAndSyncModulesAndSitesUseCaseImpl(
    this._modulesRepository,
    this._sitesRepository,
  );

  @override
  Future<void> execute(String token) async {
    // First fetch and sync modules as sites depend on them
    await _modulesRepository.fetchAndSyncModulesFromApi(token);

    // Then fetch sites and site groups
    await _sitesRepository.fetchSitesAndSiteModules(token);
    await _sitesRepository.fetchSiteGroupsAndSitesGroupModules(token);
  }
}

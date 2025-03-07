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
    try {
      // First fetch and sync modules as sites depend on them
      await _modulesRepository.fetchAndSyncModulesFromApi(token);

      // Then fetch sites and site groups using the new approach
      // These methods now use the /monitorings/object/{module_code}/module endpoint
      await _sitesRepository.fetchSitesAndSiteModules(token);
      await _sitesRepository.fetchSiteGroupsAndSitesGroupModules(token);
    } catch (e) {
      print('Error in FetchAndSyncModulesAndSitesUseCase: $e');
      rethrow;
    }
  }
}

import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_site_groups_usecase.dart';

class IncrementalSyncSiteGroupsUseCaseImpl implements IncrementalSyncSiteGroupsUseCase {
  final SitesRepository _sitesRepository;

  const IncrementalSyncSiteGroupsUseCaseImpl(this._sitesRepository);

  @override
  Future<void> execute(String token) async {
    try {
      await _sitesRepository.incrementalSyncSiteGroupsAndSitesGroupModules(token);
    } catch (e) {
      print('Error in IncrementalSyncSiteGroupsUseCase: $e');
      rethrow;
    }
  }
}
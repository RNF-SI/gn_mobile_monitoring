import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_sites_usecase.dart';

class IncrementalSyncSitesUseCaseImpl implements IncrementalSyncSitesUseCase {
  final SitesRepository _sitesRepository;

  const IncrementalSyncSitesUseCaseImpl(this._sitesRepository);

  @override
  Future<void> execute(String token) async {
    try {
      await _sitesRepository.incrementalSyncSitesAndSiteModules(token);
    } catch (e) {
      print('Error in IncrementalSyncSitesUseCase: $e');
      rethrow;
    }
  }
}
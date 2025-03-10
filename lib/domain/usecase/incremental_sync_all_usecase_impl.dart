import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_all_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_sites_usecase.dart';

class IncrementalSyncAllUseCaseImpl implements IncrementalSyncAllUseCase {
  final IncrementalSyncModulesUseCase _incrementalSyncModulesUseCase;
  final IncrementalSyncSitesUseCase _incrementalSyncSitesUseCase;
  final IncrementalSyncSiteGroupsUseCase _incrementalSyncSiteGroupsUseCase;

  const IncrementalSyncAllUseCaseImpl(
    this._incrementalSyncModulesUseCase,
    this._incrementalSyncSitesUseCase,
    this._incrementalSyncSiteGroupsUseCase,
  );

  @override
  Future<void> execute(String token) async {
    try {
      // First incrementally sync modules
      await _incrementalSyncModulesUseCase.execute(token);
      
      // Then incrementally sync sites
      await _incrementalSyncSitesUseCase.execute(token);
      
      // Finally incrementally sync site groups
      await _incrementalSyncSiteGroupsUseCase.execute(token);
    } catch (e) {
      print('Error in IncrementalSyncAllUseCase: $e');
      rethrow;
    }
  }
}
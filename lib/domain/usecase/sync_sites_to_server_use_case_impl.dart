import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/repository/upstream_sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/sync_sites_to_server_use_case.dart';

/// Implémentation du use case de synchronisation des sites vers le serveur
class SyncSitesToServerUseCaseImpl implements SyncSitesToServerUseCase {
  final UpstreamSyncRepository _upstreamSyncRepository;

  SyncSitesToServerUseCaseImpl(this._upstreamSyncRepository);

  @override
  Future<SyncResult> execute(String token, String moduleCode) async {
    return await _upstreamSyncRepository.syncSitesToServer(token, moduleCode);
  }
}

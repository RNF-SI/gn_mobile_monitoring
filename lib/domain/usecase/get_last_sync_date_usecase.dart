import 'package:gn_mobile_monitoring/domain/repository/sync_repository.dart';

abstract class GetLastSyncDateUseCase {
  Future<DateTime?> execute(String entityType);
}

class GetLastSyncDateUseCaseImpl implements GetLastSyncDateUseCase {
  final SyncRepository _syncRepository;

  GetLastSyncDateUseCaseImpl(this._syncRepository);

  @override
  Future<DateTime?> execute(String entityType) async {
    return await _syncRepository.getLastSyncDate(entityType);
  }
}
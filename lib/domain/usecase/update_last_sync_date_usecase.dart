import 'package:gn_mobile_monitoring/domain/repository/sync_repository.dart';

abstract class UpdateLastSyncDateUseCase {
  Future<void> execute(String entityType, DateTime syncDate);
}

class UpdateLastSyncDateUseCaseImpl implements UpdateLastSyncDateUseCase {
  final SyncRepository _syncRepository;

  UpdateLastSyncDateUseCaseImpl(this._syncRepository);

  @override
  Future<void> execute(String entityType, DateTime syncDate) async {
    await _syncRepository.updateLastSyncDate(entityType, syncDate);
  }
}
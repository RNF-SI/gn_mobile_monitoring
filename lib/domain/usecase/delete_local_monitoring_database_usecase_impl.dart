import 'package:gn_mobile_monitoring/domain/repository/global_database_repository.dart';

import 'delete_local_monitoring_database_usecase.dart';

class DeleteLocalMonitoringDatabaseUseCaseImpl
    implements DeleteLocalMonitoringDatabaseUseCase {
  final GlobalDatabaseRepository _repository;

  const DeleteLocalMonitoringDatabaseUseCaseImpl(this._repository);

  @override
  Future<void> execute() async {
    await _repository.deleteDatabase();
  }
}

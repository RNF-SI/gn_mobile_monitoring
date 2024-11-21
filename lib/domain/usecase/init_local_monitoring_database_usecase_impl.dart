import 'package:gn_mobile_monitoring/domain/repository/global_database_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/init_local_monitoring_database_usecase.dart';

class InitLocalMonitoringDataBaseUseCaseImpl
    implements InitLocalMonitoringDataBaseUseCase {
  final GlobalDatabaseRepository _repository;

  const InitLocalMonitoringDataBaseUseCaseImpl(this._repository);

  @override
  Future<void> execute() {
    return _repository.initDatabase();
  }
}

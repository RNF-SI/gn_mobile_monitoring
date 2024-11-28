import 'package:gn_mobile_monitoring/domain/repository/global_database_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_database_usecase.dart';

class DeleteDatabaseUseCaseImpl implements DeleteDatabaseUseCase {
  final GlobalDatabaseRepository _databaseRepository;

  DeleteDatabaseUseCaseImpl(this._databaseRepository);

  @override
  Future<void> execute() async {
    return await _databaseRepository.deleteDatabase();
  }
}

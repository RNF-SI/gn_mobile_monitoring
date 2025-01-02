import 'package:gn_mobile_monitoring/domain/repository/global_database_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/import_csv_usecase.dart';

class ImportCsvUseCaseImpl implements ImportCsvUseCase {
  final GlobalDatabaseRepository _repository;

  const ImportCsvUseCaseImpl(this._repository);

  @override
  Future<void> execute(String tableName, String filePath) {
    return _repository.importAllCsv();
  }
}

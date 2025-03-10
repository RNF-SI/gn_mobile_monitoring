import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/modules_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/datasets_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/nomenclatures_database.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_module_data_usecase.dart';

// Data layer mocks
class MockGlobalApi extends Mock implements GlobalApi {}
class MockModulesApi extends Mock implements ModulesApi {}
class MockModulesDatabase extends Mock implements ModulesDatabase {}
class MockNomenclaturesDatabase extends Mock implements NomenclaturesDatabase {}
class MockDatasetsDatabase extends Mock implements DatasetsDatabase {}

// Domain layer mocks
class MockModulesRepository extends Mock implements ModulesRepository {}
class MockGetModulesUseCase extends Mock implements GetModulesUseCase {}
class MockDownloadModuleDataUseCase extends Mock implements DownloadModuleDataUseCase {}
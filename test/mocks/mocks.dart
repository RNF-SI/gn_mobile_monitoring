import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/authentication_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/modules_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/sites_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/datasets_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/global_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/nomenclatures_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/domain/repository/authentication_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/global_database_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_token_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_local_monitoring_database_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_module_data_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_sites_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_is_logged_in_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/init_local_monitoring_database_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/login_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_is_logged_in_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/auth/auth_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/database/database_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_groups_utilisateur_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sites_utilisateur_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sync_service.dart';
import 'package:mocktail/mocktail.dart';

// Data layer mocks - API
class MockAuthenticationApi extends Mock implements AuthenticationApi {}

class MockGlobalApi extends Mock implements GlobalApi {}

class MockModulesApi extends Mock implements ModulesApi {}

class MockSitesApi extends Mock implements SitesApi {}

// Data layer mocks - Database
class MockGlobalDatabase extends Mock implements GlobalDatabase {}

class MockModulesDatabase extends Mock implements ModulesDatabase {}

class MockNomenclaturesDatabase extends Mock implements NomenclaturesDatabase {}

class MockDatasetsDatabase extends Mock implements DatasetsDatabase {}

class MockSitesDatabase extends Mock implements SitesDatabase {}

// Domain layer mocks - Repositories
class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockGlobalDatabaseRepository extends Mock
    implements GlobalDatabaseRepository {}

class MockLocalStorageRepository extends Mock
    implements LocalStorageRepository {}

class MockModulesRepository extends Mock implements ModulesRepository {}

class MockSitesRepository extends Mock implements SitesRepository {}

// Domain layer mocks - UseCases
// Auth
class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockGetTokenFromLocalStorageUseCase extends Mock
    implements GetTokenFromLocalStorageUseCase {}

class MockSetTokenFromLocalStorageUseCase extends Mock
    implements SetTokenFromLocalStorageUseCase {}

class MockClearTokenFromLocalStorageUseCase extends Mock
    implements ClearTokenFromLocalStorageUseCase {}

class MockGetUserIdFromLocalStorageUseCase extends Mock
    implements GetUserIdFromLocalStorageUseCase {}

class MockSetUserIdFromLocalStorageUseCase extends Mock
    implements SetUserIdFromLocalStorageUseCase {}

class MockClearUserIdFromLocalStorageUseCase extends Mock
    implements ClearUserIdFromLocalStorageUseCase {}

class MockGetUserNameFromLocalStorageUseCase extends Mock
    implements GetUserNameFromLocalStorageUseCase {}

class MockSetUserNameFromLocalStorageUseCase extends Mock
    implements SetUserNameFromLocalStorageUseCase {}

class MockClearUserNameFromLocalStorageUseCase extends Mock
    implements ClearUserNameFromLocalStorageUseCase {}

class MockGetIsLoggedInFromLocalStorageUseCase extends Mock
    implements GetIsLoggedInFromLocalStorageUseCase {}

class MockSetIsLoggedInFromLocalStorageUseCase extends Mock
    implements SetIsLoggedInFromLocalStorageUseCase {}

// Database
mixin InitLocalMonitoringDataBaseUseCaseMixin
    implements InitLocalMonitoringDataBaseUseCase {
  @override
  Future<void> execute() async {}
}

class MockInitLocalMonitoringDataBaseUseCase extends Mock
    with InitLocalMonitoringDataBaseUseCaseMixin {}

mixin DeleteLocalMonitoringDatabaseUseCaseMixin
    implements DeleteLocalMonitoringDatabaseUseCase {
  @override
  Future<void> execute() async {}
}

class MockDeleteLocalMonitoringDatabaseUseCase extends Mock
    with DeleteLocalMonitoringDatabaseUseCaseMixin {}

// Modules
class MockGetModulesUseCase extends Mock implements GetModulesUseCase {}

class MockFetchModulesUseCase extends Mock implements FetchModulesUseCase {}

class MockDownloadModuleDataUseCase extends Mock
    implements DownloadModuleDataUseCase {}

// Sites
class MockGetSitesUseCase extends Mock implements GetSitesUseCase {}

class MockFetchSitesUseCase extends Mock implements FetchSitesUseCase {}

class MockGetSiteGroupsUseCase extends Mock implements GetSiteGroupsUseCase {}

class MockFetchSiteGroupsUseCase extends Mock
    implements FetchSiteGroupsUseCase {}

// Presentation layer mocks - ViewModels
class MockAuthenticationViewModel extends Mock
    implements AuthenticationViewModel {}

class MockDatabaseService extends Mock implements DatabaseService {}

class MockUserModulesViewModel extends Mock implements UserModulesViewModel {}

class MockUserSitesViewModel extends Mock implements UserSitesViewModel {}

class MockSiteGroupsViewModel extends Mock implements SiteGroupsViewModel {}

class MockSyncService extends Mock implements SyncService {}

// Flutter widgets
class MockBuildContext extends Mock implements BuildContext {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

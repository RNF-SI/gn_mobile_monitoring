import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_token_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_token_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_id_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_name_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_local_monitoring_database_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_local_monitoring_database_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_module_data_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_module_data_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_modules_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_site_groups_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_sites_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_sites_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_is_logged_in_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_is_logged_in_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_modules_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_groups_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_token_from_local_storage_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_name_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_all_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_all_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_modules_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_site_groups_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_sites_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_sites_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/init_local_monitoring_database_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/init_local_monitoring_database_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/login_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/login_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_is_logged_in_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_is_logged_in_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_token_from_local_storage_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_id_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_name_from_local_storage_use_case_impl.dart';

final initLocalMonitoringDataBaseUseCaseProvider =
    Provider<InitLocalMonitoringDataBaseUseCase>((ref) =>
        InitLocalMonitoringDataBaseUseCaseImpl(
            ref.watch(globalDatabaseRepositoryProvider)));

final deleteLocalMonitoringDatabaseUseCaseProvider =
    Provider<DeleteLocalMonitoringDatabaseUseCase>((ref) =>
        DeleteLocalMonitoringDatabaseUseCaseImpl(
            ref.watch(globalDatabaseRepositoryProvider)));

final loginUseCaseProvider = Provider<LoginUseCase>(
    (ref) => LoginUseCaseImpl(ref.watch(authenticationRepositoryProvider)));

final getIsLoggedInFromLocalStorageUseCaseProvider =
    Provider<GetIsLoggedInFromLocalStorageUseCase>((ref) =>
        GetIsLoggedInFromLocalStorageUseCaseImpl(
            ref.watch(localStorageProvider)));

final setIsLoggedInFromLocalStorageUseCaseProvider =
    Provider<SetIsLoggedInFromLocalStorageUseCase>((ref) =>
        SetIsLoggedInFromLocalStorageUseCaseImpl(
            ref.watch(localStorageProvider)));

final getUserIdFromLocalStorageUseCaseProvider =
    Provider<GetUserIdFromLocalStorageUseCase>((ref) =>
        GetUserIdFromLocalStorageUseCaseImpl(ref.watch(localStorageProvider)));

final setUserIdFromLocalStorageUseCaseProvider =
    Provider<SetUserIdFromLocalStorageUseCase>((ref) =>
        SetUserIdFromLocalStorageUseCaseImpl(ref.watch(localStorageProvider)));

final getUserNameFromLocalStorageUseCaseProvider =
    Provider<GetUserNameFromLocalStorageUseCase>((ref) =>
        GetUserNameFromLocalStorageUseCaseImpl(
            ref.watch(localStorageProvider)));

final setUserNameFromLocalStorageUseCaseProvider =
    Provider<SetUserNameFromLocalStorageUseCase>((ref) =>
        SetUserNameFromLocalStorageUseCaseImpl(
            ref.watch(localStorageProvider)));

final getModulesUseCaseProvider = Provider<GetModulesUseCase>(
    (ref) => GetModulesUseCaseImpl(ref.watch(modulesRepositoryProvider)));

final setTokenFromLocalStorageUseCaseProvider =
    Provider<SetTokenFromLocalStorageUseCase>((ref) =>
        SetTokenFromLocalStorageUseCaseImpl(ref.watch(localStorageProvider)));

final getTokenFromLocalStorageUseCaseProvider =
    Provider<GetTokenFromLocalStorageUseCase>((ref) =>
        GetTokenFromLocalStorageUseCaseImpl(ref.watch(localStorageProvider)));

final clearUserIdFromLocalStorageUseCaseProvider =
    Provider<ClearUserIdFromLocalStorageUseCase>((ref) =>
        ClearUserIdFromLocalStorageUseCaseImpl(
            ref.watch(localStorageProvider)));

final clearUserNameFromLocalStorageUseCaseProvider =
    Provider<ClearUserNameFromLocalStorageUseCase>((ref) =>
        ClearUserNameFromLocalStorageUseCaseImpl(
            ref.watch(localStorageProvider)));

final clearTokenFromLocalStorageUseCaseProvider =
    Provider<ClearTokenFromLocalStorageUseCase>((ref) =>
        ClearTokenFromLocalStorageUseCaseImpl(ref.watch(localStorageProvider)));

final downloadModuleDataUseCaseProvider = Provider<DownloadModuleDataUseCase>(
    (ref) =>
        DownloadModuleDataUseCaseImpl(ref.watch(modulesRepositoryProvider)));

final getSiteGroupsUseCaseProvider = Provider<GetSiteGroupsUseCase>(
    (ref) => GetSiteGroupsUseCaseImpl(ref.watch(sitesRepositoryProvider)));

final getSitesUseCaseProvider = Provider<GetSitesUseCase>(
    (ref) => GetSitesUseCaseImpl(ref.watch(sitesRepositoryProvider)));

final fetchModulesUseCaseProvider = Provider<FetchModulesUseCase>(
  (ref) => FetchModulesUseCaseImpl(
    ref.watch(modulesRepositoryProvider),
  ),
);

final fetchSitesUseCaseProvider = Provider<FetchSitesUseCase>(
  (ref) => FetchSitesUseCaseImpl(
    ref.watch(sitesRepositoryProvider),
  ),
);

final fetchSiteGroupsUseCaseProvider = Provider<FetchSiteGroupsUseCase>(
  (ref) => FetchSiteGroupsUseCaseImpl(
    ref.watch(sitesRepositoryProvider),
  ),
);

final incrementalSyncModulesUseCaseProvider = Provider<IncrementalSyncModulesUseCase>(
  (ref) => IncrementalSyncModulesUseCaseImpl(
    ref.watch(modulesRepositoryProvider),
  ),
);

final incrementalSyncSitesUseCaseProvider = Provider<IncrementalSyncSitesUseCase>(
  (ref) => IncrementalSyncSitesUseCaseImpl(
    ref.watch(sitesRepositoryProvider),
  ),
);

final incrementalSyncSiteGroupsUseCaseProvider = Provider<IncrementalSyncSiteGroupsUseCase>(
  (ref) => IncrementalSyncSiteGroupsUseCaseImpl(
    ref.watch(sitesRepositoryProvider),
  ),
);

final incrementalSyncAllUseCaseProvider = Provider<IncrementalSyncAllUseCase>(
  (ref) => IncrementalSyncAllUseCaseImpl(
    ref.watch(incrementalSyncModulesUseCaseProvider),
    ref.watch(incrementalSyncSitesUseCaseProvider),
    ref.watch(incrementalSyncSiteGroupsUseCaseProvider),
  ),
);

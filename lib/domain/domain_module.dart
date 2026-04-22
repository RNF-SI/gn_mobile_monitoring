import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/data/repository/composite_sync_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/downstream_sync_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/upstream_sync_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/repository/downstream_sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/upstream_sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/check_app_update_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/check_app_update_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_api_url_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_token_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_token_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_id_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_name_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_observation_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_observation_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_visit_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_local_monitoring_database_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_local_monitoring_database_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_observation_detail_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_observation_details_by_observation_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_observation_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_observation_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_visit_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_app_update_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_app_update_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_complete_module_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_complete_module_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_module_taxons_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_modules_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_site_groups_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_api_url_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_complete_module_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_complete_module_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_datasets_for_module_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_is_logged_in_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_is_logged_in_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_last_sync_date_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_module_taxons_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_modules_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclature_by_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclature_by_id_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclatures_by_type_code_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclatures_by_type_code_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclatures_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclatures_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observation_by_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observation_by_id_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observation_detail_by_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observation_details_by_observation_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observations_by_visit_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observations_by_visit_id_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_groups_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_orphan_sites_by_module_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_orphan_sites_by_module_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_by_site_group_and_module_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_by_site_group_and_module_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_by_site_group_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_by_site_group_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_suggestion_taxons_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_taxon_by_cd_nom_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_taxons_by_list_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/is_taxon_in_list_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_token_from_local_storage_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_name_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_complement_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_complement_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_with_details_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_with_details_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visits_by_site_and_module_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visits_by_site_and_module_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_all_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_all_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_modules_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_site_groups_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/init_local_monitoring_database_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/init_local_monitoring_database_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/login_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/login_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/save_observation_detail_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/save_visit_complement_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/save_visit_complement_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/search_taxons_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_api_url_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_is_logged_in_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_is_logged_in_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_token_from_local_storage_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_id_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_name_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/sync_complete_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/sync_complete_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/sync_sites_to_server_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/sync_sites_to_server_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_last_sync_date_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_observation_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_observation_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_visit_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_site_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_site_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_site_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_site_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_group_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_group_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_site_group_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_site_group_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_site_group_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_site_group_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_complements_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_complements_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_by_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_by_id_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_groups_by_id_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_groups_by_id_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_with_relations_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_with_relations_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_group_with_relations_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_group_with_relations_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/service/map_geometry_service.dart';
import 'package:gn_mobile_monitoring/data/service/map_geometry_service_impl.dart';
import 'package:gn_mobile_monitoring/domain/service/geojson_parser_service.dart';
import 'package:gn_mobile_monitoring/data/service/geojson_parser_service_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/load_map_features_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/load_map_features_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/load_map_tile_layers_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/load_map_tile_layers_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_location_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_location_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/find_feature_at_point_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/find_feature_at_point_use_case_impl.dart';

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

final getApiUrlFromLocalStorageUseCaseProvider =
    Provider<GetApiUrlFromLocalStorageUseCase>((ref) =>
        GetApiUrlFromLocalStorageUseCaseImpl(ref.watch(localStorageProvider)));

final setApiUrlFromLocalStorageUseCaseProvider =
    Provider<SetApiUrlFromLocalStorageUseCase>((ref) =>
        SetApiUrlFromLocalStorageUseCaseImpl(ref.watch(localStorageProvider)));

final clearApiUrlFromLocalStorageUseCaseProvider =
    Provider<ClearApiUrlFromLocalStorageUseCase>((ref) =>
        ClearApiUrlFromLocalStorageUseCaseImpl(
            ref.watch(localStorageProvider)));

final checkAppUpdateUseCaseProvider = Provider<CheckAppUpdateUseCase>(
    (ref) => CheckAppUpdateUseCaseImpl(ref.watch(appUpdateRepositoryProvider)));

final downloadAppUpdateUseCaseProvider = Provider<DownloadAppUpdateUseCase>(
    (ref) =>
        DownloadAppUpdateUseCaseImpl(ref.watch(appUpdateRepositoryProvider)));

final downloadCompleteModuleUseCaseProvider =
    Provider<DownloadCompleteModuleUseCase>(
        (ref) => DownloadCompleteModuleUseCaseImpl(
              ref.watch(modulesRepositoryProvider),
            ));

final getSiteGroupsUseCaseProvider = Provider<GetSiteGroupsUseCase>(
    (ref) => GetSiteGroupsUseCaseImpl(ref.watch(sitesRepositoryProvider)));

final fetchModulesUseCaseProvider = Provider<FetchModulesUseCase>(
  (ref) => FetchModulesUseCaseImpl(
    ref.watch(modulesRepositoryProvider),
  ),
);

final fetchSiteGroupsUseCaseProvider = Provider<FetchSiteGroupsUseCase>(
  (ref) => FetchSiteGroupsUseCaseImpl(
    ref.watch(sitesRepositoryProvider),
  ),
);

final incrementalSyncModulesUseCaseProvider =
    Provider<IncrementalSyncModulesUseCase>(
  (ref) => IncrementalSyncModulesUseCaseImpl(
    ref.watch(modulesRepositoryProvider),
  ),
);

final incrementalSyncSiteGroupsUseCaseProvider =
    Provider<IncrementalSyncSiteGroupsUseCase>(
  (ref) => IncrementalSyncSiteGroupsUseCaseImpl(
    ref.watch(sitesRepositoryProvider),
  ),
);

// Fournisseur pour le repository de synchronisation descendante (serveur vers appareil)
final downstreamSyncRepositoryProvider = Provider<DownstreamSyncRepository>(
  (ref) => DownstreamSyncRepositoryImpl(
    ref.watch(globalApiProvider),
    ref.watch(taxonApiProvider),
    ref.watch(globalDatabaseProvider),
    ref.watch(nomenclatureDatabaseProvider),
    ref.watch(datasetsDatabaseProvider),
    ref.watch(taxonDatabaseProvider),
    modulesRepository: ref.watch(modulesRepositoryProvider),
    sitesRepository: ref.watch(sitesRepositoryProvider),
    visitesDatabase: ref.watch(visitDatabaseProvider),
    observationsDatabase: ref.watch(observationsDatabaseProvider),
  ),
);

// Fournisseur pour le repository de synchronisation ascendante (appareil vers serveur)
final upstreamSyncRepositoryProvider = Provider<UpstreamSyncRepository>(
  (ref) => UpstreamSyncRepositoryImpl(
    ref.watch(globalApiProvider),
    ref.watch(globalDatabaseProvider),
    ref.watch(moduleDatabaseProvider),
    visitRepository: ref.watch(visitRepositoryProvider),
    observationsRepository: ref.watch(observationsRepositoryProvider),
    observationDetailsRepository:
        ref.watch(observationDetailsRepositoryImplProvider),
    sitesRepository: ref.watch(sitesRepositoryProvider),
  ),
);

// Fournisseur pour le repository de synchronisation composite (façade)
final syncRepositoryProvider = Provider<SyncRepository>(
  (ref) => CompositeSyncRepositoryImpl(
    downstreamRepo: ref.watch(downstreamSyncRepositoryProvider),
    upstreamRepo: ref.watch(upstreamSyncRepositoryProvider),
  ),
);

final incrementalSyncAllUseCaseProvider = Provider<IncrementalSyncAllUseCase>(
  (ref) => IncrementalSyncAllUseCaseImpl(
    ref.watch(syncRepositoryProvider),
  ),
);

final getLastSyncDateUseCaseProvider = Provider<GetLastSyncDateUseCase>(
  (ref) => GetLastSyncDateUseCaseImpl(
    ref.watch(syncRepositoryProvider),
  ),
);

final updateLastSyncDateUseCaseProvider = Provider<UpdateLastSyncDateUseCase>(
  (ref) => UpdateLastSyncDateUseCaseImpl(
    ref.watch(syncRepositoryProvider),
  ),
);

final getVisitWithDetailsUseCaseProvider = Provider<GetVisitWithDetailsUseCase>(
  (ref) => GetVisitWithDetailsUseCaseImpl(ref.watch(visitRepositoryProvider)),
);

final createVisitUseCaseProvider = Provider<CreateVisitUseCase>(
  (ref) => CreateVisitUseCaseImpl(ref.watch(visitRepositoryProvider)),
);

final updateVisitUseCaseProvider = Provider<UpdateVisitUseCase>(
  (ref) => UpdateVisitUseCaseImpl(ref.watch(visitRepositoryProvider)),
);

final deleteVisitUseCaseProvider = Provider<DeleteVisitUseCase>(
  (ref) => DeleteVisitUseCaseImpl(ref.watch(visitRepositoryProvider)),
);

final getVisitComplementUseCaseProvider = Provider<GetVisitComplementUseCase>(
  (ref) => GetVisitComplementUseCaseImpl(ref.watch(visitRepositoryProvider)),
);

final saveVisitComplementUseCaseProvider = Provider<SaveVisitComplementUseCase>(
  (ref) => SaveVisitComplementUseCaseImpl(ref.watch(visitRepositoryProvider)),
);

// Observations use cases
final getObservationsByVisitIdUseCaseProvider =
    Provider<GetObservationsByVisitIdUseCase>(
  (ref) => GetObservationsByVisitIdUseCaseImpl(
      ref.watch(observationsRepositoryProvider)),
);

final createObservationUseCaseProvider = Provider<CreateObservationUseCase>(
  (ref) =>
      CreateObservationUseCaseImpl(ref.watch(observationsRepositoryProvider)),
);

final updateObservationUseCaseProvider = Provider<UpdateObservationUseCase>(
  (ref) =>
      UpdateObservationUseCaseImpl(ref.watch(observationsRepositoryProvider)),
);

final deleteObservationUseCaseProvider = Provider<DeleteObservationUseCase>(
  (ref) =>
      DeleteObservationUseCaseImpl(ref.watch(observationsRepositoryProvider)),
);

// Sites use cases
final createSiteUseCaseProvider = Provider<CreateSiteUseCase>(
  (ref) => CreateSiteUseCaseImpl(ref.watch(siteDatabaseProvider)),
);

final updateSiteUseCaseProvider = Provider<UpdateSiteUseCase>(
  (ref) => UpdateSiteUseCaseImpl(ref.watch(siteDatabaseProvider)),
);

final deleteSiteUseCaseProvider = Provider<DeleteSiteUseCase>(
  (ref) => DeleteSiteUseCaseImpl(ref.watch(siteDatabaseProvider)),
);

// Sites Group use cases
final createSiteGroupUseCaseProvider = Provider<CreateSiteGroupUseCase>(
  (ref) => CreateSiteGroupUseCaseImpl(ref.watch(siteDatabaseProvider)),
);

final updateSiteGroupUseCaseProvider = Provider<UpdateSiteGroupUseCase>(
  (ref) => UpdateSiteGroupUseCaseImpl(ref.watch(siteDatabaseProvider)),
);

final deleteSiteGroupUseCaseProvider = Provider<DeleteSiteGroupUseCase>(
  (ref) => DeleteSiteGroupUseCaseImpl(ref.watch(siteDatabaseProvider)),
);


// ObservationDetail Providers
final getObservationDetailsByObservationIdUseCaseProvider =
    Provider<GetObservationDetailsByObservationIdUseCase>(
  (ref) => GetObservationDetailsByObservationIdUseCaseImpl(
      ref.watch(observationDetailsRepositoryImplProvider)),
);

final getObservationDetailByIdUseCaseProvider =
    Provider<GetObservationDetailByIdUseCase>(
  (ref) => GetObservationDetailByIdUseCaseImpl(
      ref.watch(observationDetailsRepositoryImplProvider)),
);

final saveObservationDetailUseCaseProvider =
    Provider<SaveObservationDetailUseCase>(
  (ref) => SaveObservationDetailUseCaseImpl(
      ref.watch(observationDetailsRepositoryImplProvider)),
);

final deleteObservationDetailUseCaseProvider =
    Provider<DeleteObservationDetailUseCase>(
  (ref) => DeleteObservationDetailUseCaseImpl(
      ref.watch(observationDetailsRepositoryImplProvider)),
);

final deleteObservationDetailsByObservationIdUseCaseProvider =
    Provider<DeleteObservationDetailsByObservationIdUseCase>(
  (ref) => DeleteObservationDetailsByObservationIdUseCaseImpl(
      ref.watch(observationDetailsRepositoryImplProvider)),
);

// UseCase pour récupérer un module complet depuis la base locale
final getCompleteModuleUseCaseProvider = Provider<GetCompleteModuleUseCase>(
  (ref) => GetCompleteModuleUseCaseImpl(ref.watch(modulesRepositoryProvider)),
);

// UseCase pour récupérer toutes les nomenclatures
final getNomenclaturesUseCaseProvider = Provider<GetNomenclaturesUseCase>(
  (ref) => GetNomenclaturesUseCaseImpl(ref.watch(modulesRepositoryProvider)),
);

// UseCase pour récupérer une nomenclature par son ID
final getNomenclatureByIdUseCaseProvider = Provider<GetNomenclatureByIdUseCase>(
  (ref) => GetNomenclatureByIdUseCaseImpl(
      ref.watch(getNomenclaturesUseCaseProvider)),
);

// UseCase pour récupérer les sites associés à un groupe de sites
final getSitesBySiteGroupUseCaseProvider = Provider<GetSitesBySiteGroupUseCase>(
  (ref) => GetSitesBySiteGroupUseCaseImpl(ref.watch(sitesRepositoryProvider)),
);

// UseCase pour récupérer les sites d'un groupe filtrés par module
final getSitesBySiteGroupAndModuleUseCaseProvider =
    Provider<GetSitesBySiteGroupAndModuleUseCase>(
  (ref) => GetSitesBySiteGroupAndModuleUseCaseImpl(
      ref.watch(sitesRepositoryProvider)),
);

// UseCase pour récupérer les sites orphelins (sans groupe) d'un module (#157)
final getOrphanSitesByModuleUseCaseProvider =
    Provider<GetOrphanSitesByModuleUseCase>(
  (ref) =>
      GetOrphanSitesByModuleUseCaseImpl(ref.watch(sitesRepositoryProvider)),
);

final getVisitsBySiteAndModuleUseCaseProvider =
    Provider<GetVisitsBySiteAndModuleUseCase>(
  (ref) =>
      GetVisitsBySiteAndModuleUseCaseImpl(ref.watch(visitRepositoryProvider)),
);

final getObservationByIdUseCaseProvider = Provider<GetObservationByIdUseCase>(
  (ref) =>
      GetObservationByIdUseCaseImpl(ref.watch(observationsRepositoryProvider)),
);

// Provider pour le cas d'utilisation des nomenclatures par type
final getNomenclaturesByTypeCodeUseCaseProvider =
    Provider<GetNomenclaturesByTypeCodeUseCase>(
  (ref) => GetNomenclaturesByTypeCodeUseCaseImpl(
      ref.watch(modulesRepositoryProvider)),
);

final downloadModuleTaxonsUseCaseProvider =
    Provider<DownloadModuleTaxonsUseCase>(
  (ref) => DownloadModuleTaxonsUseCaseImpl(ref.watch(taxonRepositoryProvider)),
);

final getModuleTaxonsUseCaseProvider = Provider<GetModuleTaxonsUseCase>(
  (ref) => GetModuleTaxonsUseCaseImpl(
    ref.watch(taxonRepositoryProvider),
  ),
);

final getTaxonsByListIdUseCaseProvider = Provider<GetTaxonsByListIdUseCase>(
  (ref) => GetTaxonsByListIdUseCaseImpl(
    ref.watch(taxonRepositoryProvider),
  ),
);

final getTaxonByCdNomUseCaseProvider = Provider<GetTaxonByCdNomUseCase>(
  (ref) => GetTaxonByCdNomUseCaseImpl(
    ref.watch(taxonRepositoryProvider),
  ),
);

final searchTaxonsUseCaseProvider = Provider<SearchTaxonsUseCase>(
  (ref) => SearchTaxonsUseCaseImpl(
    ref.watch(taxonRepositoryProvider),
  ),
);

final isTaxonInListUseCaseProvider = Provider<IsTaxonInListUseCase>(
  (ref) => IsTaxonInListUseCaseImpl(
    ref.watch(taxonRepositoryProvider),
  ),
);

final getSuggestionTaxonsUseCaseProvider =
    Provider<GetSuggestionTaxonsUseCase>(
  (ref) => GetSuggestionTaxonsUseCaseImpl(
    ref.watch(taxonRepositoryProvider),
  ),
);

// Provider pour le cas d'utilisation des datasets
final getDatasetsForModuleUseCaseProvider =
    Provider<GetDatasetsForModuleUseCase>(
  (ref) => GetDatasetsForModuleUseCaseImpl(
    ref.watch(modulesRepositoryProvider),
  ),
);

// Provider pour la synchronisation complète
final syncSitesToServerUseCaseProvider = Provider<SyncSitesToServerUseCase>(
  (ref) => SyncSitesToServerUseCaseImpl(
    ref.watch(upstreamSyncRepositoryProvider),
  ),
);

final syncCompleteUseCaseProvider = Provider<SyncCompleteUseCase>(
  (ref) => SyncCompleteUseCaseImpl(
    ref.watch(syncRepositoryProvider),
    ref.watch(getModulesUseCaseProvider),
    ref.watch(syncSitesToServerUseCaseProvider),
  ),
);

// Provider pour le service de géométrie de carte
final mapGeometryServiceProvider = Provider<MapGeometryService>(
  (ref) => const MapGeometryServiceImpl(),
);

// Provider pour récupérer les compléments de sites
final getSiteComplementsUseCaseProvider = Provider<GetSiteComplementsUseCase>(
  (ref) => GetSiteComplementsUseCaseImpl(ref.watch(sitesRepositoryProvider)),
);

// Provider pour récupérer un site par son ID
final getSiteByIdUseCaseProvider = Provider<GetSiteByIdUseCase>(
  (ref) => GetSiteByIdUseCaseImpl(ref.watch(sitesRepositoryProvider)),
);

// Provider pour récupérer un groupe de sites par son ID
final getSiteGroupByIdUseCaseProvider = Provider<GetSiteGroupsByIdUseCase>(
  (ref) => GetSiteGroupsByIdUseCaseImpl(ref.watch(sitesRepositoryProvider)),
);

// Provider pour créer un site avec ses relations (module et complément)
final createSiteWithRelationsUseCaseProvider = Provider<CreateSiteWithRelationsUseCase>(
  (ref) => CreateSiteWithRelationsUseCaseImpl(
    ref.watch(createSiteUseCaseProvider),
    ref.watch(siteDatabaseProvider),
  ),
);

// Provider pour créer un groupe de sites avec ses relations (module)
final createSiteGroupWithRelationsUseCaseProvider = Provider<CreateSiteGroupWithRelationsUseCase>(
  (ref) => CreateSiteGroupWithRelationsUseCaseImpl(
    ref.watch(createSiteGroupUseCaseProvider),
    ref.watch(siteDatabaseProvider),
  ),
);

// ============================================================================
// Providers pour la carte (Map)
// ============================================================================

// Provider pour le service de parsing GeoJSON
final geoJsonParserServiceProvider = Provider<GeoJsonParserService>(
  (ref) => const GeoJsonParserServiceImpl(),
);

// Provider pour charger les features de la carte
final loadMapFeaturesUseCaseProvider = Provider<LoadMapFeaturesUseCase>(
  (ref) => LoadMapFeaturesUseCaseImpl(ref.watch(geoJsonParserServiceProvider)),
);

// Provider pour charger les couches de tuiles
final loadMapTileLayersUseCaseProvider = Provider<LoadMapTileLayersUseCase>(
  (ref) => const LoadMapTileLayersUseCaseImpl(),
);

// Provider pour récupérer la position utilisateur
final getUserLocationUseCaseProvider = Provider<GetUserLocationUseCase>(
  (ref) => const GetUserLocationUseCaseImpl(),
);

// Provider pour trouver une feature à un point donné
final findFeatureAtPointUseCaseProvider = Provider<FindFeatureAtPointUseCase>(
  (ref) => FindFeatureAtPointUseCaseImpl(ref.watch(mapGeometryServiceProvider)),
);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/sync_modules_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/model/moduleInfo.dart';
import 'package:gn_mobile_monitoring/presentation/model/moduleInfo_liste.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart'
    as custom_async_state;

final userModuleListeProvider =
    Provider.autoDispose<custom_async_state.State<ModuleInfoListe>>((ref) {
  final userModuleListeState =
      ref.watch(userModuleListeViewModelStateNotifierProvider);

  return userModuleListeState.when(
    init: () => const custom_async_state.State.init(),
    success: (moduleInfoListe) {
      return custom_async_state.State.success(moduleInfoListe);
    },
    loading: () => const custom_async_state.State.loading(),
    error: (exception) => custom_async_state.State.error(exception),
  );
});

final userModuleListeViewModelStateNotifierProvider =
    StateNotifierProvider.autoDispose<UserModulesViewModel,
        custom_async_state.State<ModuleInfoListe>>((ref) {
  return UserModulesViewModel(
    const AsyncValue<ModuleInfoListe>.data(ModuleInfoListe(values: [])),
    ref.watch(getUserIdFromLocalStorageUseCaseProvider),
    ref.watch(syncModulesUseCaseProvider),
    ref.watch(getModulesUseCaseProvider),
    ref.watch(getTokenFromLocalStorageUseCaseProvider),
  );
});

class UserModulesViewModel
    extends StateNotifier<custom_async_state.State<ModuleInfoListe>> {
  final GetUserIdFromLocalStorageUseCase _getUserIdFromLocalStorageUseCase;
  final SyncModulesUseCase _syncModulesUseCase;
  final GetModulesUseCase _getModulesUseCase;
  final GetTokenFromLocalStorageUseCase _getTokenFromLocalStorageUseCase;

  UserModulesViewModel(
    AsyncValue<ModuleInfoListe> userDispListe,
    this._getUserIdFromLocalStorageUseCase,
    this._syncModulesUseCase,
    this._getModulesUseCase,
    this._getTokenFromLocalStorageUseCase,
  ) : super(const custom_async_state.State.init()) {
    state = const custom_async_state.State.success(ModuleInfoListe(values: []));
  }

  Future<void> refreshModules() async {}

  Future<bool> hasInternetConnection() async {
    // var connectivityResult = await Connectivity().checkConnectivity();
    // if (connectivityResult == ConnectivityResult.mobile ||
    //     connectivityResult == ConnectivityResult.wifi) {
    //   // We have a network connection, so we might have internet
    //   // Note: This does not guarantee internet access, further checking is needed for actual internet access
    //   return true;
    // }
    return true;
  }

  Future<void> syncModules() async {
    try {
      state = const custom_async_state.State.loading();
      final token = await _getTokenFromLocalStorageUseCase.execute() as String;
      await _syncModulesUseCase.execute(token);

      // Recharger les modules après synchronisation
      await loadModules();
    } catch (e) {
      print('Error during module synchronization: $e');
      state =
          custom_async_state.State.error(Exception("Failed to sync modules"));
    }
  }

  Future<void> loadModules() async {
    try {
      // Fetch modules from the use case
      final modules = await _getModulesUseCase.execute();

      // Map the modules to ModuleInfo objects
      final moduleInfos = modules
          .map((module) => ModuleInfo(
                module: module,
                downloadStatus: ModuleDownloadStatus.moduleNotDownloaded,
              ))
          .toList();

      // Update the state with the ModuleInfoListe
      state = custom_async_state.State.success(
          ModuleInfoListe(values: moduleInfos));
    } catch (e) {
      state =
          custom_async_state.State.error(Exception("Failed to load modules"));
    }
  }
}

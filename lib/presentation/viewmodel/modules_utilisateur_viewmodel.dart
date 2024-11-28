import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_local_monitoring_database_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/init_local_monitoring_database_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/model/moduleInfo_liste.dart';
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
    ref.watch(initLocalMonitoringDataBaseUseCaseProvider),
    ref.watch(deleteLocalMonitoringDatabaseUseCaseProvider),
    ref.watch(getUserIdFromLocalStorageUseCaseProvider),
  );
});

class UserModulesViewModel
    extends StateNotifier<custom_async_state.State<ModuleInfoListe>> {
  final InitLocalMonitoringDataBaseUseCase _initLocalMonitoringDataBaseUseCase;
  final DeleteLocalMonitoringDatabaseUseCase
      _deleteLocalMonitoringDatabaseUseCase;
  final GetUserIdFromLocalStorageUseCase _getUserIdFromLocalStorageUseCase;

  UserModulesViewModel(
    AsyncValue<ModuleInfoListe> userDispListe,
    this._initLocalMonitoringDataBaseUseCase,
    this._deleteLocalMonitoringDatabaseUseCase,
    this._getUserIdFromLocalStorageUseCase,
  ) : super(const custom_async_state.State.init()) {
    _init();
    // Creates db tables and insert listee data (ex:essences, etc.)
    try {
      print("Creating database tables and inserting listee data");
      _initLocalMonitoringDataBaseUseCase.execute();
    } on Exception catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future<void> refreshModules() async {
    _init();
  }

  Future<void> _init() async {
    state = const custom_async_state.State.loading();
    try {
      // Initialize database
      await _initLocalMonitoringDataBaseUseCase.execute();

      // Simulate success with empty data for now
      state =
          const custom_async_state.State.success(ModuleInfoListe(values: []));
    } catch (e, stackTrace) {
      // Handle errors gracefully and display in the UI
      print("Error during initialization: $e");
      print(stackTrace);
      state = custom_async_state.State.error(
          Exception("Failed to initialize database"));
    }
  }

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

  Future<void> initLocalMonitoringDataBase() async {
    try {
      await _initLocalMonitoringDataBaseUseCase.execute();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteLocalMonitoringDatabase() async {
    try {
      await _deleteLocalMonitoringDatabaseUseCase.execute();
    } catch (e) {
      print(e);
    }
  }
}

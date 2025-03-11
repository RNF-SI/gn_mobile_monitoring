import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_module_data_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_modules_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info_list.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart'
    as custom_async_state;

final userModuleListeProvider =
    Provider.autoDispose<custom_async_state.State<ModuleInfoList>>((ref) {
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
        custom_async_state.State<ModuleInfoList>>((ref) {
  return UserModulesViewModel(
    ref.watch(getModulesUseCaseProvider),
    ref.watch(downloadModuleDataUseCaseProvider),
    const AsyncValue<ModuleInfoList>.data(ModuleInfoList(values: [])),
  );
});

class UserModulesViewModel
    extends StateNotifier<custom_async_state.State<ModuleInfoList>> {
  final GetModulesUseCase _getModulesUseCase;
  final DownloadModuleDataUseCase _downloadModuleDataUseCase;

  UserModulesViewModel(
    this._getModulesUseCase,
    this._downloadModuleDataUseCase,
    AsyncValue<ModuleInfoList> userDispListe,
  ) : super(custom_async_state.State.loading()) {
    loadModules();
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

  Future<void> loadModules() async {
    try {
      final modules = await _getModulesUseCase.execute();

      // Fetch downloaded status for each module
      final moduleInfos = modules.map((module) {
        final downloaded = module.downloaded ?? false;
        return ModuleInfo(
          module: module,
          downloadStatus: downloaded
              ? ModuleDownloadStatus.moduleDownloaded
              : ModuleDownloadStatus.moduleNotDownloaded,
        );
      }).toList();

      state =
          custom_async_state.State.success(ModuleInfoList(values: moduleInfos));
    } catch (e) {
      state =
          custom_async_state.State.error(Exception("Failed to load modules"));
    }
  }

  startDownloadModule(final ModuleInfo moduleInfo, BuildContext context) async {
    final moduleId = moduleInfo.module.id;
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Download failed: No internet connection."),
      ));
      return;
    }

    // Initially set the state to downloading
    var newModuleInfo = moduleInfo.copyWith(
        downloadStatus: ModuleDownloadStatus.moduleDownloading,
        downloadProgress: 0.0 // Explicitly set progress to 0 on start
        );
    state = custom_async_state.State.success(
        state.data!.updateModuleInfo(newModuleInfo));

    try {
      await _downloadModuleDataUseCase.execute(moduleId, (double progress) {
        // Directly update state inside the callback to reflect real-time progress
        newModuleInfo = newModuleInfo.copyWith(downloadProgress: progress);
        state = custom_async_state.State.success(
            state.data!.updateModuleInfo(newModuleInfo));
      });

      // Once download is complete, update the state to reflect this
      newModuleInfo = newModuleInfo.copyWith(
          downloadStatus: ModuleDownloadStatus.moduleDownloaded,
          downloadProgress:
              1.0 // Ensure progress is set to 100% when downloaded
          );
      state = custom_async_state.State.success(
          state.data!.updateModuleInfo(newModuleInfo));
    } on Exception catch (e) {
      state = custom_async_state.State.error(e);
    } catch (e) {
      print(e);
      state = custom_async_state.State.error(Exception(e));
    }
  }

  stopDownloadModule(final ModuleInfo moduleInfo) async {
    if (moduleInfo.downloadStatus == ModuleDownloadStatus.moduleDownloading) {
      final newModuleInfo = moduleInfo.copyWith(
          downloadStatus: ModuleDownloadStatus.moduleNotDownloaded);
      state = custom_async_state.State.success(
          state.data!.updateModuleInfo(newModuleInfo));
    }
  }
}

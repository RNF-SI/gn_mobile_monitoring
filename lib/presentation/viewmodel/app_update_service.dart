import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/mobile_app_version.dart';
import 'package:gn_mobile_monitoring/domain/usecase/check_app_update_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_app_update_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_last_dismissed_app_version_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_last_dismissed_app_version_use_case.dart';
import 'package:open_filex/open_filex.dart';

enum AppUpdateState { idle, checking, updateAvailable, downloading, error }

class AppUpdateStatus {
  final AppUpdateState state;
  final MobileAppVersion? availableUpdate;
  final double downloadProgress;
  final String? errorMessage;

  const AppUpdateStatus({
    this.state = AppUpdateState.idle,
    this.availableUpdate,
    this.downloadProgress = 0.0,
    this.errorMessage,
  });

  AppUpdateStatus copyWith({
    AppUpdateState? state,
    MobileAppVersion? availableUpdate,
    double? downloadProgress,
    String? errorMessage,
  }) {
    return AppUpdateStatus(
      state: state ?? this.state,
      availableUpdate: availableUpdate ?? this.availableUpdate,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final appUpdateServiceProvider =
    StateNotifierProvider<AppUpdateService, AppUpdateStatus>((ref) {
  return AppUpdateService(
    ref.read(checkAppUpdateUseCaseProvider),
    ref.read(downloadAppUpdateUseCaseProvider),
    ref.read(getTokenFromLocalStorageUseCaseProvider),
    ref.read(getLastDismissedAppVersionUseCaseProvider),
    ref.read(setLastDismissedAppVersionUseCaseProvider),
  );
});

class AppUpdateService extends StateNotifier<AppUpdateStatus> {
  final CheckAppUpdateUseCase _checkAppUpdateUseCase;
  final DownloadAppUpdateUseCase _downloadAppUpdateUseCase;
  final GetTokenFromLocalStorageUseCase _getTokenUseCase;
  final GetLastDismissedAppVersionUseCase _getLastDismissedUseCase;
  final SetLastDismissedAppVersionUseCase _setLastDismissedUseCase;

  AppUpdateService(
    this._checkAppUpdateUseCase,
    this._downloadAppUpdateUseCase,
    this._getTokenUseCase,
    this._getLastDismissedUseCase,
    this._setLastDismissedUseCase,
  ) : super(const AppUpdateStatus());

  /// Vérifie si une mise à jour est disponible.
  ///
  /// Ne redéclenche pas le dialog pour une version déjà refusée par
  /// l'utilisateur lors d'une session précédente (issue #170). L'API ne
  /// renvoyant un update que si la version distante est strictement
  /// supérieure à celle installée, une simple égalité sur versionCode avec
  /// la dernière version refusée suffit : si le serveur publie ensuite une
  /// version encore plus récente, elle repassera.
  Future<void> checkForUpdate() async {
    // Ne pas vérifier si déjà en cours de vérification ou téléchargement
    if (state.state == AppUpdateState.checking ||
        state.state == AppUpdateState.downloading) {
      return;
    }

    try {
      state = state.copyWith(state: AppUpdateState.checking);

      final token = await _getTokenUseCase.execute();
      if (token == null || token.isEmpty) {
        state = const AppUpdateStatus(state: AppUpdateState.idle);
        return;
      }

      final update = await _checkAppUpdateUseCase.execute(token);

      if (update != null) {
        final lastDismissed = await _getLastDismissedUseCase.execute();
        if (lastDismissed != null && lastDismissed == update.versionCode) {
          // L'utilisateur a déjà dit "Plus tard" pour cette version exacte.
          state = const AppUpdateStatus(state: AppUpdateState.idle);
          return;
        }

        state = AppUpdateStatus(
          state: AppUpdateState.updateAvailable,
          availableUpdate: update,
        );
      } else {
        state = const AppUpdateStatus(state: AppUpdateState.idle);
      }
    } catch (e) {
      // En cas d'erreur, on reste silencieux (pas de blocage de l'app)
      state = const AppUpdateStatus(state: AppUpdateState.idle);
    }
  }

  /// Télécharge et installe la mise à jour
  Future<void> downloadAndInstall() async {
    final update = state.availableUpdate;
    if (update == null || update.urlApk == null) return;

    try {
      state = state.copyWith(
        state: AppUpdateState.downloading,
        downloadProgress: 0.0,
      );

      final token = await _getTokenUseCase.execute();

      final filePath = await _downloadAppUpdateUseCase.execute(
        update.urlApk!,
        token: token,
        onProgress: (progress) {
          state = state.copyWith(downloadProgress: progress);
        },
      );

      // Ouvrir l'APK avec l'installeur Android
      await OpenFilex.open(filePath);

      state = const AppUpdateStatus(state: AppUpdateState.idle);
    } catch (e) {
      state = AppUpdateStatus(
        state: AppUpdateState.error,
        availableUpdate: update,
        errorMessage: 'Erreur lors du téléchargement de la mise à jour',
      );
    }
  }

  /// Remet le service à l'état idle (après fermeture du dialog) et persiste
  /// la version refusée pour ne plus la reproposer après une relance (#170).
  Future<void> dismiss() async {
    final dismissedCode = state.availableUpdate?.versionCode;
    state = const AppUpdateStatus(state: AppUpdateState.idle);
    if (dismissedCode != null && dismissedCode.isNotEmpty) {
      try {
        await _setLastDismissedUseCase.execute(dismissedCode);
      } catch (_) {
        // Best-effort : si la persistance échoue on ne bloque pas l'UI.
      }
    }
  }
}

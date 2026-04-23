import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/mobile_app_version.dart';
import 'package:gn_mobile_monitoring/domain/usecase/check_app_update_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_app_update_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_token_from_local_storage_usecase.dart';
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
  );
});

class AppUpdateService extends StateNotifier<AppUpdateStatus> {
  final CheckAppUpdateUseCase _checkAppUpdateUseCase;
  final DownloadAppUpdateUseCase _downloadAppUpdateUseCase;
  final GetTokenFromLocalStorageUseCase _getTokenUseCase;

  // Version refusée par l'utilisateur pendant cette session uniquement.
  // Non persistée : à chaque relance de l'app, une MAJ encore disponible sera
  // reproposée (issue #170). Une MAJ déjà installée n'est plus proposée car
  // l'API ne la renvoie que si strictement supérieure à la version installée.
  String? _dismissedThisSession;

  AppUpdateService(
    this._checkAppUpdateUseCase,
    this._downloadAppUpdateUseCase,
    this._getTokenUseCase,
  ) : super(const AppUpdateStatus());

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
        if (_dismissedThisSession != null &&
            _dismissedThisSession == update.versionCode) {
          // Déjà dit "Plus tard" pour cette version dans cette session.
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

  /// Ferme le dialog de MAJ et évite de le rouvrir pour la même version
  /// jusqu'au prochain lancement de l'app (#170).
  void dismiss() {
    _dismissedThisSession = state.availableUpdate?.versionCode;
    state = const AppUpdateStatus(state: AppUpdateState.idle);
  }
}

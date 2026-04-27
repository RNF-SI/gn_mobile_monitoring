import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/mobile_app_version.dart';
import 'package:gn_mobile_monitoring/domain/usecase/check_app_update_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_app_update_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_dismissed_app_version_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_dismissed_app_version_use_case.dart';
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
    ref.read(getDismissedAppVersionUseCaseProvider),
    ref.read(setDismissedAppVersionUseCaseProvider),
  );
});

class AppUpdateService extends StateNotifier<AppUpdateStatus> {
  final CheckAppUpdateUseCase _checkAppUpdateUseCase;
  final DownloadAppUpdateUseCase _downloadAppUpdateUseCase;
  final GetTokenFromLocalStorageUseCase _getTokenUseCase;
  final GetDismissedAppVersionUseCase _getDismissedUseCase;
  final SetDismissedAppVersionUseCase _setDismissedUseCase;

  // Version refusée par l'utilisateur, persistée en SharedPreferences pour ne
  // pas reproposer la même MAJ après un redémarrage de l'app. Un check manuel
  // (menu "Mise à jour de l'application") ou une nouvelle version côté serveur
  // lèvent ce garde-fou.
  String? _dismissedVersionCode;
  bool _dismissedLoaded = false;

  AppUpdateService(
    this._checkAppUpdateUseCase,
    this._downloadAppUpdateUseCase,
    this._getTokenUseCase,
    this._getDismissedUseCase,
    this._setDismissedUseCase,
  ) : super(const AppUpdateStatus());

  Future<void> _ensureDismissedLoaded() async {
    if (_dismissedLoaded) return;
    _dismissedVersionCode = await _getDismissedUseCase.execute();
    _dismissedLoaded = true;
  }

  Future<void> checkForUpdate() async {
    // Ne pas relancer une vérification si :
    // - une est déjà en cours (checking) ou un download tourne ;
    // - un dialog updateAvailable est déjà à l'écran (sinon une 2e check
    //   déclenchée par sync.success rejouerait la transition checking →
    //   updateAvailable et la listener du HomePage rouvrirait un 2e dialog).
    if (state.state == AppUpdateState.checking ||
        state.state == AppUpdateState.downloading ||
        state.state == AppUpdateState.updateAvailable) {
      return;
    }

    try {
      state = state.copyWith(state: AppUpdateState.checking);
      await _ensureDismissedLoaded();

      final token = await _getTokenUseCase.execute();
      if (token == null || token.isEmpty) {
        state = const AppUpdateStatus(state: AppUpdateState.idle);
        return;
      }

      final update = await _checkAppUpdateUseCase.execute(token);

      if (update != null) {
        // Réponse d'API incomplète (versionCode vide) : on ignore pour éviter
        // un dialog "version " vide affiché côté UI.
        final versionCode = update.versionCode;
        if (versionCode.isEmpty) {
          state = const AppUpdateStatus(state: AppUpdateState.idle);
          return;
        }

        if (_dismissedVersionCode != null &&
            _dismissedVersionCode == versionCode) {
          // Déjà refusée par l'utilisateur (et persistée) : on ne repropose pas.
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

  /// Ferme le dialog de MAJ et persiste le refus pour ne pas reproposer la
  /// même version au prochain lancement (#170). Une nouvelle version côté
  /// serveur ou un check manuel lèvent ce garde-fou.
  void dismiss() {
    final code = state.availableUpdate?.versionCode;
    _dismissedVersionCode = code;
    _dismissedLoaded = true;
    state = const AppUpdateStatus(state: AppUpdateState.idle);
    // Fire-and-forget : la persistance ne doit pas bloquer la fermeture du dialog.
    _setDismissedUseCase.execute(code);
  }

  /// Re-vérifie la disponibilité d'une MAJ en levant le garde-fou
  /// "dismissed". Utilisé par le bouton "Mise à jour de l'application" du
  /// menu, qui permet à l'utilisateur de rouvrir le dialog après avoir dit
  /// "Plus tard".
  Future<void> checkForUpdateManually() async {
    _dismissedVersionCode = null;
    _dismissedLoaded = true;
    await _setDismissedUseCase.execute(null);
    await checkForUpdate();
  }
}

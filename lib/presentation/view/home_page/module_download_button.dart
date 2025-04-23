import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/state/sync_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/module/module_loading_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sync_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Custom Colors
const Color colorBlue1 = Color(0xFF598979); // Bleu
const Color colorGreen = Color(0xFF8AAC3E); // Vert
const Color colorBlue2 = Color(0xFF7DAB9C); // Bleu
const Color colorBlack = Color(0xFF1a1a18); // Noir
const Color colorBeige = Color(0xFFF4F1E4); // Beige
const Color colorBrown = Color(0xFF8B5500); // Marron

@immutable
class ModuleDownloadButton extends HookConsumerWidget {
  const ModuleDownloadButton({
    super.key,
    required this.moduleInfo,
  });

  final ModuleInfo moduleInfo;
  final Duration transitionDuration = const Duration(milliseconds: 500);

  bool get _isDownloading =>
      moduleInfo.downloadStatus == ModuleDownloadStatus.moduleDownloading;

  bool get _isFetching =>
      moduleInfo.downloadStatus == ModuleDownloadStatus.moduleFetchingDownload;

  bool get _isDownloaded =>
      moduleInfo.downloadStatus == ModuleDownloadStatus.moduleDownloaded;

  bool get _isRemoving =>
      moduleInfo.downloadStatus == ModuleDownloadStatus.moduleRemoving;

  void _onPressed(BuildContext context, WidgetRef ref) async {
    try {
      switch (moduleInfo.downloadStatus) {
        case ModuleDownloadStatus.moduleNotDownloaded:
          ref
              .read(userModuleListeViewModelStateNotifierProvider.notifier)
              .startDownloadModule(moduleInfo, context);
          break;
        case ModuleDownloadStatus.moduleFetchingDownload:
          // do nothing.
          break;
        case ModuleDownloadStatus.moduleDownloading:
          ref
              .read(userModuleListeViewModelStateNotifierProvider.notifier)
              .stopDownloadModule(moduleInfo);
          break;
        case ModuleDownloadStatus.moduleDownloaded:
          // Navigate to the ModuleLoadingPage which will then load the module with its configuration
          Navigator.push(context, MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return ModuleLoadingPage(moduleInfo: moduleInfo);
            },
          ));
          break;
        case ModuleDownloadStatus.moduleRemoving:
          // Handle the removing state, perhaps do nothing or show a message
          break;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("An error occurred: ${e.toString()}"),
      ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useAnimationController(duration: transitionDuration);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      }
    });

    // Observer le statut de synchronisation pour désactiver le bouton pendant la synchronisation
    final syncStatus = ref.watch(syncServiceProvider);
    final isSyncing = syncStatus.state == SyncState.inProgress;

    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return GestureDetector(
            onTap: isSyncing
                ? null // Désactiver le tap pendant la synchronisation
                : () {
                    _onPressed(context, ref);
                  },
            child: Opacity(
              opacity: isSyncing
                  ? 0.5
                  : 1.0, // Réduire l'opacité pendant la synchronisation
              child: Stack(
                children: [
                  ButtonShapeWidget(
                    transitionDuration: transitionDuration,
                    isDownloaded: _isDownloaded,
                    isDownloading: _isDownloading,
                    isFetching: _isFetching,
                    isRemoving: _isRemoving,
                    downloadProgress: moduleInfo.downloadProgress,
                    isDisabled: isSyncing, // Passer l'état de désactivation
                  ),
                  if (_isDownloading || _isFetching)
                    Positioned.fill(
                      child: AnimatedOpacity(
                        duration: transitionDuration,
                        opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
                        curve: Curves.ease,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ProgressIndicatorWidget(
                              isDownloading: _isDownloading,
                              isFetching: _isFetching,
                              progress: moduleInfo.downloadProgress,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        });
  }
}

@immutable
class ButtonShapeWidget extends StatelessWidget {
  const ButtonShapeWidget({
    super.key,
    required this.isDownloading,
    required this.isDownloaded,
    required this.isFetching,
    required this.isRemoving,
    required this.transitionDuration,
    this.downloadProgress = 0.0,
    this.isDisabled = false,
  });

  final bool isDownloading;
  final bool isDownloaded;
  final bool isFetching;
  final double downloadProgress;
  final Duration transitionDuration;
  final bool isRemoving;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    var shape = ShapeDecoration(
      shape: StadiumBorder(),
      color: isDownloaded ? colorBlue1 : colorBeige,
    );

    if (isDownloading || isFetching) {
      shape = ShapeDecoration(
        shape: CircleBorder(),
        color: Colors.white.withOpacity(0.7),
      );
    }

    // Update button text based on the state
    String buttonText = isDownloaded ? 'Ouvrir' : 'Télécharger';
    if (isDownloading) {
      if (downloadProgress == 1.0) {
        buttonText = '${(downloadProgress * 99).toInt()}%';
      } else
        buttonText = '${(downloadProgress * 100).toInt()}%';
    } else if (isRemoving) {
      buttonText = 'Supression...'; // New text for the removing state
    }

    return AnimatedContainer(
      duration: transitionDuration,
      curve: Curves.ease,
      width: double.infinity,
      decoration: shape,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: AnimatedOpacity(
          duration: transitionDuration,
          opacity: isDownloading || isFetching
              ? 0.5
              : 1.0, // Slight opacity change when downloading
          curve: Curves.ease,
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDownloading ? colorGreen : colorBlack,
                ),
          ),
        ),
      ),
    );
  }
}

@immutable
class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    super.key,
    this.progress = 0.0,
    required this.isDownloading,
    required this.isFetching,
  });

  final double progress;
  final bool isDownloading;
  final bool isFetching;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: CircularProgressIndicator(
          backgroundColor: colorBeige,
          valueColor: AlwaysStoppedAnimation(
            isFetching ? colorBlue1 : colorGreen,
          ),
          value: isDownloading ? (progress == 1.0 ? 0.99 : progress) : null,
          strokeWidth: 2,
        ));
  }
}

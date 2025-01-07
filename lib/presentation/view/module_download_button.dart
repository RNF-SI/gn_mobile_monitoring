import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/model/moduleInfo.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';

class ModuleDownloadButton extends ConsumerWidget {
  const ModuleDownloadButton({
    super.key,
    required this.moduleInfo,
  });

  final ModuleInfo moduleInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDownloading =
        moduleInfo.downloadStatus == ModuleDownloadStatus.moduleDownloading;
    final isDownloaded =
        moduleInfo.downloadStatus == ModuleDownloadStatus.moduleDownloaded;

    String buttonText;
    if (isDownloaded) {
      buttonText = 'OPEN';
    } else if (isDownloading) {
      buttonText = '${(moduleInfo.downloadProgress * 100).toInt()}%';
    } else {
      buttonText = 'DOWNLOAD';
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDownloaded ? const Color(0xFF598979) : Colors.blue,
      ),
      onPressed: isDownloading
          ? null
          : () async {
              if (isDownloaded) {
                // Handle open logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening module...')),
                );
              } else {
                // Trigger download
                await ref
                    .read(
                        userModuleListeViewModelStateNotifierProvider.notifier)
                    .syncModules();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading module...')),
                );
              }
            },
      child: Text(
        buttonText,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

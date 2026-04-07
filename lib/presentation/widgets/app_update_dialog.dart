import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/app_update_service.dart';

class AppUpdateDialog extends ConsumerWidget {
  const AppUpdateDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(appUpdateServiceProvider);
    final isDownloading = status.state == AppUpdateState.downloading;
    final hasError = status.state == AppUpdateState.error;

    return AlertDialog(
      title: const Text('Mise à jour disponible'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Une nouvelle version de l\'application est disponible '
            '(version ${status.availableUpdate?.versionCode ?? ""}).\n\n'
            'Voulez-vous la télécharger et l\'installer ?',
          ),
          if (isDownloading) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(value: status.downloadProgress),
            const SizedBox(height: 8),
            Text(
              '${(status.downloadProgress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (hasError) ...[
            const SizedBox(height: 16),
            Text(
              status.errorMessage ?? 'Erreur inconnue',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: isDownloading
              ? null
              : () {
                  ref.read(appUpdateServiceProvider.notifier).dismiss();
                  Navigator.of(context).pop();
                },
          child: const Text('Plus tard'),
        ),
        TextButton(
          onPressed: isDownloading
              ? null
              : () {
                  ref.read(appUpdateServiceProvider.notifier).downloadAndInstall();
                },
          child: isDownloading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Mettre à jour'),
        ),
      ],
    );
  }
}

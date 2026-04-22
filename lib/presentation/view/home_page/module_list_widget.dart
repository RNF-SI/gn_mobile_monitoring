import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/theme/app_colors.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info_list.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';

import 'module_item_card_widget.dart';

class ModuleListWidget extends ConsumerWidget {
  const ModuleListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moduleInfoList = ref.watch(userModuleListeProvider);

    return moduleInfoList.when(
      init: () => const Center(child: Text('Initialisation...')),
      success: (ModuleInfoList moduleInfoList) {
        if (moduleInfoList.isEmpty()) {
          return const Center(
            child: Text('Aucun module disponible'),
          );
        }

        // Séparer les modules téléchargés et à télécharger
        final downloadedModules = moduleInfoList.values
            .where((m) =>
                m.downloadStatus == ModuleDownloadStatus.moduleDownloaded ||
                m.downloadStatus == ModuleDownloadStatus.moduleDownloading ||
                m.downloadStatus == ModuleDownloadStatus.moduleRemoving)
            .toList();
        final notDownloadedModules = moduleInfoList.values
            .where((m) =>
                m.downloadStatus == ModuleDownloadStatus.moduleNotDownloaded ||
                m.downloadStatus ==
                    ModuleDownloadStatus.moduleFetchingDownload)
            .toList();

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await ref
                .read(userModuleListeViewModelStateNotifierProvider.notifier)
                .loadModules();
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 48),
            children: [
              if (downloadedModules.isNotEmpty) ...[
                _buildSectionHeader(
                    context, 'Modules installés', downloadedModules.length),
                ...downloadedModules.map((moduleInfo) =>
                    ModuleItemCardWidget(moduleInfo: moduleInfo)),
              ],
              if (notDownloadedModules.isNotEmpty) ...[
                _buildSectionHeader(context, 'Modules à télécharger',
                    notDownloadedModules.length),
                ...notDownloadedModules.map((moduleInfo) =>
                    ModuleItemCardWidget(moduleInfo: moduleInfo)),
              ],
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error) => _buildErrorView(context, ref, error.toString()),
    );
  }

  /// Vue d'erreur récupérable pour la liste des modules (#168).
  /// Rend le message copiable et propose un bouton "Réessayer" + le
  /// pull-to-refresh reste actif via un ListView scrollable.
  Widget _buildErrorView(
      BuildContext context, WidgetRef ref, String errorMessage) {
    Future<void> retry() async {
      await ref
          .read(userModuleListeViewModelStateNotifierProvider.notifier)
          .loadModules();
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: retry,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 48),
          const Icon(Icons.error_outline, size: 64, color: AppColors.red),
          const SizedBox(height: 16),
          const Text(
            'Impossible de charger la liste des modules',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.red.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.red.withValues(alpha: 0.3)),
            ),
            child: SelectableText(
              errorMessage,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.red,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                key: const Key('module-list-copy-error-button'),
                onPressed: () async {
                  await Clipboard.setData(
                      ClipboardData(text: errorMessage));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Erreur copiée dans le presse-papiers'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copier'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                key: const Key('module-list-retry-button'),
                onPressed: retry,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
      child: Text(
        '$title ($count)',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.dark,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

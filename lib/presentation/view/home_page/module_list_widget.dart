import 'package:flutter/material.dart';
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
      error: (error) => Center(
        child: Text(
          'Erreur: $error',
          style: const TextStyle(color: AppColors.red),
        ),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/theme/app_colors.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/module_download_button.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sync_service.dart';

/// IDs des modules ayant au moins une visite locale non téléversée.
/// Lu par chaque [ModuleItemCardWidget] pour décider d'afficher le point
/// orange "Saisies locales non téléversées". Se rafraîchit automatiquement
/// après une mutation locale (`localVisitsCounterProvider`) ou un sync
/// (`cacheVersionProvider`), donc plus besoin d'invalider à chaque
/// navigation.
final unsyncedModuleIdsProvider = FutureProvider<Set<int>>((ref) async {
  ref.watch(localVisitsCounterProvider);
  ref.watch(cacheVersionProvider);
  final db = ref.watch(visitDatabaseProvider);
  return db.getModuleIdsWithUnsyncedVisits();
});

class ModuleItemCardWidget extends ConsumerWidget {
  const ModuleItemCardWidget({super.key, required this.moduleInfo});

  final ModuleInfo moduleInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unsyncedIds =
        ref.watch(unsyncedModuleIdsProvider).asData?.value ?? const <int>{};
    final hasUnsynced = unsyncedIds.contains(moduleInfo.module.id);

    return Card(
      key: Key('module-card-${moduleInfo.module.moduleCode}'),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          moduleInfo.module.moduleLabel ?? 'Module sans nom',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.dark,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnsynced) ...[
                        const SizedBox(width: 8),
                        Tooltip(
                          message: 'Saisies locales non téléversées',
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    moduleInfo.module.moduleDesc ??
                        'Pas de description disponible',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 96,
              child: ModuleDownloadButton(moduleInfo: moduleInfo),
            )
          ],
        ),
      ),
    );
  }
}

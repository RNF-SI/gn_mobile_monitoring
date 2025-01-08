import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/model/moduleInfo.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/module_download_button.dart';

class ModuleItemCardWidget extends ConsumerWidget {
  const ModuleItemCardWidget({super.key, required this.moduleInfo});

  final ModuleInfo moduleInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
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
                  Text(
                    moduleInfo.module.moduleLabel ?? 'Module sans nom',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF598979)), // Brand color
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    moduleInfo.module.moduleDesc ??
                        'Pas de description disponible',
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            ModuleDownloadButton(moduleInfo: moduleInfo),
          ],
        ),
      ),
    );
  }
}

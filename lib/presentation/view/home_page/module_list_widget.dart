import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info_list.dart';
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

        return RefreshIndicator(
          color: const Color(0xFF8AAC3E),
          onRefresh: () async {
            await ref
                .read(userModuleListeViewModelStateNotifierProvider.notifier)
                .loadModules();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: moduleInfoList.length,
            itemBuilder: (context, index) {
              final moduleInfo = moduleInfoList[index];
              return ModuleItemCardWidget(moduleInfo: moduleInfo);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error) => Center(
        child: Text(
          'Erreur: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

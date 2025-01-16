import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/model/moduleInfo_liste.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';

import 'module_item_card_widget.dart';

class ModuleListWidget extends ConsumerWidget {
  const ModuleListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the state of the modules
    final userModuleListProv = ref.watch(userModuleListeProvider);

    return Column(
      children: [
        Expanded(
          child: userModuleListProv.when(
            init: () => const Center(child: Text('Initialisation...')),
            success: (data) => RefreshIndicator(
              color: const Color(0xFF8AAC3E),
              onRefresh: () async {
                // Trigger the loading of modules when the user pulls to refresh
                await ref
                    .read(
                        userModuleListeViewModelStateNotifierProvider.notifier)
                    .loadModules();
              },
              child: _buildModuleListWidget(context, data),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e) => Center(
              child: Text(
                'Erreur: $e',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModuleListWidget(
      BuildContext context, ModuleInfoListe moduleInfoList) {
    if (moduleInfoList.isEmpty()) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Aucun module disponible.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF598979), // Brand color
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: moduleInfoList.length,
        itemBuilder: (BuildContext context, int index) {
          return ModuleItemCardWidget(moduleInfo: moduleInfoList[index]);
        },
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/module_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/module_detail_viewmodel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ModuleLoadingPage extends ConsumerWidget {
  final ModuleInfo moduleInfo;

  const ModuleLoadingPage({super.key, required this.moduleInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observer l'état du ViewModel pour le module
    final moduleDetailState = ref.watch(
      moduleDetailViewModelProvider(moduleInfo.module.id),
    );

    // En fonction de l'état, afficher le widget approprié
    return Scaffold(
      appBar: AppBar(
        title: Text('Module: ${moduleInfo.module.moduleLabel ?? 'Module Details'}'),
      ),
      body: Builder(
        builder: (context) {
          switch (moduleDetailState.state) {
            case ModuleDetailState.loading:
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Chargement des informations du module...'),
                  ],
                ),
              );
            case ModuleDetailState.loaded:
              if (moduleDetailState.module != null) {
                // Créer un nouveau ModuleInfo avec le module chargé
                final updatedModuleInfo = ModuleInfo(
                  module: moduleDetailState.module!,
                  downloadStatus: moduleInfo.downloadStatus,
                  downloadProgress: moduleInfo.downloadProgress,
                );
                
                // Naviguer vers la page de détail du module avec les informations complètes
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ModuleDetailPage(moduleInfo: updatedModuleInfo),
                    ),
                  );
                });
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(
                  child: Text('Une erreur est survenue lors du chargement du module.'),
                );
              }
            case ModuleDetailState.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Erreur: ${moduleDetailState.errorMessage ?? "Erreur inconnue"}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(moduleDetailViewModelProvider(moduleInfo.module.id).notifier)
                            .loadModuleWithConfig(moduleInfo.module.id);
                      },
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
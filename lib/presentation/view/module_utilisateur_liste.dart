import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/model/moduleInfo.dart';
import 'package:gn_mobile_monitoring/presentation/model/moduleInfo_liste.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';

class ModuleUtilisateurListe extends ConsumerWidget {
  const ModuleUtilisateurListe({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModuleListProv = ref.watch(userModuleListeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Module Utilisateur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              // Call the delete database use case
              ref
                  .read(userModuleListeViewModelStateNotifierProvider.notifier)
                  .deleteLocalMonitoringDatabase();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Database deleted successfully'),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                ref
                    .read(
                        userModuleListeViewModelStateNotifierProvider.notifier)
                    .initLocalMonitoringDataBase();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Database initialized successfully")),
                );
              } catch (e) {
                print("Error initializing database: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error initializing database: $e")),
                );
              }
            },
            child: const Text("Initialize Database"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final viewModel = ref.read(
                    userModuleListeViewModelStateNotifierProvider.notifier);

                await viewModel.syncModules();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Module synchronized successfully')),
                );
              } catch (e) {
                print('Error synchronizing modules: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error synchronizing modules: $e')),
                );
              }
            },
            child: const Text('Sync Modules'),
          ),
        ],
      ),
      body: userModuleListProv.when(
        init: () => const Center(child: Text('Initializing...')),
        success: (data) => RefreshIndicator(
          color: const Color(0xFF8AAC3E),
          onRefresh: () async {
            ref
                .read(userModuleListeViewModelStateNotifierProvider.notifier)
                .refreshModules();
          },
          child: _buildModuleListWidget(context, data),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e) => Center(
          child: Text(
            'Error: $e',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
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
                'Pas de modules',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: Color(0xFF598979)), // Using brand blue
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

class ModuleItemCardWidget extends ConsumerWidget {
  const ModuleItemCardWidget({
    super.key,
    required this.moduleInfo,
  });

  final ModuleInfo moduleInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {}, // Add onTap functionality if needed
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      moduleInfo.module.moduleLabel!,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF598979)), // Brand blue
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              // SizedBox(
              //   width: 96,
              //   child: DownloadButton(dispInfo: moduleInfo),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_groups_utilisateur_viewmodel.dart';

class SiteGroupListWidget extends ConsumerWidget {
  const SiteGroupListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteGroupListProv = ref.watch(siteGroupListProvider);

    return Column(
      children: [
        Expanded(
          child: siteGroupListProv.when(
            init: () => const Center(child: Text('Initialisation...')),
            success: (data) => RefreshIndicator(
              color: const Color(0xFF8AAC3E),
              onRefresh: () async {
                await ref
                    .read(siteGroupViewModelStateNotifierProvider.notifier)
                    .refreshSiteGroups();
              },
              child: _buildSiteGroupListWidget(context, data),
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

  Widget _buildSiteGroupListWidget(
      BuildContext context, List<SiteGroup> siteGroupList) {
    if (siteGroupList.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Aucun groupe de sites disponible.',
                style: TextStyle(
                    fontSize: 16, color: Color(0xFF598979)), // Brand color
              ),
            ),
          ),
        ],
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: siteGroupList.length,
        itemBuilder: (BuildContext context, int index) {
          final siteGroup = siteGroupList[index];
          return Card(
            child: ListTile(
              title: Text(siteGroup.sitesGroupName ?? "Nom non défini"),
              subtitle: Text(
                siteGroup.sitesGroupDescription ?? "Description non disponible",
              ),
              trailing: Text(
                siteGroup.uuidSitesGroup ?? "UUID non défini",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          );
        },
      );
    }
  }
}

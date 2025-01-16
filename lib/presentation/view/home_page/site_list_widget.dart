import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sites_utilisateur_viewmodel.dart';

class SiteListWidget extends ConsumerWidget {
  const SiteListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSitesProviderState = ref.watch(userSitesProvider);

    return Column(
      children: [
        Expanded(
          child: userSitesProviderState.when(
            init: () => const Center(child: Text('Initialisation...')),
            success: (data) => RefreshIndicator(
              color: const Color(0xFF8AAC3E),
              onRefresh: () async {
                await ref
                    .read(userSitesViewModelStateNotifierProvider.notifier)
                    .loadSites();
              },
              child: _buildSiteListWidget(context, data),
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

  Widget _buildSiteListWidget(BuildContext context, List<BaseSite> sites) {
    if (sites.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Aucun site disponible.',
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
        itemCount: sites.length,
        itemBuilder: (BuildContext context, int index) {
          final site = sites[index];
          return Card(
            child: ListTile(
              title: Text(site.baseSiteName ?? "Nom du site"),
              subtitle: Text(site.baseSiteDescription ?? "Description du site"),
            ),
          );
        },
      );
    }
  }
}

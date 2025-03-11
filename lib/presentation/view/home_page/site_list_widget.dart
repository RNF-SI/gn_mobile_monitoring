import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sites_utilisateur_viewmodel.dart';

class SiteListWidget extends ConsumerWidget {
  const SiteListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSitesProviderState = ref.watch(userSitesProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final filteredSites = ref.watch(filteredSitesProvider);

    return Column(
      children: [
        // Champ de recherche
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Rechercher un site',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => ref.read(searchQueryProvider.notifier).state = '',
                    )
                  : null,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
          ),
        ),
        Expanded(
          child: userSitesProviderState.when(
            init: () => const Center(child: Text('Initialisation...')),
            success: (_) => RefreshIndicator(
              color: const Color(0xFF8AAC3E),
              onRefresh: () async {
                // Effacer la recherche lors du rafraîchissement
                ref.read(searchQueryProvider.notifier).state = '';
                await ref
                    .read(userSitesViewModelStateNotifierProvider.notifier)
                    .loadSites();
              },
              child: _buildSiteListWidget(context, filteredSites, searchQuery),
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

  Widget _buildSiteListWidget(BuildContext context, List<BaseSite> sites, String searchQuery) {
    if (sites.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                searchQuery.isNotEmpty
                    ? 'Aucun résultat trouvé pour "$searchQuery"'
                    : 'Aucun site disponible.',
                style: const TextStyle(
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

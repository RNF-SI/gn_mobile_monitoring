import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gn_mobile_monitoring/core/theme/app_colors.dart';

/// Widget réutilisable pour la barre d'outils d'une liste (tri + recherche)
class ListToolbarWidget extends StatelessWidget {
  final bool showSearch;
  final String searchQuery;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final Function() onToggleSearch;
  final Function() onCloseSearch;
  final Position? userPosition;
  final bool sortByDistance;
  final Function() onToggleSort;
  final String searchHintText;
  final Widget? addButton;
  final String? label; // Label à afficher à gauche

  const ListToolbarWidget({
    super.key,
    required this.showSearch,
    required this.searchQuery,
    required this.searchController,
    required this.onSearchChanged,
    required this.onToggleSearch,
    required this.onCloseSearch,
    this.userPosition,
    this.sortByDistance = true,
    required this.onToggleSort,
    this.searchHintText = 'Rechercher...',
    this.addButton,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barre d'outils avec label, boutons et tri
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            children: [
              // Label (si fourni)
              if (label != null) ...[
                Text(
                  label!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                // const SizedBox(width: 8),
              ],
              // Bouton de recherche
              IconButton(
                icon: Icon(
                  showSearch ? Icons.search : Icons.search_outlined,
                  color: showSearch
                      ? Colors.white
                      : Theme.of(context).colorScheme.primary,
                ),
                tooltip: 'Rechercher',
                style: IconButton.styleFrom(
                  backgroundColor: showSearch
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                ),
                onPressed: onToggleSearch,
              ),
              // Bouton d'ajout (si fourni)
              if (addButton != null) ...[
                // const SizedBox(width: 0),
                addButton!,
              ],
              // Espace flexible pour pousser le bouton de tri à droite
              const Spacer(),
              // Bouton pour basculer entre tri par distance et alphabétique
              if (userPosition != null)
                ActionChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        sortByDistance
                            ? Icons.sort_by_alpha
                            : Icons.location_on,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        sortByDistance ? 'Alphabétique' : 'Distance',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  side: BorderSide.none,
                  backgroundColor: AppColors.primary,
                  onPressed: onToggleSort,
                ),
            ],
          ),
        ),
        // Champ de recherche (affiché conditionnellement)
        if (showSearch)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: searchHintText,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              tooltip: 'Effacer la recherche',
                              onPressed: () {
                                onSearchChanged('');
                                searchController.clear();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                    ),
                    onChanged: (value) {
                      onSearchChanged(value.toLowerCase());
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onCloseSearch,
                  icon: const Icon(Icons.close),
                  tooltip: 'Fermer la recherche',
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

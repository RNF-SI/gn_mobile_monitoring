import 'package:flutter/material.dart';

/// Widget réutilisable pour la barre de recherche
class SearchBarWidget extends StatelessWidget {
  final bool showSearch;
  final String searchQuery;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final Function() onToggleSearch;
  final Function() onCloseSearch;
  final String hintText;

  const SearchBarWidget({
    super.key,
    required this.showSearch,
    required this.searchQuery,
    required this.searchController,
    required this.onSearchChanged,
    required this.onToggleSearch,
    required this.onCloseSearch,
    this.hintText = 'Rechercher...',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showSearch)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onCloseSearch,
                  tooltip: 'Fermer la recherche',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: onSearchChanged,
            ),
          ),
      ],
    );
  }
}


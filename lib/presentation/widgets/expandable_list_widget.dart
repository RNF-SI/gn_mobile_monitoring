import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';

/// Widget générique pour afficher une liste d'éléments avec ExpansionTile
/// Supporte le tri par distance ou alphabétique, et l'affichage des propriétés
class ExpandableListWidget<T> extends StatelessWidget {
  final List<T> items;
  final int? expandedIndex;
  final Function(int?) onExpansionChanged;
  final Position? userPosition;
  final bool sortByDistance;
  final ObjectConfig? objectConfig;
  final CustomConfig? customConfig;
  final Map<String, dynamic> parsedConfig;
  final Widget Function(BuildContext, T, int) buildTitle;
  final Widget Function(BuildContext, T) buildProperties;
  final Widget? Function(BuildContext, T)? buildDistanceBadge;
  final double? Function(T)? calculateDistance;
  final String Function(
          T, String, ObjectConfig?, CustomConfig?, Map<String, dynamic>)
      getPropertyValue;
  final String?
      excludePropertyFromBody; // Propriété à exclure du body (ex: sites_group_name, base_site_name)
  final String emptyMessage;
  final Widget Function(BuildContext, T)? buildLeading;

  const ExpandableListWidget({
    super.key,
    required this.items,
    required this.expandedIndex,
    required this.onExpansionChanged,
    this.userPosition,
    this.sortByDistance = true,
    this.objectConfig,
    this.customConfig,
    required this.parsedConfig,
    required this.buildTitle,
    required this.buildProperties,
    this.buildDistanceBadge,
    this.calculateDistance,
    required this.getPropertyValue,
    this.excludePropertyFromBody,
    required this.emptyMessage,
    this.buildLeading,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(emptyMessage),
      );
    }

    // Trier les éléments selon le mode sélectionné
    List<T> sortedItems = List.from(items);

    if (sortByDistance && userPosition != null && calculateDistance != null) {
      // Tri par distance
      sortedItems.sort((a, b) {
        final distanceA = calculateDistance!(a);
        final distanceB = calculateDistance!(b);

        if (distanceA != null && distanceB != null) {
          return distanceA.compareTo(distanceB);
        }
        if (distanceA != null && distanceB == null) {
          return -1;
        }
        if (distanceA == null && distanceB != null) {
          return 1;
        }
        return 0;
      });
    } else {
      // Tri alphabétique par le premier champ de display_list
      final List<String>? displayProperties =
          objectConfig?.displayList ?? objectConfig?.displayProperties;

      if (displayProperties != null && displayProperties.isNotEmpty) {
        final firstProperty = displayProperties.first;

        sortedItems.sort((a, b) {
          final valueA = getPropertyValue(
              a, firstProperty, objectConfig, customConfig, parsedConfig);
          final valueB = getPropertyValue(
              b, firstProperty, objectConfig, customConfig, parsedConfig);
          return valueA.compareTo(valueB);
        });
      }
    }

    return ListView.builder(
      itemCount: sortedItems.length,
      itemBuilder: (context, index) {
        final item = sortedItems[index];
        final originalIndex = items.indexOf(item);
        final isExpanded = expandedIndex == originalIndex;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ExpansionTile(
            key: ValueKey('expansion_${originalIndex}_$expandedIndex'),
            shape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            collapsedShape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            childrenPadding: EdgeInsets.zero,
            leading: buildLeading != null ? buildLeading!(context, item) : null,
            title: Row(
              children: [
                Expanded(
                  child: buildTitle(context, item, originalIndex),
                ),
                if (buildDistanceBadge != null)
                  buildDistanceBadge!(context, item) ?? const SizedBox.shrink(),
              ],
            ),
            initiallyExpanded: isExpanded,
            onExpansionChanged: (bool expanded) {
              if (expanded) {
                onExpansionChanged(originalIndex);
              } else if (expandedIndex == originalIndex) {
                onExpansionChanged(null);
              }
            },
            children: [
              buildProperties(context, item),
            ],
          ),
        );
      },
    );
  }
}

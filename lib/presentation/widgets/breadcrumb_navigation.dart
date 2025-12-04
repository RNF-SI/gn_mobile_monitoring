import 'package:flutter/material.dart';

/// Widget pour afficher un fil d'Ariane de navigation adapté au mobile
/// Permet de voir le contexte hiérarchique actuel (Module > Site > Visite > Observation)
class BreadcrumbNavigation extends StatefulWidget {
  /// Liste des éléments du fil d'Ariane
  final List<BreadcrumbItem> items;

  /// Style pour le texte des éléments
  final TextStyle? textStyle;

  /// Couleur pour les séparateurs
  final Color? separatorColor;

  /// Afficher horizontalement ou verticalement
  final bool isVertical;

  /// L'icône à utiliser comme séparateur
  final IconData separatorIcon;

  /// Si true, permet d'afficher les éléments dans une ScrollView
  final bool scrollable;

  /// Constructeur
  const BreadcrumbNavigation({
    super.key,
    required this.items,
    this.textStyle,
    this.separatorColor,
    this.isVertical = false,
    this.separatorIcon = Icons.chevron_right,
    this.scrollable = true,
  });

  @override
  State<BreadcrumbNavigation> createState() => _BreadcrumbNavigationState();
}

class _BreadcrumbNavigationState extends State<BreadcrumbNavigation> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    // Le fil d'Ariane peut être affiché horizontalement ou verticalement
    if (widget.isVertical) {
      return _buildVerticalBreadcrumb(context);
    } else {
      return _buildMobileBreadcrumb(context);
    }
  }

  /// Construit un fil d'Ariane adapté au mobile
  Widget _buildMobileBreadcrumb(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Titre du fil d'Ariane
          Row(
            children: [
              Icon(
                Icons.navigation,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                'Navigation',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Fil d'Ariane générique (toujours visible)
          _buildGenericBreadcrumb(context),

          // Bouton pour afficher/masquer les détails
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _showDetails = !_showDetails;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _showDetails ? Icons.expand_less : Icons.expand_more,
                  size: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 4),
                Text(
                  _showDetails ? 'Masquer les détails' : 'Afficher les détails',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Détails (affichés conditionnellement)
          if (_showDetails) ...[
            const SizedBox(height: 8),
            _buildDetailedBreadcrumb(context),
          ],
        ],
      ),
    );
  }

  /// Construit le fil d'Ariane générique (labels seulement)
  Widget _buildGenericBreadcrumb(BuildContext context) {
    final breadcrumbItems = <Widget>[];

    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      final isLast = i == widget.items.length - 1;

      // Ajouter l'élément générique
      breadcrumbItems.add(
        _buildGenericBreadcrumbItem(item, context, isLast),
      );

      // Ajouter le séparateur si ce n'est pas le dernier élément
      if (!isLast) {
        breadcrumbItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Icon(
              widget.separatorIcon,
              size: 14,
              color: widget.separatorColor ??
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        );
      }
    }

    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: breadcrumbItems,
    );
  }

  /// Construit un élément générique du fil d'Ariane
  Widget _buildGenericBreadcrumbItem(
      BreadcrumbItem item, BuildContext context, bool isLast) {
    final style = TextStyle(
      fontSize: 14,
      fontWeight: isLast ? FontWeight.bold : FontWeight.w500,
      color: isLast
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
    );

    if (item.onTap != null && !isLast) {
      return InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
          child: Text(item.label, style: style),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
        child: Text(item.label, style: style),
      );
    }
  }

  /// Construit le fil d'Ariane détaillé (avec les valeurs)
  Widget _buildDetailedBreadcrumb(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.items
            .map((item) => _buildDetailedBreadcrumbItem(item, context))
            .toList(),
      ),
    );
  }

  /// Construit un élément détaillé du fil d'Ariane
  Widget _buildDetailedBreadcrumbItem(
      BreadcrumbItem item, BuildContext context) {
    final isLast = widget.items.indexOf(item) == widget.items.length - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '${item.label}:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: item.onTap != null && !isLast
                ? InkWell(
                    onTap: item.onTap,
                    child: Text(
                      item.value,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                : Text(
                    item.value,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                      color: isLast
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  /// Construit un fil d'Ariane horizontal (par défaut - conservé pour compatibilité)
  Widget _buildHorizontalBreadcrumb(BuildContext context) {
    final defaultTextStyle = widget.textStyle ??
        TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8));

    final breadcrumbItems = <Widget>[];

    // Construire la liste des éléments avec les séparateurs
    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];

      // Ajouter l'élément
      breadcrumbItems.add(_buildBreadcrumbItemWidget(
          item, context, defaultTextStyle, i == widget.items.length - 1));

      // Ajouter le séparateur si ce n'est pas le dernier élément
      if (i < widget.items.length - 1) {
        breadcrumbItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(
              widget.separatorIcon,
              size: 14,
              color: widget.separatorColor ??
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        );
      }
    }

    // Renvoyer le widget final, scrollable ou non
    if (widget.scrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: breadcrumbItems,
        ),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: breadcrumbItems,
      );
    }
  }

  /// Construit un fil d'Ariane vertical
  Widget _buildVerticalBreadcrumb(BuildContext context) {
    final defaultTextStyle = widget.textStyle ??
        TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8));

    final breadcrumbItems = <Widget>[];

    // Construire la liste des éléments avec les séparateurs
    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];

      // Ajouter l'élément
      breadcrumbItems.add(_buildBreadcrumbItemWidget(
          item, context, defaultTextStyle, i == widget.items.length - 1));

      // Ajouter le séparateur si ce n'est pas le dernier élément
      if (i < widget.items.length - 1) {
        breadcrumbItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: widget.separatorColor ??
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: breadcrumbItems,
    );
  }

  /// Construit un élément du fil d'Ariane
  Widget _buildBreadcrumbItemWidget(BreadcrumbItem item, BuildContext context,
      TextStyle defaultTextStyle, bool isLast) {
    // Le dernier élément est mis en évidence
    final style = isLast
        ? defaultTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          )
        : defaultTextStyle;

    // Si l'élément a une action de navigation, le rendre cliquable
    if (item.onTap != null) {
      return InkWell(
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
          child: Text(
            '${item.label}: ${item.value}',
            style: style,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        child: Text(
          '${item.label}: ${item.value}',
          style: style,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }
}

/// Classe représentant un élément du fil d'Ariane
class BreadcrumbItem {
  /// Le libellé de l'élément (ex: "Module", "Site")
  final String label;

  /// La valeur à afficher (ex: "Apollons", "1")
  final String value;

  /// L'action à effectuer lorsqu'on clique sur l'élément (optionnel)
  final VoidCallback? onTap;

  /// Le contexte associé à cet élément (pour la navigation)
  final Map<String, dynamic>? context;

  BreadcrumbItem({
    required this.label,
    required this.value,
    this.onTap,
    this.context,
  });
}

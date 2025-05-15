import 'package:flutter/material.dart';

/// Widget pour afficher un fil d'Ariane de navigation adapté au mobile
/// Permet de voir le contexte hiérarchique actuel (Module > Site > Visite > Observation)
class BreadcrumbNavigation extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // Le fil d'Ariane peut être affiché horizontalement ou verticalement
    if (isVertical) {
      return _buildVerticalBreadcrumb(context);
    } else {
      return _buildHorizontalBreadcrumb(context);
    }
  }
  
  /// Construit un fil d'Ariane horizontal (par défaut)
  Widget _buildHorizontalBreadcrumb(BuildContext context) {
    final defaultTextStyle = textStyle ?? 
      TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8));
    
    final breadcrumbItems = <Widget>[];
    
    // Construire la liste des éléments avec les séparateurs
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      
      // Ajouter l'élément
      breadcrumbItems.add(
        _buildBreadcrumbItemWidget(item, context, defaultTextStyle, i == items.length - 1)
      );
      
      // Ajouter le séparateur si ce n'est pas le dernier élément
      if (i < items.length - 1) {
        breadcrumbItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(
              separatorIcon,
              size: 14,
              color: separatorColor ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        );
      }
    }
    
    // Renvoyer le widget final, scrollable ou non
    if (scrollable) {
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
    final defaultTextStyle = textStyle ?? 
      TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8));
    
    final breadcrumbItems = <Widget>[];
    
    // Construire la liste des éléments avec les séparateurs
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      
      // Ajouter l'élément
      breadcrumbItems.add(
        _buildBreadcrumbItemWidget(item, context, defaultTextStyle, i == items.length - 1)
      );
      
      // Ajouter le séparateur si ce n'est pas le dernier élément
      if (i < items.length - 1) {
        breadcrumbItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: separatorColor ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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
  Widget _buildBreadcrumbItemWidget(
    BreadcrumbItem item, 
    BuildContext context, 
    TextStyle defaultTextStyle,
    bool isLast
  ) {
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
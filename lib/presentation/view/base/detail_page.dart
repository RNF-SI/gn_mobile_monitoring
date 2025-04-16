import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';
import 'package:gn_mobile_monitoring/core/helpers/value_formatter.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/property_display_widget.dart';

/// Page de détail de base pour afficher les différents types d'objets
/// (modules, sites, visites, observations, etc.)
/// Cette classe sert de base pour toutes les pages de détail
/// en utilisant systématiquement generateUnifiedSchema pour le parsing des configurations
abstract class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  DetailPageState createState();
}

abstract class DetailPageState<T extends DetailPage> extends State<T> {
  /// Configuration de l'objet affiché
  ObjectConfig? get objectConfig;

  /// Données personnalisées de la configuration
  CustomConfig? get customConfig;

  /// Propriétés à afficher (depuis la configuration)
  List<String>? get displayProperties;

  /// Données de l'objet à afficher
  Map<String, dynamic> get objectData;

  /// Titre de la section des propriétés
  String get propertiesTitle => 'Propriétés';

  /// Éléments du fil d'Ariane pour la navigation
  List<BreadcrumbItem> getBreadcrumbItems();

  /// Type d'objets enfants (sites, visites, observations, etc.)
  List<String> get childrenTypes => [];

  /// Indique si les champs vides doivent être séparés
  bool get separateEmptyFields => false;

  /// Méthode pour générer le schéma unifié à partir de la configuration
  Map<String, dynamic> generateSchema() {
    if (objectConfig == null) {
      return {};
    }

    return FormConfigParser.generateUnifiedSchema(objectConfig!, customConfig);
  }

  /// Construit le widget pour afficher les propriétés de l'objet
  Widget buildPropertiesWidget() {
    return PropertyDisplayWidget(
      data: objectData,
      config: objectConfig,
      customConfig: customConfig,
      title: propertiesTitle,
      separateEmptyFields: separateEmptyFields,
    );
  }

  /// Construit le fil d'Ariane
  Widget buildBreadcrumb() {
    final items = getBreadcrumbItems();
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: BreadcrumbNavigation(items: items),
        ),
      ),
    );
  }

  /// Widget pour le contenu de base (propriétés)
  Widget buildBaseContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPropertiesWidget(),
        ],
      ),
    );
  }

  /// Widget pour le contenu des enfants (à implémenter dans les sous-classes si nécessaire)
  Widget? buildChildrenContent() {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final childContent = buildChildrenContent();

    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildBreadcrumb(),
          if (childContent == null)
            Expanded(child: buildBaseContent())
          else
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: buildBaseContent(),
                  ),
                  Expanded(
                    flex: 3,
                    child: childContent,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Construit l'AppBar (à surcharger dans les sous-classes)
  PreferredSizeWidget buildAppBar() {
    return AppBar(
      title: Text(getTitle()),
    );
  }

  /// Obtient le titre de la page (à surcharger dans les sous-classes)
  String getTitle() {
    return 'Détails';
  }

  // MÉTHODES COMMUNES POUR LES TABLEAUX DE DONNÉES

  /// Détermine les colonnes à afficher dans un tableau de données
  /// basé sur la configuration et les données
  List<String> determineDataColumns({
    required List<String>
        standardColumns, // Colonnes toujours affichées (ex: 'actions', 'date')
    ObjectConfig?
        itemConfig, // Configuration de l'élément (visite, observation)
    Map<String, dynamic>?
        firstItemData, // Données du premier élément pour auto-détection
    bool filterMetaColumns =
        true, // Filtrer les colonnes de métadonnées (geom, uuid, meta)
  }) {
    List<String> displayColumns = List.from(standardColumns);
    Set<String> allPossibleKeys = <String>{};

    // Utiliser en priorité les propriétés définies dans la configuration
    if (itemConfig?.displayList != null &&
        itemConfig!.displayList!.isNotEmpty) {
      allPossibleKeys.addAll(itemConfig.displayList!);
    } else if (itemConfig?.displayProperties != null &&
        itemConfig!.displayProperties!.isNotEmpty) {
      allPossibleKeys.addAll(itemConfig.displayProperties!);
    }

    // Ajouter les propriétés de generic et specific si disponibles
    if (itemConfig != null) {
      if (itemConfig.generic != null) {
        allPossibleKeys.addAll(itemConfig.generic!.keys);
      }
      if (itemConfig.specific != null) {
        allPossibleKeys.addAll(itemConfig.specific!.keys);
      }
      if (itemConfig.propertiesKeys != null) {
        allPossibleKeys.addAll(itemConfig.propertiesKeys!);
      }
    }

    // Ajouter les clés trouvées dans les données
    if (firstItemData != null) {
      allPossibleKeys.addAll(firstItemData.keys);
    }

    // Filtrer les clés pour ne garder que les pertinentes
    List<String> filteredKeys = allPossibleKeys.where((key) {
      bool keyIsValid = !displayColumns.contains(key);

      if (filterMetaColumns) {
        keyIsValid = keyIsValid &&
            !key.contains('geom') &&
            !key.contains('uuid') &&
            !key.contains('meta');
      }

      return keyIsValid;
    }).toList();

    // Prioriser les clés plutôt que les limiter
    List<String> priorityKeys = [];
    if (itemConfig?.displayList != null) {
      priorityKeys.addAll(itemConfig!.displayList!);
    } else if (itemConfig?.displayProperties != null) {
      priorityKeys.addAll(itemConfig!.displayProperties!);
    }

    // Trier les clés pour mettre en priorité celles définies dans la configuration
    filteredKeys.sort((a, b) {
      // Si a est dans priorityKeys mais pas b, a vient en premier
      if (priorityKeys.contains(a) && !priorityKeys.contains(b)) {
        return -1;
      }
      // Si b est dans priorityKeys mais pas a, b vient en premier
      if (!priorityKeys.contains(a) && priorityKeys.contains(b)) {
        return 1;
      }
      // Sinon, ordre alphabétique
      return a.compareTo(b);
    });

    // Ajouter les clés filtrées aux colonnes
    displayColumns.addAll(filteredKeys);

    return displayColumns;
  }

  /// Construit les colonnes d'un DataTable basé sur la configuration
  List<DataColumn> buildDataColumns({
    required List<String> columns,
    required ObjectConfig? itemConfig,
    Map<String, String> predefinedLabels = const {},
  }) {
    // Générer le schéma unifié à partir de la configuration
    Map<String, dynamic> schema = {};
    if (itemConfig != null) {
      schema = FormConfigParser.generateUnifiedSchema(itemConfig, customConfig);
    }

    return columns.map((column) {
      String label = column;

      // Vérifier d'abord les labels prédéfinis
      if (predefinedLabels.containsKey(column)) {
        label = predefinedLabels[column]!;
      }
      // Sinon rechercher dans la configuration
      else {
        if (itemConfig != null) {
          // Vérifier dans la configuration parsée
          if (schema.containsKey(column) &&
              schema[column].containsKey('attribut_label')) {
            label = schema[column]['attribut_label'];
          }
          // Vérifier dans generic
          else if (itemConfig.generic != null &&
              itemConfig.generic!.containsKey(column)) {
            label = itemConfig.generic![column]!.attributLabel ?? column;
          }
          // Vérifier dans specific
          else if (itemConfig.specific != null &&
              itemConfig.specific!.containsKey(column)) {
            final specificConfig =
                itemConfig.specific![column] as Map<String, dynamic>?;
            if (specificConfig != null &&
                specificConfig.containsKey('attribut_label')) {
              label = specificConfig['attribut_label'];
            }
          }
        }
      }

      // Formater le libellé pour une meilleure présentation
      label = ValueFormatter.formatLabel(label);

      return DataColumn(
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }).toList();
  }

  /// Formate une valeur en fonction de son type et de la configuration
  String formatDataCellValue({
    required dynamic rawValue,
    required String columnName,
    required Map<String, dynamic> schema,
  }) {
    if (rawValue == null) {
      return '';
    }

    // Valeur par défaut en cas d'erreur de formatage
    String displayValue = ValueFormatter.format(rawValue);

    try {
      // Utiliser le type défini dans le schéma pour formater correctement la valeur
      if (schema.containsKey(columnName)) {
        final fieldConfig = schema[columnName];
        final typeWidget = fieldConfig['type_widget'];

        // Formater en fonction du type de widget
        switch (typeWidget) {
          case 'nomenclature':
            // Idéalement récupérer le label de la nomenclature
            // Pour l'instant, on utilise juste la valeur brute
            displayValue = rawValue.toString();
            break;
          case 'checkbox':
            displayValue = rawValue == true ? 'Oui' : 'Non';
            break;
          case 'date':
          case 'datetime':
            if (rawValue is String) {
              displayValue = formatDateString(rawValue);
            }
            break;
          case 'number':
            if (rawValue is num) {
              // Appliquer un format spécifique pour les nombres si nécessaire
              displayValue = ValueFormatter.format(rawValue);
            }
            break;
          case 'text':
          case 'textarea':
            if (rawValue is String) {
              displayValue = rawValue;
            }
            break;
          default:
            displayValue = ValueFormatter.format(rawValue);
        }
      }
    } catch (e) {
      // En cas d'erreur de formatage, utiliser le format par défaut
      debugPrint('Erreur de formatage pour $columnName: $e');
    }

    return displayValue;
  }

  /// Construit une cellule de données formatée avec tooltip pour les valeurs longues
  DataCell buildFormattedDataCell({
    required String value,
    bool enableTooltip = true,
    int tooltipThreshold = 30,
    int maxLines = 1,
  }) {
    return DataCell(
      Tooltip(
        message: enableTooltip && value.length > tooltipThreshold ? value : '',
        child: Text(
          value,
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
        ),
      ),
    );
  }

  /// Couleurs et styles communs pour les tableaux
  static const Color tableHeaderColor = Color(0xFFE8F5E9);
  static const Color tableRowColor = Colors.white;
  static const Color tableAlternateRowColor = Color(0xFFF5F5F5);
  static const Color tableBorderColor = Color(0xFFDDDDDD);

  /// Construit un onglet avec TabBar
  Widget buildTabBar({
    required TabController tabController,
    required List<Tab> tabs,
  }) {
    return Material(
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: TabBar(
        controller: tabController,
        tabs: tabs,
        labelColor: Theme.of(context).primaryColor,
        indicatorColor: Theme.of(context).primaryColor,
      ),
    );
  }

  /// Construit un tableau de données avec le style standardisé
  Widget buildDataTable({
    required List<DataColumn> columns,
    required List<DataRow> rows,
    bool showSearch = true,
    String searchHint = 'Rechercher',
    TextEditingController? searchController,
    Function(String)? onSearchChanged,
    Widget? headerActions,
    bool isLoading = false,
    Widget? emptyMessage,
  }) {
    return Container(
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Barre avec bouton d'ajout + recherche
            if (showSearch || headerActions != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    if (headerActions != null) headerActions,
                    const Spacer(),
                    if (showSearch && searchController != null)
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: searchHint,
                            suffixIcon: searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      searchController.clear();
                                      if (onSearchChanged != null) {
                                        onSearchChanged('');
                                      }
                                    },
                                  )
                                : const Icon(Icons.search),
                            border: const OutlineInputBorder(),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          onChanged: onSearchChanged,
                        ),
                      ),
                  ],
                ),
              ),

            // Tableau de données
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : rows.isEmpty
                      ? Center(
                          child: emptyMessage ??
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.info_outline,
                                      size: 48, color: Colors.grey),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Aucune donnée disponible',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                        )
                      : Card(
                          elevation: 2,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              child: DataTable(
                                columns: columns,
                                rows: rows,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: tableBorderColor,
                                    width: 1,
                                  ),
                                ),
                                headingRowColor: MaterialStateProperty.all(
                                  tableHeaderColor,
                                ),
                              ),
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

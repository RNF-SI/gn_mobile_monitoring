import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
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
}
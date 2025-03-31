import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';
import 'package:intl/intl.dart';

class SiteDetailPage extends ConsumerWidget {
  // Fonction d'aide pour formater les dates
  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  final BaseSite site;
  final ModuleInfo? moduleInfo;
  final dynamic siteGroup; // Peut être un SiteGroup si ouvert depuis un groupe

  const SiteDetailPage({
    super.key,
    required this.site,
    this.moduleInfo,
    this.siteGroup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Récupérer l'ID du module depuis moduleInfo
    final int? moduleId = moduleInfo?.module.id;

    // Utiliser le provider avec l'ID du module si disponible
    final visitsState =
        ref.watch(siteVisitsViewModelProvider((site.idBaseSite, moduleId!)));

    // Récupérer la configuration des visites depuis le module
    final ObjectConfig? visitConfig =
        moduleInfo?.module.complement?.configuration?.visit;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${moduleInfo?.module.complement?.configuration?.site?.label ?? 'Site'}: ${site.baseSiteName ?? 'Détails'}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fil d'Ariane pour la navigation
          if (moduleInfo != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  child: BreadcrumbNavigation(
                    items: [
                      // Module
                      BreadcrumbItem(
                        label: 'Module',
                        value: moduleInfo!.module.moduleLabel ?? 'Module',
                        onTap: () {
                          // Retour au module (peut être à plusieurs niveaux)
                          if (siteGroup != null) {
                            // Si ouvert depuis un groupe, retourner de 2 niveaux
                            Navigator.of(context).popUntil((route) =>
                                route.isFirst ||
                                route.settings.name == '/module_detail');
                          } else {
                            Navigator.of(context)
                                .pop(); // Retour simple à la page précédente
                          }
                        },
                      ),
                      // Groupe de site (si disponible)
                      if (siteGroup != null)
                        BreadcrumbItem(
                          label: moduleInfo!.module.complement?.configuration
                                  ?.sitesGroup?.label ??
                              'Groupe',
                          value: siteGroup.sitesGroupName ??
                              siteGroup.sitesGroupCode ??
                              'Groupe',
                          onTap: () {
                            Navigator.of(context)
                                .pop(); // Retour à la page du groupe
                          },
                        ),
                      // Site (actuel)
                      BreadcrumbItem(
                        label: moduleInfo!.module.complement?.configuration
                                ?.site?.label ??
                            'Site',
                        value:
                            site.baseSiteName ?? site.baseSiteCode ?? 'Détails',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Properties Card
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        moduleInfo?.module.complement?.configuration?.site
                                ?.label ??
                            'Propriétés',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildPropertyRow(
                        _getFieldLabel('base_site_name', 'Nom', moduleInfo),
                        site.baseSiteName ?? ''),
                    _buildPropertyRow(
                        _getFieldLabel('base_site_code', 'Code', moduleInfo),
                        site.baseSiteCode ?? ''),
                    // Maintenant on affiche la description si disponible
                    if (site.baseSiteDescription != null &&
                        site.baseSiteDescription!.isNotEmpty)
                      _buildPropertyRow(
                          _getFieldLabel('base_site_description', 'Description',
                              moduleInfo),
                          site.baseSiteDescription!),
                    // Affichage de l'altitude si disponible
                    if (site.altitudeMin != null || site.altitudeMax != null)
                      _buildPropertyRow(
                        'Altitude',
                        site.altitudeMin != null && site.altitudeMax != null
                            ? '${site.altitudeMin}-${site.altitudeMax} m'
                            : site.altitudeMin != null
                                ? '${site.altitudeMin} m'
                                : '${site.altitudeMax} m',
                      ),
                    // Affichage de la date de première utilisation si disponible
                    if (site.firstUseDate != null)
                      _buildPropertyRow(
                        'Date de première utilisation',
                        _formatDate(site.firstUseDate!),
                      ),
                    // Ajout de l'identifiant UUID si disponible
                    if (site.uuidBaseSite != null &&
                        site.uuidBaseSite!.isNotEmpty)
                      _buildPropertyRow('UUID', site.uuidBaseSite!),
                  ],
                ),
              ),
            ),
          ),

          // Visits Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  visitConfig?.label ?? 'Visites',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (visitConfig != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VisitFormPage(
                            site: site,
                            visitConfig: visitConfig,
                            customConfig: moduleInfo
                                ?.module.complement?.configuration?.custom,
                            moduleId: moduleInfo?.module.id,
                            moduleInfo: moduleInfo, // Pour le fil d'Ariane
                            siteGroup: siteGroup, // Pour le fil d'Ariane
                          ),
                        ),
                      ).then((_) {
                        // Rafraîchir la liste des visites après ajout
                        ref
                            .read(siteVisitsViewModelProvider(
                                (site.idBaseSite, moduleId)).notifier)
                            .loadVisits();
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Configuration de visite non disponible'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter une visite'),
                ),
              ],
            ),
          ),

          // Visits Table
          Expanded(
            child: visitsState.when(
              data: (visits) => _buildVisitsTable(visits, visitConfig, context),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text(
                  'Erreur lors du chargement des visites: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitsTable(
      List<BaseVisit> visits, ObjectConfig? visitConfig, BuildContext context) {
    if (visits.isEmpty) {
      return const Center(
        child: Text('Aucune visite pour ce site'),
      );
    }

    // Colonnes du tableau
    const List<String> defaultColumns = [
      'actions',
      'visit_date_min',
      'observers',
      'comments'
    ];

    // Utiliser les propriétés d'affichage de la configuration si disponibles
    final List<String> displayColumns =
        visitConfig?.displayList?.isNotEmpty ?? false
            ? ['actions', ...(visitConfig?.displayList ?? [])]
            : visitConfig?.displayProperties?.isNotEmpty ?? false
                ? ['actions', ...(visitConfig?.displayProperties ?? [])]
                : defaultColumns;

    // Obtenir le schéma unifié de la configuration des visites pour les libellés
    final unifiedSchema = visitConfig != null
        ? FormConfigParser.generateUnifiedSchema(
            visitConfig,
            moduleInfo?.module.complement?.configuration?.custom,
          )
        : <String, dynamic>{};

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            // Corps du tableau (scrollable verticalement)
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: displayColumns.map((column) {
                      String label =
                          _getColumnLabel(column, unifiedSchema, visitConfig);
                      return DataColumn(
                        label: Text(
                          label,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                    rows: visits.map((visit) {
                      return DataRow(
                        cells: displayColumns.map((column) {
                          return DataCell(
                            _buildVisitTableCell(
                                column, visit, visitConfig, context),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit une cellule du tableau en fonction du type de colonne
  Widget _buildVisitTableCell(String column, BaseVisit visit,
      ObjectConfig? visitConfig, BuildContext context) {
    switch (column) {
      case 'actions':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bouton d'édition
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () {
                if (visitConfig != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VisitFormPage(
                          site: site,
                          visitConfig: visitConfig,
                          customConfig: moduleInfo
                              ?.module.complement?.configuration?.custom,
                          moduleId: moduleInfo?.module.id,
                          visit: visit, // Passer la visite à éditer
                          moduleInfo: moduleInfo, // Pour le fil d'Ariane
                          siteGroup: siteGroup // Pour le fil d'Ariane
                          ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Configuration de visite non disponible'),
                    ),
                  );
                }
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 36,
                minHeight: 36,
              ),
              tooltip: 'Modifier',
            ),
            // Bouton de visualisation
            IconButton(
              icon: const Icon(Icons.visibility, size: 20),
              onPressed: () {
                // Naviguer vers la page de détail de la visite
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VisitDetailPage(
                      visit: visit,
                      site: site,
                      moduleInfo: moduleInfo,
                      fromSiteGroup: siteGroup,
                      isNewVisit:
                          false, // Indiquer explicitement que ce n'est pas une nouvelle visite
                    ),
                  ),
                );
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 36,
                minHeight: 36,
              ),
              tooltip: 'Voir les détails',
            ),
          ],
        );

      case 'visit_date_min':
        return Text(
          visit.visitDateMax != null && visit.visitDateMax != visit.visitDateMin
              ? '${formatDateString(visit.visitDateMin)} - ${formatDateString(visit.visitDateMax!)}'
              : formatDateString(visit.visitDateMin),
          style: const TextStyle(fontWeight: FontWeight.w500),
        );

      case 'observers':
        return Text(
          visit.observers != null && visit.observers!.isNotEmpty
              ? '${visit.observers!.length}'
              : '0',
        );

      case 'comments':
        return Text(
          visit.comments ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        );

      default:
        // Pour les données spécifiques au module (dans le champ data)
        if (visit.data != null && visit.data!.containsKey(column)) {
          final value = visit.data![column];
          return Text(
            value?.toString() ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }

        // Si la colonne n'est pas trouvée, afficher une cellule vide
        return const Text('-');
    }
  }

  /// Obtient le libellé d'une colonne à partir de la configuration
  String _getColumnLabel(String column, Map<String, dynamic> unifiedSchema,
      ObjectConfig? visitConfig) {
    // Pour la colonne des actions
    if (column == 'actions') {
      return 'Actions';
    }

    String label = column;

    // Chercher dans le schéma unifié
    if (unifiedSchema.containsKey(column)) {
      label = unifiedSchema[column]['attribut_label'] ?? column;
    }
    // Vérifier directement dans la configuration si le schéma unifié ne contient pas la colonne
    else if (visitConfig?.generic != null &&
        visitConfig!.generic!.containsKey(column)) {
      label = visitConfig.generic![column]!.attributLabel ?? column;
    } else if (visitConfig?.specific != null &&
        visitConfig!.specific!.containsKey(column)) {
      final specificConfig =
          visitConfig.specific![column] as Map<String, dynamic>;
      if (specificConfig.containsKey('attribut_label')) {
        label = specificConfig['attribut_label'];
      }
    }

    // Formater le libellé (première lettre en majuscule, underscore remplacés par des espaces)
    return label
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }

  /// Méthode pour obtenir le libellé d'un champ à partir de la configuration du module
  String _getFieldLabel(
      String fieldName, String defaultLabel, ModuleInfo? moduleInfo) {
    if (moduleInfo == null ||
        moduleInfo.module.complement?.configuration == null) {
      return defaultLabel;
    }

    // Récupérer la configuration du site
    final siteConfig = moduleInfo.module.complement?.configuration?.site;
    final customConfig = moduleInfo.module.complement?.configuration?.custom;

    if (siteConfig == null) {
      return defaultLabel;
    }

    // Générer le schéma unifié
    final unifiedSchema =
        FormConfigParser.generateUnifiedSchema(siteConfig, customConfig);

    // Chercher le libellé dans le schéma
    if (unifiedSchema.containsKey(fieldName) &&
        unifiedSchema[fieldName].containsKey('attribut_label')) {
      return unifiedSchema[fieldName]['attribut_label'];
    }

    // Si pas trouvé dans le schéma, vérifier dans les champs generic
    if (siteConfig.generic != null &&
        siteConfig.generic!.containsKey(fieldName)) {
      return siteConfig.generic![fieldName]!.attributLabel ?? defaultLabel;
    }

    return defaultLabel;
  }

  Widget _buildPropertyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

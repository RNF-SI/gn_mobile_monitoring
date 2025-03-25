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

class SiteDetailPage extends ConsumerWidget {
  final BaseSite site;
  final ModuleInfo? moduleInfo;

  const SiteDetailPage({
    super.key,
    required this.site,
    this.moduleInfo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitsState = ref.watch(siteVisitsViewModelProvider(site.idBaseSite));

    // Récupérer la configuration des visites depuis le module
    final ObjectConfig? visitConfig =
        moduleInfo?.module.complement?.configuration?.visit;

    return Scaffold(
      appBar: AppBar(
        title: Text(site.baseSiteName ?? 'Détails du site'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Properties Card
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Propriétés',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildPropertyRow('Nom', site.baseSiteName ?? ''),
                    _buildPropertyRow('Code', site.baseSiteCode ?? ''),
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
                          ),
                        ),
                      ).then((_) {
                        // Rafraîchir la liste des visites après ajout
                        ref
                            .read(siteVisitsViewModelProvider(site.idBaseSite)
                                .notifier)
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
    const List<String> defaultColumns = ['actions', 'visit_date_min', 'observers', 'comments'];
    
    // Utiliser les propriétés d'affichage de la configuration si disponibles
    final List<String> displayColumns = visitConfig?.displayList?.isNotEmpty ?? false
        ? ['actions', ...visitConfig!.displayList!]
        : visitConfig?.displayProperties?.isNotEmpty ?? false
            ? ['actions', ...visitConfig!.displayProperties!]
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
      child: SingleChildScrollView(
        child: Table(
          columnWidths: _getColumnWidths(displayColumns),
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              ),
              children: displayColumns.map((column) {
                // Déterminer le libellé de la colonne
                String label = _getColumnLabel(column, unifiedSchema, visitConfig);
                
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0, 
                    horizontal: column == 'actions' ? 16.0 : 8.0
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
            ...visits.map((visit) => TableRow(
                  children: displayColumns.map((column) {
                    // Générer la cellule en fonction du type de colonne
                    return _buildVisitTableCell(column, visit, visitConfig, context);
                  }).toList(),
                )),
          ],
        ),
      ),
    );
  }

  /// Génère les largeurs des colonnes en fonction des colonnes affichées
  Map<int, TableColumnWidth> _getColumnWidths(List<String> columns) {
    final Map<int, TableColumnWidth> widths = {};
    
    for (int i = 0; i < columns.length; i++) {
      final column = columns[i];
      
      if (column == 'actions') {
        widths[i] = const FixedColumnWidth(120);
      } else if (column == 'observers') {
        widths[i] = const FlexColumnWidth(1);
      } else if (column == 'visit_date_min' || column == 'date' || column.contains('date')) {
        widths[i] = const FlexColumnWidth(3);
      } else if (column == 'comments') {
        widths[i] = const FlexColumnWidth(4);
      } else {
        // Autres colonnes - largeur par défaut
        widths[i] = const FlexColumnWidth(2);
      }
    }
    
    return widths;
  }
  
  /// Construit une cellule du tableau en fonction du type de colonne
  Widget _buildVisitTableCell(String column, BaseVisit visit, ObjectConfig? visitConfig, BuildContext context) {
    switch (column) {
      case 'actions':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          height: 48,
          alignment: Alignment.center,
          child: Row(
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
                          customConfig: moduleInfo?.module
                              .complement?.configuration?.custom,
                          moduleId: moduleInfo?.module.id,
                          visit: visit, // Passer la visite à éditer
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Configuration de visite non disponible'),
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
          ),
        );
        
      case 'visit_date_min':
        return Container(
          height: 48,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            visit.visitDateMax != null &&
                    visit.visitDateMax != visit.visitDateMin
                ? '${formatDateString(visit.visitDateMin)} - ${formatDateString(visit.visitDateMax!)}'
                : formatDateString(visit.visitDateMin),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        );
        
      case 'observers':
        return Container(
          height: 48,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: visit.observers != null && visit.observers!.isNotEmpty
              ? Text('${visit.observers!.length}')
              : const Text('0'),
        );
        
      case 'comments':
        return Container(
          height: 48,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            visit.comments ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
        
      default:
        // Pour les données spécifiques au module (dans le champ data)
        if (visit.data != null && visit.data!.containsKey(column)) {
          final value = visit.data![column];
          return Container(
            height: 48,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              value?.toString() ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }
        
        // Si la colonne n'est pas trouvée, afficher une cellule vide
        return Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.centerLeft,
          child: const Text('-'),
        );
    }
  }
  
  /// Obtient le libellé d'une colonne à partir de la configuration
  String _getColumnLabel(String column, Map<String, dynamic> unifiedSchema, ObjectConfig? visitConfig) {
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
    else if (visitConfig?.generic != null && visitConfig!.generic!.containsKey(column)) {
      label = visitConfig.generic![column]!.attributLabel ?? column;
    } 
    else if (visitConfig?.specific != null && visitConfig!.specific!.containsKey(column)) {
      final specificConfig = visitConfig.specific![column] as Map<String, dynamic>;
      if (specificConfig.containsKey('attribut_label')) {
        label = specificConfig['attribut_label'];
      }
    }
    
    // Formater le libellé (première lettre en majuscule, underscore remplacés par des espaces)
    return label
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
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

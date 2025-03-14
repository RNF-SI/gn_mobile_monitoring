import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
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
    final ObjectConfig? visitConfig = moduleInfo?.module.complement?.configuration?.visit;

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
                    _buildPropertyRow(
                        'Description', site.baseSiteDescription ?? ''),
                    _buildPropertyRow(
                      'Altitude',
                      site.altitudeMin != null &&
                              site.altitudeMax != null
                          ? '${site.altitudeMin}-${site.altitudeMax}m'
                          : site.altitudeMin?.toString() ??
                              site.altitudeMax?.toString() ??
                              '',
                    ),
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
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            customConfig: moduleInfo?.module.complement?.configuration?.custom,
                          ),
                        ),
                      ).then((_) {
                        // Rafraîchir la liste des visites après ajout
                        ref.read(siteVisitsViewModelProvider(site.idBaseSite).notifier).loadVisits();
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Configuration de visite non disponible'),
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

  Widget _buildVisitsTable(List<BaseVisit> visits, ObjectConfig? visitConfig, BuildContext context) {
    if (visits.isEmpty) {
      return const Center(
        child: Text('Aucune visite pour ce site'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Table(
          columnWidths: const {
            0: FixedColumnWidth(80), // Action column
            1: FlexColumnWidth(1), // Date column
            2: FlexColumnWidth(1), // Observer column
            3: FlexColumnWidth(2), // Comments column
          },
          children: [
            const TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Text('Action',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Date',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Observateur',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Commentaire',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            ...visits.map((visit) => TableRow(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0),
                  height: 48,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                                  customConfig: moduleInfo?.module.complement?.configuration?.custom,
                                  visit: visit, // Passer la visite à éditer
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
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 48,
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(formatDate(visit.visitDateMin)),
                ),
                Container(
                  height: 48,
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(visit.idDigitiser?.toString() ?? ''),
                ),
                Container(
                  height: 48,
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(visit.comments ?? ''),
                ),
              ],
            )),
          ],
        ),
      ),
    );
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
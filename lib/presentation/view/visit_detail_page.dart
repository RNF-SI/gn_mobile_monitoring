import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';

class VisitDetailPage extends ConsumerWidget {
  final BaseVisit visit;
  final BaseSite site;
  final ModuleInfo? moduleInfo;

  const VisitDetailPage({
    super.key,
    required this.visit,
    required this.site,
    this.moduleInfo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Récupérer la configuration des visites depuis le module
    final ObjectConfig? visitConfig =
        moduleInfo?.module.complement?.configuration?.visit;

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la visite'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (visitConfig != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VisitFormPage(
                      site: site,
                      visitConfig: visitConfig,
                      customConfig:
                          moduleInfo?.module.complement?.configuration?.custom,
                      moduleId: moduleInfo?.module.id,
                      visit: visit,
                    ),
                  ),
                ).then((_) {
                  // Rafraîchir les données après édition
                  ref
                      .read(
                          siteVisitsViewModelProvider(site.idBaseSite).notifier)
                      .loadVisits();
                  Navigator.pop(context); // Retourner à la page précédente
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Configuration de visite non disponible'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carte d'informations générales
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Informations générales',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildInfoRow('Site', site.baseSiteName ?? 'Non spécifié'),
                    _buildInfoRow(
                        'Date de visite', formatDateString(visit.visitDateMin)),
                    if (visit.visitDateMax != null &&
                        visit.visitDateMax != visit.visitDateMin)
                      _buildInfoRow('Fin de visite',
                          formatDateString(visit.visitDateMax!)),
                    _buildInfoRow(
                        'Observateurs',
                        visit.observers != null && visit.observers!.isNotEmpty
                            ? '${visit.observers!.length} observateur(s)'
                            : 'Aucun observateur'),
                    _buildInfoRow(
                        'Date de création',
                        visit.metaCreateDate != null
                            ? formatDateString(visit.metaCreateDate!)
                            : 'Non spécifiée'),
                    if (visit.metaUpdateDate != null &&
                        visit.metaUpdateDate != visit.metaCreateDate)
                      _buildInfoRow('Dernière modification',
                          formatDateString(visit.metaUpdateDate!)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Commentaires
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Commentaires',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Text(visit.comments ?? 'Aucun commentaire'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Données spécifiques au module
            if (visit.data != null && visit.data!.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Données spécifiques',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      ..._buildDataFields(visit.data!),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDataFields(Map<String, dynamic> data) {
    final List<Widget> widgets = [];

    data.forEach((key, value) {
      if (value != null) {
        String displayValue;

        if (value is Map) {
          displayValue = 'Objet complexe';
        } else if (value is List) {
          displayValue = 'Liste (${value.length} éléments)';
        } else {
          displayValue = value.toString();
        }

        widgets.add(_buildInfoRow(key, displayValue));
      }
    });

    if (widgets.isEmpty) {
      widgets.add(const Text('Aucune donnée spécifique disponible'));
    }

    return widgets;
  }
}

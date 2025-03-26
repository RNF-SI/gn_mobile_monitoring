import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';

class ObservationDetailPage extends ConsumerStatefulWidget {
  final Observation observation;
  final BaseVisit visit;
  final BaseSite site;
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup;

  const ObservationDetailPage({
    super.key,
    required this.observation,
    required this.visit,
    required this.site,
    this.moduleInfo,
    this.fromSiteGroup,
  });

  @override
  ConsumerState<ObservationDetailPage> createState() =>
      _ObservationDetailPageState();
}

class _ObservationDetailPageState extends ConsumerState<ObservationDetailPage> {
  @override
  Widget build(BuildContext context) {
    // Récupérer la configuration des observations depuis le module
    final ObjectConfig? observationConfig =
        widget.moduleInfo?.module.complement?.configuration?.observation;

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'observation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (observationConfig != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ObservationFormPage(
                      visitId: widget.visit.idBaseVisit,
                      observationConfig: observationConfig,
                      customConfig: widget
                          .moduleInfo?.module.complement?.configuration?.custom,
                      moduleId: widget.moduleInfo?.module.id,
                      observation: widget.observation,
                      moduleName: widget.moduleInfo?.module.moduleLabel,
                      siteLabel: widget.moduleInfo?.module.complement
                              ?.configuration?.site?.label ??
                          'Site',
                      siteName:
                          widget.site.baseSiteName ?? widget.site.baseSiteCode,
                      visitLabel: widget.moduleInfo?.module.complement
                              ?.configuration?.visit?.label ??
                          'Visite',
                      visitDate: formatDateString(widget.visit.visitDateMin),
                    ),
                  ),
                ).then((_) {
                  // Rafraîchir les observations après édition
                  ref.refresh(observationsProvider(widget.visit.idBaseVisit));
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Configuration des observations non disponible'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: _buildContent(context, observationConfig),
    );
  }

  Widget _buildContent(BuildContext context, ObjectConfig? observationConfig) {
    // Récupérer les labels configurés
    final String siteLabel =
        widget.moduleInfo?.module.complement?.configuration?.site?.label ??
            'Site';
    final String visitLabel =
        widget.moduleInfo?.module.complement?.configuration?.visit?.label ??
            'Visite';
    final String observationLabel = widget
            .moduleInfo?.module.complement?.configuration?.observation?.label ??
        'Observation';
    final String groupLabel = widget
            .moduleInfo?.module.complement?.configuration?.sitesGroup?.label ??
        'Groupe';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fil d'Ariane pour la navigation
          if (widget.moduleInfo != null)
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: BreadcrumbNavigation(
                  items: [
                    // Module
                    BreadcrumbItem(
                      label: 'Module',
                      value: widget.moduleInfo!.module.moduleLabel ?? 'Module',
                      onTap: () {
                        Navigator.of(context).popUntil((route) =>
                            route.isFirst ||
                            route.settings.name == '/module_detail');
                      },
                    ),

                    // Groupe de site (si disponible)
                    if (widget.fromSiteGroup != null)
                      BreadcrumbItem(
                        label: groupLabel,
                        value: widget.fromSiteGroup.sitesGroupName ??
                            widget.fromSiteGroup.sitesGroupCode ??
                            'Groupe',
                        onTap: () {
                          int count = 0;
                          Navigator.of(context).popUntil((route) {
                            return count++ >= 3;
                          });
                        },
                      ),

                    // Site
                    BreadcrumbItem(
                      label: siteLabel,
                      value: widget.site.baseSiteName ??
                          widget.site.baseSiteCode ??
                          'Site',
                      onTap: () {
                        int count = 0;
                        Navigator.of(context).popUntil((route) => count++ >= 2);
                      },
                    ),

                    // Visite
                    BreadcrumbItem(
                      label: visitLabel,
                      value: formatDateString(widget.visit.visitDateMin),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),

                    // Observation (actuelle)
                    BreadcrumbItem(
                      label: observationLabel,
                      value: 'Observation #${widget.observation.idObservation}',
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Informations générales
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Informations générales',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                      'ID', widget.observation.idObservation.toString()),
                  _buildInfoRow(
                      'Date de création',
                      widget.observation.metaCreateDate != null
                          ? formatDateString(widget.observation.metaCreateDate!)
                          : 'Non spécifiée'),
                  if (widget.observation.metaUpdateDate != null &&
                      widget.observation.metaUpdateDate !=
                          widget.observation.metaCreateDate)
                    _buildInfoRow('Dernière modification',
                        formatDateString(widget.observation.metaUpdateDate!)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Commentaires
          if (widget.observation.comments != null &&
              widget.observation.comments!.isNotEmpty)
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
                    Text(widget.observation.comments ?? 'Aucun commentaire'),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Données spécifiques
          if (widget.observation.data != null &&
              widget.observation.data!.isNotEmpty)
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
                    ..._buildDataFields(
                        widget.observation.data!, observationConfig),
                  ],
                ),
              ),
            ),
        ],
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

  List<Widget> _buildDataFields(
      Map<String, dynamic> data, ObjectConfig? config) {
    final List<Widget> widgets = [];
    final Map<String, String> fieldLabels = {};

    if (config != null) {
      final parsedConfig = FormConfigParser.generateUnifiedSchema(
          config, widget.moduleInfo?.module.complement?.configuration?.custom);

      for (final entry in parsedConfig.entries) {
        fieldLabels[entry.key] = entry.value['attribut_label'];
      }
    }

    final sortedKeys = data.keys.toList()..sort();

    for (final key in sortedKeys) {
      if (data[key] != null) {
        String displayLabel = fieldLabels[key] ?? key;
        if (displayLabel == key) {
          displayLabel = key
              .replaceAll('_', ' ')
              .split(' ')
              .map((word) => word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1)
                  : '')
              .join(' ');
        }

        String displayValue;
        if (data[key] is Map) {
          displayValue = 'Objet complexe';
        } else if (data[key] is List) {
          displayValue = 'Liste (${data[key].length} éléments)';
        } else {
          displayValue = data[key].toString();
        }

        widgets.add(_buildInfoRow(displayLabel, displayValue));
      }
    }

    if (widgets.isEmpty) {
      widgets.add(const Text('Aucune donnée spécifique disponible'));
    }

    return widgets;
  }
}

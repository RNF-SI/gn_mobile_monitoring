import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/taxon_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/taxon_service.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ObservationDetailPageBase extends DetailPage {
  final WidgetRef ref;
  final Observation observation;
  final BaseVisit visit;
  final BaseSite site;
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup;
  final ObjectConfig? observationConfig;
  final CustomConfig? customConfig;
  final ObjectConfig? observationDetailConfig;
  final bool isNewObservation;

  const ObservationDetailPageBase({
    super.key,
    required this.ref,
    required this.observation,
    required this.visit,
    required this.site,
    this.moduleInfo,
    this.fromSiteGroup,
    this.observationConfig,
    this.customConfig,
    this.observationDetailConfig,
    this.isNewObservation = false,
  });

  @override
  ObservationDetailPageBaseState createState() =>
      ObservationDetailPageBaseState();
}

class ObservationDetailPageBaseState
    extends DetailPageState<ObservationDetailPageBase> {
  Taxon? _taxon;
  bool _isLoadingTaxon = false;

  @override
  ObjectConfig? get objectConfig => widget.observationConfig;

  @override
  CustomConfig? get customConfig => widget.customConfig;

  @override
  List<String>? get displayProperties =>
      objectConfig?.displayProperties ?? objectConfig?.displayList;

  @override
  Map<String, dynamic> get objectData => widget.observation.data ?? {};

  @override
  String get propertiesTitle => 'Données spécifiques de l\'observation';

  @override
  bool get separateEmptyFields => true;

  @override
  void initState() {
    super.initState();
    // Le chargement se fera une fois que le service aura été injecté par la classe parent
  }
  
  // Cette méthode sera appelée après l'injection des dépendances
  void startLoadingData() {
    _loadTaxonData();
  }

  // Service d'accès aux taxons (pourra être injecté par la classe parente)
  late TaxonService taxonService;

  Future<void> _loadTaxonData() async {
    if (widget.observation.cdNom != null) {
      setState(() {
        _isLoadingTaxon = true;
      });

      try {
        // Utiliser le service injecté
        final taxon =
            await taxonService.getTaxonByCdNom(widget.observation.cdNom!);

        if (mounted) {
          setState(() {
            _taxon = taxon;
            _isLoadingTaxon = false;
          });
        }
      } catch (error) {
        if (mounted) {
          setState(() {
            _isLoadingTaxon = false;
          });
        }
      }
    }
  }

  @override
  List<BreadcrumbItem> getBreadcrumbItems() {
    final items = <BreadcrumbItem>[];

    if (widget.moduleInfo != null) {
      // Récupérer les labels configurés
      final String siteLabel =
          widget.moduleInfo?.module.complement?.configuration?.site?.label ??
              'Site';
      final String visitLabel =
          widget.moduleInfo?.module.complement?.configuration?.visit?.label ??
              'Visite';
      final String groupLabel = widget.moduleInfo?.module.complement
              ?.configuration?.sitesGroup?.label ??
          'Groupe';
      final String observationLabel = widget.moduleInfo?.module.complement
              ?.configuration?.observation?.label ??
          'Observation';

      // Module
      items.add(
        BreadcrumbItem(
          label: 'Module',
          value: widget.moduleInfo!.module.moduleLabel ?? 'Module',
          onTap: () {
            // Naviguer vers le module (retour de plusieurs niveaux)
            Navigator.of(context).popUntil((route) =>
                route.isFirst || route.settings.name == '/module_detail');
          },
        ),
      );

      // Groupe de site (si disponible)
      if (widget.fromSiteGroup != null) {
        items.add(
          BreadcrumbItem(
            label: groupLabel,
            value: widget.fromSiteGroup.sitesGroupName ??
                widget.fromSiteGroup.sitesGroupCode ??
                'Groupe',
            onTap: () {
              // Retour vers le groupe (plusieurs niveaux)
              Navigator.of(context).popUntil(
                  (route) => route.settings.name == '/site_group_detail');
            },
          ),
        );
      }

      // Site
      items.add(
        BreadcrumbItem(
          label: siteLabel,
          value: widget.site.baseSiteName ?? widget.site.baseSiteCode ?? 'Site',
          onTap: () {
            // Naviguer vers le site
            Navigator.of(context)
                .popUntil((route) => route.settings.name == '/site_detail');
          },
        ),
      );

      // Visite
      items.add(
        BreadcrumbItem(
          label: visitLabel,
          value: formatDateString(widget.visit.visitDateMin),
          onTap: () {
            // Naviguer vers la visite (retour de 1 niveau)
            Navigator.of(context).pop();
          },
        ),
      );

      // Observation (actuelle)
      items.add(
        BreadcrumbItem(
          label: observationLabel,
          value: _taxon?.lbNom ??
              'Observation ${widget.observation.idObservation}',
        ),
      );
    }

    return items;
  }

  @override
  PreferredSizeWidget buildAppBar() {
    return AppBar(
      title: Text(getTitle()),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            if (widget.observationConfig != null) {
              // Préparer les informations pour le fil d'Ariane
              final String? moduleName = widget.moduleInfo?.module.moduleLabel;
              final String? siteLabel = widget.moduleInfo?.module.complement
                      ?.configuration?.site?.label ??
                  'Site';
              final String? siteName =
                  widget.site.baseSiteName ?? widget.site.baseSiteCode;
              final String? visitLabel = widget.moduleInfo?.module.complement
                      ?.configuration?.visit?.label ??
                  'Visite';
              final String? visitDate =
                  formatDateString(widget.visit.visitDateMin);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ObservationFormPage(
                    visitId: widget.visit.idBaseVisit,
                    observationConfig: widget.observationConfig!,
                    customConfig: widget.customConfig,
                    moduleId: widget.moduleInfo?.module.id,
                    observation: widget.observation,
                    moduleName: moduleName,
                    siteLabel: siteLabel,
                    siteName: siteName,
                    visitLabel: visitLabel,
                    visitDate: visitDate,
                  ),
                ),
              ).then((_) {
                // On pourrait rafraîchir les données ici si nécessaire
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Configuration d\'observation non disponible'),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  String getTitle() {
    if (_taxon != null) {
      return _taxon!.lbNom ?? 'Détails de l\'observation';
    }
    return 'Détails de l\'observation';
  }

  @override
  Widget buildBaseContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Taxon Information
          _buildTaxonInfoCard(),

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
                  _buildInfoRow('Date d\'observation',
                      formatDateString(widget.visit.visitDateMin)),
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
            buildPropertiesWidget(),
        ],
      ),
    );
  }

  Widget _buildTaxonInfoCard() {
    if (_isLoadingTaxon) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_taxon == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Taxon',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(
                widget.observation.cdNom != null
                    ? 'Taxon non trouvé (CD_NOM: ${widget.observation.cdNom})'
                    : 'Aucun taxon associé',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaxonDetailPage(taxon: _taxon!),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Taxon',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.launch),
                    tooltip: 'Voir les détails du taxon',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaxonDetailPage(taxon: _taxon!),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _taxon!.lbNom ?? 'Non spécifié',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              if (_taxon!.nomVern != null && _taxon!.nomVern!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    _taxon!.nomVern!,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              const SizedBox(height: 8),
              if (_taxon!.regne != null || _taxon!.classe != null)
                Text(
                  [
                    if (_taxon!.regne != null) 'Règne: ${_taxon!.regne}',
                    if (_taxon!.classe != null) 'Classe: ${_taxon!.classe}',
                  ].join(' • '),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
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
}

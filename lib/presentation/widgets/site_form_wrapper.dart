import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/map/location_picker_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_form_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit/visit_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/generic_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';
import 'package:gn_mobile_monitoring/presentation/view/site_group_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/map/location_preview_header.dart';
import 'package:latlong2/latlong.dart';

/// Wrapper spécialisé pour les formulaires de site
/// Utilise GenericFormPage avec la logique métier spécifique aux sites
class SiteFormWrapper extends ConsumerStatefulWidget {
  final ObjectConfig siteConfig;
  final CustomConfig? customConfig;
  final BaseSite? site; // En mode édition, site existant
  final int? moduleId;
  final ModuleInfo? moduleInfo;
  final SiteGroup? siteGroup;
  final int? selectedSiteTypeId; // Type de site sélectionné

  const SiteFormWrapper({
    super.key,
    required this.siteConfig,
    this.customConfig,
    this.site,
    this.moduleId,
    this.moduleInfo,
    this.siteGroup,
    this.selectedSiteTypeId,
  });

  @override
  ConsumerState<SiteFormWrapper> createState() => _SiteFormWrapperState();
}

class _SiteFormWrapperState extends ConsumerState<SiteFormWrapper> {
  LatLng? _selectedPosition;
  bool _isLoadingLocation = true;
  bool _isPositionAdjusted = false;

  bool get _isEditMode => widget.site != null;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    if (_isEditMode && widget.site?.geom != null) {
      // Mode édition : parser le GeoJSON existant
      try {
        final geojson = jsonDecode(widget.site!.geom!) as Map<String, dynamic>;
        final coords = geojson['coordinates'] as List<dynamic>;
        if (coords.length >= 2) {
          setState(() {
            _selectedPosition = LatLng(
              (coords[1] as num).toDouble(),
              (coords[0] as num).toDouble(),
            );
            _isLoadingLocation = false;
          });
          return;
        }
      } catch (_) {
        // Erreur de parsing, on continue avec le GPS
      }
    }

    // Mode création ou geom absent : récupérer la position GPS
    try {
      final useCase = ref.read(getUserLocationUseCaseProvider);
      final result = await useCase.execute();
      if (mounted) {
        setState(() {
          _selectedPosition = result?.position;
          _isLoadingLocation = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _openLocationPicker(BuildContext context) async {
    if (_selectedPosition == null) return;

    final result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerPage(
          initialPosition: _selectedPosition!,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedPosition = result;
        _isPositionAdjusted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Vérifier si le site peut être modifié
    final bool isSynced = widget.site?.serverSiteId != null;
    final bool isNotLocal = _isEditMode && widget.site?.isLocal != true;
    final bool isLocked = isNotLocal || (_isEditMode && isSynced);

    if (isLocked) {
      final String message = isSynced
          ? 'Ce site a déjà été synchronisé avec le serveur et ne peut plus être modifié.'
          : 'Seuls les sites créés localement peuvent être modifiés.';

      return Scaffold(
        appBar: AppBar(
          title: const Text('Modifier le site'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSynced ? Icons.cloud_done : Icons.lock_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ce site ne peut pas être modifié',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Retour'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return GenericFormPage(
      objectConfig: widget.siteConfig,
      customConfig: widget.customConfig,
      title: _isEditMode
          ? 'Modifier le site'
          : widget.siteConfig.label ?? 'Nouveau site',
      appBarActions: _isEditMode ? [
        IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'Supprimer le site',
          onPressed: () => _deleteSite(context),
        ),
      ] : null,
      breadcrumbItems: _buildBreadcrumbItems(context),
      initialValues: _isEditMode ? _prepareInitialValues() : _prepareDefaultValues(),
      headerWidget: _buildHeaderWidget(context),
      onSave: (formData) => _handleSave(context, formData),
      saveButtonText: _isEditMode ? 'Mettre à jour' : 'Enregistrer',
      displayProperties: _getDisplayProperties(),
      objectType: 'site',
    );
  }

  /// Construit les éléments du fil d'Ariane
  List<BreadcrumbItem> _buildBreadcrumbItems(BuildContext context) {
    if (widget.moduleInfo == null) return [];

    return BreadcrumbBuilder.buildSiteBreadcrumb(
      moduleName: widget.moduleInfo!.module.moduleLabel,
      siteGroupLabel: widget.moduleInfo!.module.complement?.configuration?.sitesGroup?.label,
      siteGroupName: widget.siteGroup?.sitesGroupName ?? widget.siteGroup?.sitesGroupCode,
      siteLabel: widget.siteConfig.label ?? 'Site',
      siteName: widget.site?.baseSiteName ?? widget.site?.baseSiteCode ?? 'Nouveau',
      onModuleTap: () {
        Navigator.of(context).popUntil((route) =>
            route.isFirst || route.settings.name == '/module_detail');
      },
      onSiteGroupTap: widget.siteGroup != null ? () {
        int count = 0;
        Navigator.of(context).popUntil((route) => count++ >= 2);
      } : null,
    );
  }

  /// Construit le widget d'en-tête avec l'aperçu de la position GPS
  Widget? _buildHeaderWidget(BuildContext context) {
    return LocationPreviewHeader(
      position: _selectedPosition,
      isLoading: _isLoadingLocation,
      isAdjusted: _isPositionAdjusted,
      onAdjustPressed: () => _openLocationPicker(context),
    );
  }

  /// Prépare les valeurs initiales pour le mode édition
  Map<String, dynamic> _prepareInitialValues() {
    if (widget.site == null) return {};

    final initialValues = <String, dynamic>{
      'base_site_name': widget.site!.baseSiteName,
      'base_site_code': widget.site!.baseSiteCode,
      'base_site_description': widget.site!.baseSiteDescription,
      'first_use_date': widget.site!.firstUseDate?.toIso8601String().split('T')[0],
      'altitude_min': widget.site!.altitudeMin,
      'altitude_max': widget.site!.altitudeMax,
    };

    // Ajouter les données complémentaires si elles existent
    // (sera géré par le viewmodel)

    return initialValues;
  }

  /// Prépare les valeurs par défaut pour le mode création
  Map<String, dynamic> _prepareDefaultValues() {
    final defaultValues = <String, dynamic>{
      'first_use_date': DateTime.now().toIso8601String().split('T')[0],
    };

    // Ajouter l'ID du module si disponible
    if (widget.moduleId != null) {
      // Le champ id_module sera géré automatiquement
    }

    // Ajouter l'ID du groupe de sites si disponible
    if (widget.siteGroup != null) {
      defaultValues['id_sites_group'] = widget.siteGroup!.idSitesGroup;
    }

    // Ajouter le type de site sélectionné
    if (widget.selectedSiteTypeId != null) {
      defaultValues['id_nomenclature_type_site'] = widget.selectedSiteTypeId;
      // Si le type de site est dans specific avec une valeur fixe, l'utiliser
      final specificTypeSite = widget.siteConfig.specific?['id_nomenclature_type_site'];
      if (specificTypeSite != null && specificTypeSite['value'] != null) {
        // Le type est déjà défini dans la config, ne pas l'écraser
      }
    }

    return defaultValues;
  }

  /// Récupère les propriétés d'affichage selon le type de site
  /// Utilise display_form en priorité, puis display_properties si display_form est vide
  List<String>? _getDisplayProperties() {
    if (widget.selectedSiteTypeId != null && widget.moduleInfo != null) {
      final typeSiteConfig = widget.moduleInfo!.module.complement?.configuration?.module
          ?.typesSite?[widget.selectedSiteTypeId.toString()];

      // TypeSiteConfig n'a que display_properties (pas display_form)
      if (typeSiteConfig?.displayProperties != null &&
          typeSiteConfig!.displayProperties!.isNotEmpty) {
        return typeSiteConfig.displayProperties!.cast<String>();
      }
    }

    // Pour la configuration générale du site, utiliser display_form en priorité
    if (widget.siteConfig.displayForm != null && widget.siteConfig.displayForm!.isNotEmpty) {
      return widget.siteConfig.displayForm;
    }

    // Sinon, utiliser display_properties
    return widget.siteConfig.displayProperties;
  }

   /// Demande à l'utilisateur s'il souhaite créer une visite
  Future<bool> _askForVisit(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Créer une visite'),
            content: const Text(
                'Voulez-vous créer une visite pour ce site ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Non'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Oui'),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Navigue vers le formulaire d'observation
  Future<void> _navigateToVisitForm(BuildContext context, BaseSite site, SiteGroup? siteGroup, [ModuleInfo? moduleToShow]) async {
    final visitConfig =  widget.moduleInfo!.module.complement?.configuration?.visit;
    if (visitConfig == null) return;

    final targetModuleInfo = moduleToShow ?? null;
    if (targetModuleInfo == null) return;

    _navigateToSiteGroupDetailPage(context, siteGroup, widget.moduleInfo);
    _navigateToSiteDetailPage(context, site, siteGroup, widget.moduleInfo);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VisitFormPage(
            site: site,
            visitConfig: visitConfig,
            customConfig: widget.customConfig,
            moduleId: widget.moduleInfo?.module.id,
            moduleInfo: targetModuleInfo,
            siteGroup: siteGroup,
        ),
      ),
    );
  }

  /// Navigue vers la page de détail de la visite
  Future<void> _navigateToSiteDetailPage(BuildContext context, BaseSite site, SiteGroup? siteGroup, [ModuleInfo? moduleToShow]) async {
    final targetModuleInfo = moduleToShow ?? null;
    if (targetModuleInfo == null) return;


    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  SiteDetailPage(
          site: site,
          moduleInfo: targetModuleInfo,
          fromSiteGroup: siteGroup,
        ),
      ),
    );
  }

 /// Navigue vers la page de détail de la visite
  Future<void> _navigateToSiteGroupDetailPage(BuildContext context, SiteGroup? siteGroup, [ModuleInfo? moduleToShow]) async {
    Navigator.of(context).pop();
    final targetModuleInfo = moduleToShow ?? null;
    if (targetModuleInfo == null) return;

    final targetsiteGroup = siteGroup ?? null;
    if (targetsiteGroup == null) return;


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SiteGroupDetailPage(
          moduleInfo: targetModuleInfo,
          siteGroup: targetsiteGroup,
        ),
      ),
    );
  }

  /// Construit le GeoJSON depuis la position sélectionnée
  String? _buildGeomOverride() {
    if (_selectedPosition == null) return null;
    return jsonEncode({
      'type': 'Point',
      'coordinates': [_selectedPosition!.longitude, _selectedPosition!.latitude],
    });
  }

  /// Gère la sauvegarde du site
  Future<bool> _handleSave(BuildContext context, Map<String, dynamic> formData) async {
    final viewModel = ref.read(siteFormViewModelProvider(
        (widget.moduleId ?? 1, widget.siteGroup?.idSitesGroup)).notifier);

    final geomOverride = _buildGeomOverride();

    try {
      bool success;
      int? siteId;

      if (_isEditMode && widget.site != null) {
        // Vérifier que le site peut être modifié (créé localement et non synchronisé)
        if (widget.site!.isLocal != true || widget.site!.serverSiteId != null) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.site!.serverSiteId != null
                      ? 'Ce site a déjà été synchronisé et ne peut plus être modifié'
                      : 'Impossible de modifier un site qui n\'a pas été créé localement',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          return false;
        }

        // Mise à jour
        success = await viewModel.updateSiteFromFormData(
          formData,
          widget.site!,
          moduleId: widget.moduleId ?? 1,
          selectedSiteTypeId: widget.selectedSiteTypeId,
          geomOverride: geomOverride,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Site mis à jour avec succès'),
            ),
          );

          // Naviguer vers la page de détail du site
          if (context.mounted) {
            final updatedSite = await viewModel.getSiteById(widget.site!.idBaseSite);
            if (updatedSite != null && context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SiteDetailPage(
                    site: updatedSite,
                    moduleInfo: widget.moduleInfo!,
                    fromSiteGroup: widget.siteGroup,
                  ),
                ),
              );
              return false; // Navigation personnalisée
            }
          }
        }
      } else {
        // Création
        siteId = await viewModel.createSiteFromFormData(
          formData,
          moduleId: widget.moduleId ?? 1,
          selectedSiteTypeId: widget.selectedSiteTypeId,
          geomOverride: geomOverride,
        );
        success = siteId != null && siteId > 0;

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Site créé avec succès'),
            ),
          );

          // Naviguer vers la page de détail du site
          if (context.mounted) {
            final newSite = await viewModel.getSiteById(siteId);
            final createVisit = await _askForVisit(context);
            if (createVisit) {
            if (newSite != null && context.mounted) {
              await _navigateToVisitForm(context, newSite, widget.siteGroup, widget.moduleInfo);
                  return false; // Navigation personnalisée faite, empêcher le pop automatique
              }
            } else {
                // L'utilisateur a dit "Non", naviguer vers la page de détail
            if (newSite != null && context.mounted) {
              await _navigateToSiteGroupDetailPage(context, widget.siteGroup, widget.moduleInfo);
              await _navigateToSiteDetailPage(context, newSite, widget.siteGroup, widget.moduleInfo);
              return false; // Navigation personnalisée faite, empêcher le pop automatique
            }
          }
          }
        }
      }

      return success;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sauvegarde: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  /// Supprime le site avec confirmation
  Future<void> _deleteSite(BuildContext context) async {
    if (widget.site == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text("Êtes-vous sûr de vouloir supprimer ce site ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final viewModel = ref.read(siteFormViewModelProvider(
          (widget.moduleId ?? 1, widget.siteGroup?.idSitesGroup)).notifier);

      final success = await viewModel.deleteSite(widget.site!.idBaseSite);

      if (context.mounted) {
        if (success) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Site supprimé avec succès')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la suppression du site'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

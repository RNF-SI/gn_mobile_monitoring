import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
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

  const SiteFormWrapper({
    super.key,
    required this.siteConfig,
    this.customConfig,
    this.site,
    this.moduleId,
    this.moduleInfo,
    this.siteGroup,
  });

  @override
  ConsumerState<SiteFormWrapper> createState() => _SiteFormWrapperState();
}

class _SiteFormWrapperState extends ConsumerState<SiteFormWrapper> {
  /// Type de géométrie courant (`Point`, `LineString`, `Polygon`).
  /// Reste `null` tant que l'utilisateur n'a pas choisi (cas multi-types au
  /// premier affichage) ou que la géométrie n'a pas encore été chargée.
  String? _geometryType;

  /// Sommets de la géométrie courante. Pour un `Point`, contient un seul
  /// élément. Pour un polygone, ne contient PAS le point de fermeture —
  /// la duplication est gérée à la sérialisation.
  List<LatLng> _geometryVertices = [];

  /// Centre de carte à utiliser quand on ouvre le picker — toujours défini
  /// une fois le GPS chargé, même si aucune géométrie n'a encore été tracée.
  LatLng? _mapCenter;

  bool _isLoadingLocation = true;
  bool _isPositionAdjusted = false;
  Map<String, dynamic>? _initialValues;
  bool _isLoadingInitialValues = true;

  bool get _isEditMode => widget.site != null;

  List<String> get _allowedGeometryTypes =>
      widget.siteConfig.allowedGeometryTypes;

  @override
  void initState() {
    super.initState();
    _initLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialValues();
    });
  }

  Future<void> _loadInitialValues() async {
    final values = _isEditMode
        ? await _prepareInitialValues()
        : _prepareDefaultValues();

    if (mounted) {
      setState(() {
        _initialValues = values;
        _isLoadingInitialValues = false;
      });
    }
  }

  Future<void> _initLocation() async {
    if (_isEditMode && widget.site?.geom != null) {
      // Mode édition : parser le GeoJSON existant (Point / LineString / Polygon).
      final parsed = GeometryDrawResult.parseGeoJson(widget.site!.geom!);
      if (parsed != null) {
        setState(() {
          _geometryType = parsed.geometryType;
          _geometryVertices = parsed.coordinates;
          _mapCenter = parsed.coordinates.first;
          _isLoadingLocation = false;
        });
        return;
      }
    }

    // Mode création ou geom absent : récupérer la position GPS.
    try {
      final useCase = ref.read(getUserLocationUseCaseProvider);
      final result = await useCase.execute();
      if (mounted) {
        final allowed = _allowedGeometryTypes;
        setState(() {
          _mapCenter = result?.position;
          // Auto-sélection si un seul type est autorisé.
          // Si plusieurs types sont autorisés et qu'on a une position GPS,
          // on pré-remplit un Point (le plus commun) — l'utilisateur pourra
          // changer de type au moment du dessin.
          if (allowed.length == 1) {
            _geometryType = allowed.first;
            if (allowed.first == 'Point' && result?.position != null) {
              _geometryVertices = [result!.position];
            }
          } else if (allowed.contains('Point') && result?.position != null) {
            _geometryType = 'Point';
            _geometryVertices = [result!.position];
          }
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
    if (_mapCenter == null) return;

    final allowed = _allowedGeometryTypes;

    // Choix du type : dialogue si plusieurs options, sinon on prend celui
    // déjà décidé (édition) ou l'unique autorisé.
    final String type;
    if (allowed.length > 1) {
      final chosen = await _askGeometryType(context, allowed, current: _geometryType);
      if (chosen == null) return; // utilisateur a annulé
      type = chosen;
    } else {
      type = allowed.first;
    }

    if (!context.mounted) return;

    // Ne pré-remplir les sommets que si on garde le même type qu'avant ;
    // changer de type repart d'une géométrie vide.
    final initialVertices = (type == _geometryType && _geometryVertices.isNotEmpty)
        ? _geometryVertices
        : null;

    final result = await Navigator.push<GeometryDrawResult>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerPage(
          initialCenter: _mapCenter!,
          geometryType: type,
          initialVertices: initialVertices,
        ),
      ),
    );

    if (result != null && result.coordinates.isNotEmpty && mounted) {
      setState(() {
        _geometryType = result.geometryType;
        _geometryVertices = result.coordinates;
        _mapCenter = result.coordinates.first;
        _isPositionAdjusted = true;
      });
    }
  }

  /// Bottom sheet permettant de choisir un type de géométrie quand plusieurs
  /// sont autorisés. Retourne `null` si l'utilisateur ferme sans choisir.
  Future<String?> _askGeometryType(
    BuildContext context,
    List<String> allowed, {
    String? current,
  }) async {
    const labels = <String, String>{
      'Point': 'Point',
      'LineString': 'Ligne (transect)',
      'Polygon': 'Polygone (zone)',
    };
    const icons = <String, IconData>{
      'Point': Icons.location_on,
      'LineString': Icons.timeline,
      'Polygon': Icons.pentagon_outlined,
    };
    return showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Type de géométrie',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            for (final type in allowed)
              ListTile(
                leading: Icon(icons[type] ?? Icons.place),
                title: Text(labels[type] ?? type),
                trailing: type == current
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () => Navigator.pop(context, type),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// Enrichit la configuration du site avec les options types_site depuis le module
  ObjectConfig _enrichSiteConfigWithTypesSite() {
    final typesSite = widget.moduleInfo?.module.complement?.configuration?.module?.typesSite;
    if (typesSite == null || typesSite.isEmpty) {
      return widget.siteConfig;
    }

    // Construire la liste de valeurs pour le datalist
    final values = typesSite.entries.map((e) => {
      'value': e.key,
      'label': e.value.name ?? 'Type ${e.key}',
    }).toList();

    final currentGeneric = Map<String, GenericFieldConfig>.from(
        widget.siteConfig.generic ?? {});

    if (currentGeneric.containsKey('types_site')) {
      // Mettre à jour le champ existant avec les valeurs et le rendre visible
      final existing = currentGeneric['types_site']!;
      currentGeneric['types_site'] = GenericFieldConfig(
        attributLabel: existing.attributLabel ?? 'Type(s) de site',
        typeWidget: existing.typeWidget ?? 'datalist',
        multiple: true,
        required: existing.required ?? true,
        keyLabel: existing.keyLabel ?? 'label',
        keyValue: existing.keyValue ?? 'value',
        values: values,
        hidden: false,
        definition: existing.definition,
      );
    } else {
      // Ajouter un nouveau champ types_site
      currentGeneric['types_site'] = GenericFieldConfig(
        attributLabel: 'Type(s) de site',
        typeWidget: 'datalist',
        multiple: true,
        required: true,
        keyLabel: 'label',
        keyValue: 'value',
        values: values,
      );
    }

    return widget.siteConfig.copyWith(generic: currentGeneric);
  }

  @override
  Widget build(BuildContext context) {
    final enrichedConfig = _enrichSiteConfigWithTypesSite();

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

    if (_isLoadingInitialValues) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_isEditMode
              ? 'Modifier le site'
              : widget.siteConfig.label ?? 'Nouveau site'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return GenericFormPage(
      objectConfig: enrichedConfig,
      customConfig: widget.customConfig,
      title: _isEditMode
          ? 'Modifier le site'
          : enrichedConfig.label ?? 'Nouveau site',
      appBarActions: _isEditMode ? [
        IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'Supprimer le site',
          onPressed: () => _deleteSite(context),
        ),
      ] : null,
      breadcrumbItems: _buildBreadcrumbItems(context),
      initialValues: _initialValues,
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

  /// Construit le widget d'en-tête avec l'aperçu de la géométrie courante.
  Widget? _buildHeaderWidget(BuildContext context) {
    return LocationPreviewHeader(
      geometryType: _geometryType,
      vertices: _geometryVertices,
      previewCenter: _mapCenter,
      isLoading: _isLoadingLocation,
      isAdjusted: _isPositionAdjusted,
      onAdjustPressed: () => _openLocationPicker(context),
    );
  }

  /// Prépare les valeurs initiales pour le mode édition
  Future<Map<String, dynamic>> _prepareInitialValues() async {
    if (widget.site == null) return {};

    final initialValues = <String, dynamic>{
      'base_site_name': widget.site!.baseSiteName,
      'base_site_code': widget.site!.baseSiteCode,
      'base_site_description': widget.site!.baseSiteDescription,
      'first_use_date': widget.site!.firstUseDate?.toIso8601String().split('T')[0],
      'altitude_min': widget.site!.altitudeMin,
      'altitude_max': widget.site!.altitudeMax,
    };

    // Charger les données complémentaires depuis la base
    try {
      final sitesDatabase = ref.read(siteDatabaseProvider);
      final complement = await sitesDatabase.getSiteComplementBySiteId(
          widget.site!.idBaseSite);

      if (complement?.data != null) {
        Map<String, dynamic> complementData = {};
        if (complement!.data is String) {
          complementData = Map<String, dynamic>.from(
              jsonDecode(complement.data as String));
        } else {
          complementData =
              Map<String, dynamic>.from(complement.data as Map);
        }
        initialValues.addAll(complementData);
      }
    } catch (e) {
      debugPrint('Erreur lors du chargement du complément du site: $e');
    }

    // Rétro-compatibilité : convertir id_nomenclature_type_site en types_site
    if (initialValues.containsKey('id_nomenclature_type_site') &&
        !initialValues.containsKey('types_site')) {
      initialValues['types_site'] = [initialValues['id_nomenclature_type_site'].toString()];
    }

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

    // Si un seul type de site est disponible, le pré-sélectionner
    final typesSite = widget.moduleInfo?.module.complement?.configuration?.module?.typesSite;
    if (typesSite != null && typesSite.length == 1) {
      defaultValues['types_site'] = [typesSite.keys.first];
    }

    return defaultValues;
  }

  /// Récupère les propriétés d'affichage selon le type de site
  /// Utilise display_form en priorité, puis display_properties si display_form est vide
  List<String>? _getDisplayProperties() {
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

  /// Construit le GeoJSON depuis la géométrie courante. Pour un polygone,
  /// ferme explicitement l'anneau en répétant le premier sommet comme
  /// l'exige la spec GeoJSON.
  String? _buildGeomOverride() {
    if (_geometryType == null || _geometryVertices.isEmpty) return null;
    List<double> coord(LatLng p) => [p.longitude, p.latitude];

    switch (_geometryType) {
      case 'Point':
        return jsonEncode({
          'type': 'Point',
          'coordinates': coord(_geometryVertices.first),
        });
      case 'LineString':
        return jsonEncode({
          'type': 'LineString',
          'coordinates': _geometryVertices.map(coord).toList(),
        });
      case 'Polygon':
        final ring = [..._geometryVertices, _geometryVertices.first];
        return jsonEncode({
          'type': 'Polygon',
          'coordinates': [ring.map(coord).toList()],
        });
    }
    return null;
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

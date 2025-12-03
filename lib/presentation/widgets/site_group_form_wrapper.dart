import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/module/module_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_group_form_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/generic_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';

/// Wrapper spécialisé pour les formulaires de site
/// Utilise GenericFormPage avec la logique métier spécifique aux sites
class SiteGroupFormWrapper extends ConsumerStatefulWidget {
  final ObjectConfig siteConfig;
  final CustomConfig? customConfig;
  final BaseSite? site; // En mode édition, site existant
  final int? moduleId;
  final ModuleInfo? moduleInfo;
  final SiteGroup? siteGroup;
  final int? selectedSiteTypeId; // Type de site sélectionné

  const SiteGroupFormWrapper({
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
  ConsumerState<SiteGroupFormWrapper> createState() => _SiteGroupFormWrapperState();
}

class _SiteGroupFormWrapperState extends ConsumerState<SiteGroupFormWrapper> {
  Map<String, dynamic>? _initialValues;
  bool _isLoading = true;

  bool get _isEditMode => widget.site != null;

  @override
  void initState() {
    super.initState();
    // Charger les valeurs initiales après le premier build pour avoir accès à ref
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialValues();
    });
  }

  Future<void> _loadInitialValues() async {
    final defaultValues = _isEditMode 
        ? _prepareInitialValues() 
        : await _prepareDefaultValues(ref);
    
    if (mounted) {
      setState(() {
        _initialValues = defaultValues;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
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
          onPressed: () => _deleteSite(context, ref),
        ),
      ] : null,
      breadcrumbItems: _buildBreadcrumbItems(context),
      initialValues: _initialValues,
      headerWidget: _buildHeaderWidget(context),
      onSave: (formData) => _handleSave(context, ref, formData),
      saveButtonText: _isEditMode ? 'Mettre à jour' : 'Enregistrer',
      displayProperties: _getDisplayProperties(),
      objectType: 'sites_group', // Spécifier le type d'objet pour appliquer les exclusions spécifiques aux groupes de sites
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

  /// Construit le widget d'en-tête
  Widget? _buildHeaderWidget(BuildContext context) {
    final List<Widget> widgets = [];

    // Ajouter le message informatif sur l'observateur en mode création
    if (!_isEditMode) {
      widgets.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Vous êtes automatiquement ajouté comme observateur',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Ajouter le widget d'en-tête du module si nécessaire
    if (widget.moduleInfo == null) {
      widgets.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            'Module: ${widget.moduleInfo?.module.moduleLabel ?? 'Module'}',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    if (widgets.isEmpty) return null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
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
  Future<Map<String, dynamic>> _prepareDefaultValues(WidgetRef ref) async {
    final defaultValues = <String, dynamic>{
      'first_use_date': DateTime.now().toIso8601String().split('T')[0],
    };

    // Note: id_inventor n'est pas initialisé ici car il n'existe pas dans la configuration
    // des groupes de sites (sites_group). Il est uniquement utilisé pour les sites.
    // L'utilisateur sera automatiquement ajouté comme observateur lors de la sauvegarde.
  
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
  List<String>? _getDisplayProperties() {
    if (widget.selectedSiteTypeId != null && widget.moduleInfo != null) {
      final typeSiteConfig = widget.moduleInfo!.module.complement?.configuration?.module
          ?.typesSite?[widget.selectedSiteTypeId.toString()];
      if (typeSiteConfig?.displayProperties != null &&
          typeSiteConfig!.displayProperties!.isNotEmpty) {
        return typeSiteConfig.displayProperties!.cast<String>();
      }
    }
    return widget.siteConfig.displayProperties;
  }

  /// Gère la sauvegarde du site
  Future<bool> _handleSave(BuildContext context, WidgetRef ref, Map<String, dynamic> formData) async {
    final viewModel = ref.read(siteGroupFormViewModelProvider(
        (widget.moduleId ?? 1, widget.siteGroup?.idSitesGroup)).notifier);

    try {
      bool success;
      int? siteGroupId;

      if (_isEditMode && widget.site != null) {
        // Mise à jour
        success = await viewModel.updateSiteFromFormData(
          formData,
          widget.siteGroup!,
          moduleId: widget.moduleId ?? 1,
          selectedSiteTypeId: widget.selectedSiteTypeId,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Site mis à jour avec succès'),
            ),
          );

          // Naviguer vers la page de détail du site
          if (context.mounted) {
            final updatedSiteGroup = await viewModel.getSiteGroupById(widget.siteGroup!.idSitesGroup);
            if (updatedSiteGroup != null && context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ModuleDetailPage(
                    moduleInfo: widget.moduleInfo!,
                  ),
                ),
              );
              return false; // Navigation personnalisée
            }
          }
        }
      } else {
        // Création
        siteGroupId = await viewModel.createSiteGroupFromFormData(
          formData,
          moduleId: widget.moduleId ?? 1,
          selectedSiteTypeId: widget.selectedSiteTypeId,
        );
        success = siteGroupId != null && siteGroupId > 0;

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Site créé avec succès'),
            ),
          );

          // Naviguer vers la page de détail du site
          if (context.mounted) {
            final newSiteGroup = await viewModel.getSiteGroupById(siteGroupId);
            if (newSiteGroup != null && context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ModuleDetailPage(
                    moduleInfo: widget.moduleInfo!
                  ),
                ),
              );
              return false; // Navigation personnalisée
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
  Future<void> _deleteSite(BuildContext context, WidgetRef ref) async {
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
      final viewModel = ref.read(siteGroupFormViewModelProvider(
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


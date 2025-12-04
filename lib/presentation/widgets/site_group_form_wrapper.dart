import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit/visit_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/module/module_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_group_form_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/generic_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/site_group_detail_page.dart';

/// Wrapper spécialisé pour les formulaires de site
/// Utilise GenericFormPage avec la logique métier spécifique aux sites
class SiteGroupFormWrapper extends ConsumerStatefulWidget {
  final ObjectConfig siteGroupConfig;
  final ObjectConfig? siteConfig;
  final CustomConfig? customConfig;
  final int? moduleId;
  final ModuleInfo? moduleInfo;
  final SiteGroup? siteGroup;

  const SiteGroupFormWrapper({
    super.key,
    required this.siteGroupConfig,
    this.siteConfig,
    this.customConfig,
    this.moduleId,
    this.moduleInfo,
    this.siteGroup,
  });

  @override
  ConsumerState<SiteGroupFormWrapper> createState() =>
      _SiteGroupFormWrapperState();
}

class _SiteGroupFormWrapperState extends ConsumerState<SiteGroupFormWrapper> {
  Map<String, dynamic>? _initialValues;
  bool _isLoading = true;

  bool get _isEditMode => widget.siteGroup != null;

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
      objectConfig: widget.siteGroupConfig,
      customConfig: widget.customConfig,
      title: _isEditMode
          ? 'Modifier le groupe de site'
          : widget.siteGroupConfig.label ?? 'Nouveau groupe de site',
      appBarActions: _isEditMode
          ? [
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Supprimer le groupe de site',
                onPressed: () => _deleteSiteGroup(context, ref),
              ),
            ]
          : null,
      breadcrumbItems: _buildBreadcrumbItems(context),
      initialValues: _initialValues,
      headerWidget: _buildHeaderWidget(context),
      onSave: (formData) => _handleSave(context, ref, formData),
      saveButtonText: _isEditMode ? 'Mettre à jour' : 'Enregistrer',
      displayProperties: _getDisplayProperties(),
      objectType:
          'sites_group', // Spécifier le type d'objet pour appliquer les exclusions spécifiques aux groupes de sites
    );
  }

  /// Construit les éléments du fil d'Ariane
  List<BreadcrumbItem> _buildBreadcrumbItems(BuildContext context) {
    if (widget.moduleInfo == null) return [];

    return BreadcrumbBuilder.buildSiteGroupBreadcrumb(
      moduleName: widget.moduleInfo!.module.moduleLabel,
      siteGroupLabel: widget
          .moduleInfo!.module.complement?.configuration?.sitesGroup?.label,
      siteGroupName:
          widget.siteGroup?.sitesGroupName ?? widget.siteGroup?.sitesGroupCode,
      onModuleTap: () {
        Navigator.of(context).popUntil((route) =>
            route.isFirst || route.settings.name == '/module_detail');
      },
      onSiteGroupTap: widget.siteGroup != null
          ? () {
              int count = 0;
              Navigator.of(context).popUntil((route) => count++ >= 2);
            }
          : null,
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
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withOpacity(0.3),
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
    if (widget.siteGroup == null) return {};

    final initialValues = <String, dynamic>{
      'id_sites_group': widget.siteGroup!.idSitesGroup,
      // 'base_site_code': widget.site!.baseSiteCode,
      // 'base_site_description': widget.site!.baseSiteDescription,
      // 'first_use_date': widget.site!.firstUseDate?.toIso8601String().split('T')[0],
      // 'altitude_min': widget.site!.altitudeMin,
      // 'altitude_max': widget.site!.altitudeMax,
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

    return defaultValues;
  }

  /// Récupère les propriétés d'affichage du groupe de site
  List<String>? _getDisplayProperties() {
    return widget.siteGroupConfig.displayProperties;
  }

  /// Gère la sauvegarde du groupe de site
  Future<bool> _handleSave(BuildContext context, WidgetRef ref,
      Map<String, dynamic> formData) async {
    final viewModel = ref.read(siteGroupFormViewModelProvider(
        (widget.moduleId ?? 1, widget.siteGroup?.idSitesGroup)).notifier);

    try {
      bool success;
      int? siteGroupId;

      if (_isEditMode && widget.siteGroup != null) {
        // Mise à jour
        success = await viewModel.updateSiteGroupFromFormData(
          formData,
          widget.siteGroup!,
          moduleId: widget.moduleId ?? 1,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Groupe de site mis à jour avec succès'),
            ),
          );
        }
      } else {
        // Création
        siteGroupId = await viewModel.createSiteGroupFromFormData(
          formData,
          moduleId: widget.moduleId ?? 1,
        );
        success = siteGroupId != null && siteGroupId > 0;

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Groupe de site créé avec succès'),
            ),
          );

          // Naviguer vers le formulaire du site
          final newSiteGroup = await viewModel.getSiteGroupById(siteGroupId);
          if (context.mounted) {
            final createSite = await _askForSite(context);
            if (createSite) {
              if (newSiteGroup != null && context.mounted) {
                  await _navigateToSiteForm(context, newSiteGroup, formData);
                  return false; // Navigation personnalisée faite, empêcher le pop automatique
              }
           } else {
                // L'utilisateur a dit "Non", naviguer vers la page de détail
            if (context.mounted) {
              await _navigateToModuleDetailPage(context, widget.moduleInfo);
              await _navigateToSiteGroupDetailPage(context, newSiteGroup, widget.moduleInfo);
              return false; // Navigation personnalisée faite, empêcher le pop automatique
            }
          }
        }
        }
      }
      // Naviguer vers la page de détail du groupe de site
      if (context.mounted) {
        final updatedSiteGroup =
            await viewModel.getSiteGroupById(widget.siteGroup!.idSitesGroup);
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

  /// Demande à l'utilisateur s'il souhaite créer un site
  Future<bool> _askForSite(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Créer un site'),
            content: const Text(
                'Voulez-vous créer un site pour ce groupe de site ?'),
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
  Future<void> _navigateToSiteForm(BuildContext context, SiteGroup siteGroup, [Map<String, dynamic>? siteFormData]) async {
    _navigateToModuleDetailPage(context, widget.moduleInfo);
    _navigateToSiteGroupDetailPage(context, siteGroup, widget.moduleInfo);
    final siteConfig =  widget.moduleInfo!.module.complement?.configuration?.site;
    if (siteConfig == null) return;

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => SiteDetailPage(
    //       site: widget.site,
    //       moduleInfo: widget.moduleInfo,
    //       fromSiteGroup: siteGroup,
    //     ),
    //     ),
    // );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SiteFormPage(
          siteConfig: siteConfig,
          customConfig: widget.moduleInfo!.module.complement
              ?.configuration?.custom,
          moduleId: widget.moduleId,
          moduleInfo: widget.moduleInfo,
          siteGroup: siteGroup,
        ),
      ),
    );
  }
  
  /// Navigue vers la page de détail de la visite
  Future<void> _navigateToSiteGroupDetailPage(BuildContext context, SiteGroup? siteGroup, [ModuleInfo? moduleToShow]) async {
    final targetModuleInfo = moduleToShow ?? null;
    if (targetModuleInfo == null) return;

    final targetsiteGroup = siteGroup ?? null;
    if (targetsiteGroup == null) return;


    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SiteGroupDetailPage(
          moduleInfo: targetModuleInfo,
          siteGroup: targetsiteGroup,
        ),
      ),
    );
  }
  
  /// Navigue vers la page de détail de la visite
  Future<void> _navigateToModuleDetailPage(BuildContext context, [ModuleInfo? moduleToShow]) async {
    Navigator.of(context).pop();
    final targetModuleInfo = moduleToShow ?? null;
    if (targetModuleInfo == null) return;


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ModuleDetailPage(
          moduleInfo: targetModuleInfo,
        ),
      ),
    );
  }

  /// Supprime le groupe de site avec confirmation
  Future<void> _deleteSiteGroup(BuildContext context, WidgetRef ref) async {
    if (widget.siteGroup == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text(
            "Êtes-vous sûr de vouloir supprimer ce groupe de site ?"),
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

      final success =
          await viewModel.deleteSiteGroup(widget.siteGroup!.idSitesGroup);

      if (context.mounted) {
        if (success) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Groupe de site supprimé avec succès')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la suppression du groupe de site'),
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

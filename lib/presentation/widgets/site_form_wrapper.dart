import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_form_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/generic_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';

/// Wrapper spécialisé pour les formulaires de site
/// Utilise GenericFormPage avec la logique métier spécifique aux sites
class SiteFormWrapper extends ConsumerWidget {
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

  bool get _isEditMode => site != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GenericFormPage(
      objectConfig: siteConfig,
      customConfig: customConfig,
      title: _isEditMode
          ? 'Modifier le site'
          : siteConfig.label ?? 'Nouveau site',
      appBarActions: _isEditMode ? [
        IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'Supprimer le site',
          onPressed: () => _deleteSite(context, ref),
        ),
      ] : null,
      breadcrumbItems: _buildBreadcrumbItems(context),
      initialValues: _isEditMode ? _prepareInitialValues() : _prepareDefaultValues(),
      headerWidget: _buildHeaderWidget(context),
      onSave: (formData) => _handleSave(context, ref, formData),
      saveButtonText: _isEditMode ? 'Mettre à jour' : 'Enregistrer',
      displayProperties: _getDisplayProperties(),
    );
  }

  /// Construit les éléments du fil d'Ariane
  List<BreadcrumbItem> _buildBreadcrumbItems(BuildContext context) {
    if (moduleInfo == null) return [];

    return BreadcrumbBuilder.buildSiteBreadcrumb(
      moduleName: moduleInfo!.module.moduleLabel,
      siteGroupLabel: moduleInfo!.module.complement?.configuration?.sitesGroup?.label,
      siteGroupName: siteGroup?.sitesGroupName ?? siteGroup?.sitesGroupCode,
      siteLabel: siteConfig.label ?? 'Site',
      siteName: site?.baseSiteName ?? site?.baseSiteCode ?? 'Nouveau',
      onModuleTap: () {
        Navigator.of(context).popUntil((route) =>
            route.isFirst || route.settings.name == '/module_detail');
      },
      onSiteGroupTap: siteGroup != null ? () {
        int count = 0;
        Navigator.of(context).popUntil((route) => count++ >= 2);
      } : null,
    );
  }

  /// Construit le widget d'en-tête
  Widget? _buildHeaderWidget(BuildContext context) {
    if (moduleInfo != null) return null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        'Module: ${moduleInfo?.module.moduleLabel ?? 'Module'}',
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  /// Prépare les valeurs initiales pour le mode édition
  Map<String, dynamic> _prepareInitialValues() {
    if (site == null) return {};

    final initialValues = <String, dynamic>{
      'base_site_name': site!.baseSiteName,
      'base_site_code': site!.baseSiteCode,
      'base_site_description': site!.baseSiteDescription,
      'first_use_date': site!.firstUseDate?.toIso8601String().split('T')[0],
      'altitude_min': site!.altitudeMin,
      'altitude_max': site!.altitudeMax,
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
    if (moduleId != null) {
      // Le champ id_module sera géré automatiquement
    }

    // Ajouter l'ID du groupe de sites si disponible
    if (siteGroup != null) {
      defaultValues['id_sites_group'] = siteGroup!.idSitesGroup;
    }

    // Ajouter le type de site sélectionné
    if (selectedSiteTypeId != null) {
      defaultValues['id_nomenclature_type_site'] = selectedSiteTypeId;
      // Si le type de site est dans specific avec une valeur fixe, l'utiliser
      final specificTypeSite = siteConfig.specific?['id_nomenclature_type_site'];
      if (specificTypeSite != null && specificTypeSite['value'] != null) {
        // Le type est déjà défini dans la config, ne pas l'écraser
      }
    }

    return defaultValues;
  }

  /// Récupère les propriétés d'affichage selon le type de site
  List<String>? _getDisplayProperties() {
    if (selectedSiteTypeId != null && moduleInfo != null) {
      final typeSiteConfig = moduleInfo!.module.complement?.configuration?.module
          ?.typesSite?[selectedSiteTypeId.toString()];
      if (typeSiteConfig?.displayProperties != null &&
          typeSiteConfig!.displayProperties!.isNotEmpty) {
        return typeSiteConfig.displayProperties!.cast<String>();
      }

    }
    return siteConfig.displayProperties;
  }

  /// Gère la sauvegarde du site
  Future<bool> _handleSave(BuildContext context, WidgetRef ref, Map<String, dynamic> formData) async {
    final viewModel = ref.read(siteFormViewModelProvider(
        (moduleId ?? 1, siteGroup?.idSitesGroup)).notifier);

    try {
      bool success;
      int? siteId;

      if (_isEditMode && site != null) {
        // Mise à jour
        success = await viewModel.updateSiteFromFormData(
          formData,
          site!,
          moduleId: moduleId ?? 1,
          selectedSiteTypeId: selectedSiteTypeId,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Site mis à jour avec succès'),
            ),
          );

          // Naviguer vers la page de détail du site
          if (context.mounted) {
            final updatedSite = await viewModel.getSiteById(site!.idBaseSite);
            if (updatedSite != null && context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SiteDetailPage(
                    site: updatedSite,
                    moduleInfo: moduleInfo!,
                    fromSiteGroup: siteGroup,
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
          moduleId: moduleId ?? 1,
          selectedSiteTypeId: selectedSiteTypeId,
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
            if (newSite != null && context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SiteDetailPage(
                    site: newSite,
                    moduleInfo: moduleInfo!,
                    fromSiteGroup: siteGroup,
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
    if (site == null) return;

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
          (moduleId ?? 1, siteGroup?.idSitesGroup)).notifier);

      final success = await viewModel.deleteSite(site!.idBaseSite);

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



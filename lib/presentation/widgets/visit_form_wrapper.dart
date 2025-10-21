import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit/visit_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/generic_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';

// Provider pour le statut du bouton "Enchainer les saisies" des visites
final chainVisitInputProvider = StateProvider<bool>((ref) => false);

/// Wrapper spécialisé pour les formulaires de visite
/// Utilise GenericFormPage avec la logique métier spécifique aux visites
class VisitFormWrapper extends ConsumerWidget {
  final BaseSite site;
  final ObjectConfig visitConfig;
  final CustomConfig? customConfig;
  final BaseVisit? visit; // En mode édition, visite existante
  final int? moduleId;
  final ModuleInfo? moduleInfo;
  final dynamic siteGroup;

  const VisitFormWrapper({
    super.key,
    required this.site,
    required this.visitConfig,
    this.customConfig,
    this.visit,
    this.moduleId,
    this.moduleInfo,
    this.siteGroup,
  });

  bool get _isEditMode => visit != null;

  /// Extrait l'ID du dataset depuis les données du formulaire
  /// Retourne 1 par défaut si aucun dataset n'est trouvé
  int _extractDatasetId(Map<String, dynamic> formData) {
    if (formData.containsKey('id_dataset')) {
      final value = formData['id_dataset'];
      if (value is int && value > 0) {
        return value;
      } else if (value is String && int.tryParse(value) != null) {
        final parsed = int.parse(value);
        if (parsed > 0) return parsed;
      } else if (value is num) {
        final intValue = value.toInt();
        if (intValue > 0) return intValue;
      }
    }
    return 1; // Valeur par défaut
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GenericFormPage(
      objectConfig: visitConfig,
      customConfig: customConfig,
      title: _isEditMode
          ? 'Modifier la visite'
          : visitConfig.label ?? 'Nouvelle visite',
      appBarActions: _isEditMode ? [
        IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'Supprimer la visite',
          onPressed: () => _deleteVisit(context, ref),
        ),
      ] : null,
      breadcrumbItems: _buildBreadcrumbItems(context),
      initialValues: _isEditMode ? _prepareInitialValues() : null,
      headerWidget: _buildHeaderWidget(context),
      onSave: (formData) => _handleSave(context, ref, formData),
      saveButtonText: _isEditMode ? 'Mettre à jour' : 'Enregistrer',
      chainInputProvider: chainVisitInputProvider,
      displayProperties: visitConfig.displayProperties,
    );
  }

  /// Construit les éléments du fil d'Ariane
  List<BreadcrumbItem> _buildBreadcrumbItems(BuildContext context) {
    if (moduleInfo == null) return [];

    return BreadcrumbBuilder.buildVisitBreadcrumb(
      moduleName: moduleInfo!.module.moduleLabel,
      siteGroupLabel: moduleInfo!.module.complement?.configuration?.sitesGroup?.label,
      siteGroupName: siteGroup?.sitesGroupName ?? siteGroup?.sitesGroupCode,
      siteLabel: moduleInfo!.module.complement?.configuration?.site?.label,
      siteName: site.baseSiteName ?? site.baseSiteCode ?? 'Site',
      visitLabel: visitConfig.label ?? 'Visite',
      visitValue: visit != null
          ? formatDateString(visit!.visitDateMin)
          : 'Nouvelle',
      onModuleTap: () {
        Navigator.of(context).popUntil((route) =>
            route.isFirst || route.settings.name == '/module_detail');
      },
      onSiteGroupTap: siteGroup != null ? () {
        int count = 0;
        Navigator.of(context).popUntil((route) => count++ >= 2);
      } : null,
      onSiteTap: () => Navigator.of(context).pop(),
    );
  }

  /// Construit le widget d'en-tête (bandeau site si pas de moduleInfo)
  Widget? _buildHeaderWidget(BuildContext context) {
    if (moduleInfo != null) return null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        'Site: ${site.baseSiteName}${site.baseSiteCode != null ? ' (${site.baseSiteCode})' : ''}',
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  /// Prépare les valeurs initiales pour le mode édition
  Map<String, dynamic> _prepareInitialValues() {
    if (visit == null) return {};

    // Créer un Map avec les champs de base de la visite
    final initialValues = <String, dynamic>{
      'visit_date_min': visit!.visitDateMin,
      'visit_date_max': visit!.visitDateMax,
      'comments': visit!.comments,
      'id_dataset': visit!.idDataset,
      'observers': visit!.observers ?? [],
    };

    // Ajouter les données complémentaires si elles existent
    if (visit!.data != null && visit!.data!.isNotEmpty) {
      initialValues.addAll(visit!.data!);
    }

    return initialValues;
  }

  /// Gère la sauvegarde de la visite
  Future<bool> _handleSave(BuildContext context, WidgetRef ref, Map<String, dynamic> formData) async {
    final viewModel = ref.read(siteVisitsViewModelProvider(
        (site.idBaseSite, moduleId ?? 1)).notifier);

    try {
      // Récupérer le nom d'utilisateur pour l'affichage
      final userName = await viewModel.getCurrentUserName();

      bool success;
      if (_isEditMode && visit != null) {
        // Mise à jour
        success = await viewModel.updateVisitFromFormData(
          formData,
          site,
          visit!.idBaseVisit,
          moduleId: moduleId ?? 1,
        );

        if (success) {
          // Afficher le SnackBar de succès d'abord
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Visite mise à jour avec succès${userName != null ? " avec $userName comme observateur" : ""}',
              ),
            ),
          );

          final chainInput = ref.read(chainVisitInputProvider);
          
          if (!chainInput) {
            // Vérifier si la configuration des observations existe
            final hasObservationConfig = moduleInfo?.module.complement
                    ?.configuration?.observation != null;

            // Demander s'il souhaite saisir des observations
            if (hasObservationConfig) {
              final createObservations = await _askForObservations(context);
              if (createObservations) {
                if (context.mounted) {
                  await _navigateToObservationForm(context, visit!.idBaseVisit, formData);
                  return false; // Navigation personnalisée faite, empêcher le pop automatique
                }
              } else {
                // L'utilisateur a dit "Non", naviguer vers la page de détail
                if (context.mounted) {
                  await _navigateToVisitDetailPage(context);
                  return false; // Navigation personnalisée faite, empêcher le pop automatique
                }
              }
            } else {
              // Pas de config d'observation, naviguer directement vers la page de détail
              if (context.mounted) {
                await _navigateToVisitDetailPage(context);
                return false; // Navigation personnalisée faite, empêcher le pop automatique
              }
            }
          }
        }
      } else {
        // Création
        final visitId = await viewModel.createVisitFromFormData(
          formData,
          site,
          moduleId: moduleId ?? 1,
        );
        success = visitId > 0;

        if (success) {
          // Afficher le SnackBar de succès d'abord
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Visite créée avec succès${userName != null ? " avec $userName comme observateur" : ""}',
              ),
            ),
          );

          final chainInput = ref.read(chainVisitInputProvider);

          if (!chainInput) {
            // Créer un objet BaseVisit temporaire avec toutes les données du formulaire
            final newVisit = BaseVisit(
              idBaseVisit: visitId,
              idDataset: _extractDatasetId(formData),
              idBaseSite: site.idBaseSite,
              visitDateMin: formData['visit_date_min'] ?? DateTime.now().toIso8601String(),
              visitDateMax: formData['visit_date_max'],
              comments: formData['comments'],
              idModule: moduleId ?? 1,
              observers: formData['observers'] as List<int>?,
              data: formData,
            );

            // Vérifier si la configuration des observations existe
            final hasObservationConfig = moduleInfo?.module.complement
                    ?.configuration?.observation != null;

            // Demander s'il souhaite saisir des observations
            if (hasObservationConfig) {
              final createObservations = await _askForObservations(context);
              if (createObservations) {
                if (context.mounted) {
                  await _navigateToObservationForm(context, visitId, formData);
                  return false; // Navigation personnalisée faite, empêcher le pop automatique
                }
              } else {
                // L'utilisateur a dit "Non", naviguer vers la page de détail
                if (context.mounted) {
                  await _navigateToVisitDetailPage(context, newVisit);
                  return false; // Navigation personnalisée faite, empêcher le pop automatique
                }
              }
            } else {
              // Pas de config d'observation, naviguer directement vers la page de détail
              if (context.mounted) {
                await _navigateToVisitDetailPage(context, newVisit);
                return false; // Navigation personnalisée faite, empêcher le pop automatique
              }
            }
          }
        }
      }

      // Si on arrive ici, c'est soit un échec, soit le mode enchaînement
      // Dans les deux cas, laisser GenericFormPage gérer
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

  /// Supprime la visite avec confirmation
  Future<void> _deleteVisit(BuildContext context, WidgetRef ref) async {
    if (visit == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text("Êtes-vous sûr de vouloir supprimer cette visite ?"),
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
      final viewModel = ref.read(siteVisitsViewModelProvider(
          (site.idBaseSite, moduleId ?? 1)).notifier);

      final success = await viewModel.deleteVisit(visit!.idBaseVisit);

      if (context.mounted) {
        if (success) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Visite supprimée avec succès')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la suppression de la visite'),
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

  /// Demande à l'utilisateur s'il souhaite créer des observations
  Future<bool> _askForObservations(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Créer des observations'),
        content: const Text('Voulez-vous créer des observations pour cette visite ?'),
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
    ) ?? false;
  }

  /// Navigue vers le formulaire d'observation
  Future<void> _navigateToObservationForm(BuildContext context, int visitId, [Map<String, dynamic>? visitFormData]) async {
    final observationConfig = moduleInfo?.module.complement?.configuration?.observation;
    if (observationConfig == null) return;

    // Si on n'a pas d'objet visit existant mais qu'on a les données du formulaire, créer un objet temporaire
    BaseVisit? visitForNavigation = visit;
    if (visit == null && visitFormData != null) {
      visitForNavigation = BaseVisit(
        idBaseVisit: visitId,
        idDataset: _extractDatasetId(visitFormData),
        idBaseSite: site.idBaseSite,
        visitDateMin: visitFormData['visit_date_min'] ?? DateTime.now().toIso8601String(),
        idModule: moduleId ?? 1,
        data: visitFormData,
      );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ObservationFormPage(
          visitId: visitId,
          observationConfig: observationConfig,
          customConfig: customConfig,
          moduleId: moduleId,
          observationDetailConfig: moduleInfo?.module.complement?.configuration?.observationDetail,
          moduleName: moduleInfo?.module.moduleLabel,
          siteLabel: moduleInfo?.module.complement?.configuration?.site?.label,
          siteName: site.baseSiteName ?? site.baseSiteCode,
          visitLabel: visitConfig.label,
          visitDate: visitForNavigation?.visitDateMin != null 
              ? formatDateString(visitForNavigation!.visitDateMin) 
              : 'Nouvelle visite',
          // Les objets complets seront nécessaires pour une navigation complète
          visit: visitForNavigation,
          site: site,
          moduleInfo: moduleInfo,
          fromSiteGroup: siteGroup,
        ),
      ),
    );
  }

  /// Navigue vers la page de détail de la visite
  Future<void> _navigateToVisitDetailPage(BuildContext context, [BaseVisit? visitToShow]) async {
    final targetVisit = visitToShow ?? visit;
    if (targetVisit == null) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VisitDetailPage(
          visit: targetVisit,
          site: site,
          moduleInfo: moduleInfo,
          fromSiteGroup: siteGroup,
        ),
      ),
    );
  }
}
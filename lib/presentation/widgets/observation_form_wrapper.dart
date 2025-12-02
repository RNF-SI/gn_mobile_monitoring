import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_detail/observation_detail_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/generic_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';

// Provider pour le statut du bouton "Enchainer les saisies"
final chainObservationInputProvider = StateProvider<bool>((ref) => false);

/// Wrapper spécialisé pour les formulaires d'observation
/// Utilise GenericFormPage avec la logique métier spécifique aux observations
class ObservationFormWrapper extends ConsumerWidget {
  final int visitId;
  final ObjectConfig observationConfig;
  final CustomConfig? customConfig;
  final Observation? observation; // En mode édition, observation existante
  final int? moduleId;
  final ObjectConfig? observationDetailConfig;

  // Informations pour le fil d'Ariane
  final String? moduleName;
  final String? siteLabel;
  final String? siteName;
  final String? visitLabel;
  final String? visitDate;
  final BaseVisit? visit;
  final BaseSite? site;
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup;
  final SyncConflict? currentConflict;

  const ObservationFormWrapper({
    super.key,
    required this.visitId,
    required this.observationConfig,
    this.customConfig,
    this.observation,
    this.moduleId,
    this.observationDetailConfig,
    this.moduleName,
    this.siteLabel,
    this.siteName,
    this.visitLabel,
    this.visitDate,
    this.visit,
    this.site,
    this.moduleInfo,
    this.fromSiteGroup,
    this.currentConflict,
  });

  bool get _isEditMode => observation != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GenericFormPage(
      objectConfig: observationConfig,
      customConfig: customConfig,
      title: _isEditMode ? 'Modifier l\'observation' : 'Nouvelle observation',
      breadcrumbItems: _buildBreadcrumbItems(context),
      initialValues: _isEditMode ? _prepareInitialValues() : null,
      currentConflict: currentConflict,
      onSave: (formData) => _handleSave(context, ref, formData),
      saveButtonText: _isEditMode ? 'Enregistrer' : 'Ajouter',
      chainInputProvider: chainObservationInputProvider,
      displayProperties: observationConfig.displayProperties,
      idListTaxonomy: moduleInfo?.module.complement?.idListTaxonomy,
      normalizeInitialValues: _normalizeNomenclatureValues,
    );
  }

  /// Construit les éléments du fil d'Ariane
  List<BreadcrumbItem> _buildBreadcrumbItems(BuildContext context) {
    return BreadcrumbBuilder.buildObservationBreadcrumb(
      moduleName: moduleName,
      siteLabel: siteLabel,
      siteName: siteName,
      visitLabel: visitLabel,
      visitDate: visitDate,
      observationLabel: observationConfig.label ?? 'Observation',
      observationValue: _isEditMode
          ? (observation?.cdNom?.toString() ?? 'Édition')
          : 'Nouvelle',
      onModuleTap: () {
        Navigator.of(context).popUntil((route) =>
            route.isFirst || route.settings.name == '/module_detail');
      },
      onSiteTap: () {
        int count = 0;
        Navigator.of(context).popUntil((route) => count++ >= 2);
      },
      onVisitTap: () => Navigator.of(context).pop(),
    );
  }

  /// Prépare les valeurs initiales pour le mode édition
  Map<String, dynamic> _prepareInitialValues() {
    if (observation == null) return {};

    final values = <String, dynamic>{
      'id_observation': observation!.idObservation,
      'cd_nom': observation!.cdNom,
      'comments': observation!.comments,
    };

    if (observation!.data != null) {
      values.addAll(observation!.data!);
    }

    return values;
  }

  /// Normalise les valeurs de nomenclature
  Map<String, dynamic> _normalizeNomenclatureValues(Map<String, dynamic> values) {
    final result = Map<String, dynamic>.from(values);

    for (final key in result.keys.toList()) {
      if (key.startsWith('id_nomenclature_')) {
        final value = result[key];

        if (value is int) {
          result[key] = {'id': value};
        } else if (value is String) {
          final intValue = int.tryParse(value);
          if (intValue != null) {
            result[key] = {'id': intValue};
          } else {
            result[key] = {'id': 0};
          }
        } else if (value == null) {
          // Laisser la valeur nulle
        } else if (value is! Map) {
          result[key] = {'id': 0};
        }
      }
    }

    return result;
  }

  /// Gère la sauvegarde de l'observation
  Future<bool> _handleSave(BuildContext context, WidgetRef ref, Map<String, dynamic> formData) async {
    final observationsViewModel = ref.read(observationsProvider(visitId).notifier);

    try {
      bool success;
      if (_isEditMode && observation != null) {
        // Mise à jour
        success = await observationsViewModel.updateObservation(
          formData,
          observation!.idObservation,
        );
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Observation mise à jour avec succès')),
          );
          
          // Redirection vers la page de détail
          await _navigateToDetailPage(context, ref, observation!.idObservation);
          return false; // Navigation personnalisée faite, empêcher le pop automatique
        }
      } else {
        // Création
        final newObservationId = await observationsViewModel.createObservation(formData);
        success = newObservationId > 0;
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Observation créée avec succès')),
          );
          
          // Redirection vers la page de détail ou prompt pour détail d'observation
          await _handleNewObservationNavigation(context, ref, newObservationId);
          
          // Si on n'est pas en mode enchaînement, _handleNewObservationNavigation a fait une navigation
          // donc empêcher le pop automatique
          final chainInput = ref.read(chainObservationInputProvider);
          if (!chainInput) {
            return false; // Navigation personnalisée faite, empêcher le pop automatique
          }
          // Si on est en mode enchaînement, _handleNewObservationNavigation n'a rien fait
          // donc laisser GenericFormPage gérer normalement
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

  /// Navigue vers la page de détail d'une observation
  Future<void> _navigateToDetailPage(BuildContext context, WidgetRef ref, int observationId) async {
    if (visit == null || site == null) return;

    final observationsViewModel = ref.read(observationsProvider(visitId).notifier);
    final updatedObservation = await observationsViewModel.getObservationById(observationId);

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ObservationDetailPage(
            observation: updatedObservation,
            visit: visit!,
            site: site!,
            moduleInfo: moduleInfo,
            fromSiteGroup: fromSiteGroup,
            observationConfig: observationConfig,
            customConfig: customConfig,
            observationDetailConfig: observationDetailConfig,
            isNewObservation: !_isEditMode,
          ),
        ),
      );
    }
  }

  /// Gère la navigation après création d'une nouvelle observation
  Future<void> _handleNewObservationNavigation(BuildContext context, WidgetRef ref, int observationId) async {
    // Si enchaînement activé, ne pas rediriger (GenericFormPage s'en charge)
    final chainInput = ref.read(chainObservationInputProvider);
    if (chainInput) return;

    final observationsViewModel = ref.read(observationsProvider(visitId).notifier);
    final newObservation = await observationsViewModel.getObservationById(observationId);

    if (!context.mounted) return;

    // Si configuration des détails d'observation disponible, proposer de créer un détail
    if (observationDetailConfig != null) {
      final shouldAddDetail = await _promptForObservationDetail(context);
      if (shouldAddDetail && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ObservationDetailFormPage(
              observationDetail: observationDetailConfig!,
              observation: newObservation,
              customConfig: customConfig,
              visit: visit,
              site: site,
              moduleInfo: moduleInfo,
              fromSiteGroup: fromSiteGroup,
            ),
          ),
        );
        return;
      }
    }

    // Sinon, rediriger vers la page de détail
    await _navigateToDetailPage(context, ref, observationId);
  }

  /// Demande à l'utilisateur s'il souhaite ajouter un détail d'observation
  Future<bool> _promptForObservationDetail(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un détail d\'observation ?'),
        content: const Text('Voulez-vous ajouter un détail d\'observation maintenant ?'),
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
}
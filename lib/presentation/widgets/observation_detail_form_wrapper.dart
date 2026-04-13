import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_detail/observation_detail_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observation_detail_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/generic_form_page.dart';

// Provider pour le statut du bouton "Enchainer les saisies" des détails d'observation
final chainDetailInputProvider = StateProvider<bool>((ref) => false);

/// Wrapper spécialisé pour les formulaires de détail d'observation
/// Utilise GenericFormPage avec la logique métier spécifique aux détails d'observation
class ObservationDetailFormWrapper extends ConsumerStatefulWidget {
  final ObjectConfig observationDetail;
  final Observation observation;
  final CustomConfig? customConfig;
  final ObservationDetail? existingDetail; // En mode édition
  
  // Informations optionnelles pour la navigation complète
  final BaseVisit? visit;
  final BaseSite? site;
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup;

  const ObservationDetailFormWrapper({
    super.key,
    required this.observationDetail,
    required this.observation,
    this.customConfig,
    this.existingDetail,
    this.visit,
    this.site,
    this.moduleInfo,
    this.fromSiteGroup,
  });

  @override
  ObservationDetailFormWrapperState createState() => ObservationDetailFormWrapperState();
}

class ObservationDetailFormWrapperState extends ConsumerState<ObservationDetailFormWrapper> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeProvider();
  }

  /// Initialise le provider pour l'enchaînement
  void _initializeProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Récupérer la valeur actuelle du provider d'enchaînement
      final chainInput = ref.read(chainDetailInputProvider);
      setState(() {
        _isInitialized = true;
      });
    });
  }

  bool get _isEditMode => widget.existingDetail != null;

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Détail d\'observation'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return GenericFormPage(
      objectConfig: widget.observationDetail,
      customConfig: widget.customConfig,
      title: _isEditMode
          ? 'Modifier le détail'
          : 'Nouveau détail d\'observation',
      initialValues: _isEditMode ? widget.existingDetail!.data : null,
      onSave: (formData) => _handleSave(context, formData),
      saveButtonText: _isEditMode ? 'Enregistrer' : 'Ajouter',
      chainInputProvider: chainDetailInputProvider,
      displayProperties: widget.observationDetail.displayProperties ?? [],
    );
  }

  /// Gère la sauvegarde du détail d'observation
  Future<bool> _handleSave(BuildContext context, Map<String, dynamic> formData) async {
    try {
      final detailsProvider = observationDetailsProvider(widget.observation.idObservation);

      ObservationDetail detailToSave;
      if (_isEditMode && widget.existingDetail != null) {
        // Mise à jour - copier le détail existant avec les nouvelles données
        detailToSave = widget.existingDetail!.copyWith(data: formData);
      } else {
        // Création - créer un nouveau détail
        detailToSave = ObservationDetail(
          idObservationDetail: null, // null pour création
          idObservation: widget.observation.idObservation,
          data: formData,
        );
      }

      // Utiliser saveObservationDetail pour création et mise à jour
      final savedId = await ref.read(detailsProvider.notifier).saveObservationDetail(detailToSave);
      final success = savedId > 0;

      if (success) {
        final message = _isEditMode 
            ? 'Détail mis à jour avec succès'
            : 'Détail créé avec succès';
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );

        // Redirection vers la page de détail du détail d'observation
        if (!ref.read(chainDetailInputProvider)) {
          final finalDetail = _isEditMode 
              ? detailToSave
              : ObservationDetail(
                  idObservationDetail: savedId,
                  idObservation: widget.observation.idObservation,
                  data: formData,
                );
          await _navigateToDetailPage(context, finalDetail);
          return false; // Navigation personnalisée faite, empêcher le pop automatique
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

  /// Navigue vers la page de détail du détail d'observation
  Future<void> _navigateToDetailPage(BuildContext context, ObservationDetail detail) async {
    // Calculer l'index du détail (pour l'affichage)
    final detailsProvider = observationDetailsProvider(widget.observation.idObservation);
    
    // Charger les détails et récupérer la liste
    ref.read(detailsProvider.notifier).loadObservationDetails();
    final allDetails = await ref.read(detailsProvider.notifier).getObservationDetailsByObservationId(widget.observation.idObservation);
    
    int index = 1; // Par défaut
    final detailIndex = allDetails.indexWhere(
      (d) => d.idObservationDetail == detail.idObservationDetail,
    );
    if (detailIndex >= 0) {
      index = detailIndex + 1;
    }

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ObservationDetailDetailPage(
            observationDetail: detail,
            config: widget.observationDetail,
            customConfig: widget.customConfig,
            index: index,
          ),
        ),
      );
    }
  }
}
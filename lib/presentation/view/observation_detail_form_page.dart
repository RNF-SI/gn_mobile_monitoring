import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation_detail_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observation_detail_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

/// Page de formulaire pour créer ou éditer un détail d'observation
class ObservationDetailFormPage extends ConsumerStatefulWidget {
  final ObjectConfig? observationDetail;
  final Observation? observation;
  final CustomConfig? customConfig;
  final Map<String, dynamic>? initialData;
  final ObservationDetail? existingDetail;
  final ObservationDetail? detail;
  final BaseVisit? visit;
  final BaseSite? site;
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup;

  const ObservationDetailFormPage({
    Key? key,
    required this.observationDetail,
    required this.observation,
    required this.customConfig,
    this.initialData,
    this.existingDetail,
    this.detail,
    this.visit,
    this.site,
    this.moduleInfo,
    this.fromSiteGroup,
  }) : super(key: key);

  @override
  ConsumerState<ObservationDetailFormPage> createState() =>
      _ObservationDetailFormPageState();
}

class _ObservationDetailFormPageState
    extends ConsumerState<ObservationDetailFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _formBuilderKey = GlobalKey<DynamicFormBuilderState>();
  late Map<String, dynamic> _formData;
  late Map<String, dynamic> _parsedConfig;
  List<String> _displayProperties = [];
  bool _isInitialized = false;
  bool _isSaving = false;
  bool _chainInput = false; // pour "enchaîner les saisies"

  @override
  void initState() {
    super.initState();
    _initForm();
    // Si la config indique que l'enchaînement est possible, on initialise la bascule
    _chainInput = widget.observationDetail?.chained ?? false;
  }

  /// Initialise le formulaire avec les données existantes ou nouvelles
  void _initForm() {
    // Initialiser les données du formulaire
    _formData = widget.initialData ??
        (widget.existingDetail != null ? widget.existingDetail!.data : {});

    // Si nous avons une observation, stocker son ID dans les données du formulaire
    if (widget.observation != null) {
      // Utiliser l'identifiant de l'observation
      _formData['id_observation'] =
          widget.observation!.idObservation.toString();
    }

    // Parser la configuration pour ce formulaire
    if (widget.observationDetail != null) {
      _parsedConfig = FormConfigParser.generateUnifiedSchema(
        widget.observationDetail!,
        widget.customConfig,
      );

      // Récupérer les propriétés à afficher dans l'ordre
      _displayProperties = widget.observationDetail!.displayProperties ??
          widget.observationDetail!.displayList ??
          FormConfigParser.generateDefaultDisplayProperties(_parsedConfig);

      // Trier les champs selon l'ordre défini
      _parsedConfig = FormConfigParser.sortFormFields(
        _parsedConfig,
        _displayProperties,
      );
    }

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || widget.observationDetail == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Détail d\'observation'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingDetail != null
            ? 'Modifier le détail'
            : 'Nouveau détail d\'observation'),
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Formulaire dynamique basé sur la configuration
                    DynamicFormBuilder(
                      key: _formBuilderKey,
                      objectConfig: widget.observationDetail!,
                      customConfig: widget.customConfig,
                      initialValues: widget.existingDetail?.data ?? {},
                      chainInput: _chainInput,
                      onChainInputChanged: (value) {
                        setState(() {
                          _chainInput = value;
                        });
                      },
                      displayProperties: widget.observationDetail
                              ?.displayProperties as List<String>? ??
                          [],
                    ),
                    const SizedBox(height: 24),
                    // Bouton de sauvegarde
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: _isSaving ? null : _saveObservationDetail,
                        child: Text(widget.existingDetail != null
                            ? 'Enregistrer'
                            : 'Ajouter'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// Sauvegarde des données du détail d'observation
  void _saveObservationDetail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      try {
        // Créer ou modifier un détail d'observation
        final observationDetail = ObservationDetail(
          idObservationDetail: widget.existingDetail?.idObservationDetail,
          idObservation: widget.observation?.idObservation,
          uuidObservationDetail: widget.existingDetail?.uuidObservationDetail,
          data: _formData,
        );

        // Sauvegarder le détail d'observation
        final result = await ref
            .read(observationDetailsProvider(
                    widget.observation?.idObservation ?? 0)
                .notifier)
            .saveObservationDetail(observationDetail);

        if (mounted) {
          if (result > 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Détail d\'observation enregistré avec succès'),
              ),
            );

            if (!_chainInput) {
              // Récupérer le détail d'observation créé/mis à jour
              final updatedDetail = await ref
                  .read(observationDetailsProvider(
                          widget.observation?.idObservation ?? 0)
                      .notifier)
                  .getObservationDetailById(result);

              if (updatedDetail != null &&
                  mounted &&
                  widget.observationDetail != null) {
                // Naviguer vers la page de détail du détail d'observation
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ObservationDetailDetailPage(
                      observationDetail: updatedDetail,
                      config: widget.observationDetail!,
                      customConfig: widget.customConfig,
                      index: result, // Utiliser l'ID comme index
                    ),
                  ),
                );
              }
            } else {
              // En mode enchaînement, réinitialiser le formulaire
              _formKey.currentState?.reset();
              _formBuilderKey.currentState?.resetForm();
              setState(() {
                _formData = {};
                _isSaving = false;
              });
              // Forcer la reconstruction du formulaire en naviguant vers une nouvelle instance
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ObservationDetailFormPage(
                    observationDetail: widget.observationDetail!,
                    observation: widget.observation,
                    customConfig: widget.customConfig,
                    visit: widget.visit,
                    site: widget.site,
                    moduleInfo: widget.moduleInfo,
                    fromSiteGroup: widget.fromSiteGroup,
                  ),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Erreur lors de l\'enregistrement du détail d\'observation'),
                backgroundColor: Colors.red,
              ),
            );
            setState(() {
              _isSaving = false;
            });
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

/// Page de formulaire pour créer ou éditer un détail d'observation
class ObservationDetailFormPage extends ConsumerStatefulWidget {
  final ObjectConfig? observationDetail;
  final Observation? observation;
  final CustomConfig? customConfig;
  final Map<String, dynamic>? initialData;
  final ObservationDetail? existingDetail;
  final ObservationDetail? detail;

  const ObservationDetailFormPage({
    Key? key,
    required this.observationDetail,
    required this.observation,
    required this.customConfig,
    this.initialData,
    this.existingDetail,
    this.detail,
  }) : super(key: key);

  @override
  ConsumerState<ObservationDetailFormPage> createState() =>
      _ObservationDetailFormPageState();
}

class _ObservationDetailFormPageState
    extends ConsumerState<ObservationDetailFormPage> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _formData;
  late Map<String, dynamic> _parsedConfig;
  List<String> _displayProperties = [];
  bool _isInitialized = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initForm();
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
        title: Text(widget.observationDetail!.label ?? 'Détail d\'observation'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Formulaire dynamique basé sur la configuration
                  DynamicFormBuilder(
                    objectConfig: ObjectConfig(
                      label: widget.observationDetail!.label ??
                          'Détail d\'observation',
                      generic: {}, // Nécessaire pour le formateur
                      specific: _parsedConfig, // Utiliser la config parsée
                    ),
                    initialValues: _formData,
                    onSubmit: (values) {
                      _formData = values;
                    },
                  ),

                  const SizedBox(height: 24.0),

                  // Boutons d'action
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Annuler'),
                      ),
                      const SizedBox(width: 16.0),
                      ElevatedButton(
                        onPressed: _isSaving ? null : _saveObservationDetail,
                        child: _isSaving
                            ? const CircularProgressIndicator()
                            : const Text('Enregistrer'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
            .read(observationsProvider(widget.observation?.idObservation ?? 0)
                .notifier)
            .saveObservationDetail(observationDetail);

        if (mounted) {
          Navigator.pop(context, result);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }
}

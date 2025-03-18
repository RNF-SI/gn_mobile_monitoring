import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

class ObservationFormPage extends ConsumerStatefulWidget {
  final int visitId;
  final ObjectConfig observationConfig;
  final CustomConfig? customConfig;
  final Observation? observation; // En mode édition, observation existante
  final int? moduleId; // ID du module pour la visite/observation

  const ObservationFormPage({
    super.key,
    required this.visitId,
    required this.observationConfig,
    this.customConfig,
    this.observation,
    this.moduleId,
  });

  @override
  ObservationFormPageState createState() => ObservationFormPageState();
}

class ObservationFormPageState extends ConsumerState<ObservationFormPage> {
  late bool _isEditMode;
  bool _isLoading = false;
  bool _chainInput = false; // pour "enchaîner les saisies"
  final _formBuilderKey = GlobalKey<DynamicFormBuilderState>();
  Map<String, dynamic>? _initialValues;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.observation != null;
    // Si la config indique que l'enchaînement est possible, on initialise la bascule
    _chainInput = widget.observationConfig.chained ?? false;

    // En mode édition, préparer les valeurs initiales depuis l'observation existante
    if (_isEditMode && widget.observation != null) {
      _initialValues = _prepareInitialValues(widget.observation!);
    }
  }

  /// Prépare les valeurs initiales pour le formulaire à partir d'une observation existante
  Map<String, dynamic> _prepareInitialValues(Observation observation) {
    // Commencer par les champs de base
    final Map<String, dynamic> values = {
      'id_observation': observation.idObservation,
      'cd_nom': observation.cdNom,
      'comments': observation.comments,
    };

    // Ajouter toutes les données supplémentaires de l'observation
    if (observation.data != null) {
      values.addAll(observation.data!);
    }

    return values;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode 
          ? 'Modifier l\'observation' 
          : 'Nouvelle observation'),
        actions: [
          // Bouton de sauvegarde
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveObservation,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre de la page
                  Text(
                    _isEditMode 
                      ? 'Modifier les informations de l\'observation' 
                      : 'Saisir une nouvelle observation',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  // Formulaire dynamique basé sur la configuration
                  DynamicFormBuilder(
                    key: _formBuilderKey,
                    objectConfig: widget.observationConfig,
                    customConfig: widget.customConfig,
                    initialValues: _initialValues,
                    chainInput: _chainInput,
                    onChainInputChanged: (value) {
                      setState(() {
                        _chainInput = value;
                      });
                    },
                    displayProperties: widget.observationConfig.displayProperties,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Bouton de sauvegarde
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: _isLoading ? null : _saveObservation,
                      child: Text(_isEditMode ? 'Enregistrer' : 'Ajouter'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// Sauvegarde l'observation (création ou mise à jour)
  Future<void> _saveObservation() async {
    if (_formBuilderKey.currentState?.validate() != true) {
      // Formulaire invalide
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez corriger les erreurs du formulaire')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Récupérer les valeurs du formulaire
      final formData = _formBuilderKey.currentState!.getFormValues();
      
      // Accéder au viewmodel des observations
      final observationsViewModel = ref.read(observationsProvider(widget.visitId).notifier);
      
      if (_isEditMode && widget.observation != null) {
        // Mettre à jour l'observation existante
        final success = await observationsViewModel.updateObservation(
          formData, 
          widget.observation!.idObservation,
        );
        
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Observation mise à jour avec succès')),
          );
          
          // Fermer la page et retourner à la page précédente
          if (!_chainInput) {
            Navigator.of(context).pop();
          } else {
            // En mode enchaînement, réinitialiser le formulaire
            _formBuilderKey.currentState?.resetForm();
            setState(() {
              _isLoading = false;
            });
          }
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de la mise à jour de l\'observation')),
          );
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        // Créer une nouvelle observation
        final newObservationId = await observationsViewModel.createObservation(formData);
        
        if (newObservationId > 0 && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Observation créée avec succès')),
          );
          
          // Fermer la page et retourner à la page précédente
          if (!_chainInput) {
            Navigator.of(context).pop();
          } else {
            // En mode enchaînement, réinitialiser le formulaire
            _formBuilderKey.currentState?.resetForm();
            setState(() {
              _isLoading = false;
            });
          }
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de la création de l\'observation')),
          );
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
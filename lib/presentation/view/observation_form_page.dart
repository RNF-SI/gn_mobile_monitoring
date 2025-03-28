import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation_detail_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

class ObservationFormPage extends ConsumerStatefulWidget {
  final int visitId;
  final ObjectConfig observationConfig;
  final CustomConfig? customConfig;
  final Observation? observation; // En mode édition, observation existante
  final int? moduleId; // ID du module pour la visite/observation
  final ObjectConfig?
      observationDetailConfig; // Configuration des observations_detail

  // Informations complémentaires pour le fil d'Ariane et la redirection
  final String? moduleName;
  final String? siteLabel;
  final String? siteName;
  final String? visitLabel;
  final String? visitDate;
  final BaseVisit? visit;
  final BaseSite? site;
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup;

  const ObservationFormPage({
    super.key,
    required this.visitId,
    required this.observationConfig,
    this.customConfig,
    this.observation,
    this.moduleId,
    this.moduleName,
    this.siteLabel,
    this.siteName,
    this.visitLabel,
    this.visitDate,
    this.visit,
    this.site,
    this.moduleInfo,
    this.fromSiteGroup,
    this.observationDetailConfig,
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
        title: Text(
            _isEditMode ? 'Modifier l\'observation' : 'Nouvelle observation'),
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
                  // Fil d'Ariane pour la navigation
                  if (widget.moduleName != null ||
                      widget.siteName != null ||
                      widget.visitDate != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        child: BreadcrumbNavigation(
                          items: [
                            if (widget.moduleName != null)
                              BreadcrumbItem(
                                label: 'Module',
                                value: widget.moduleName!,
                                onTap: () {
                                  // Retour au module (plusieurs niveaux)
                                  Navigator.of(context).popUntil((route) =>
                                      route.isFirst ||
                                      route.settings.name == '/module_detail');
                                },
                              ),
                            if (widget.siteName != null)
                              BreadcrumbItem(
                                label: widget.siteLabel ?? 'Site',
                                value: widget.siteName!,
                                onTap: () {
                                  // Retour au site (2 niveaux)
                                  int count = 0;
                                  Navigator.of(context).popUntil((route) {
                                    return count++ >= 2;
                                  });
                                },
                              ),
                            if (widget.visitDate != null)
                              BreadcrumbItem(
                                label: widget.visitLabel ?? 'Visite',
                                value: widget.visitDate!,
                                onTap: () {
                                  // Retour à la visite (1 niveau)
                                  Navigator.of(context).pop();
                                },
                              ),
                            BreadcrumbItem(
                              label: widget.observationConfig.label ??
                                  'Observation',
                              value: _isEditMode
                                  ? (widget.observation?.cdNom?.toString() ??
                                      'Édition')
                                  : 'Nouvelle',
                            ),
                          ],
                        ),
                      ),
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
                    displayProperties:
                        widget.observationConfig.displayProperties,
                  ),

                  const SizedBox(height: 24),

                  // Bouton de sauvegarde
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
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
        const SnackBar(
            content: Text('Veuillez corriger les erreurs du formulaire')),
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
      final observationsViewModel =
          ref.read(observationsProvider(widget.visitId).notifier);

      if (_isEditMode && widget.observation != null) {
        // Mettre à jour l'observation existante
        final success = await observationsViewModel.updateObservation(
          formData,
          widget.observation!.idObservation,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Observation mise à jour avec succès')),
          );

          // Fermer la page et retourner à la page précédente
          if (!_chainInput) {
            // Récupérer l'observation créée/mise à jour
            final observation = await observationsViewModel
                .getObservationById(widget.observation!.idObservation);

            if (observation != null && mounted) {
              // Rediriger vers la page de détail de l'observation
              if (mounted && widget.visit != null && widget.site != null) {
                setState(() {
                  _isLoading = false;
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ObservationDetailPage(
                      observation: observation,
                      visit: widget.visit!,
                      site: widget.site!,
                      moduleInfo: widget.moduleInfo,
                      fromSiteGroup: widget.fromSiteGroup,
                    ),
                  ),
                );
              } else if (mounted) {
                setState(() {
                  _isLoading = false;
                });
                Navigator.pop(context);
              }
            }
          } else {
            // En mode enchaînement, réinitialiser le formulaire
            _formBuilderKey.currentState?.resetForm();
            setState(() {
              _isLoading = false;
              _initialValues = {}; // Réinitialiser les valeurs initiales
            });
          }
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Erreur lors de la mise à jour de l\'observation')),
          );
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        // Créer une nouvelle observation
        final newObservationId =
            await observationsViewModel.createObservation(formData);

        if (newObservationId > 0 && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Observation créée avec succès')),
          );

          // Gérer la navigation
          if (!_chainInput) {
            // Récupérer l'observation créée
            final observation = await observationsViewModel
                .getObservationById(newObservationId);

            if (observation != null && mounted) {
              // Rediriger vers la page de détail de l'observation
              if (mounted && widget.visit != null && widget.site != null) {
                setState(() {
                  _isLoading = false;
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ObservationDetailPage(
                      observation: observation,
                      visit: widget.visit!,
                      site: widget.site!,
                      moduleInfo: widget.moduleInfo,
                      fromSiteGroup: widget.fromSiteGroup,
                    ),
                  ),
                );
              } else if (mounted) {
                setState(() {
                  _isLoading = false;
                });
                Navigator.pop(context);
              }
            }
          } else {
            // En mode enchaînement, réinitialiser le formulaire
            _formBuilderKey.currentState?.resetForm();
            setState(() {
              _isLoading = false;
              _initialValues = {}; // Réinitialiser les valeurs initiales
            });
          }
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Erreur lors de la création de l\'observation')),
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

  /// Navigue vers le formulaire de détail d'observation
  void _navigateToObservationDetailForm(Observation observation) {
    if (widget.observationDetailConfig != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ObservationDetailFormPage(
            observationDetail: widget.observationDetailConfig!,
            observation: observation,
            customConfig: widget.customConfig,
            visit: widget.visit,
            site: widget.site,
            moduleInfo: widget.moduleInfo,
            fromSiteGroup: widget.fromSiteGroup,
          ),
        ),
      );
    }
  }
}
